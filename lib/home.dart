import 'package:auto_size_text/auto_size_text.dart';
import 'package:calibratecpa/util.dart';
import 'package:calibratecpa/var.dart';
import 'package:calibratecpa/documents.dart';
import 'package:calibratecpa/firebase.dart';
import 'package:flutter/material.dart';
import 'package:localpkg/dialogue.dart';
import 'package:localpkg/functions.dart';

bool lightMode = true;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedItem = 0;
  Map data = {"error": "loading"};
  List buttons = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    print("initializing...");
    buildButtons(data);
    refresh();
  }

  void buildButtons(Map data) {
    buttons = [
      {
        "text": "Documents",
        "icon": Icons.edit_document,
        "action": () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DocumentsPage(data: data)),
          );
        },
      },
      {
        "text": "Contact",
        "icon": Icons.contact_mail,
        "action": () {
          openContactUrl(context);
        },
      },
    ];
  }

  Future<void> refresh({int mode = 1}) async {
    if (mode == 1) {
      setState(() {
        data = {"error": "loading"};
      });
      data = await loadData(context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("building: getting variables");
    lightMode = Theme.of(context).brightness == Brightness.light;

    List items = [];
    Map item = {};
    List steps = [];

    if (data["error"] == null) {
      items = data["data"];
      item = items[selectedItem];
      steps = item["steps"];
    }

    int buttonGridCrossAxisCount =
        getCrossAxisCount(context: context, factor: 172);
    int maxButtonGridCrossAxisCount = 5;

    if (buttonGridCrossAxisCount > maxButtonGridCrossAxisCount) {
      buttonGridCrossAxisCount = maxButtonGridCrossAxisCount;
    }
    if (buttonGridCrossAxisCount > buttons.length) {
      buttonGridCrossAxisCount = buttons.length;
    }

    print("building: building data");
    buildButtons(item);
    print("building: building scaffold");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Calibrate Dashboard"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: refresh,
          ),
        ],
      ),
      body: Center(
        child: RefreshIndicator(
          onRefresh: refresh,
          child: !data.containsKey("error") ? Column(
            children: [
              DropdownButton(
                items: items.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map item = entry.value;
                  return DropdownMenuItem(
                    value: index,
                    child: Text(item["name"]),
                  );
                }).toList(),
                value: selectedItem,
                hint: Text('Select an item'),
                onChanged: (value) {
                  selectedItem = value ?? 0;
                  refresh(mode: 2);
                },
                borderRadius: BorderRadius.circular(12),
                focusColor: Colors.transparent,
              ),
              StatusBar(data: item, steps: steps, size: getSizeFactor(context: context) * 16),
              SizedBox(height: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 1000.0, // Set the maximum width
                    ),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: buttonGridCrossAxisCount,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 64,
                      ),
                      itemBuilder: (context, index) {
                        return button(
                          context: context,
                          text: buttons[index]["text"],
                          icon: buttons[index]["icon"],
                          action: buttons[index]["action"],
                        );
                      },
                      itemCount: buttons.length, // Total number of items
                    ),
                  ),
                ),
              ),
            ],
          ) : data["error"] == "loading" ? CircularProgressIndicator() : data["error"] == "nouser" ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextButton(child: Text("Sign In", style: TextStyle(
                  fontSize: 32,
                )), onPressed: () {
                  signIn(context, true);
                })
              ]
            ),
          ) : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text("Your account is not set up yet. Please wait until your account is set up for use with the Calibrate CPA Dashboard.", style: TextStyle(
                  fontSize: 24,
                ), textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  final Color color;
  CirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color // Fill color
      ..style = PaintingStyle.fill; // Ensures the circle is filled

    final center =
        Offset(size.width / 2, size.height / 2); // Center of the circle
    final radius = size.width / 4; // Radius of the circle

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Widget button({
  required BuildContext context,
  required String text,
  required IconData icon,
  required VoidCallback action,
}) {
  return TextButton(
    onPressed: action,
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) =>
            lightMode ? Colors.blueGrey : Color.fromARGB(255, 68, 68, 68),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white),
        SizedBox(width: 10),
        AutoSizeText(text, style: TextStyle(color: Colors.white)),
      ],
    ),
  );
}

Widget circle({
  double size = 100,
  Color color = Colors.blue,
}) {
  return CustomPaint(
    size: Size(size, size), // I'm just as confused as you are
    painter: CirclePainter(color: color),
  );
}

Widget StatusBar(
    {required Map data,
    required List steps,
    double? size,
    bool useSimpleColor = true}) {
  int status = data["status"] ?? 0;
  Map statusItem = steps[status];
  print("${data["status"]},$status,$statusItem");
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: AutoSizeText(
                  statusItem["name"],
                  style: TextStyle(
                    fontSize: 48,
                    color: statusItem["color"] ??
                        statusItem["overwriteColor"],
                  ),
                  maxLines: 1,
                  minFontSize: 10,
                  maxFontSize: 48,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(steps.length, (index) { // til that for some reason List.generate goes 1, 2, 3 instead of 0, 1, 2
            print("generating status bar: $index");
            Map before = index - 1 < 0 ? {"show": false} : (steps[index - 1] ?? {"show": false});
            Map after = index + 2 > steps.length ? {"show": false} : steps[index];
            print("building status bar: $index");
            return Row(
                children: [
                  if (index < steps.length &&
                      steps[index]["show"] &&
                      before["show"])
                    circleRowSpacer(
                        active: status >= index, size: size),
                  if (steps[index]["show"])
                    circle(
                        size: 50,
                        color: useSimpleColor
                            ? status >= index &&
                                    steps[index]["show"]
                                ? lightMode
                                    ? Colors.blue
                                    : Colors.lightBlue
                                : Colors.grey
                            : (statusItem.containsKey("overwriteColor")
                                ? statusItem["overwriteColor"]
                                : status >= index &&
                                        steps[index]["show"]
                                    ? steps[index]["color"] ?? Colors.white
                                    : Colors.grey)),
                  if (index < steps.length &&
                      steps[index]["show"] &&
                      after["show"])
                    circleRowSpacer(
                        active: status >= index, size: size),
                ],
              );
            }
          ),
        ),
      ],
    ),
  );
}

Widget circleRowSpacer({double? size = 20, bool active = false}) {
  return Container(
    width: size, // Length of the line
    height: active ? 2 : 2, // Thickness of the line
    color: active
        ? lightMode
            ? Colors.blue
            : Colors.lightBlue
        : Colors.grey, // Color of the line
  );
}

void openContactUrl(BuildContext context) {
  openUrlConf(context, Uri.parse(contactUrl));
}

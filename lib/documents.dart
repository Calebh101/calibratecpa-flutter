import 'package:calibratecpa/home.dart';
import 'package:calibratecpa/var.dart';
import 'package:flutter/material.dart';
import 'package:localpkg/dialogue.dart';
import 'package:localpkg/functions.dart';

class DocumentsPage extends StatefulWidget {
  final Map data;

  const DocumentsPage({
    super.key,
    required this.data,
  });

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  @override
  Widget build(BuildContext context) {
    Map docs = widget.data["documents"];
    return Scaffold(
        appBar: AppBar(
          title: Text("Documents Manager for ${widget.data["name"]}"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
          child: Column(
            children: [
              if (docs["nodone"] != [])
                Column(
                  children: [
                    title(text: "Waiting", color: Colors.red),
                    button(
                        context: context,
                        text: "Submit Documents",
                        icon: Icons.edit_document,
                        action: () async {
                          if (await showConfirmDialogue(
                                  context,
                                  "Submit documents?",
                                  "You will need to email the documents to $email. Continue?") ??
                              false) {
                            openUrl(url: Uri.parse("mailto:$email"));
                          }
                        }),
                    list(items: docs["nodone"]),
                  ],
                ),
              if (docs["process"].length > 0)
                Column(
                  children: [
                    title(text: "Processing", color: Colors.orange),
                    list(items: docs["process"]),
                  ],
                ),
              if (docs["done"].length > 0)
                Column(
                  children: [
                    title(text: "Complete", color: Colors.green),
                    list(items: docs["done"]),
                  ],
                ),
            ],
          ),
        ));
  }

  Widget title({required String text, Color? color}) {
    return Text(text, style: TextStyle(fontSize: 36, color: color));
  }

  Widget list({required List items}) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.document_scanner),
          title: Text(items[index]["name"]),
          subtitle: items[index].containsKey("desc")
              ? Text(items[index]["desc"])
              : null,
        );
      },
    );
  }
}

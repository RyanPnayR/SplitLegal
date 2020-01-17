import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:splitlegal/app_state_container.dart';
import 'package:splitlegal/models/app_state.dart';

class PdfViewPage extends StatefulWidget {
  final String path;
  final String title;

  const PdfViewPage({Key key, this.path, this.title}) : super(key: key);
  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  bool pdfReady = false;
  PDFViewController _pdfViewController;

  @override
  Widget build(BuildContext context) {
    var container = AppStateContainer.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            autoSpacing: true,
            enableSwipe: true,
            pageSnap: true,
            swipeHorizontal: true,
            nightMode: false,
            onError: (e) {
              print(e);
            },
            onRender: (_pages) {
              setState(() {
                pdfReady = true;
              });
            },
            onViewCreated: (PDFViewController vc) {
              _pdfViewController = vc;
            },
            onPageChanged: (int page, int total) {
              setState(() {});
            },
            onPageError: (page, e) {},
          ),
          !pdfReady
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Offstage()
        ],
      ),
      floatingActionButton:
          Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        FloatingActionButton(
          backgroundColor: Colors.blue,
          child: new Icon(Icons.email),
          onPressed: () {
            getTemporaryDirectory().then((tempDir) {
              File("${widget.path}")
                  .copySync("${tempDir.path}/${widget.title}.pdf");
              String tempFileName = '${tempDir.path}/${widget.title}.pdf';
              final MailOptions email = MailOptions(
                subject: 'Here is your completed ${widget.title}.',
                recipients: [container.state.user.email],
                attachments: [tempFileName],
                isHTML: false,
              );
              FlutterMailer.send(email).whenComplete(() {
                File(tempFileName).deleteSync();
                Navigator.pop(context);
              });
            });
          },
        )
      ]),
    );
  }
}

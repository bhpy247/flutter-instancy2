import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../../../backend/navigation/navigation.dart';
import '../../../utils/my_print.dart';

class PDFLaunchScreen extends StatefulWidget {
  static const String routeName = "/PDFLaunchScreen";

  final PDFLaunchScreenNavigationArguments arguments;

  const PDFLaunchScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<PDFLaunchScreen> createState() => _PDFLaunchScreenState();
}

class _PDFLaunchScreenState extends State<PDFLaunchScreen> {
  late ThemeData themeData;

  FutureOr<Uint8List> getNetworkPdfBytes() async {
    try {
      Response response = await get(Uri.parse(widget.arguments.pdfUrl));
      return response.bodyBytes;
    }
    catch(e, s) {
      MyPrint.printOnConsole("Error in Getting PDF Bytes:$e");
      MyPrint.printOnConsole(s);
      return Uint8List(0);
    }
  }

  FutureOr<Uint8List> getLocalPdfBytes() async {
    if(widget.arguments.pdfFileBytes != null) {
      return widget.arguments.pdfFileBytes!;
    }

    if(widget.arguments.pdfFilePath.isNotEmpty) {
      return File(widget.arguments.pdfFilePath).readAsBytes();
    }

    return Uint8List(0);
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.arguments.contntName.isNotEmpty ? widget.arguments.contntName : 'PDF View',
        ),
      ),
      body: PdfPreview(
        build: (PdfPageFormat format) {
          if(widget.arguments.isNetworkPDF) {
            return getNetworkPdfBytes();
          }
          else {
            return getLocalPdfBytes();
          }
        },
        onError: (BuildContext context, Object? error) {
          return Center(
            child: Text(
              "Error in Loading PDF:\n\n$error",
              textAlign: TextAlign.center,
            ),
          );
        },
        onPrintError: (BuildContext context, dynamic error) {
          MyPrint.printOnConsole("Error in Printing PDF:$error");
        },
        useActions: false,
        allowPrinting: true,
        allowSharing: true,
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
      ),
    );
  }
}

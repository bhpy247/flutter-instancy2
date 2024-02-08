import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/utils/my_safe_state.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';
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

class _PDFLaunchScreenState extends State<PDFLaunchScreen> with MySafeState {
  late Future<Uint8List?> futureGetPdfBytes;

  Future<Uint8List?> getData() async {
    Uint8List? uint8list;

    if (widget.arguments.isNetworkPDF) {
      uint8list = await getNetworkPdfBytes();
    } else {
      uint8list = await getLocalPdfBytes();
    }

    return uint8list;
  }

  FutureOr<Uint8List> getNetworkPdfBytes() async {
    try {
      Response response = await get(Uri.parse(widget.arguments.pdfUrl));
      return response.bodyBytes;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Getting PDF Bytes:$e");
      MyPrint.printOnConsole(s);
      return Uint8List(0);
    }
  }

  FutureOr<Uint8List> getLocalPdfBytes() async {
    if (widget.arguments.pdfFileBytes != null) {
      return widget.arguments.pdfFileBytes!;
    }

    if (widget.arguments.pdfFilePath.isNotEmpty) {
      return File(widget.arguments.pdfFilePath).readAsBytes();
    }

    return Uint8List(0);
  }

  @override
  void initState() {
    super.initState();

    MyPrint.printOnConsole("PDFLaunchScreen init called with arguments:${widget.arguments}");

    futureGetPdfBytes = getData();
  }

  @override
  Widget build(BuildContext context) {
    super.pageBuild();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.arguments.contntName.isNotEmpty ? widget.arguments.contntName : 'PDF View',
        ),
        actions: [
          IconButton(
            onPressed: () {
              futureGetPdfBytes = getData();
              mySetState();
            },
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
      body: FutureBuilder<Uint8List?>(
        future: futureGetPdfBytes,
        builder: (BuildContext context, AsyncSnapshot<Uint8List?> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const CommonLoader();
          }

          return PdfPreview(
            build: (PdfPageFormat format) {
              return Future.value(snapshot.data);
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
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/api/api_controller.dart';
import 'package:flutter_instancy_2/backend/Catalog/content_launch_controller.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:flutter_instancy_2/views/common/components/common_loader.dart';

import '../../../backend/navigation/navigation.dart';

class QRCodeImageScreen extends StatefulWidget {
  static const String routeName = "/QRCodeImageScreen";

  final QRCodeImageScreenNavigationArguments arguments;

  const QRCodeImageScreen({
    Key? key,
    required this.arguments,
  }) : super(key: key);

  @override
  State<QRCodeImageScreen> createState() => _QRCodeImageScreenState();
}

class _QRCodeImageScreenState extends State<QRCodeImageScreen> {
  String qrCodeImageUrl = "";

  late Future<void> futureGet;

  Future<void> getData() async {
    MyPrint.printOnConsole("qrCodePath:${widget.arguments.qrCodePath}");

    qrCodeImageUrl = ContentLaunchController().getQRCodeImageMainUrlFromCertificatePath(
      qrCodeImagePath: widget.arguments.qrCodePath,
      siteUrl: ApiController().apiDataProvider.getCurrentSiteUrl(),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    futureGet = getData();
  }

  @override
  Widget build(BuildContext context) {
    MyPrint.printOnConsole("qrCodeImageUrl:$qrCodeImageUrl");

    return Scaffold(
      appBar: getAppBar(),
      body: FutureBuilder<void>(
        future: futureGet,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return getMainBody(qrCodeImageUrl: qrCodeImageUrl);
          } else {
            return const CommonLoader();
          }
        },
      ),
    );
  }

  Widget getMainBody({required String qrCodeImageUrl}) {
    if (qrCodeImageUrl.isEmpty) {
      return const Center(
        child: Text("QR Code Couldn't loaded"),
      );
    }

    return Center(
      child: CommonCachedNetworkImage(
        imageUrl: qrCodeImageUrl,
      ),
    );
  }

  PreferredSizeWidget getAppBar() {
    return AppBar(
      title: const Text(
        "QR Code",
        style: TextStyle(
          fontSize: 18,
          // color: Color(int.parse("0xFF${appBloc.uiSettingModel.appHeaderTextColor.substring(1, 7).toUpperCase()}")),
        ),
      ),
    );
  }
}

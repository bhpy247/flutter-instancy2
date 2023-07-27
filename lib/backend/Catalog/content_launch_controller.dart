class ContentLaunchController {
  String getContentMainUrlFromContentPath({
    required String contentPath,
    required String siteUrl,
    bool isOverlapUrls = false,
  }) {
    if((contentPath.startsWith("http://") || contentPath.startsWith("https://")) && !isOverlapUrls) {
      return contentPath;
    }
    String contentMainUrl = siteUrl + contentPath;
    return contentMainUrl;
  }

  //region Certificate
  String getCertificateMainUrlFromCertificatePath({
    required String certificatePath,
    required String siteUrl,
  }) {
    return getContentMainUrlFromContentPath(siteUrl: siteUrl, contentPath: certificatePath);
  }

  String getCertificateViewUrlFromCertificatePath({
    required String certificatePath,
    required String siteUrl,
  }) {
    String certificateMainUrl = getCertificateMainUrlFromCertificatePath(certificatePath: certificatePath, siteUrl: siteUrl);
    return 'https://docs.google.com/gview?embedded=true&url=$certificateMainUrl';
  }

  String getCertificateDownloadUrlFromCertificatePath({
    required String certificatePath,
    required String siteUrl,
  }) {

    /*if (urlpath.toLowerCase().contains(".ppt") ||
        urlpath.toLowerCase().contains(".pptx") ||
      //  urlpath.toLowerCase().contains(".pdf") ||
        urlpath.toLowerCase().contains(".doc") ||
        urlpath.toLowerCase().contains(".docx") ||
        urlpath.toLowerCase().contains(".xls") ||
        urlpath.toLowerCase().contains(".xlsx")) {
      urlpath = urlpath.replaceAll("file://", "");
      urlpath = "https://docs.google.com/gview?embedded=true&url=" + urlpath;
    }
    else if (urlpath.toLowerCase().contains(".pdf")) {
      if (appBloc.uiSettingModel.isCloudStorageEnabled.toLowerCase() ==
          'true') {
        urlpath = urlpath + "?fromnativeapp=true";
      } else {
        urlpath = urlpath + "?fromNativeapp=true";
      }
    }
    else {
      urlpath = urlpath;
    }*/

    String certificateMainUrl = getCertificateMainUrlFromCertificatePath(certificatePath: certificatePath, siteUrl: siteUrl);
    return "$certificateMainUrl?fromnativeapp=true";
  }
  //endregion

  String getQRCodeImageMainUrlFromCertificatePath({
    required String qrCodeImagePath,
    required String siteUrl,
  }) {
    return getContentMainUrlFromContentPath(siteUrl: siteUrl, contentPath: qrCodeImagePath );
  }
}

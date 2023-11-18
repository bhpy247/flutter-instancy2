import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app_theme/app_theme_provider.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_controller.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_provider.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:provider/provider.dart';

import '../../../utils/my_print.dart';
import '../../../utils/my_utils.dart';

class MainScreenDrawerHeaderWidget extends StatefulWidget {
  const MainScreenDrawerHeaderWidget({Key? key}) : super(key: key);

  @override
  _MainScreenDrawerHeaderWidgetState createState() => _MainScreenDrawerHeaderWidgetState();
}

class _MainScreenDrawerHeaderWidgetState extends State<MainScreenDrawerHeaderWidget> {
  late ThemeData themeData;

  String imgUrl = "https://www.insertcart.com/wp-content/uploads/2018/05/thumbnail.jpg";

  String userimageUrl = "", username = "", shortName = "";

  late AppThemeProvider appThemeProvider;

  Future<void> getUserDetails() async {
    AuthenticationProvider authenticationProvider = Provider.of<AuthenticationProvider>(context, listen: false);

    String name = authenticationProvider.getSuccessfulUserLoginModel()?.username ?? "";
    String imageurl = authenticationProvider.getSuccessfulUserLoginModel()?.image ?? "";
    MyPrint.printOnConsole("name:$name");
    MyPrint.printOnConsole("imageurl:$imageurl");

    userimageUrl = imageurl;
    username = name;

    shortName = "";
    List<String> nameinfo = username.split(" ");
    if (nameinfo.length > 1) {
      for (int i = 0; i < nameinfo.length; i++) {
        shortName += nameinfo[i][0];
      }
    }
    else if (nameinfo.length == 1) {
      shortName += username[0];
    }
  }

  @override
  void initState() {
    super.initState();
    appThemeProvider = Provider.of<AppThemeProvider>(context, listen: false);
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    String userImageUrlInDrawerHeader = MyUtils.getSecureUrl(userimageUrl.isEmpty ? imgUrl : userimageUrl);
    MyPrint.printOnConsole("userImageUrlInDrawerHeader:$userImageUrlInDrawerHeader");

    return Container(
      color: themeData.primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,

          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 50),
            Row(
              children: <Widget>[
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: userImageUrlInDrawerHeader,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => ClipOval(
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: themeData.primaryColor,
                        child: Text(
                         shortName,
                          style: themeData.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: appThemeProvider.getInstancyThemeColors().appHeaderTextColor.getColor(),
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => ClipOval(
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: themeData.primaryColor,
                        child: Text(
                         shortName,
                          style: themeData.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: appThemeProvider.getInstancyThemeColors().appHeaderTextColor.getColor(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        AuthenticationProvider authenticationProvider = Provider.of<AuthenticationProvider>(context, listen: false);
                        AuthenticationController authenticationController = AuthenticationController(
                          provider: authenticationProvider,
                        );

                        authenticationController.logout();
                      },
                      child: Icon(
                        Icons.logout,
                        color: appThemeProvider.getInstancyThemeColors().appHeaderTextColor.isEmpty
                            ? Colors.grey
                            : appThemeProvider.getInstancyThemeColors().appHeaderTextColor.getColor(),
                        ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(
                        "Sign Out",
                        style: themeData.textTheme.labelMedium?.copyWith(
                          color: appThemeProvider.getInstancyThemeColors().appHeaderTextColor.getColor(),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: Text(
                username,
                maxLines: 1,
                style: themeData.textTheme.titleMedium?.copyWith(
                  color: appThemeProvider.getInstancyThemeColors().appHeaderTextColor.getColor(),
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // const Divider(
            //   color: Colors.grey,
            //   height: 3,
            // ),
          ],
        ),
      ),
    );
  }
}

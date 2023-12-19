import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app_theme/app_theme_provider.dart';
import 'package:flutter_instancy_2/backend/authentication/authentication_provider.dart';
import 'package:flutter_instancy_2/backend/gamification/gamification_provider.dart';
import 'package:flutter_instancy_2/models/gamification/data_model/user_over_all_data_model.dart';
import 'package:flutter_instancy_2/models/gamification/response_model/user_achievement_dto_model.dart';
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
  late GamificationProvider gamificationProvider;

  Future<void> getUserDetails() async {
    AuthenticationProvider authenticationProvider = Provider.of<AuthenticationProvider>(context, listen: false);

    String name = authenticationProvider.getEmailLoginResponseModel()?.username ?? "";
    String imageurl = authenticationProvider.getEmailLoginResponseModel()?.image ?? "";
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
    } else if (nameinfo.length == 1) {
      shortName += username[0];
    }
  }

  @override
  void initState() {
    super.initState();
    appThemeProvider = Provider.of<AppThemeProvider>(context, listen: false);
    gamificationProvider = Provider.of<GamificationProvider>(context, listen: false);
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);

    MyPrint.printOnConsole("userimageUrl:$userimageUrl");
    String userImageUrlInDrawerHeader = MyUtils.getSecureUrl(userimageUrl.isEmpty ? imgUrl : userimageUrl);
    MyPrint.printOnConsole("userImageUrlInDrawerHeader:$userImageUrlInDrawerHeader");

    return Consumer<GamificationProvider>(
      builder: (BuildContext context, GamificationProvider gamificationProvider, Widget? child) {
        UserAchievementDTOModel? userAchievementDTOModel = gamificationProvider.userAchievementDataForDrawer.get();

        Widget? gameDataWidget = getGameDataWidget(userAchievementDTOModel: userAchievementDTOModel);
        Widget? userPointsProgressBarWidget = getUserPointsProgressBarWidget(userAchievementDTOModel: userAchievementDTOModel);

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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: userImageUrlInDrawerHeader,
                        width: 60,
                        height: 60,
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
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            username,
                            maxLines: 2,
                            style: themeData.textTheme.titleMedium?.copyWith(
                              color: themeData.colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (gameDataWidget != null) ...[
                            const SizedBox(height: 5),
                            gameDataWidget,
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                if (userPointsProgressBarWidget != null) ...[
                  const SizedBox(height: 10),
                  userPointsProgressBarWidget,
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget? getGameDataWidget({required UserAchievementDTOModel? userAchievementDTOModel}) {
    if (userAchievementDTOModel == null) return null;

    UserOverAllDataModel? userOverAllDataModel = userAchievementDTOModel.UserOverAllData;
    if (userOverAllDataModel == null) return null;

    return Row(
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: themeData.colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              "Points ${userOverAllDataModel.OverAllPoints}",
              style: themeData.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: themeData.primaryColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: themeData.colorScheme.onPrimary,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              "Badges ${userOverAllDataModel.Badges}",
              style: themeData.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: themeData.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget? getUserPointsProgressBarWidget({required UserAchievementDTOModel? userAchievementDTOModel}) {
    if (userAchievementDTOModel == null) return null;

    UserOverAllDataModel? userOverAllDataModel = userAchievementDTOModel.UserOverAllData;
    if (userOverAllDataModel == null) return null;

    int totalPoints = userOverAllDataModel.OverAllPoints + userOverAllDataModel.NeededPoints;
    double progress = userOverAllDataModel.OverAllPoints / totalPoints;

    String colorCode = context.read<AppThemeProvider>().getInstancyThemeColors().footerBackgroundColor;
    Color? color = colorCode.isNotEmpty ? HexColor.fromHex(colorCode) : null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LinearProgressIndicator(
          minHeight: 8,
          backgroundColor: themeData.colorScheme.background,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? themeData.colorScheme.onBackground,
          ),
          value: progress,
          borderRadius: BorderRadius.circular(100),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              userOverAllDataModel.UserLevel == "--" ? "" : userOverAllDataModel.UserLevel,
              style: themeData.textTheme.bodySmall?.copyWith(
                color: themeData.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.arrow_circle_up,
                    size: 20,
                    color: themeData.colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "${userOverAllDataModel.NeededPoints} Points To Level Up",
                    style: themeData.textTheme.bodySmall?.copyWith(
                      color: themeData.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

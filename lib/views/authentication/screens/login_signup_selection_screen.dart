import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/backend/navigation/navigation_controller.dart';
import 'package:flutter_instancy_2/utils/my_print.dart';
import 'package:flutter_instancy_2/views/common/components/common_button.dart';
import 'package:flutter_instancy_2/views/common/components/common_cached_network_image.dart';
import 'package:flutter_onboard/flutter_onboard.dart' as board;
import 'package:provider/provider.dart';

import '../../common/components/common_loader.dart';
import '../components/onBoard_custome.dart';

class LoginSignUpSelectionScreen extends StatefulWidget {
  static const String routeName = "/LoginSignUpSelectionScreen";

  const LoginSignUpSelectionScreen({Key? key}) : super(key: key);

  @override
  State<LoginSignUpSelectionScreen> createState() => _LoginSignUpSelectionScreenState();
}

class _LoginSignUpSelectionScreenState extends State<LoginSignUpSelectionScreen> {
  String logoUrl = "assets/images/playgroundlogo.png";
  String circleUrl = "assets/onBoarding/Onboarding_circles.png";
  String firstImage = "assets/onBoarding/1_image.png";
  String secondImage = "assets/onBoarding/2_image.png";
  String thirdImage = "assets/onBoarding/3_image.png";

  String circleImageUrl = "";
  late List<board.OnBoardModel> onBoardData = [];

  late ThemeData themeData;
  final PageController _pageController = PageController();

  late AppProvider appProvider;

  @override
  void initState() {
    super.initState();

    appProvider = context.read<AppProvider>();

    onBoardData = [
      board.OnBoardModel(
        title: "",
        description: "",
        imgUrl: firstImage,
      ),
      board.OnBoardModel(
        title: "",
        description: "",
        imgUrl: secondImage,
      ),
      board.OnBoardModel(
        title: "",
        description: "",
        imgUrl: thirdImage,
      ),
    ];

    circleImageUrl =
        "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/OnboardingImages%2Fenterprisedemo%2FOnboarding_circles.png?alt=media&token=0f3d2a4e-1782-4126-9f15-d50fee754166";
    // circleImageUrl = "https://upgradedenterprise.instancy.com/content/onboarding/Onboarding_circles.png";
    onBoardData = [
      const board.OnBoardModel(
        title: "",
        description: "",
        imgUrl: "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/OnboardingImages%2Fenterprisedemo%2F1_image.png?alt=media&token=a739bdce-8337-42e1-a29e-deb7cf4ad190",
        // imgUrl: "https://upgradedenterprise.instancy.com/content/onboarding/1_image.png",
      ),
      const board.OnBoardModel(
        title: "",
        description: "",
        imgUrl: "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/OnboardingImages%2Fenterprisedemo%2F2_image.png?alt=media&token=48e483df-c882-4d45-9c53-17dce9da0676",
        // imgUrl: "https://upgradedenterprise.instancy.com/content/onboarding/2_image.png",
      ),
      const board.OnBoardModel(
        title: "",
        description: "",
        imgUrl: "https://firebasestorage.googleapis.com/v0/b/instancy-f241d.appspot.com/o/OnboardingImages%2Fenterprisedemo%2F3_image.png?alt=media&token=4aef780d-87a9-464b-b5ff-ebfc4fbae071",
        // imgUrl: "https://upgradedenterprise.instancy.com/content/onboarding/3_image.png",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return Scaffold(
      body: getMainBody2(),
    );
  }

  Widget getMainBody2() {
    return Stack(
      alignment: Alignment.topCenter,
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          // alignment: Alignment.topCenter,
          child: getCircles(),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Container()),
            Expanded(child: Container()),
            Expanded(child: Container()),
            getCarouselView(),
            getAppLogo(),
            const SizedBox(
              height: 10,
            ),
            Text(
              appProvider.localStr.loginScreenOnBoardingMessage,
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: getSignInButton(
                appProvider.localStr.loginButtonSigninbutton,
                themeData.primaryColor,
                isDarkBackground: true,
                onPressed: () {
                  NavigationController.navigateToLoginScreen(context: context, selectedSectionIndex: 0);
                },
              ),
            ),
            Expanded(child: Container()),
            signUpText(),
            const SizedBox(
              height: 10,
            )
          ],
        )
      ],
    );
  }

  Widget getCircles() {
    if(circleImageUrl.isNotEmpty) {
      return CommonCachedNetworkImage(
        imageUrl: circleImageUrl,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.contain,
        placeholder: (_, __) => SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.3,
          child: const SizedBox(),
        ),
      );
    }
    else {
      return Image.asset(
        circleUrl,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
        color: themeData.primaryColor,
      );
    }
  }

  Widget getAppLogo() {
    String logoUrl = appProvider.appSystemConfigurationModel.appLogoURl;
    MyPrint.printOnConsole("logoUrl:$logoUrl");

    // return CachedNetworkImage(imageUrl: logoUrl);

    return CommonCachedNetworkImage(
      imageUrl: logoUrl,
      height: 80,
      width: 250,
      errorIconSize: 60,
      placeholder: (_, __) => const SizedBox(),
    );
  }

  Widget getSignInButton(String text, Color color, {Function()? onPressed, bool isDarkBackground = false}) {
    return CommonButton(
      onPressed: onPressed,
      text: text,
      borderColor: isDarkBackground ? color : Colors.grey,
      fontColor: isDarkBackground ? Colors.white : Colors.black,
      fontWeight: FontWeight.w600,
      backGroundColor: color,
      borderRadius: 15,
      fontSize: 16,
      padding: const EdgeInsets.symmetric(vertical: 14),
      minWidth: MediaQuery.of(context).size.width,
    );
  }

  Widget getCarouselView() {
    return OnBoard(
      pageController: _pageController,
      // Either Provide onSkip Callback or skipButton Widget to handle skip state
      onSkip: () {
        // print('skipped');
      },
      // Either Provide onDone Callback or nextButton Widget to handle done state
      onDone: () {
        // print('done tapped');
      },
      onBoardData: onBoardData,
      titleStyles: const TextStyle(
        color: Colors.deepOrange,
        fontSize: 18,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.15,
      ),
      descriptionStyles: TextStyle(
        fontSize: 16,
        color: Colors.brown.shade300,
      ),
      imageHeight: 229,
      imageWidth: 228,
      // imageColor: themeData.primaryColor,
      nextButton: Container(),
      pageIndicatorStyle: board.PageIndicatorStyle(
        width: 100,
        inactiveColor: themeData.primaryColor.withOpacity(0.3),
        activeColor: themeData.primaryColor,
        inactiveSize: const Size(8, 8),
        activeSize: const Size(12, 12),
      ),
      skipButton: Container(),
      itemBuilder: ({required board.OnBoardModel onBoardModel}) {
        Widget imageWidget;
        if(onBoardModel.imgUrl.startsWith("http://") || onBoardModel.imgUrl.startsWith("https://")) {
          MyPrint.printOnConsole("onBoardModel.imgUrl:${onBoardModel.imgUrl}");

          imageWidget = CommonCachedNetworkImage(
            imageUrl: onBoardModel.imgUrl,
            width: 228,
            height: 229,
            fit: BoxFit.contain,
            placeholder: (_, __) => const CommonLoader(isCenter: true),
          );
        }
        else {
          imageWidget = Image.asset(
            onBoardModel.imgUrl,
            width: 228,
            height: 229,
            fit: BoxFit.contain,
          );
        }

        return SizedBox(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30,),
              imageWidget,
              const SizedBox(height: 20,),
              // Container(
              //   margin: const EdgeInsets.symmetric(horizontal: 12),
              //   child: Text(
              //     onBoardData[index].title,
              //     textAlign: TextAlign.center,
              //     style: titleStyles ??
              //         const TextStyle(
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold,
              //         ),
              //   ),
              // ),
              // Container(
              //   padding: const EdgeInsets.symmetric(vertical: 12),
              //   margin: const EdgeInsets.symmetric(horizontal: 12),
              //   child: Text(
              //     onBoardData[index].description,
              //     textAlign: TextAlign.center,
              //     style: descriptionStyles ??
              //         const TextStyle(
              //           fontSize: 14,
              //           color: Colors.black54,
              //         ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  Widget signUpText() {
    return RichText(
      text: TextSpan(text: "Don’t have an account? ", style: const TextStyle(fontSize: 16, color: Colors.black), children: [
        TextSpan(
          text: appProvider.localStr.loginButtonSignupbutton,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              NavigationController.navigateToLoginScreen(context: context, selectedSectionIndex: 1);
            },
          style: TextStyle(
            fontSize: 16,
            color: themeData.primaryColor,
            decoration: TextDecoration.underline,
            // height: 5
          ),
        )
      ]),
    );
  }
}

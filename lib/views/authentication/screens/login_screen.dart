import 'package:flutter/material.dart';
import 'package:flutter_instancy_2/backend/app/app_provider.dart';
import 'package:flutter_instancy_2/models/app_configuration_models/data_models/app_ststem_configurations.dart';
import 'package:flutter_instancy_2/utils/extensions.dart';
import 'package:provider/provider.dart';

import '../../../backend/authentication/authentication_controller.dart';
import '../../../backend/authentication/authentication_provider.dart';
import '../../../backend/navigation/navigation_controller.dart';
import '../../../models/authentication/data_model/profile_config_data_model.dart';
import '../../../models/authentication/data_model/profile_config_data_ui_control_model.dart';
import '../../../utils/my_print.dart';
import '../../../utils/my_toast.dart';
import '../../main_screen/screens/main_screen.dart';
import '../components/sign_in_view.dart';
import '../components/sign_up_view.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/LoginScreen";

  final int selectedSectionIndex;
  const LoginScreen({
    Key? key,
    this.selectedSectionIndex = 0,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late ThemeData themeData;

  late AppProvider appProvider;

  late AuthenticationController authenticationController;
  late AuthenticationProvider authenticationProvider;

  String logoUrl = "assets/images/playgroundlogo.png";
  
  //Sign In
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPassController = TextEditingController();
  bool isSignInPasswordVisible = false, isSignInProgress = false;

  //Sign Up
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  bool isSignUpInProgress = false;

  String linkDineLogoUrl = "assets/socials/Linkedin Logo.png";
  String fbLogoUrl = "assets/socials/Fb.png";
  String googleLogoUrl = "assets/socials/google.png";
  String twitterLogoUrl = "assets/socials/Twitter Logo.png";

  int selectedSectionIndex  = 0;

  List<ProfileConfigDataModel> profileConfigDataList = [];

  Future<void> loginWithEmailAndPassword({required String email, required String password}) async {
    FocusScope.of(context).requestFocus(FocusNode());

    bool isValid = (signInFormKey.currentState?.validate() ?? false);
    MyPrint.printOnConsole("isValid:$isValid");
    if(!isValid) {
      return;
    }

    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    setState(() {
      isSignInProgress = true;
    });

    bool isUserLoggedIn = await authenticationController.loginWithEmailEnaPassword(username: email, password: password);

    isSignInProgress = false;

    if(isUserLoggedIn) {
      setState(() {});

      Navigator.pushNamedAndRemoveUntil(NavigationController.mainNavigatorKey.currentContext!, MainScreen.routeName, (route) => false);
    }
    else {
      setState(() {});

      MyToast.showError(context: context, msg: appProvider.localStr.loginAlerttitleSigninfailed);
    }
  }

  Future<void> signUp() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if(signUpFormKey.currentState?.validate() ?? false) {
      MyPrint.printOnConsole("Validated");

      AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

      isSignUpInProgress = true;
      setState(() {});

      bool isRegistered = await authenticationController.signUpUserWithSelfRegistration(
        context: context,
        data: profileConfigDataList,
        enableMembership: appProvider.appSystemConfigurationModel.enableMembership,
      );

      MyPrint.printOnConsole("isRegistered:$isRegistered");

      isSignUpInProgress = false;

      if(isRegistered) {
        String email = profileConfigDataList.where((element) => element.profileConfigDataUIControlModel?.isEmail == true).firstElement?.profileConfigDataUIControlModel?.value ?? "";
        String password = profileConfigDataList.where((element) => element.profileConfigDataUIControlModel?.isPassword == true).firstElement?.profileConfigDataUIControlModel?.value ?? "";

        MyPrint.printOnConsole("Email:$email");
        MyPrint.printOnConsole("Password:$password");

        selectedSectionIndex = 0;

        loginEmailController.text = email;
        loginPassController.text = password;

        for (ProfileConfigDataModel profileConfigData in profileConfigDataList) {
          ProfileConfigDataUIControlModel? profileConfigDataUIControlModel = profileConfigData.profileConfigDataUIControlModel;
          if(profileConfigDataUIControlModel != null) {
            profileConfigDataUIControlModel.value = "";
            profileConfigDataUIControlModel.confirmPasswordTextEditingController?.clear();
            profileConfigDataUIControlModel.textEditingController?.clear();
            profileConfigDataUIControlModel.isPassVisible = true;
            profileConfigDataUIControlModel.isConfPassVisible = true;
          }
        }
      }

      setState(() {});
    }
    else {
      MyPrint.printOnConsole("Not Validated");
    }
  }

  void getProfileConfigData() {
    profileConfigDataList = authenticationProvider.profileConfigDataList.map((e) {
      ProfileConfigDataModel profileConfigData = ProfileConfigDataModel.fromJson(e.toJson());
      profileConfigData.initializeProfileConfigDataUIControlModel();

      return profileConfigData;
    }).toList();
    MyPrint.printOnConsole("ProfileConfigDataListssss: ${profileConfigDataList.length}");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    appProvider = context.read<AppProvider>();

    if([0, 1].contains(widget.selectedSectionIndex)) {
      selectedSectionIndex = widget.selectedSectionIndex;
    }

    authenticationProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    authenticationController = AuthenticationController(authenticationProvider: authenticationProvider);
    // getFuture = getSignupFields();
    getProfileConfigData();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body:getMainBody2(),
      ),
    );
  }

  Widget getMainBody2() {
    return Consumer<AppProvider>(
      builder: (BuildContext context, AppProvider appProvider, Widget? child) {
        AppSystemConfigurationModel appSystemConfigurationModel = appProvider.appSystemConfigurationModel;
        bool isGoogleLoginEnabled = appSystemConfigurationModel.isGoogle;
        bool isFacebookLoginEnabled = appSystemConfigurationModel.isFaceBook;
        bool isTwitterLoginEnabled = appSystemConfigurationModel.isTwitter;
        bool isLinkedInLoginEnabled = appSystemConfigurationModel.isLinkedIn;

        List<bool> socialEnabledList = [
          isGoogleLoginEnabled,
          isFacebookLoginEnabled,
          isTwitterLoginEnabled,
          isLinkedInLoginEnabled,
        ];

        return Stack(
          children: [
            backGround(),
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        welcomeText(),
                        loginSignUpView(isSignUpAllowed: appSystemConfigurationModel.selfRegistrationAllowed),
                        if(socialEnabledList.contains(true)) getOrText(),
                        if(socialEnabledList.contains(true)) socialsView(
                          isGoogleLoginEnabled: isGoogleLoginEnabled,
                          isFacebookLoginEnabled: isFacebookLoginEnabled,
                          isTwitterLoginEnabled: isTwitterLoginEnabled,
                          isLinkedInLoginEnabled: isLinkedInLoginEnabled,
                        ),
                        const SizedBox(height: 30,),
                        // SizedBox(height: 100,),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget backGround(){
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeData.primaryColor,
            themeData.primaryColor.withOpacity(0.7),
            themeData.primaryColor.withOpacity(0.2)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter
        )
      ),
      height: MediaQuery.of(context).size.height /2,
    );
  }

  Widget welcomeText() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25).copyWith(top: MediaQuery.of(context).size.height * 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
        Text(
          appProvider.localStr.loginScreenWelcomeTitle,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: themeData.colorScheme.background,
          ),
        ),
        const SizedBox(height: 21,),
          Text(appProvider.localStr.loginScreenWelcomeDescription,style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: themeData.colorScheme.background),)
        ],
      ),
    );
  }

  //region Login/SignUp View
  Widget loginSignUpView({bool isSignUpAllowed = true}){
    return Center(
      child: Container(
        margin: const EdgeInsets.all(25),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Colors.white,
          elevation: 5,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            // height:selectedIndex == 0 ? 400 : 450,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                  children: [
                    headerView(isSignUpAllowed: isSignUpAllowed),
                    const SizedBox(height: 20,),
                    selectedSectionIndex == 0 ? signInView() : signupView(),
                    // widgetList[selectedIndex],
                  ],
                ),
            ),
          ),
        ),
      ),
    );
  }

  Widget headerView({bool isSignUpAllowed = true}){
    return Row(
      children: [
        headerText(appProvider.localStr.loginButtonSigninbutton,0),
        const SizedBox(width: 30,),
        if(isSignUpAllowed) headerText(appProvider.localStr.loginButtonSignupbutton, 1)
      ],
    );
  }

  Widget headerText(String text, int index){
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2,
            color: selectedSectionIndex == index ?  themeData.primaryColor: Colors.transparent
          )
        )
      ),
      child: InkWell(
          onTap: (){
            setState(() {
              selectedSectionIndex = index;
            });
          },
          child: Text(text,style: TextStyle(color: selectedSectionIndex == index? themeData.primaryColor : Colors.grey, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 0.5),)),
    );
  }

  //region Login View
  Widget signInView(){
    return SignInView(
      signInFormKey: signInFormKey,
      loginEmailController: loginEmailController,
      loginPassController: loginPassController,
      isSignInPasswordVisible: isSignInPasswordVisible,
      isSignInProgress: isSignInProgress,
      isPasswordVisibilityChanged: () {
        setState(() {
          isSignInPasswordVisible = !isSignInPasswordVisible;
        });
      },
      signIn: loginWithEmailAndPassword,
    );
  }
  //endregion

  //region Sign UP View
  Widget signupView(){
    return SignUpView(
      profileConfigDataList: profileConfigDataList,
      setState: () {
        setState(() {});
      },
      onSignUpSuccess: ({required String email, required String password}) {
        selectedSectionIndex = 0;

        MyPrint.printOnConsole("Email:$email");
        MyPrint.printOnConsole("Password:$password");

        for (ProfileConfigDataModel profileConfigData in profileConfigDataList) {
          ProfileConfigDataUIControlModel? profileConfigDataUIControlModel = profileConfigData.profileConfigDataUIControlModel;
          if(profileConfigDataUIControlModel != null) {
            profileConfigDataUIControlModel.value = "";
            profileConfigDataUIControlModel.confirmPasswordTextEditingController?.clear();
            profileConfigDataUIControlModel.textEditingController?.clear();
            profileConfigDataUIControlModel.isPassVisible = true;
            profileConfigDataUIControlModel.isConfPassVisible = true;
          }
        }
        setState(() {});
      },
      signUp: signUp,
      signUpFormKey: signUpFormKey,
      isSignUpInProgress: isSignUpInProgress,
    );
  }
  //endregion
  //endregion

  Widget getOrText(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25.0),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(child: Divider(color: Colors.black54,)),
              Text("   or   ",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w700,fontSize: 16),),
              Expanded(child: Divider(color: Colors.black54,)),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 30),
            child: Text(
              "Sign In with Social Media",
              style: themeData.textTheme.labelLarge?.copyWith(
                // color: Colors.black,
                fontWeight: FontWeight.w700,
                // letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //region Social Login Buttons
  Widget socialsView({bool isGoogleLoginEnabled = false, bool isFacebookLoginEnabled = false, bool isTwitterLoginEnabled = false,
    bool isLinkedInLoginEnabled = false, }) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
           if(isGoogleLoginEnabled) socialsIcon(googleLogoUrl),
           if(isFacebookLoginEnabled) socialsIcon(fbLogoUrl),
           if(isTwitterLoginEnabled) socialsIcon(twitterLogoUrl),
           if(isLinkedInLoginEnabled) socialsIcon(linkDineLogoUrl),
        ],
      ),
    );
  }

  Widget socialsIcon(String url) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),

      child: Container(
          padding: const EdgeInsets.all(15),
          height: 60,
          width: 60,
          child: Image.asset(url,height: 10,width: 10,fit: BoxFit.contain,)),
    );
  }
  //endregion
}



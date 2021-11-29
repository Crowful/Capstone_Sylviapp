import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylviapp_project/Domain/wrapperAuth.dart';
import 'package:sylviapp_project/Domain/wrapperCatchSignup.dart';
import 'package:sylviapp_project/Domain/wrapperMap.dart';
import 'package:sylviapp_project/Domain/wrapperVerify.dart';
import 'package:sylviapp_project/config/theme_config.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:sylviapp_project/screens/account_module/account_management.dart';
import 'package:sylviapp_project/screens/account_module/add_money.dart';
import 'package:sylviapp_project/screens/account_module/before_login.dart';
import 'package:sylviapp_project/screens/account_module/edit_account.dart';
import 'package:sylviapp_project/screens/account_module/forgot_password.dart';
import 'package:sylviapp_project/screens/account_module/onboarding.dart';
import 'package:sylviapp_project/screens/account_module/reset_password.dart';
import 'package:sylviapp_project/screens/account_module/verification.dart';
import 'package:sylviapp_project/screens/account_module/verify_email.dart';
import 'package:sylviapp_project/screens/campaign_module/campaign_monitor_organizer.dart';
import 'package:sylviapp_project/screens/campaign_module/campaign_monitor_volunteer.dart';
import 'package:sylviapp_project/screens/campaign_module/ongoing_campaign.dart';
import 'package:sylviapp_project/screens/campaign_module/recent_activity.dart';
import 'package:sylviapp_project/screens/account_module/login.dart';
import 'package:sylviapp_project/screens/account_module/register.dart';
import 'package:sylviapp_project/screens/donation_module/donation_screen.dart';
import 'package:sylviapp_project/screens/layout_screen.dart';
import 'package:sylviapp_project/screens/campaign_module/map.dart';
import 'package:sylviapp_project/screens/settings_module/aboutus.dart';
import 'package:sylviapp_project/screens/settings_module/privacy.dart';
import 'package:sylviapp_project/screens/settings_module/sendfeedback.dart';
import 'package:sylviapp_project/screens/settings_module/settings.dart';
import 'package:sylviapp_project/translations/codegen_loader.g.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  Paint.enableDithering = true;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(ProviderScope(
      child: EasyLocalization(
          supportedLocales: [Locale('en'), Locale('fil')],
          path: 'assets/translations',
          fallbackLocale: Locale('en', 'US'),
          assetLoader: CodegenLoader(),
          child: MyApp())));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {
    final isDark = watch(themingProvider);

    return MaterialApp(
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      theme: isDark.darkTheme == false ? light : dark,
      initialRoute: "/wrapperAuth",
      routes: {
        "/": (_) => SettingsPage(),
        "/settings": (_) => SettingsPage(),
        "/register": (_) => RegisterPage(),
        "/forgot_password": (_) => ForgotPasswordScreen(),
        "/onboarding": (_) => OnboardingScreen(),
        "/home": (_) => LayoutScreen(),
        "/verify_email": (_) => VerifyEmail(),
        "/login": (_) => LoginScreen(),
        "/wrapperAuth": (_) => WrapperAuth(),
        "/account_management": (_) => AccountManagementScreen(
              uid: context.read(authserviceProvider).getCurrentUserUID(),
            ),
        "/welcome": (_) => WelcomeScreen(),
        "/map": (_) => MapScreen(),
        "/recent_activity": (_) => RecentActivity(),
        "/ongoing_campaign": (_) => OngoingCampaign(),
        "/edit_profile": (_) => EditProfile(),
        "/getverified": (_) => VerificationPage(),
        "/reset_password": (_) => ResetPassword(),
        "/wrapperMap": (_) => WrapperMap(),
        "/WrapperVerify": (_) => WrapperVerify(),
        "/donation": (_) => DonationScreen(),
        "/try_organizer_monitor": (_) => CampaignMonitorOrganizer(
              uidOfCampaign: "elgytiXREqLT2Cm",
            ),
        "/try_volunteer_monitor": (_) => CampaignMonitorVolunteer(
              uidOfCampaign: "xiS4w1zhscqZQNi",
            ),
        '/add_money': (_) => AddmoneyScreen(),
        '/wrapperCatchSignup': (_) => SignupDomain(),
        '/privacy': (_) => PrivacyScreen(),
        '/aboutus': (_) => AboutUsScreen(),
        '/sendfeedback': (_) => SendFeedbackScreen(),
      },
    );
  }
}

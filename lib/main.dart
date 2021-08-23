import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylviapp_project/config/theme_config.dart';
import 'package:sylviapp_project/providers/providers.dart';
import 'package:sylviapp_project/screens/forgot_password.dart';
import 'package:sylviapp_project/screens/home.dart';
import 'package:sylviapp_project/screens/register.dart';
import 'package:sylviapp_project/screens/settings.dart';
import 'package:sylviapp_project/translations/codegen_loader.g.dart';
import 'package:sylviapp_project/widgets/register_basic_info.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();
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
      initialRoute: "/",
      routes: {
        "/": (_) => HomePage(),
        "/settings": (_) => SettingsPage(),
        "/register": (_) => RegisterPage(),
        "/forgot_password": (_) => ForgotPasswordScreen(),
        "/basicReg": (_) => BasicInfoPage()
      },
    );
  }
}

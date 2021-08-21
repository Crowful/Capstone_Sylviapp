import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sylviapp_project/Domain/theme&language_notifier.dart';
import 'package:sylviapp_project/services/authservices.dart';

final themingProvider = ChangeNotifierProvider((ref) => ThemeNotifier());

final languageProvider = ChangeNotifierProvider((ref) => ThemeNotifier());

final authserviceProvider = Provider((ref) => AuthService());

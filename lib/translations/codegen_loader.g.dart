// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader {
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String, dynamic> en = {
    'greetings': "Hello User",
    'love': "I love you",
    'Dark Mode': "Dark Mode",
    'changeLanguage': 'Change Language',
    'privacy': 'Privacy',
    'help': 'Help',
    'aboutus': 'About us',
    'sendfeedback': 'Send Feedback',
    'myaccount': 'My Account',
    'recentactivity': 'Recent Activity',
    'balance': 'Balance',
    'settings': 'Settings',
    'logout': 'Logout',
    'overview': 'Overview',
    'yourcampaigns': 'Your Campaigns',
    'allreforestationcampaign': 'All Reforestation Campaign',
    'analyticsinoverallreforestation': 'Analytics in Overall Reforestation',
    'activeCampaign': 'Active Campaign',
    'doneCampaign': 'Done Campaign',
    'campaignInProgress': 'Campaign in Progress',
    'volunteers': 'Volunteers',
    'organizers': 'Organizers',
    'overallcampaign': 'Overall Campaign',
  };

  static const Map<String, dynamic> fil = {
    "greetings": "Kamusta gumagamit",
    "love": "mahal kita",
    'Dark Mode': "Madilim na Tema",
    'changeLanguage': 'baguhin ang wika',
    'privacy': 'Pribado',
    'help': 'Tulong',
    'aboutus': 'Tungkol sa amin',
    'sendfeedback': 'Magbigay ng mensahe',
    'myaccount': 'Aking Account',
    'recentactivity': 'Kamakailang Aktibidad',
    'balance': 'Balanse',
    'settings': 'Magtakda',
    'logout': 'Umalis',
    'overview': 'Pangkalahatang Ideya',
    'yourcampaigns': 'Iyong Mga Kampanya',
    'allreforestationcampaign': 'Lahat ng kampanya sa reporestasyon',
    'analyticsinoverallreforestation': 'Pagsusuri sa lahat ng reporestasyon',
    'activeCampaign': 'Aktibong Kampanya',
    'doneCampaign': 'Tapos na Kampanya',
    'campaignInProgress': 'Kasalukuyang Kampanya',
    'volunteers': 'Boluntaryo',
    'organizers': 'Taga-ayos',
    'overallcampaign': 'Pangkalahatang Kampanya',
  };
  static const Map<String, Map<String, dynamic>> mapLocales = {
    "en": en,
    "fil": fil
  };
}

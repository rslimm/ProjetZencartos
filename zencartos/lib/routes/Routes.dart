import 'package:flutter/cupertino.dart';
import 'package:zencartos/pages/LoginPage.dart';
import 'package:zencartos/pages/ShowMapContribuable.dart';
import 'package:zencartos/pages/contribuablesPage.dart';
import 'package:zencartos/routes/Router.dart';
import 'package:zencartos/settings/404.dart';


Map<String, Widget> routes = {
  '/': LoginPage(),
  '/Pages/SettingsPage': ContribuablesPage(),
  '/Pages/ShowMapContribuable': ShowMapContribuable(),

  RouterMode.ROUTE_404: Page_404()
};
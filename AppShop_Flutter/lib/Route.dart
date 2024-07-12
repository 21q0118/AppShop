import 'package:app_shop/pages/login/ForgetPwdPage.dart';
import 'package:app_shop/pages/login/LoginPage.dart';
import 'package:app_shop/pages/login/RegisterPage.dart';
import 'package:app_shop/pages/login/UserAgreementPage.dart';
import 'package:app_shop/pages/tabs.dart';
import 'package:app_shop/pages/tabs/Home/jump.dart';
import 'package:app_shop/pages/tabs/Home/like.dart';
import 'package:app_shop/pages/tabs/Home/search_jump.dart';
import 'package:app_shop/pages/tabs/manage/body.dart';
import 'package:app_shop/pages/user/EditHeadPortraitPage.dart';
import 'package:app_shop/pages/user/EditPwdPage.dart';
import 'package:app_shop/pages/user/UserInfoPage.dart';
import 'package:app_shop/pages/user/UserSettingsPage.dart';
import 'package:app_shop/pages/user/EditIcon.dart';
import 'package:flutter/material.dart';





final routes= {
  '/JpreData':(context,{arguments})=>jumppage(arguments:arguments),
  '/JoverData':(context,{arguments})=>jumppage(arguments:arguments),
  '/Massage': (context,{arguments}) => ManageBodyWidget(arguments:arguments),
  '/ManageBodyWidget': (context,{arguments}) => ManageBodyWidget(arguments:arguments),
  '/Home': (context,{arguments}) => MyHomePage(arguments:arguments),
  '/jump':(context,{arguments})=>jumppage(arguments:arguments),
  '/jump_search':(context)=>search_jumpPage(),
  '/login': (context) => LoginPage(),
  '/login/register': (context) => RegisterPage(),
  '/login/register/agreement':(context) => UserAgreementPage(),
  '/login/forget':(context,{arguments}) => ForgetPwdPage(arguments:arguments),
  '/home/setting':(context,{arguments}) => UserSettingsPage(arguments:arguments),
  '/home/setting/userInfo':(context,{arguments}) => UserInfoPage(arguments:arguments),
  '/home/setting/userInfo/editPwd':(context,{arguments}) => EditPwdPage(arguments:arguments),
  '/home/setting/userInfo/editIcon':(context,{arguments}) => EditIconPage(arguments:arguments),
  '/home/headImage':(context,{arguments}) => EditHeadPortraitPage(arguments:arguments),
  '/home/like':(context,{arguments}) => Likepage(arguments:arguments),
};

//固定写法
var onGenerateRoute = (RouteSettings settings){
  //String? 表示 name 为可空类型
  final String? name = settings.name;
  //Function? 表示 pageContentBuilder 为可空类型
  final Function? pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
      MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
import 'dart:convert';
import 'dart:typed_data';

import 'package:app_shop/pages/tabs/manage/search_list.dart';
import 'package:device_apps/device_apps.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

import '../../../host.dart';
import 'delete.dart';
import 'edit.dart';
//nwdl
class ManageBodyWidget extends StatefulWidget {
  const ManageBodyWidget({Key? key, required this.arguments}) : super(key: key);

  final Map arguments;

  @override
  State<StatefulWidget> createState() {
    return _ManageBodyState();
  }
}

class _ManageBodyState extends State<ManageBodyWidget> {
  ScrollController scrollController = ScrollController();
  final ScrollController _scrollController = ScrollController();

  List categoryList = [
    "游戏",
    "社交",
    "媒体",
    "办公",
    "购物",
    "教育",
    "医疗",
    "金融",
    "旅游",
    "摄影"
  ];
  Map<String, dynamic> appInfo={};
  String currentCategory = "游戏";
  String currentChip = "经营策略";

  FocusNode focusNode = FocusNode();
  List<Map<String,dynamic>> listMap = [];

  late Future _future;

  @override
  void initState() {
    super.initState();
    _future = getListByType();
    getApp();
    _getInstalledApps();
  }

  Future getListByType() async {
    var client = http.Client();
    final url = Uri.parse(
        "http://a408599l51.wicp.vip/App/selectAppByType?appType=$currentChip");
    Utf8Decoder decode = const Utf8Decoder();
    await client.get(url).then((response) async {
      if (response.statusCode == 200) {
        setState(() {
          listMap = List<Map<String, dynamic>>.from(
              json.decode(decode.convert(response.bodyBytes)));
        });
      }
    });
  }
  List<Map<String, dynamic>> _installedApps = [];
 late List<Application> apps=[];


  static const platform = MethodChannel('com.example.app_shop/icons');


  Future<void> _getInstalledApps() async {
    try {
      final List<dynamic> apps = await platform.invokeMethod('getInstalledApps');
      setState(() {
        _installedApps = apps.map((app) {
          final Map<Object?, Object?> appMap = app;
          return appMap.map((key, value) => MapEntry(key.toString(), value));
        }).toList();
      });
    } on PlatformException catch (e) {
    }
  }
  List<dynamic> iconData =[];
  Future<void> getApp() async {
    List<Application> _apps = await DeviceApps.getInstalledApplications(
        onlyAppsWithLaunchIntent: true,
        includeAppIcons: true,
        includeSystemApps: true);
    for (final packapp in _installedApps) {
      for (Application app in _apps) {
        if (packapp['appName'] == app.appName) {
          iconData.add(packapp['icon']);
          break;
        }
      }
    }
    setState(() {
      apps = _apps;
    });
  }
  Future<void> openapp(String packageName) async{
    await DeviceApps.openApp(packageName);
  }
  Future<void> uninstallapp(String packageName) async{
    await DeviceApps.uninstallApp(packageName);
    Navigator.pop(context, false);
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(child: CupertinoActivityIndicator());
          case ConnectionState.active:
          case ConnectionState.done:
            return Container(
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Expanded(child:
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: Column(
                            children: [
                              Expanded(
                                flex: 10,
                                child: _appListView(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                    ,)
                ],
              ),
            );
        }
      },
    );
  }

  Widget _appListView() {
    return ListView.separated(
      controller: scrollController,
      shrinkWrap: true,
      itemCount:  apps.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0), // 设置圆角的大小// 设置背景颜色（可选）
              child: Image.memory(iconData[index],fit: BoxFit.contain,width: 40,height: 40,)

          ),
          title: Text(apps[index].appName),
          subtitle: Text(apps[index].versionName??"0"),
          onTap:() =>openapp(apps[index].packageName),
          onLongPress: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.delete_forever),
                      title: const Text("卸载"),
                      onTap: () =>uninstallapp(apps[index].packageName)
                    ),
                  ],
                );
              },
            );
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(
          height: 0.3,
          color: Colors.black26,
        );
      },
    );
  }

}

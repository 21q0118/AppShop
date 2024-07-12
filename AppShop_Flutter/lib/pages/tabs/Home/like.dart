import 'dart:convert';
import 'dart:io';

import 'package:app_shop/host.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:dio/dio.dart';
import '../../user/UserPage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_star/flutter_star.dart';

class Likepage extends StatefulWidget {
  Map arguments;

  Likepage({Key? key, required this.arguments}) : super(key: key);

  @override
  State<Likepage> createState() => _LikepageState(arguments: this.arguments);
}

class _LikepageState extends State<Likepage> {
  final _controller = ScrollController();
  Map arguments;

  _LikepageState({required this.arguments});

  @override
  void initState() {
    super.initState();
    _future = dio_picture();
    dio_list();
    dio_jingxuan_first();
  }

  Map<String, dynamic> appInfo = {};


  List list_jingxuan_first = [];
  int? len_jingxuan_first;

  void dio_jingxuan_first() async {
    var url = Uri.parse('$host/appAll');
    Utf8Decoder decode = new Utf8Decoder();
    var headers = {
      'Content-Type': 'application/json',
    };

    var params = {};
    final putData = jsonEncode(params);
    var response = await http.post(url, headers: headers, body: putData);
    appInfo = json.decode(decode.convert(response.bodyBytes));
    if (appInfo["code"] == 200) {
      setState(() {
        list_jingxuan_first.clear();
        list_jingxuan_first.add(appInfo["data"]);
        len_jingxuan_first = list_jingxuan_first[0].length;
        //   categoryMap[currentCategory] = response.data;
      });
    }
  }

  late Future _future;

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
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.blue[800],
                    centerTitle: true,
                    leading: Builder(builder: (BuildContext context) {
                      return IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context, false);
                          });
                    }),
                      titleTextStyle: TextStyle(fontSize: 18),
                    actions: [
                      IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/jump_search');
                          },
                          icon: Icon(
                            Icons.search,
                            color: Colors.white,
                          )),
                    ],
                    title:Text("收藏")

                  ),
                  body:
                      Column(children: [
                        //这是第二个是一个列表
                        Expanded(
                          flex: 7,
                          child: ListView.separated(
                            controller: _controller,
                            itemCount: len_list ?? 0,
                            separatorBuilder: (context, index) {
                              return Divider(
                                color: Colors.grey,
                              );
                            },
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            8.0), // 设置圆角的大小// 设置背景颜色（可选）
                                        child: Image(
                                          image: NetworkImage((list_list !=
                                              null &&
                                              list_list.length > 0 &&
                                              list_list[0][index] != null &&
                                              len_list! > 0)
                                              ? host +
                                              list_list[0][index]['icon']
                                              : first_picture),
                                          fit: BoxFit.contain,
                                          width: 40,
                                          height: 40,
                                        )),
                                    title: Text(
                                        "${(list_list[0] != null && list_list[0].length > 0) ? list_list[0][index]['appName'] : '暂无'} "),
                                    hoverColor: Colors.blue[200],
                                    subtitle: StarScore(
                                      score: double.parse(double.parse(
                                          list_list[0][index]['score'])
                                          .toStringAsFixed(1)),
                                      star: Star(
                                          size: 14,
                                          fillColor: Colors.yellow,
                                          emptyColor:
                                          Colors.grey.withAlpha(88)),
                                    ),
                                    trailing:Icon(Icons.keyboard_arrow_right,color: Colors.grey,),
                                    /*Text(
                                        "${(list_list[0] != null && list_list[0].length > 0) ? double.parse(list_list[0][index]['size']).toStringAsFixed(2) + "MB" : ''} "),*/
                                    onTap: () {
                                      Navigator.pushNamed(context, '/jump',
                                          arguments: {
                                            "id": (list_list != null &&
                                                list_list.length > 0)
                                                ? list_list[0][index]["id"]
                                                : '',
                                            "filename": (list_list != null &&
                                                list_list.length > 0)
                                                ? list_list[0][index]["apk"]
                                                : '',
                                            "score":double.parse(list_list[0][index]['score']).toStringAsFixed(1)
                                          });
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        )
                      ]),
                  ),
            );
        }
      },
    );
  }

  List list_picture = [];
  int? len;
  String first_picture = 'http://a408599l51.wicp.vip/imgs/rotation/1.jpg';

  Future dio_picture() async {
    final dio = Dio();
    final response =
    await dio.get("http://a408599l51.wicp.vip/Rotation/selectAllRotation");
    List<String> picpath = ["images/QQ.png", "images/Word.jpg", "mrfz.jpg"];
    setState(() {
      list_picture.add(picpath);
      len = list_picture[0].length;
    });
  }

  List list_list = [];
  int? len_list;

  int? len_list1;


  void dio_list() async {
    var url = Uri.parse('$host/appAll');
    Utf8Decoder decode = new Utf8Decoder();
    var headers = {
      'Content-Type': 'application/json',
    };

    var params = {};
    final putData = jsonEncode(params);
    var response = await http.post(url, headers: headers, body: putData);
    appInfo = json.decode(decode.convert(response.bodyBytes));
    setState(() {
      list_list.add(appInfo["data"]);
      len_list = (appInfo["data"].length > 0) ? list_list[0].length : 1;
    });
  }

  Future<void> refresh() async {
    var url = Uri.parse('$host/appAll');
    Utf8Decoder decode = new Utf8Decoder();
    var headers = {
      'Content-Type': 'application/json',
    };
    var params = {};
    final putData = jsonEncode(params);
    var response = await http.post(url, headers: headers, body: putData);
    appInfo = json.decode(decode.convert(response.bodyBytes));
    setState(() {
      list_list.clear();
      list_list.add(appInfo["data"]);
      len_list = (appInfo["data"].length > 0) ? list_list[0].length : 1;
    });
  }
}

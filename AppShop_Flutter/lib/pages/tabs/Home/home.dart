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

class Homepage extends StatefulWidget {
  Map arguments;

  Homepage({Key? key, required this.arguments}) : super(key: key);

  @override
  State<Homepage> createState() => _HomePageState(arguments: this.arguments);
}

class _HomePageState extends State<Homepage> {
  final _controller = ScrollController();
  Map arguments;

  _HomePageState({required this.arguments});

  @override
  void initState() {
    super.initState();
    _future = dio_picture();
    dio_list();
    dio_jingxuan_first();
    searchbytag(1);
    List<String> picpath = [
      "images/QQ.png",
      "images/Word.jpg",
      "images/mrfz.jpg"
    ];
    list_picture.add(picpath);
    len = list_picture[0].length;
  }

  ScrollController scrollController = ScrollController();
  final ScrollController _scrollController = ScrollController();
  TextEditingController conditionController = TextEditingController();

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

  // Map categoryMap = {
  //   "游戏": ["经营策略", "角色扮演", "休闲益智", "动作冒险", "音乐舞蹈"],
  //   "通用": ["视频播放", "社交通讯", "网上购物", "音乐电台", "金融理财"],
  //   "教育": ["早教启蒙", "在线学习", "行业考试", "语言学习", "学生解题"]
  // };
  Map<String, dynamic> appInfo = {};

  String currentCategory = "游戏";
  String currentChip = "经营策略";

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
                            Icons.person,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          });
                    }),
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
                    title: TabBar(
                      isScrollable: true,
                      labelStyle: TextStyle(fontSize: 18),
                      unselectedLabelStyle: TextStyle(fontSize: 13),
                      indicatorColor: Colors.white,
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.white,
                      tabs: <Widget>[
                        Tab(
                          text: "精选",
                        ),
                        Tab(
                          text: "分类",
                        ),
                      ],
                    ),
                  ),
                  drawer: UserPage(loginAccount: arguments['loginAccount']),
                  body: TabBarView(
                    children: <Widget>[
                      Column(children: [
                        //第一个是轮播图
                        Expanded(
                          flex: 3,
                          child: AspectRatio(
                            aspectRatio: 2.0,
                            child: Swiper(
                              itemBuilder: (BuildContext context, int index) {
                                return Image.asset("${list_picture[0][index]}");
                              },
                              itemCount: len ?? 0,
                              pagination: const SwiperPagination(),
                              control: const SwiperControl(),
                            ),
                          ),
                        ),
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
                                    trailing:
                                       Icon(Icons.keyboard_arrow_right,color: Colors.grey,),

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
                      Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    child: _categoryListView(),
                                  ),
                                ),
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
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
            );
        }
      },
    );
  }

  Widget _categoryListView() {
    return ListView.builder(
      controller: scrollController,
      itemCount: 10,
      itemBuilder: (context, index) {
        return TextButton(
          child: Text(
            categoryList[index],
            style: TextStyle(
              color: currentCategory == categoryList[index]
                  ? Colors.blue
                  : Colors.black54,
            ),
          ),
          onPressed: () {
            currentCategory = categoryList[index];
            // currentChip = categoryMap[currentCategory][0];
            searchbytag(index + 1);
          },
        );
      },
    );
  }

  Widget _appListView() {
    return Container(
      alignment: Alignment.topCenter,
      child: ListView.separated(
        controller: _scrollController,
        shrinkWrap: true,
        itemCount: len_list1 ?? 0,
        itemBuilder: (context, index) {
          return ListTile(
            leading: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                // 设置圆角的大小// 设置背景颜色（可选）
                child: Image(
                  image: NetworkImage((list_list1 != null &&
                          list_list1.length > 0 &&
                          list_list1[0][index] != null &&
                          len_list1! > 0)
                      ? host + list_list1[0][index]['icon']
                      : first_picture),
                  fit: BoxFit.contain,
                  width: 40,
                  height: 40,
                )),
            title: Text(
                "${(list_list1[0] != null && list_list1[0].length > 0) ? list_list1[0][index]['appName'] : '暂无'} "),
            hoverColor: Colors.blue[200],
            subtitle: Text(
                "${(list_list1[0] != null && list_list1[0].length > 0) ? double.parse(list_list1[0][index]['size']).toStringAsFixed(2) + "MB" : ''} "),
            onTap: () {
              Navigator.pushNamed(context, '/jump', arguments: {
                "id": (list_list != null && list_list.length > 0)
                    ? list_list1[0][index]["id"]
                    : '',
                "filename": (list_list != null && list_list.length > 0)
                    ? list_list1[0][index]["apk"]
                    : '',
              });
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(
            height: 0.3,
            color: Colors.black26,
          );
        },
      ),
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

  List list_list1 = [];
  int? len_list1;

  //searchbytag
  void searchbytag(int index) async {
    Map<String, dynamic> cateappInfo = {};
    var url = Uri.parse('$host/searchAppByTag?tag=${index}');
    Utf8Decoder decode = new Utf8Decoder();
    var headers = {
      'Content-Type': 'application/json',
    };

    var params = {};
    final putData = jsonEncode(params);
    var response = await http.post(url, headers: headers, body: putData);
    cateappInfo = json.decode(decode.convert(response.bodyBytes));

    setState(() {
      list_list1.clear();
      if (cateappInfo["data"] != null) {
        list_list1.add(cateappInfo["data"]);
      }
      len_list1 = (cateappInfo["data"].length > 0) ? list_list1[0].length : 1;
    });
  }

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

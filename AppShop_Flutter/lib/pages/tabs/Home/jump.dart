//这是跳转接口
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_star/custom_rating.dart';
import 'package:flutter_star/star.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../host.dart';

class jumppage extends StatefulWidget {
  final arguments;

  jumppage({Key? key, this.arguments}) : super(key: key);

  @override
  State<jumppage> createState() => _jumpState(arguments: this.arguments);
}

class _jumpState extends State<jumppage> {
  final arguments;

  _jumpState({this.arguments});

  @override
  void initState() {
    super.initState();
    _future = dioNetwork();
    _future = Future.value(0.0);
    getscorenum();
    getscores();
  }

  List listMap = [];
  List<String> ScreenShoot = [];
  int? Screen_count;

  Future dioNetwork() async {
    Map<String, dynamic> appInfo = {};
    Utf8Decoder decode = new Utf8Decoder();
    var headers = {
      'Content-Type': 'application/json',
    };

    var params = arguments["id"];
    var url = Uri.parse('$host/searchAppByID?appId=$params');
    var response = await http.post(url, headers: headers);
    setState(() {
      appInfo = json.decode(decode.convert(response.bodyBytes));
      listMap.add(appInfo["data"]);
    });
  }

  String first_picture = 'https://devtool.tech/api/placeholder/300/300?text=loading';


  late Future _future;


  double _progress = 0.0;
  bool _isDownloading = false;

  Future<String> getDownloadDirectoryPath() async {
    if (Platform.isAndroid) {
      // Android 10及以上版本使用分区存储
      final directory = await getExternalStorageDirectory();
      return directory?.path ?? '';
    } else {
      // iOS等其他平台
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }
  }

  Future<File> downloadFile(String url, String filename) async {
    var client = http.Client();
    var request = http.Request('GET', Uri.parse(url));
    var response = await client.send(request);
    int totalBytes = response.contentLength ?? 0;
    int receivedBytes = 0;

    final dirPath = await getDownloadDirectoryPath();
    String filePath = '$dirPath/$filename';
    File file = File(filePath);
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    List<int> bytes = [];
    response.stream.listen(
          (List<int> newBytes) {
        bytes.addAll(newBytes);
        receivedBytes += newBytes.length;
        setState(() {
          _progress = receivedBytes / totalBytes;
        });
      },
      onDone: () async {
        await file.writeAsBytes(bytes);
        setState(() {
          _isDownloading = false;
        });
        client.close();
        OpenFile.open(file.path);
      },
      onError: (e) {
        setState(() {
          _isDownloading = false;
        });
        client.close();
      },
      cancelOnError: true,
    );

    return file;
  }

  void saveFile() async {
    setState(() {
      _isDownloading = true;
      _progress = 0.0;
    });

    try {
      String url = '$host/downloadApp?id=${arguments["id"]}';
      String filename = '${arguments["filename"]}';
      await downloadFile(url, filename);
    } catch (e) {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  String scorenum = "";

  Future<void> getscorenum() async {
    int id = arguments["id"];
    Map<String, dynamic> num = {};
    var url = Uri.parse('$host/getAppScoreNum?appId=${id}');
    Utf8Decoder decode = new Utf8Decoder();
    var response = await http.post(url);
    num = json.decode(decode.convert(response.bodyBytes));
    if (num["code"] == 200) {
      setState(() {
        scorenum = num["data"].toString();
      });
    } else {
      setState(() {
        scorenum = num["data"].toString();
      });
    }
  }



  double score=0.0;

  Future<void> commitscore(double score) async{
    Map<String, dynamic> num = {};
    var url = Uri.parse('$host/updateScore');
    var params={
      "appID":arguments['id'],
      "num":1,
      "score":score
    };
    var headers = {
      'Content-Type': 'application/json',
    };
    Utf8Decoder decode = new Utf8Decoder();
    final putData = jsonEncode(params);
    var response = await http.post(url,body: putData,headers: headers);
    num = json.decode(decode.convert(response.bodyBytes));
    if (num["code"] == 200) {
      Fluttertoast.showToast(
          msg: "提交成功",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: num["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  bool isFavorited = false;
  String buttonText = '已收藏';
  void toggleFavorite() {
    setState(() {
      isFavorited = !isFavorited;
      buttonText = isFavorited ? '收藏' : '已收藏';
    });
  }
  String getscore="";
  Future<void> getscores() async {
    int id = arguments["id"];
    Map<String, dynamic> num = {};
    var url = Uri.parse('$host/getAppScore?appId=${id}');
    Utf8Decoder decode = new Utf8Decoder();
    var response = await http.post(url);
    num = json.decode(decode.convert(response.bodyBytes));
    if (num["code"] == 200) {
      setState(() {
        getscore = num["data"];
      });
    } else {
      setState(() {
        getscore = num["data"];
      });
    }
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
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(40),
                child: AppBar(
                  title: Text(
                    "${(listMap != null && listMap.length > 0)
                        ? listMap[0]['appName']
                        : ''} ",
                    style: TextStyle(color: Colors.black),
                  ),
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ),
              ),
              body: ListView(
                padding: EdgeInsets.all(10),
                children: <Widget>[
                  Container(
                    height: 100,
                    child: Row(
                      children: [
                        Expanded(
                          child: ListTile(
                              leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  // 设置圆角的大小// 设置背景颜色（可选）

                                  child: Image(
                                    image: NetworkImage((listMap != null &&
                                        listMap.length > 0 &&
                                        listMap[0] != null)
                                        ? host + listMap[0]['icon']
                                        : first_picture,),
                                    fit: BoxFit.contain,
                                    width: 40,
                                    height: 40,)


                              ),


                              title: Text(
                                  "${(listMap != null && listMap.length > 0)
                                      ? listMap[0]['appName']
                                      : ''} "),
                              subtitle: Text(
                                  "大小：${(listMap != null &&
                                      listMap.length > 0) ? double.parse(
                                      listMap[0]["size"]).toStringAsFixed(2) +
                                      "MB" : ""}"),
                              trailing: Column(children: <Widget>[
                                Text("评分：${double.parse(getscore).toStringAsFixed(1)}"),
                                Text("评分人数:${scorenum}"),

                              ]

                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                      child: Expanded(
                        flex: 1,
                        child: Container(
                            margin: EdgeInsets.all(0),
                            width: 130,
                            child:ElevatedButton(
                              onPressed: toggleFavorite,
                              child: Text(buttonText),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty
                                    .all(
                                    Color(0xAAFC5B5B)),
                                foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                                textStyle: MaterialStateProperty.all(
                                    TextStyle(fontSize: 15)),
                                shape: MaterialStateProperty.all(
                                    const StadiumBorder(
                                        side: BorderSide(
                                          style: BorderStyle.solid,
                                          color: Color(0xAAFC5B5B),
                                        ))),
                              ),
                            )
                        ),)),

                  Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.white, Colors.grey.shade50]),
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 18.0),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  "版本号：${(listMap != null &&
                                      listMap.length > 0)
                                      ? listMap[0]['version']
                                      : ''}",
                                  textAlign: TextAlign.center,
                                )),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  "开发公司：${(listMap != null &&
                                      listMap.length > 0)
                                      ? listMap[0]['corp']
                                      : ''}",
                                  textAlign: TextAlign.center,
                                )),
                          ],
                        ),
                      )),
                  Container(
                    child: ExpansionTile(
                        title: Text('简介'),
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "${(listMap != null && listMap.length > 0)
                                  ? listMap[0]['index']
                                  : ''}",
                              style: TextStyle(
                                fontSize: 14,
                              ),),

                          )
                        ]
                    ),
                  ),
                  Container(
                    child: ExpansionTile(
                        title: Text('日志'),
                        children: <Widget>[
                          ListTile(
                            title:
                            Text(
                              "创建时间:${(listMap != null &&
                                  listMap.length > 0)
                                  ? listMap[0]['create_time']
                                  : ''}",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          ListTile(
                            title:
                            Text(
                              "更新时间:${(listMap != null &&
                                  listMap.length > 0)
                                  ? listMap[0]['updateTime']
                                  : ''}",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          )
                        ]
                    ),
                  ),
                  Container(
                    child: ExpansionTile(
                        title: Text('提交评分'),
                        children: <Widget>[
                          ListTile(
                            leading: CustomRating(
                                max: 5,
                                star: Star(
                                    num: 5,
                                    fillColor: Colors.yellow,
                                    fat: 0.5,
                                    emptyColor: Colors.grey.withAlpha(88)),
                                onRating:(s){
                                  score=s;
                                }
                            ),
                            trailing: ElevatedButton(child: Text("提交"),onPressed: () {
                              commitscore(score);
                            },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty
                                    .all(
                                    Color(0xAACDBC66)),
                                foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                                textStyle: MaterialStateProperty.all(
                                    TextStyle(fontSize: 15)),
                                shape: MaterialStateProperty.all(
                                    const StadiumBorder(
                                        side: BorderSide(
                                          style: BorderStyle.solid,
                                          color: Color(0xAACDBC66),
                                        ))),
                              ),),
                          ),
                        ]
                    ),

                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isDownloading)
                          Column(
                            children: [
                              LinearProgressIndicator(value: _progress,
                                  backgroundColor: Color(0xFFCCCCCC),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xAA66CDAA))),
                              SizedBox(height: 20),
                              Text('${(_progress * 100).toStringAsFixed(0)}%'),
                            ],
                          )
                        else
                          Container(
                            height: 95,
                            margin: const EdgeInsets.fromLTRB(50, 0, 50, 20),
                            child: Column(
                              children: [
                                SizedBox(height: 50),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    margin: EdgeInsets.all(0),
                                    width: 200,
                                    child: ElevatedButton(
                                      child:
                                      Text('下载'),


                                      onPressed: () {
                                        saveFile();
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: MaterialStateProperty
                                            .all(
                                            Color(0xAA66CDAA)),
                                        foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                        textStyle: MaterialStateProperty.all(
                                            TextStyle(fontSize: 20)),
                                        shape: MaterialStateProperty.all(
                                            const StadiumBorder(
                                                side: BorderSide(
                                                  style: BorderStyle.solid,
                                                  color: Color(0xAA66CDAA),
                                                ))),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                ],
              ),
            );
        }
      },
    );
  }
}

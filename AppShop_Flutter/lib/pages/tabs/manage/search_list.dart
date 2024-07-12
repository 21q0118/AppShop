import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'delete.dart';
import 'edit.dart';

class SearchListWidget extends StatefulWidget{
  const SearchListWidget({Key? key,required this.arguments}) : super(key: key);

  final Map arguments;
  @override
  State<StatefulWidget> createState() {
    return SearchListState();
  }

}

class SearchListState extends State<SearchListWidget>{
  ScrollController scrollController = ScrollController();
  TextEditingController conditionController = TextEditingController();
  List<Map<String, dynamic>> listMap = [];

  @override
  void initState(){
    super.initState();
  }


  void getListByCondition(condition) async{
    var client = http.Client();
    final url = Uri.parse("http://a408599l51.wicp.vip/App/selectAppByCondition?condition=$condition");
    Utf8Decoder decode = const Utf8Decoder();
    client.get(url).then((response) async {
      if (response.statusCode == 200) {
        setState(() {
          listMap = List<Map<String, dynamic>>.from(json.decode(decode.convert(response.bodyBytes)));
          if(listMap.isEmpty){
            Fluttertoast.showToast(
                msg: "未搜索到相应内容",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                fontSize: 16.0
            );
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("搜索App"),backgroundColor: Colors.blue[800],),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: ListView(
          children: [
            TextField(
              controller: conditionController,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))
                  ),
                  prefixIcon: Icon(Icons.search),
                  hintText: "请输入搜索App"
              ),
              onSubmitted: (value){
                setState(() {
                  getListByCondition(value);
                });
              }
            ),
            Container(
              padding: const EdgeInsets.all(5),
              child: ListView.separated(
                controller: scrollController,
                shrinkWrap: true,
                itemCount: listMap.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(listMap[index]["appIcon"]),
                    ),
                    title: Text(listMap[index]["appName"]),
                    subtitle: Text(listMap[index]["appVersion"]),
                    onLongPress: (){
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context){
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.edit),
                                title: const Text("更改"),
                                onTap: () {
                                  Future future = Navigator.push(context,
                                      MaterialPageRoute(
                                        builder: (context) => EditAppWidget(appId: listMap[index]["appId"],arguments: widget.arguments,),
                                        settings: RouteSettings(name: "路由名",arguments: listMap[index]["appId"]),
                                      )
                                  );
                                  future.then((value) {
                                    if(value == false){
                                      setState(() {
                                        Navigator.pop(context);
                                      });
                                    }
                                  });
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.delete_forever),
                                title: const Text("删除"),
                                onTap: (){
                                  Future future = Navigator.push(context,
                                      MaterialPageRoute(
                                        builder: (context) => DeleteAppWidget(appId: listMap[index]["appId"],arguments: widget.arguments,),
                                        settings: RouteSettings(name: "路由名",arguments: listMap[index]["appId"]),
                                      )
                                  );
                                  future.then((value) {
                                    if(value == false || value == null){
                                      setState(() {
                                        Navigator.pop(context);
                                      });
                                    }
                                  });
                                },
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
              ),
            )
          ],
        ),
      )
    );
  }

  Future showDeleteDialog(){
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("温馨提示"),
          titlePadding: const EdgeInsets.all(10),
          titleTextStyle: const TextStyle(color: Colors.black87, fontSize: 16),
          content: const Text("您确定要删除吗?"),
          contentPadding: const EdgeInsets.all(10),
          contentTextStyle: const TextStyle(color: Colors.black54, fontSize: 14),
          actions: [
            TextButton(
              child: const Text("取消"),
              onPressed: () {
                Navigator.pop(context,false);
              },
            ),
            ElevatedButton(
              child: const Text("确定"),
              onPressed:(){
                Navigator.pop(context,false);
              },
            )
          ],
        );
      }
    );
  }
}
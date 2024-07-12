import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;

class DeleteAppWidget extends StatefulWidget{
  const DeleteAppWidget({Key? key,required this.appId,required this.arguments}) : super(key: key);

  final Map arguments;
  final int appId;
  @override
  State<StatefulWidget> createState() {
    return DeleteAppState();
  }

}

class DeleteAppState extends State<DeleteAppWidget>{

  var app = {};
  TextEditingController nameController = TextEditingController();
  TextEditingController versionController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController explainController = TextEditingController();
  TextEditingController applyExplainController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List chipList = [];
  String chipString = '';

  late Future _future;

  @override
  void initState(){
    super.initState();
    _future = getListByAppId();
  }

  Future getListByAppId() async{
    var client = http.Client();
    final url = Uri.parse("http://a408599l51.wicp.vip/App/selectAppById?appId=${widget.appId}");
    Utf8Decoder decode = const Utf8Decoder();
    client.get(url).then((response) async {
      if (response.statusCode == 200) {
        setState(() {
          app = json.decode(decode.convert(response.bodyBytes));
          nameController.text = app["appName"];
          versionController.text = app["appVersion"];
          explainController.text = app["appExplain"];

          chipString = app["appType"];
          chipList = chipString.split(';');
          chipList.removeAt(chipList.length-1);
        });
      }
    });
  }

  void deleteApp () async{
    var client = http.Client();
    final url = Uri.parse("http://a408599l51.wicp.vip/App/deleteApp");
    client.post(url,body: {
      "appId":widget.appId.toString(),
      "loginAccount": widget.arguments["loginAccount"],
      "applyExplain":applyExplainController.text,
    }).then((response) async {
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "操作成功",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 16.0
        );
      }
    });
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
                appBar: AppBar(title: const Text("删除App信息"),
                  backgroundColor: Colors.blue[800],
                 ),
                body: ListView(
                  children: [
                    // imageWidget(),
                    deleteFormWidget(),
                    Container(
                      height: 100,
                      padding: const EdgeInsets.only(top: 30,bottom: 20,left: 50,right: 50),
                      child: ElevatedButton(
                        child: const Text("删除"),
                        onPressed: (){
                          if(_formKey.currentState!.validate()){
                            Future future = showDeleteDialog();
                            future.then((value) {
                              if(mounted){
                                setState(() {

                                });
                              }
                              if(value == false || value == null){
                                setState(() {
                                  Navigator.pop(context);
                                });
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
          }
        });


  }

  Widget deleteFormWidget(){
    return SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.only(top:20,left: 30,right: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //App名称
              Row(
                children: [
                  const Icon(Icons.local_library,color: Colors.grey,),
                  const Expanded(flex: 1,child: Text("名称",style: TextStyle(fontSize: 16),),),
                  Expanded(flex: 5,child: TextFormField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      border: InputBorder.none,
                    ),
                    controller: nameController,
                    enabled: false,
                  ),)
                ],
              ),
              const Divider(height: 1.0,color: Colors.grey,),
              //App版本
              Row(
                children: [
                  const Icon(Icons.layers,color: Colors.grey,),
                  const Expanded(flex: 1,child: Text("版本",style: TextStyle(fontSize: 16),),),
                  Expanded(flex: 5,child: TextFormField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      border: InputBorder.none,
                    ),
                    controller: versionController,
                    enabled: false,
                  ),)
                ],
              ),
              const Divider(height: 1.0,color: Colors.grey,),
              //App类型
              Row(
                children: [
                  const Icon(Icons.local_offer,color: Colors.grey,),
                  const Expanded(flex: 1,child: Text("类型",style: TextStyle(fontSize: 16),),),
                  Container(
                    width: 220,
                    height: 50,
                    alignment: Alignment.centerLeft,
                    // padding: const EdgeInsets.only(left: 5),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: chipList.length,
                      itemBuilder: (BuildContext context, int index){
                        return  Chip(
                          label: Text(chipList[index]),
                          /*deleteIcon: const Icon(Icons.clear),
                          onDeleted: (){
                            setState(() {
                              chipList.remove(chipList[index]);
                            });
                          },*/
                        );
                      },
                    ),
                  ),
                ],
              ),
              const Divider(height: 1.0,color: Colors.grey,),
              //App简介
              Container(
                padding: const EdgeInsets.only(top: 15,bottom: 30),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.bookmarks,color: Colors.grey,),
                        Expanded(flex: 1,child: Text("简介",style: TextStyle(fontSize: 16),),),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 4,
                                )
                            )
                        ),
                        maxLines: null,
                        controller: explainController,
                        enabled: false,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1.0,color: Colors.grey,),
              Container(
                padding: const EdgeInsets.only(top: 15),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.bookmarks,color: Colors.grey,),
                        Expanded(flex: 1,child: Text("理由",style: TextStyle(fontSize: 16),),),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            hintText: '请输入删除App的理由',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 4,
                                )
                            )
                        ),
                        maxLines: null,
                        minLines: 4,
                        controller: applyExplainController,
                        validator: (value){
                          if(value!.isEmpty){
                            return "App申请理由不可为空";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
                  Navigator.pop(context,true);
                },
              ),
              ElevatedButton(
                child: const Text("确定"),
                onPressed:(){
                  deleteApp();
                  Navigator.pop(context,false);
                },
              )
            ],
          );
        }
    );
  }

}
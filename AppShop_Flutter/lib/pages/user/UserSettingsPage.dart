import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app_shop/host.dart';
import 'package:http/http.dart' as http;


class UserSettingsPage extends StatefulWidget{
  Map arguments;

  UserSettingsPage({Key? key,required this.arguments}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _UserSettingsPageState(arguments:this.arguments);
  }
}

class _UserSettingsPageState extends State<UserSettingsPage>{
  Map arguments;
  _UserSettingsPageState({required this.arguments});

  var _index=0;

  @override
  void initState(){
    super.initState();
  }

  _deleteAccount()async{
    var queryParamUrl = Uri.parse('$host/delUser?telephone=${arguments['loginAccount']}');
    Utf8Decoder decode = new Utf8Decoder();
    var headers = {
      'Content-Type': 'application/json',
    };
    var params = {};
    final putData = jsonEncode(params);
    var response = await http.post(queryParamUrl, headers: headers, body: putData);
    setState(() {
      if(response.statusCode==200){
        Navigator.pushNamed(context, '/login');
        Fluttertoast.showToast(
            msg: "账号注销成功",
            gravity: ToastGravity.CENTER,
            textColor: Colors.grey
        );
      }else{
        Fluttertoast.showToast(
            msg: "账号注销失败",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设置'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.verified_user),
            ),
            title: Text('账号与安全'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: (){
              Navigator.pushNamed(context, '/home/setting/userInfo',arguments: {
                'loginAccount':arguments['loginAccount'],
                'loginPassword':arguments['loginPassword'],
                'loginRole':arguments['loginRole'],
                'loginName':arguments['loginName'],
                'loginMail':arguments['loginMail'],
                'profilePhoto':arguments['profilePhoto'],
              });
            },
          ),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.directions_walk),
            ),
            title: Text('退出登录'),
            onTap: (){
              _index=1;
              showBottomSheet();
            },
          ),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.delete_forever),
            ),
            title: Text('注销账号'),
            onTap: (){
              _index=2;
              showBottomSheet();
            },
          ),
        ],
      ),
    );
  }

  void showBottomSheet() {
    //用于在底部打开弹框的效果
    showModalBottomSheet(builder: (BuildContext context) {
      //构建弹框中的内容
      return buildBottomSheetWidget(context);
    }, context: context);
  }
  Widget buildBottomSheetWidget(BuildContext context){
    return Container(
      height: 160,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              child: Align(
                alignment: Alignment.center,
                  child: Text('取消',style: TextStyle(fontSize: 20),)
              ),
              onTap: (){
                Navigator.pop(context);
              },
            )
          ),
          Divider(),
          Expanded(
              flex: 1,
              child: GestureDetector(
                child: Align(
                    alignment: Alignment.center,
                    child: Text('确定',style: TextStyle(fontSize: 20))
                ),
                onTap: (){
                  if(_index==2){
                    _deleteAccount();
                  }else{
                    Navigator.pushNamed(context, '/login');
                  }
                },
              )
          ),
        ],
      ),
    );
  }

}
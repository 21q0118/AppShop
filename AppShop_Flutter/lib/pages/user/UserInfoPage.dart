import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:app_shop/host.dart';
import 'package:http/http.dart' as http;

class UserInfoPage extends StatefulWidget{
  Map arguments;
  UserInfoPage({Key? key,required this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _UserInfoPageState(arguments:this.arguments);
  }
}

class _UserInfoPageState extends State<UserInfoPage>{
  Map arguments;
  String _logintelephone = '';
  String _loginPassword = '';

  _UserInfoPageState({required this.arguments});



  void _getUserInfo() async {
    Map<String,dynamic>userInfo={};
    var queryParamUrl = Uri.parse('$host/userInfo?telephone=${arguments['loginAccount']}');
    Utf8Decoder decode = new Utf8Decoder();
    var headers = {
      'Content-Type': 'application/json',
    };
    var params = {};
    final putData = jsonEncode(params);
    var response = await http.post(queryParamUrl, headers: headers, body: putData);
    userInfo = json.decode(decode.convert(response.bodyBytes));
    // Map<String, dynamic> postData = {
    //   'telephone': '123456', // 假设这是您想要发送的电话号码
    // };

    try {
      if (response.statusCode == 200) { // 检查HTTP状态码是否为200，表示成功
        setState(() {

            arguments['loginAccount'] = userInfo["data"]["user"]['telephone'];
            if(userInfo["data"]["user"]['tag']==1){
              arguments['loginRole'] ="普通用户";
            }else if(userInfo["data"]["user"]['tag'] ==10){
              arguments['loginRole'] ="超级管理员";
            }else if (userInfo["data"]["user"]['tag'] ==0){
              arguments['loginRole'] ="管理员";
            }
            //arguments['loginRole'] = userInfo["data"]["user"]['tag'];
            arguments['loginName'] = userInfo["data"]["user"]['userName'];
            arguments['loginPetName'] = userInfo["data"]["user"]['petName'];
            arguments['profilePhoto'] =host+userInfo["data"]["user"]['icon'];
        });
      }
    } catch (e) {
      // 处理网络错误
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('账号与安全'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('用户头像'),
            trailing: Container(
              height: 50,
              width: 50,
              child:ClipOval(
                child:arguments['profilePhoto'].toString().isNotEmpty
                    ?Image.network('${arguments['profilePhoto']}',fit: BoxFit.cover,):null,
              ),
            ),
          ),
          ListTile(
            title: Text('用户名'),
            trailing: Text('${arguments['loginName']}'),
          ),
          ListTile(
            title: Text('绑定的电话号码'),
            trailing:Text('${arguments['loginAccount']}')
          ),
          ListTile(
            title: Text('修改密码'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: (){
              Navigator.pushNamed(context, '/home/setting/userInfo/editPwd',arguments: {
                'loginPassword':arguments['loginPassword'],
                'loginAccount':arguments['loginAccount'],
              }).then((value) => value=='true'?_getUserInfo():null);
            },
          ),
          ListTile(
            title: Text('账号角色'),
            trailing:Text(arguments['loginRole']),
          ),
        ],
      ),
    );
  }
}
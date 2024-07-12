import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_shop/host.dart';
import 'package:http/http.dart' as http;

class UserPage extends StatefulWidget{
  final String loginAccount;
  const UserPage({Key? key,required this.loginAccount}) : super(key: key);

   @override
   _UserPageState createState()=>_UserPageState(loginAccount:this.loginAccount);


}

class _UserPageState extends State<UserPage>{
  final String loginAccount;
  _UserPageState({required this.loginAccount});


  final Map _userInfo={
    "loginAccount": "",//userInfo["data"]["telephone"]
    "loginRole": "",//userInfo["data"]["tag"]
    "loginName": "",//userInfo["data"]["userName"]
    "loginPetName": "",//userInfo["data"]["petName"]
    'profilePhoto': "",//userInfo["data"]["icon"]
  };

  late Future _future;

  @override
  void initState(){
    _future = _postUserInfo();

    super.initState();
  }

  Future _postUserInfo() async {
    Map<String,dynamic>userInfo={};
    var queryParamUrl = Uri.parse('$host/userInfo?telephone=${loginAccount}');
    Utf8Decoder decode = new Utf8Decoder();
    var headers = {
      'Content-Type': 'application/json',
    };
    var params = {};
    final putData = jsonEncode(params);
    var response = await http.post(queryParamUrl, headers: headers, body: putData);
    userInfo = json.decode(decode.convert(response.bodyBytes));
    try {
      if (response.statusCode == 200) { // 检查HTTP状态码是否为200，表示成功
        setState(() {
          // 确保data是一个Map
          _userInfo['loginAccount'] = userInfo["data"]["user"]['telephone'];
          if(userInfo["data"]["user"]['tag']==1){
            _userInfo['loginRole'] ="普通用户";
          }else if(userInfo["data"]["user"]['tag'] ==10){
            _userInfo['loginRole'] ="超级管理员";
          }else if (userInfo["data"]["user"]['tag'] ==0){
            _userInfo['loginRole'] ="管理员";
          }
         // _userInfo['loginRole'] = userInfo["data"]["user"]['tag'];
          _userInfo['loginName'] = userInfo["data"]["user"]['userName'];
          _userInfo['profilePhoto'] = host + userInfo["data"]["user"]['icon'];
          // 现在应该能够打印出_userInfo了
        });
      } }
      catch (e) {
      // 处理网络错误
    }
  }






  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder(
        future: _future,
        builder:  (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CupertinoActivityIndicator(),);
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(child: Text('网络请求出错'),);
              }
              return Scaffold(
                body:ListView(
                  children:<Widget>[
                    Container(
                      height: 30,
                    ),
                    Container(
                      alignment: Alignment(0,0),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, '/home/headImage',arguments: {
                            'headImageUrl':_userInfo['profilePhoto'],
                            'loginAccount':_userInfo['loginName']
                          }).then((value) => value=='true'?initState():null);
                        },
                        child: Container(
                          height: 102,
                          width: 102,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue,width: 2),
                              borderRadius: BorderRadius.circular(90)
                          ),
                          child: ClipOval(
                            child: _userInfo['profilePhoto'].isNotEmpty
                                ?Image.network('${_userInfo['profilePhoto']}',fit: BoxFit.cover,height: 100, width: 100,)
                                :null,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment(0,-0.4),
                      child: Theme(data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(title: Text("用户名"),
                          initiallyExpanded: true,
                          children:<Widget>[
                            ListTile(
                              title: Text(
                                "${_userInfo['loginName']}",
                                style: TextStyle(color: Colors.black),),

                            )
                          ]
                      ),
                      /*alignment: Alignment(0,-0.4),
                    child: Text('用户名：${_userInfo['loginName']}', style: TextStyle(color: Colors.black),)*/
                    ),),
                    Container(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment(0,-0.2),
                      child:Theme(data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child:
                      ExpansionTile(title: Text("账号"),
                          initiallyExpanded: true,
                          children:<Widget>[
                            ListTile(
                              title: Text(
                                "${_userInfo['loginAccount']}",
                                style: TextStyle(color: Colors.black),),

                            )
                          ]
                      ),
                      //Text('电话号码：${_userInfo['loginAccount']}', style: TextStyle(color: Colors.black),)
                    ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment(0,0),
                      child:Theme(data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child:
                      ExpansionTile(title: Text("用户角色"),
                          initiallyExpanded: true,
                          children:<Widget>[
                            ListTile(
                              title: Text(
                                "${_userInfo['loginRole']}",
                                style: TextStyle(color: Colors.black),),

                            )
                          ]
                      ),
                      //Text('用户角色：${_userInfo['loginRole']}', style: TextStyle(color: Colors.black),)
                    ),),
                   Container(
                      height: 20,
                    ),
                    const Divider(color: Colors.grey,),
                    Container(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment(-1,0.5),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.settings),
                        ),
                        title: Text('设置'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: (){
                          Navigator.pushNamed(context, '/home/setting',arguments: {
                            'loginAccount':_userInfo['loginAccount'],
                            'loginRole':_userInfo['loginRole'],
                            'loginName':_userInfo['loginName'],
                            'loginMail':_userInfo['loginMail'],
                            'profilePhoto':_userInfo['profilePhoto'],
                          });
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment(-1,1.5),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(Icons.thumb_up),
                        ),
                        title: Text('收藏'),
                        trailing: Icon(Icons.keyboard_arrow_right),
                        onTap: (){
                          Navigator.pushNamed(context, '/home/like',arguments: {
                            "id":_userInfo['loginAccount']
                          });
                        },
                      ),
                    ),
                  ],
                )
               // children: [


               // ],
              );
          }
        },
      ),
    );
  }
}
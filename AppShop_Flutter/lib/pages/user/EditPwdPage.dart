import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:app_shop/host.dart';
import 'package:http/http.dart' as http;

class EditPwdPage extends StatefulWidget{
  Map arguments;
  EditPwdPage({Key? key,required this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditPwdPageState(arguments: this.arguments);
  }

}

class _EditPwdPageState extends State<EditPwdPage>{
  Map arguments;
  _EditPwdPageState({required this.arguments});

  final _currentPwdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPwdController = TextEditingController();

  var _isShowPwd = true;
  var _currentStep = 0;

 Map<String, dynamic> userInfo={};
  _login() async {

    var url = Uri.parse('$host/login');
    Utf8Decoder decode = new Utf8Decoder();

    var headers = {
      'Content-Type': 'application/json',
    };

    var params = {
      "telephone": arguments['loginAccount'],
      "password": _currentPwdController.text
    };
    final putData = jsonEncode(params);
    var response = await http.post(url, headers: headers, body: putData);
    setState(() {
      userInfo = json.decode(decode.convert(response.bodyBytes));


      if(userInfo['code']==200){
        _currentStep++;
      }else{
        Fluttertoast.showToast(
            msg: "密码错误",
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

  _setNewPwd()async{
    // Dio dio = Dio();
    // String url = Uri.parse('$host/updatePw').toString();
    // var response = await dio.post(url,queryParameters: {
    //   'loginAccount':arguments['loginAccount'],
    //   'loginPassword':_passwordController.text
    // });
    var url = Uri.parse('$host/updatePw');
    Utf8Decoder decode = new Utf8Decoder();
    var headers = {
      'Content-Type': 'application/json',
    };

    var params = {
      "telephone": arguments['loginAccount'],
      "password": _passwordController.text
    };
    final putData = jsonEncode(params);
    var response = await http.post(url, headers: headers, body: putData);
    setState(() {
      if(userInfo["code"] == 200){
        Fluttertoast.showToast(
            msg: "密码修改成功",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Navigator.pushNamed(context,'/login');
      }else{
        Fluttertoast.showToast(
            msg: "密码修改失败",
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
        title: Text('验证密码'),
      ),
      body:GestureDetector(
        onTap: ()=>{
          FocusScope.of(context).requestFocus(FocusNode())
        },
        child: Stepper(
          type: StepperType.horizontal,
          currentStep: _currentStep,
          onStepContinue: (){
            setState(() {
              FocusScope.of(context).requestFocus(FocusNode());
              if(_currentStep == 0){
                _login();
              }else if(_passwordController.text.length>5 && _passwordController.text.length<21  &&(_passwordController.text == _confirmPwdController.text)){
                _setNewPwd();
              }else if(_passwordController.text.isEmpty){
                Fluttertoast.showToast(
                    msg: "新密码不能为空",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }else if(_passwordController.text != _confirmPwdController.text &&_passwordController.text.length>5 &&_passwordController.text.length<21){
                Fluttertoast.showToast(
                    msg: "两次输入的密码不一致",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }else{
                Fluttertoast.showToast(
                    msg: "密码格式错误",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }
            });
          },
          controlsBuilder: (BuildContext context, ControlsDetails controls){
            return Container(
              margin: EdgeInsets.only(top: 30),
              height: 45,
              child: ElevatedButton(
                onPressed: controls.onStepContinue,
                child: _currentStep==0? Text('下一步', style: TextStyle(color: Colors.white),)
                    :Text('提交', style: TextStyle(color: Colors.white),),
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(TextStyle(fontSize: 18,)),
                  shape: MaterialStateProperty.all(
                    const StadiumBorder(
                        side: BorderSide(
                          style: BorderStyle.solid,
                          color: Color(0xAA87C1FF),
                        )
                    )
                  ),
                ),
              ),
            );
          },
          steps: [
            Step(
              isActive: _currentStep >= 0 ? true :false,
              title: Text('验证当前密码'),
              content: Container(
                height: 160,
                margin: EdgeInsets.only(top: 30),
                child: ListView(
                  children: [
                    TextField(
                      controller: _currentPwdController,
                      obscureText: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9+]')),
                        LengthLimitingTextInputFormatter(20),
                      ],
                      decoration: InputDecoration(
                        hintText: "请输入当前密码",
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/login/forget",arguments: {
                            'loginAccount':arguments['loginAccount']
                          });
                        },
                        child: Text('忘记密码',style: TextStyle(color: Colors.blue)),
                      ),
                    ),
                  ],
                ),
              )
            ),
            Step(
                isActive: _currentStep == 1 ? true :false,
                title: Text('设置新密码'),
                content: Container(
                  height: 160,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: _passwordController,
                          obscureText: _isShowPwd,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9+]')),
                            LengthLimitingTextInputFormatter(20),
                          ],
                          decoration: InputDecoration(
                              hintText: '请设置6-20位新的登录密码',
                              fillColor: Colors.white,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white,),
                              ),
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon((_isShowPwd) ? Icons.visibility_off : Icons.visibility),
                                onPressed: (){
                                  setState(() {
                                    _isShowPwd=!_isShowPwd;
                                  });
                                },
                              )
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _confirmPwdController,
                          obscureText: true,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9+]')),
                            LengthLimitingTextInputFormatter(20),
                          ],
                          decoration: InputDecoration(
                            hintText: '请再次输入新的登录密码',
                            fillColor: Colors.white,
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white,),
                            ),
                            prefixIcon: Icon(Icons.lock),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ),
          ],
        ),
      )
    );
  }
}
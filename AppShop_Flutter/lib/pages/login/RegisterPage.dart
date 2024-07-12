import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import '../../host.dart';

class RegisterPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {

  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPwdController = TextEditingController();
  final _mailController = TextEditingController();
  final _authCodeController = TextEditingController();
  final _userNameController = TextEditingController();

  var _isShowPwd = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _authCode='';
  String _record='';

  bool _isButtonEnable=true;  //按钮状态 是否可点击
  String buttonText='发送验证码'; //初始文本
  int count=60;      //初始倒计时时间
  Timer? _timer;
  void _buttonClickListen(){
    setState(() {
      if(_isButtonEnable){   //当按钮可点击时
        _isButtonEnable=false; //按钮状态标记
        _initTimer();
        return null;   //返回null按钮禁止点击
      }else{     //当按钮不可点击时
        return null;    //返回null按钮禁止点击
      }
    });
  }
  void _initTimer(){
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      count--;
      setState(() {
        if(count==0){
          timer.cancel();    //倒计时结束取消定时器
          _isButtonEnable=true;  //按钮可点击
          count=60;     //重置时间
          buttonText='发送验证码';  //重置按钮文本
        }else{
          buttonText='重新发送($count)'; //更新文本内容
        }
      });
    });
  }

  @override
  void dispose() {
    if(_timer!=null){
      _timer!.cancel();//销毁计时器
    }
    super.dispose();
  }
  
  _register()async{
    var _userInfo = {
      "userName":_accountController.text,
      "telephone": _mailController.text,
      "password": _passwordController.text,
    };
    String _userjsonString = jsonEncode(_userInfo);
    if(_authCodeController.text == _authCode) {
      Utf8Decoder decode = new Utf8Decoder();
      var url = Uri.parse('$host/register');
      var response = await http.post(url, body: _userjsonString, headers: {"content-type": "application/json"});
      Map<String, dynamic>res =json.decode(decode.convert(response.bodyBytes));
      setState(() {
        if (res["code"]==200) {
          Fluttertoast.showToast(
              msg: res["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0
          );
          Navigator.pushNamed(context, '/login');
        } else {
          Fluttertoast.showToast(
              msg: res["message"],
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
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('新用户注册'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => {
          FocusScope.of(context).requestFocus(FocusNode()),
        },
        child: Container(
          child: ListView(
            children: [
              Container(
                color: Colors.white,
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 20, left: 20,top: 30),
                height: 420,
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _accountController,
                          validator: (v) {
                            return v!.trim().isNotEmpty ? null : "用户名不能为空且不可修改";
                          },
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_]')),
                            LengthLimitingTextInputFormatter(20),
                          ],
                          decoration: InputDecoration(
                            contentPadding:EdgeInsets.all(0),
                            hintText: '请输入用户名',
                            fillColor: Colors.white,
                            filled: true,
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _isShowPwd,
                          validator: (v) {
                            return v!.trim().length > 5 ? null : "密码不能少于6位";
                          },
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9+]')),
                            LengthLimitingTextInputFormatter(20),
                          ],
                          decoration: InputDecoration(
                            contentPadding:EdgeInsets.all(0),
                            hintText: '请设置6-20位登录密码',
                            fillColor: Colors.white,
                            filled: true,
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
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
                          validator: (v){
                            return v==_passwordController.text ? null : '登录密码需相同';
                          },
                          obscureText:true,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9+]')),
                            LengthLimitingTextInputFormatter(20),
                          ],
                          decoration: InputDecoration(
                            contentPadding:EdgeInsets.all(0),
                            hintText: '请再次确认登录密码',
                            fillColor: Colors.white,
                            filled: true,
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            prefixIcon: Icon(Icons.lock),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _mailController,
                          keyboardType: TextInputType.number,

                          style: TextStyle(
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            contentPadding:EdgeInsets.all(0),
                            hintText: '请输入绑定手机号',
                            fillColor: Colors.white,
                            filled: true,
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            prefixIcon: Icon(Icons.phone),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 30,right: 30,top: 10),
                child: RichText(
                  text: TextSpan(
                      children: [
                        TextSpan(
                            text: '注册即同意',
                            style: TextStyle(
                              fontSize: 15.0,
                              color: Color(0xFF4A4A4A),
                            )
                        ),
                        TextSpan(
                          text: '《用户服务协议》',
                          recognizer: TapGestureRecognizer()..onTap = () {
                            Navigator.pushNamed(context, '/login/register/agreement');
                          },
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.blue,
                          )
                        ),
                      ]
                  ),

                ),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.only(left: 30,right: 30,top: 20,bottom: 10),
                child: ElevatedButton(
                  onPressed: () {
                      _register();
                  },
                  child: Text('注册',style: TextStyle(fontSize: 23),),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0xA087C1FF)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    textStyle: MaterialStateProperty.all(TextStyle(fontSize: 20)),
                    shape: MaterialStateProperty.all(
                        const StadiumBorder(
                            side: BorderSide(
                              style: BorderStyle.solid,
                              color: Color(0xA087C1FF),
                            )
                        )
                    ),
                  )
                ),
              ),
              Container(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text('已有账户，立即登录',style: TextStyle(color: Colors.blue),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


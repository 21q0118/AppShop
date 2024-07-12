import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ForgetPwdPage extends StatefulWidget{

  Map arguments;
  ForgetPwdPage({Key? key,required this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ForgetPwdPageState(arguments:this.arguments);
  }


}

class _ForgetPwdPageState extends State<ForgetPwdPage>{
  Map arguments;
  _ForgetPwdPageState({required this.arguments});

  var _currentStep = 0;

  final _mailController = TextEditingController();
  final _authCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPwdController = TextEditingController();

  var _isShowPwd = true;

  var _getMail;
  var _authCode='';

  @override
  void initState(){
    super.initState();
    _verifyPhone();
  }

  _verifyPhone()async{
    Dio dio =Dio();
    String url = 'http://a408599l51.wicp.vip/Login/selectLoginById';
    var response = await dio.get(url,queryParameters: {'loginAccount':arguments['loginAccount']});
    setState(() {
      _getMail = response.data['loginMail'].toString();
    });
  }

  _setNewPwd()async{
    Dio dio = Dio();
    String url = 'http://a408599l51.wicp.vip/Login/updatePassword';
    var response = await dio.post(url,queryParameters: {
      'loginAccount':arguments['loginAccount'],
      'loginPassword':_passwordController.text
    });
  }

  _getAuthCode()async{
    for(int i=0;i<4;i++){
      _authCode+=(Random().nextInt(10)).toString();
    }
    Dio dio = Dio();
    String url = 'http://a408599l51.wicp.vip/Mail/sendMail';
    var response = await dio.get(url,queryParameters: {
      'code':_authCode,
      'receiverMail':_mailController.text
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('找回密码'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => {
        FocusScope.of(context).requestFocus(FocusNode()),
        },
        child:Stepper(
          type: StepperType.horizontal,
          currentStep: _currentStep,
          onStepContinue: () {
            setState(() {
              FocusScope.of(context).requestFocus(FocusNode());
              if (_currentStep == 0 && _mailController.text== _getMail && _authCodeController.text==_authCode ) {
                _currentStep++;
              }else if(_mailController.text != _getMail){
                Fluttertoast.showToast(
                    msg: "请输入正确的邮箱",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }else if(_authCodeController.text.isEmpty){
                Fluttertoast.showToast(
                    msg: "验证码不能为空",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }else if(_authCodeController.text!=_authCode){
                Fluttertoast.showToast(
                    msg: "验证码错误",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              }else if(_passwordController.text.length>5 && _passwordController.text.length<21  &&(_passwordController.text == _confirmPwdController.text)){
                _setNewPwd();
                Fluttertoast.showToast(
                    msg: "密码修改成功",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                Navigator.pushNamed(context, '/login');
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
              }else if(_passwordController.text != _confirmPwdController.text &&_passwordController.text.length>5){
                Fluttertoast.showToast(
                    msg: "两次输入的密码不一致",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              } else{
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
          controlsBuilder: (BuildContext context, ControlsDetails controls) {
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
              title: Text('验证邮箱'),
              content: Container(
                height: 160,
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextField(
                        controller: _mailController,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        decoration: InputDecoration(
                          hintText: '请输入绑定的邮箱',
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white,),
                          ),
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        controller: _authCodeController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                          LengthLimitingTextInputFormatter(4),
                        ],
                        decoration: InputDecoration(
                          hintText: '请输入验证码',
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white,),
                          ),
                          prefixIcon: Icon(Icons.drafts),
                          suffixIcon:Container(
                            margin: EdgeInsets.only(top: 5,bottom: 5,right: 10),
                            child: OutlinedButton(
                                style: _isButtonEnable==true?OutlinedButton.styleFrom(
                                    side: BorderSide(width: 2, color: Color(0x80002FA7)),
                                    padding: EdgeInsets.only(left: 5,right: 5)
                                ):OutlinedButton.styleFrom(
                                    side: BorderSide(width: 2, color: Colors.grey),
                                    padding: EdgeInsets.only(left: 5,right: 5)
                                ),
                                onPressed: () {
                                  if(_mailController.text==_getMail){
                                    _getAuthCode();
                                    _buttonClickListen();
                                  }else{
                                    Fluttertoast.showToast(
                                        msg: "邮箱错误",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  }
                                },
                                child: Text(
                                  '$buttonText',
                                  style: _isButtonEnable==true?TextStyle(
                                      fontSize: 15,
                                      color: Color(0x90002FA7)
                                  ):TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                )
                            ),
                          ),
                        ),
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
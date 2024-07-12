// TODO Implement this library.
import 'package:app_shop/pages/tabs/manage/manageHome.dart';
import 'package:flutter/material.dart';
import 'tabs/Home/home.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

class MyHomePage extends StatefulWidget {
  Map arguments;
  MyHomePage({Key? key,required this.arguments}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState(arguments:this.arguments);
}

class _MyHomePageState extends State<MyHomePage> {
  Map arguments;
  _MyHomePageState({required this.arguments});

  final List _pageList = [];


  int _currentIndex = 0;


  appBarTitle(){
    switch(_currentIndex){
      case 0:
        return Text("首页");
      case 1:
        return Text("App管理");
      case 3:
        return Text("消息");
    }
  }

  appSearch(){
    switch(_currentIndex){
      case 0:
        return  IconButton(
            onPressed: (){
              Navigator.pushNamed(context, '/jump_search');
            },
            icon:Icon(Icons.search)
        );
      case 1:
        return 0;
      case 3:
        return 0;
    }
  }
  JPush jPush = JPush();
  String debugLabel='';
  @override
  void initState(){
    super.initState();
    _pageList.add(Homepage(arguments:arguments));
    _pageList.add(MangeHomeWidget(arguments:arguments));

    jPush.setAlias('${arguments['loginAccount']}').then((map)  {
      var tags = map['tags'];
      setState(() {
        debugLabel = "设置别名成功: $map $tags";
      });
    }).catchError((error){
      setState(() {
        debugLabel = "设置别名错误: $error";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pageList[_currentIndex] ,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
          },
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blue[700],
        backgroundColor: Colors.white,

        items:  [
          BottomNavigationBarItem(icon: Icon(Icons.home,color: Colors.blue[700],), label: '首页',backgroundColor: Colors.white),
          BottomNavigationBarItem(icon: Icon(Icons.build_circle_outlined,color: Colors.blue[700]), label: '管理',backgroundColor: Colors.white,),
        ],
      ),
      //drawer: UserPage(loginAccount:arguments['loginAccount']),
    );
  }
}

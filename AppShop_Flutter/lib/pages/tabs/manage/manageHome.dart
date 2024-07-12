import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../user/UserPage.dart';
import 'apply.dart';
import 'body.dart';

class MangeHomeWidget extends StatefulWidget{
  const MangeHomeWidget({Key? key,required this.arguments}) : super(key: key);

  final Map arguments;
  @override
  State<StatefulWidget> createState() {
    return ManageHomeState();
  }
  
}

class ManageHomeState extends State<MangeHomeWidget>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("管理"),
        titleTextStyle: TextStyle(fontSize: 18),
        backgroundColor: Colors.blue[800],
        centerTitle: true,leading: Builder(
          builder: (BuildContext context){
            return IconButton(
                icon: Icon(Icons.person,color: Colors.white,),
                onPressed: (){
                  Scaffold.of(context).openDrawer();
                }
            );
          }

      ),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.pushNamed(context, '/jump_search');
              },
              icon:Icon(Icons.search,color: Colors.white,)
          ),
        ],
      ),
      drawer: UserPage(loginAccount:widget.arguments['loginAccount']),
      body: ManageBodyWidget(arguments: widget.arguments),
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => ApplyAppWidget(arguments: widget.arguments,),
                settings: const RouteSettings(name: "路由名"),
              )
          );
          },
        tooltip: "申请上线App",
        child: const Icon(Icons.add),
      ),
    );
  }
}
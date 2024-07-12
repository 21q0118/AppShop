import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../host.dart';
class search_jumpPage extends StatefulWidget {
  const search_jumpPage({Key? key}) : super(key: key);
  @override
  State<search_jumpPage> createState() => _search_jumpState();
}

class _search_jumpState extends State<search_jumpPage> {
  TextEditingController conditionController = TextEditingController();
  final _controller = ScrollController();
  List  listMap = [];
  int ? len;
  Future dioNetwork() async {

    Map<String,dynamic> appInfo={};
    Utf8Decoder decode = new Utf8Decoder();
    var headers = {
      'Content-Type': 'application/json',
    };

    var params = conditionController.text;

    var url = Uri.parse('$host/appSearch?appName=$params');
    var response = await http.post(url,headers: headers);
    setState(() {
      appInfo = json.decode(decode.convert(response.bodyBytes));
      listMap.add(appInfo["data"]);
      len=listMap[0].length;
      num=1;
    });
  }
  String first_picture = 'http://a408599l51.wicp.vip/imgs/rotation/1.jpg';
  late Future _future;
  @override
  void initState() {
    super.initState();
  }

  int  num=0;
  Widget _testSearch(){
    if(num==1){
      if(listMap!=null && listMap.length>0 && listMap[0]!=null&&len! >0 ) {
        return ListView.separated(
          controller: scrollController,
          shrinkWrap: true,
          itemCount:len ??0,
          itemBuilder: (context, index) {
            return ListTile(
              leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0), // 设置圆角的大小// 设置背景颜色（可选）

                  child:Image(image:NetworkImage((listMap!=null && listMap.length>0 && listMap[0][index]!=null&&len! >0)
                      ? host+listMap[0][index]["icon"]:first_picture),fit: BoxFit.contain,width: 40,height: 40,)


              ),

              title: Text("${(listMap != null && listMap.length > 0) ? listMap[0][index]['appName'] : '暂无搜索信息'} "),
              subtitle: Text("${(listMap != null && listMap.length > 0) ? listMap[0][index]['version'] : '暂无搜索信息'} "),

              onTap:(){
                Navigator.pushNamed(context, '/jump',
                    arguments: {
                  "id" :(listMap != null && listMap.length > 0) ? listMap[0][index]['id'] : ''
                });
              } ,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(
              height: 0.3,
              color: Colors.black26,
            );
          },
        );
      } else {
        return const Text("暂无此搜索信息，请您重新输入",textAlign: TextAlign.center,);
      }
    }
    else {
      return Container();
    }
  }

  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   leading: IconButton(
        //     icon: const Icon(Icons.arrow_back, color: Colors.black),
        //     onPressed: () => Navigator.of(context).pop(),
        //   ),),
        body: Container(
          padding: const EdgeInsets.all(5),
          child: ListView(
            children: [
              TextField(
                  controller: conditionController,
                  textInputAction: TextInputAction.search,
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
                      num=1;
                      listMap.clear();
                      dioNetwork();
                    });
                  },
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: _testSearch(),
              )
            ],
          ),
        )
    );
  }
}

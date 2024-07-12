import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:app_shop/host.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:http/http.dart' as http;
import 'cropImage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';

class ApplyAppWidget extends StatefulWidget{
   ApplyAppWidget({Key? key,required this.arguments}) : super(key: key);

   Map arguments;
  @override
  State<StatefulWidget> createState() {
    return _ApplyAppState(arguments:this.arguments);
  }

}

class _ApplyAppState extends State<ApplyAppWidget>{
  Map arguments;
  _ApplyAppState({ required this.arguments});
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Map categoryMap = {
    "通用": [
      "视频播放", "社交通讯", "网上购物","音乐电台","金融理财"
    ],
    "游戏":[
      "经营策略", "角色扮演", "休闲益智","动作冒险","音乐舞蹈"
    ],
    "教育":[
      "早教启蒙", "在线学习", "行业考试","语言学习","学生解题"
    ]
  };

  int typeIndex1 = 0;
  int typeIndex2 = 0;
  FixedExtentScrollController typeController1 = FixedExtentScrollController();
  FixedExtentScrollController typeController2 = FixedExtentScrollController();
  List type1 = ["通用","游戏","教育"];
  List type2 = ["视频播放", "社交通讯", "网上购物","音乐电台","金融理财"];
  String result = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode focusNode = FocusNode();

  TextEditingController nameController = TextEditingController();
  TextEditingController versionController = TextEditingController();
  TextEditingController explainController = TextEditingController();
  TextEditingController applyExplainController = TextEditingController();

  DateTime now = DateTime.now();

  final List<Asset> _imageFiles = [];
  List<String> nameList = [];
  List chipList = [];
  String chipString = '';

  late Future _future;

  @override
  void initState(){
    super.initState();
    _future = getDefaultIcon();
  }

  Future<String> getDefaultIcon() async{
    return "https://img.tukuppt.com/png_preview/00/08/69/CkMaugaPDU.jpg!/fw/780";
  }

  Future<void> commituser(String crop) async{
    Map<String, dynamic>  manageresult={};
    var url = Uri.parse('$host/commitUser');
    Utf8Decoder decode = new Utf8Decoder();
    var headers = {
      'Content-Type': 'application/json',
    };
    var params = {
      "telephone":int.parse(arguments['loginAccount']),
      "corp":crop
    };
    final putData = jsonEncode(params);
    var response = await http.post(url, headers: headers, body: putData);
    manageresult = json.decode(decode.convert(response.bodyBytes));
    if (manageresult["code"] == 200) {
      Fluttertoast.showToast(
          msg: "已提交申请",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }else{
      Fluttertoast.showToast(
          msg: manageresult["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("申请成为管理员"),backgroundColor: Colors.blue[800]),
      body: FutureBuilder(
        future: _future,
        builder: (context,snapshot){
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(child: CupertinoActivityIndicator());
            case ConnectionState.active:
            case ConnectionState.done:
              return GestureDetector(
                onTap: (){
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: ListView(
                  children: [
                    imagePickerWidget(),
                    applyFormWidget(),
                    Container(
                      height: 100,
                      padding: const EdgeInsets.only(top: 30,bottom: 20,left: 50,right: 50),
                      child: ElevatedButton(
                        child: const Text("提交"),
                        onPressed: (){
                          commituser(nameController.text);
                        },
                      ),
                    ),
                  ],
                ),
              );
          }
        },
      ),
    );
  }

  Widget imagePickerWidget(){
    return Container(
      height: 140,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          InkWell(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child:
                 Image.network("$host${arguments['profilePhoto']}",
                  width: 100,
                  height: 100,
                )
            ),
          ),
        ],
      ),
    );
  }

  Widget applyFormWidget(){
    return SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.only(left: 30,right: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.person,color: Colors.grey,),
                  const Expanded(flex: 1,child: Text("账号",style: TextStyle(fontSize: 16),),),
                  Expanded(flex: 5,child:  Text("${arguments['loginAccount']}",style: TextStyle(fontSize: 16),),),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.local_library,color: Colors.grey,),
                  const Expanded(flex: 1,child: Text("名称",style: TextStyle(fontSize: 16),),),
                  Expanded(flex: 5,child: TextFormField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      hintText: '请输入公司名称',
                      border: InputBorder.none,
                    ),
                    controller: nameController,
                    validator: (value){
                      if(value!.isEmpty){
                        return "名称不可为空";
                      }
                      return null;
                    },
                  ),)
                ],
              ),
              const Divider(height: 1.0,color: Colors.grey,),

              Container(
                padding: const EdgeInsets.only(top: 15,bottom: 15),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.bookmarks,color: Colors.grey,),
                        Expanded(flex: 1,child: Text("理由",style: TextStyle(fontSize: 16),),),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5,top: 15,bottom: 10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            hintText: '请输入申请理由',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 4,
                                )
                            )
                        ),
                        maxLines: null,
                        minLines: 3,
                        controller: applyExplainController,
                        validator: (value){
                          if(value!.isEmpty){
                            return "申请理由不可为空";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1.0,color: Colors.grey,),
            ],
          ),
        ),
      ),
    );
  }
}
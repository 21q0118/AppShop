import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'cropImage.dart';

class EditAppWidget extends StatefulWidget{
  const EditAppWidget({Key? key,required this.appId,required this.arguments}) : super(key: key);

  final Map arguments;
  final int appId;
  @override
  State<StatefulWidget> createState() {
    return EditAppState();
  }

}

class EditAppState extends State<EditAppWidget>{
  var app = {};
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
  TextEditingController applyLogController = TextEditingController();

  String screenshot = '';
  List screenshotList = [];

  DateTime now = DateTime.now();
  final List<Asset> _imageFiles = [];
  List<String> nameList = [];

  List chipList = [];
  String chipString = '';

  late Future _future;

  @override
  void initState(){
    super.initState();
    _future = getListByAppId();
  }

  Future getListByAppId() async{
    var client = http.Client();
    final url = Uri.parse("http://a408599l51.wicp.vip/App/selectAppById?appId=${widget.appId}");
    Utf8Decoder decode = const Utf8Decoder();
    await client.get(url).then((response) async {
      if (response.statusCode == 200) {
        setState(() {
          app = json.decode(decode.convert(response.bodyBytes));
          nameController.text = app["appName"];
          versionController.text = app["appVersion"];

          chipString = app["appType"];
          chipList = chipString.split(';');
          chipList.removeAt(chipList.length-1);


          explainController.text = app["appExplain"];

          screenshot = app["appScreenshot"];
          screenshotList = screenshot.split(';');
          screenshotList.removeAt(screenshotList.length-1);
        });
      }
    });
  }

  void postEditInfo() async{
    chipString = '';
    for(int i = 0; i < chipList.length; i++){
      chipString += chipList[i] + ';';
    }

    String appIcon = '';
    if(_image != null){
      String? fileExt = _image?.path.substring(_image!.path.lastIndexOf('.'),_image?.path.length);
      appIcon = "http://a408599l51.wicp.vip/imgs/icon/" + now.toString().replaceAll(':', '：') + fileExt!;
    }else{
      appIcon = app["appIcon"];
    }

    for(int i = 0; i < _imageFiles.length; i++){
      nameList.add('');
      nameList[i] = "/screenshot/" + now.toString().replaceAll(':', '：') + i.toString();
    }
    String appScreenshot = '';
    for(int i = 0; i < nameList.length; i++){
      appScreenshot = appScreenshot + "http://a408599l51.wicp.vip/imgs" + nameList[i] + '.jpg' + ';';
    }

    var client = http.Client();
    final url = Uri.parse("http://a408599l51.wicp.vip/App/updateApp");
    client.post(url,
        body: json.encode({
          "appId":app["appId"],
          "appName":nameController.text,
          "appExplain":explainController.text,
          "appVersion":versionController.text,
          "appIcon":appIcon,
          "appScreenshot":appScreenshot,
          "appState":app["appState"],
          "appType":chipString,
          "appAuthor":app["appAuthor"],
          "loginAccount": widget.arguments['loginAccount'],
          "applyExplain":applyExplainController.text,
          "appLog": applyLogController.text,
        }),
      headers: {"content-type": "application/json"}
    ).then((response) async {
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "修改成功",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            fontSize: 16.0
        );
      }
    });
  }

  upLoadIcon(File image) async {
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/"), path.length);
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(path, filename: name),
      "name": "/icon/" + now.toString(),
    });
    Dio dio =  Dio();
    var response = await dio.post<String>("http://a408599l51.wicp.vip/test/upload", data: formData,
        options: Options(contentType: "multipart/form-data",)
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "图片上传成功",
          gravity: ToastGravity.CENTER,
          textColor: Colors.grey
      );
    }
  }

  upLoadScreenShot(List<Asset> pickImage,List screenImage) async {
    List _imageData = [];
    Dio dio =  Dio();

    for(int i = 0; i < screenImage.length; i++){
      ByteData byteData = (await File(screenImage[i]).readAsBytes()) as ByteData;
      List<int> imageData = byteData.buffer.asUint8List();
      MultipartFile multipartFile = MultipartFile.fromBytes(
        imageData,
        filename: 'some-file-name.jpg',
      );
       _imageData.add(multipartFile);
    }

    for(int i = screenImage.length; i < pickImage.length; i++){
      ByteData byteData = await pickImage[i].getByteData();
      List<int> imageData = byteData.buffer.asUint8List();
      MultipartFile multipartFile = MultipartFile.fromBytes(
        imageData,
        filename: 'some-file-name.jpg',
      );
      _imageData.add(multipartFile);
    }

    FormData formData = FormData.fromMap({
      "fileList": _imageData,
      "nameList": nameList,
    });

    var response = await dio.post<String>("http://a408599l51.wicp.vip/test/batchUpload", data: formData,
        options: Options(contentType: "multipart/form-data",)
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("更改App信息"), backgroundColor: Colors.blue[800],
        ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          switch (snapshot.connectionState){
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
                    editFormWidget(),
                    screenShotWidget(),
                    Container(
                      height: 100,
                      padding: const EdgeInsets.only(top: 30,bottom: 20,left: 50,right: 50),
                      child: ElevatedButton(
                        child: const Text("提交"),
                        onPressed: (){
                          if(_formKey.currentState!.validate()){
                            if(chipList.isEmpty){
                              Fluttertoast.showToast(
                                  msg: "未添加App类型",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  fontSize: 16.0
                              );
                            }else if(_imageFiles.isEmpty&&screenshotList.isEmpty){
                              Fluttertoast.showToast(
                                  msg: "未上传App相关截图",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  fontSize: 16.0
                              );
                            }else{
                              Fluttertoast.showToast(
                                  msg: "提交成功",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  fontSize: 16.0
                              );
                              postEditInfo();
                              if(_image != null){
                                upLoadIcon(_image!);
                              }
                              upLoadScreenShot(_imageFiles,screenshotList);
                              Navigator.pop(context,false);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
          }
        }),
      );
  }

  Widget imagePickerWidget(){
    return Container(
      height: 140,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          InkWell(
            onTap: (){
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context){
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.camera),
                        title: const Text("拍照"),
                        onTap: () {
                          _picker.pickImage(source: ImageSource.camera,imageQuality:50).then((value){
                            if(value != null){
                              Future tempImage = Navigator.push(context,
                                  MaterialPageRoute(
                                    builder: (context) => CropImageWidget(image: File(value.path),),
                                    settings: const RouteSettings(name: "cropWidgetRoute"),
                                  )
                              );
                              tempImage.then((value) {
                                setState(() {
                                  _image = value;
                                  Navigator.pop(context);
                                });
                              });
                            }
                          });
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: const Text("从相册选择"),
                        onTap: (){
                          _picker.pickImage(source: ImageSource.gallery,imageQuality:50).then((value){
                            if(value != null){
                              Future tempImage = Navigator.push(context,
                                  MaterialPageRoute(
                                    builder: (context) => CropImageWidget(image: File(value.path),),
                                    settings: const RouteSettings(name: "cropWidgetRoute"),
                                  )
                              );
                              tempImage.then((value) {
                                setState(() {
                                  _image = value;
                                  Navigator.pop(context);
                                });
                              });
                            }
                          });
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: _image == null ?
                Image(
                  image:NetworkImage(app["appIcon"]),
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                ) : Image(height:100,width:100,image: FileImage(_image!))
            ),
          ),
        ],
      ),
    );
  }

  Widget editFormWidget(){
    return SingleChildScrollView(
      child: Padding(padding: const EdgeInsets.only(left: 30,right: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              //App名称
              Row(
                children: [
                  const Icon(Icons.local_library,color: Colors.grey,),
                  const Expanded(flex: 1,child: Text("名称",style: TextStyle(fontSize: 16),),),
                  const VerticalDivider(color: Colors.blue, width: 5,),
                  Expanded(flex: 5,child: TextFormField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      border: InputBorder.none,
                    ),
                    controller: nameController,
                    validator: (value){
                      if(value!.isEmpty){
                        return "App名称不可为空";
                      }
                      return null;
                    },
                  ),)
                ],
              ),
              const Divider(height: 1.0,color: Colors.grey,),
              //App版本
              Row(
                children: [
                  const Icon(Icons.layers,color: Colors.grey,),
                  const Expanded(flex: 1,child: Text("版本",style: TextStyle(fontSize: 16),),),
                  Expanded(flex: 5,child: TextFormField(
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      border: InputBorder.none,
                    ),
                    controller: versionController,
                    validator: (value){
                      if(value!.isEmpty){
                        return "App版本不可为空";
                      }
                      return null;
                    },
                  ),)
                ],
              ),
              const Divider(height: 1.0,color: Colors.grey,),
              //App类型
              Row(
                children: [
                  const Icon(Icons.local_offer,color: Colors.grey,),
                  const Expanded(flex: 1,child: Text("类型",style: TextStyle(fontSize: 16),),),
                  Container(
                    width: 180,
                    height: 50,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 5),
                    child: chipList.isNotEmpty ? ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: chipList.length,
                      itemBuilder: (BuildContext context, int index){
                        return  Chip(
                          label: Text(chipList[index]),
                          deleteIcon: const Icon(Icons.clear),
                          onDeleted: (){
                            setState(() {
                              chipList.remove(chipList[index]);
                            });
                          },
                        );
                      },
                    )
                        : const Chip(label: Text("请添加App类型")),
                  ),
                  IconButton(
                    onPressed: (){
                      focusListener();
                    },
                    icon: const Icon(Icons.add, color: Colors.grey,),
                  )
                ],
              ),
              const Divider(height: 1.0,color: Colors.grey,),
              //App简介
              Container(
                padding: const EdgeInsets.only(top: 15,bottom: 20),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.bookmarks,color: Colors.grey,),
                        Expanded(flex: 1,child: Text("简介",style: TextStyle(fontSize: 16),),),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5,top: 15,bottom: 10),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            hintText: '请输入App简介',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 4,
                                )
                            )
                        ),
                        maxLines: null,
                        minLines: 8,
                        controller: explainController,
                        validator: (value){
                          if(value!.isEmpty){
                            return "App简介不可为空";
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
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
                      padding: const EdgeInsets.only(left: 5,top: 15,bottom: 20),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            hintText: '请输入App申请理由',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 4,
                                )
                            )
                        ),
                        maxLines: null,
                        minLines: 5,
                        controller: applyExplainController,
                        validator: (value){
                          if(value!.isEmpty){
                            return "App申请理由不可为空";
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1.0,color: Colors.grey,),
              Container(
                padding: const EdgeInsets.only(top: 15,bottom: 15),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.bookmarks,color: Colors.grey,),
                        Expanded(flex: 1,child: Text("日志",style: TextStyle(fontSize: 16),),),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5,top: 15,bottom: 20),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10),
                            hintText: '请输入App更新日志',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 4,
                                )
                            )
                        ),
                        maxLines: 5,
                        controller: applyLogController,
                        validator: (value){
                          if(value!.isEmpty){
                            return "App更新日志不可为空";
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

  void focusListener(){
    focusNode.unfocus();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context){
        return StatefulBuilder(builder: (context, state){
          return Container(height: 250,
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Expanded(flex: 1,
                  child: Row(
                    children: [
                      Expanded(flex: 1,
                        child: TextButton(
                          child: const Text("取消"),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Expanded(flex: 1,
                        child: TextButton(
                          child: const Text("确定"),
                          onPressed: (){
                            setState(() {
                              chipList.add(categoryMap[type1[typeIndex1]][typeIndex2]);
                              chipList = LinkedHashSet.from(chipList).toList();
                            });
                            Navigator.pop(context);
                          },
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(flex: 4,
                  child: Row(
                    children: [
                      Expanded(
                        child:  CupertinoPicker(
                          itemExtent: 40,
                          backgroundColor: Colors.white,
                          scrollController: typeController1,
                          diameterRatio: 1.1,
                          onSelectedItemChanged: (position) {
                            state(() {
                              typeIndex1 = position;
                              typeIndex2 = 0;
                              type2 = categoryMap[type1[typeIndex1]];
                            });
                            typeController2.jumpToItem(0);
                          },
                          children: type1.map((e) {
                            return Text(e);
                          }) .toList(),
                        ),
                      ),
                      Expanded(
                        child:  CupertinoPicker(
                          itemExtent: 40,
                          diameterRatio: 1.1,
                          backgroundColor: Colors.white,
                          scrollController: typeController2,
                          onSelectedItemChanged: (position) {
                            state(() {
                              typeIndex2 = position;
                            });
                          },
                          children: listType2(),
                        ),
                      ),
                    ],
                  ),
                )

              ],
            ),
          );
        });
      },
    );
  }

  List<Widget> listType2(){
    if(type2==null) return [];
    List<Widget> lists = type2.map((item,{index}){
      return Text(item);
    }).toList();
    return lists;
  }

  Widget screenShotWidget(){
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: StaggeredGridView.countBuilder(
          shrinkWrap: true,
          crossAxisCount: 3,
          itemCount: _imageFiles.isEmpty&&screenshotList.isEmpty ? 1 : _imageFiles.length+screenshotList.length+1,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return InkWell(
                onTap: () => _onPickImage(),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xFFF6F7F8),
                  ),
                  child: const Center(
                    child: Icon(Icons.add, color: Color(0xFFB4B4B4), size: 40,),
                  ),
                ),
              );
            } else if(screenshotList.isNotEmpty && index > 0 && index < screenshotList.length + 1){
              return Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: InkWell(
                        child: Image(image:NetworkImage(screenshotList[index-1])),
                    ),
                  ),
                  InkWell(
                    onTap: () => _deleteImage(screenshotList,index - 1),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99.0),
                        color: Colors.red,
                      ),
                      padding: const EdgeInsets.all(2.0),
                      child: const Icon(Icons.close, size: 20.0, color: Colors.white,),
                    ),
                  ),
                ],
              );
            }else {
              return Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: InkWell(
                        child: AssetThumb(asset: _imageFiles[index-screenshotList.length-1], height: 100, width: 100,)
                    ),
                  ),
                  InkWell(
                    onTap: () => _deleteImage(_imageFiles,index-screenshotList.length-1),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(99.0),
                        color: Colors.red,
                      ),
                      padding: const EdgeInsets.all(2.0),
                      child: const Icon(Icons.close, size: 20.0, color: Colors.white,),
                    ),
                  ),
                ],
              );
            }
          },
          staggeredTileBuilder: (int index) => const StaggeredTile.count(1, 1),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        ),
      ),
    );
  }

  /// 选择图片
  _onPickImage() async {
    List<Asset> assets = await MultiImagePicker.pickImages(
      // 选择图片的最大数量
      maxImages: 9,
      materialOptions: const MaterialOptions(
        // 显示所有照片，值为 false 时显示相册
          startInAllView: true,
          allViewTitle: '所有照片',
          actionBarColor: '#2196F3',
          textOnNothingSelected: '没有选择照片'
      ),
    );
    if (assets == null || assets.isEmpty) return;
    setState(() {
      _imageFiles.addAll(assets);
    });
  }
  /// 删除图片
  _deleteImage(List list,int index) {
    if (list == null || list.length <= index) return;
    setState(() {
      list.removeAt(index);
    });
  }

}
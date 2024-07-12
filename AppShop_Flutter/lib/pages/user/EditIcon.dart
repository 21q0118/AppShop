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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';

import '../tabs/manage/cropImage.dart';

class EditIconPage extends StatefulWidget{
  Map arguments;
  EditIconPage({Key? key,required this.arguments}) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _EditIconPageState(arguments:this.arguments);
  }

}

class _EditIconPageState extends State<EditIconPage>{
  Map arguments;
  _EditIconPageState({ required this.arguments});

  File? _image;
  final ImagePicker _picker = ImagePicker();


  int typeIndex1 = 0;
  int typeIndex2 = 0;
  FixedExtentScrollController typeController1 = FixedExtentScrollController();
  FixedExtentScrollController typeController2 = FixedExtentScrollController();
  String result = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FocusNode focusNode = FocusNode();

  TextEditingController nameController = TextEditingController();
  TextEditingController versionController = TextEditingController();
  TextEditingController explainController = TextEditingController();
  TextEditingController applyExplainController = TextEditingController();

  DateTime now = DateTime.now();

  final List<Asset> _imageFiles = [];
  List chipList = [];
  String chipString = '';

  late Future _future;

  get categoryMap => null;

  @override
  void initState(){
    super.initState();
    _future = getDefaultIcon();
  }

  Future<String> getDefaultIcon() async{
    return "https://img.tukuppt.com/png_preview/00/08/69/CkMaugaPDU.jpg!/fw/780";
  }

  upLoadIcon(File image) async {
    String path = image.path;
    var name = path.substring(path.lastIndexOf("/"), path.length);
    FormData formData = FormData.fromMap({
      "icon": await MultipartFile.fromFile(path, filename: name),
    });
    var response = await http.post(Uri.parse("$host/app/uploadIcon"), body: formData,headers: {
      "ContentType": "multipart/form-data"
    }
    );
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "图片上传成功",
          gravity: ToastGravity.CENTER,
          textColor: Colors.grey
      );
    }
  }
//xiugaitouxiang
  upLoadScreenShot(List<Asset> image) async {
    List _imageData = [];
    for(int i = 0; i < image.length; i++){
      ByteData byteData = await image[i].getByteData();
      List<int> imageData = byteData.buffer.asUint8List();
      MultipartFile multipartFile = MultipartFile.fromBytes(
        imageData,
        filename: 'some-file-name.jpg',
      );
      _imageData.add(multipartFile);
    }

    FormData formData = FormData.fromMap({
      "icon": _imageData,
    });

    var response = await http.post(Uri.parse("$host/app/uploadIcon"), body: formData,headers: {
      "ContentType": "multipart/form-data"
    }
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("修改用户头像"),backgroundColor: Colors.blue[800]),
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
                    // screenShotWidget(),
                    Container(
                      height: 100,
                      padding: const EdgeInsets.only(top: 30,bottom: 20,left: 50,right: 50),
                      child: ElevatedButton(
                        child: const Text("提交"),
                        onPressed: (){
                            if(_image == null){
                              Fluttertoast.showToast(
                                  msg: "未上传图像",
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
                              upLoadIcon(_image!);
                              upLoadScreenShot(_imageFiles);
                              Navigator.pop(context);
                           }

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
                Image.network("${arguments['photo']}",
                  width: 100,
                  height: 100,
                ) : Image(height:100,width:100,image: FileImage(_image!),fit: BoxFit.fill,)
            ),
          ),
        ],
      ),
    );
  }


}

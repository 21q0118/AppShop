import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_crop/image_crop.dart';
import 'dart:ui';
//test666
class EditHeadPortraitPage extends StatefulWidget{
  Map arguments;
  EditHeadPortraitPage({Key? key,required this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EditHeadPortraitPageState(arguments: this.arguments);
  }

}

class _EditHeadPortraitPageState extends State<EditHeadPortraitPage>{

  Map arguments;
  _EditHeadPortraitPageState({required this.arguments});

  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('查看头像'),
        centerTitle: true,
        leading:IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context,'true');
          },
        ),
      ),
      body: GestureDetector(
        onLongPress: (){
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
                      _picker.pickImage(source: ImageSource.camera,imageQuality:30).then((value){
                        if(value!=null){
                          Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context) => CropImageWidget(
                                    image: File(value.path),
                                    loginAccount:arguments['loginAccount']
                                ),
                                settings: const RouteSettings(name: "cropWidgetRoute"),
                              )
                          ).then((value) {
                            setState(() {
                              _image = value;
                              Navigator.pop(context);
                            });
                          });
                        }else{
                          Navigator.pop(context);
                        }
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text("从相册选择"),
                    onTap: (){
                      _picker.pickImage(source: ImageSource.gallery,imageQuality:30).then((value){
                       if(value!=null){
                          Navigator.push(context,
                              MaterialPageRoute(
                                builder: (context) => CropImageWidget(
                                  image: File(value.path),
                                  loginAccount: arguments['loginAccount'],
                                ),
                                settings: const RouteSettings(name: "cropWidgetRoute"),
                              )
                          ).then((value) {
                            setState(() {
                              _image = value;
                              Navigator.pop(context);
                            });
                          });
                       }else{
                         Navigator.pop(context);
                       }
                      });
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF87C1FF), Color(0xFF96CDCD)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
          child: ListView(
            children:[
              Container(
                height: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(40),
                child: ClipOval(
                    child: _image == null ? Image.network(arguments['headImageUrl'],fit: BoxFit.cover)
                    : Image(image: FileImage(_image!),fit: BoxFit.cover,)
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  '当前头像',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
}

class CropImageWidget extends StatefulWidget{
  const CropImageWidget({Key? key,required this.image,required this.loginAccount}) : super(key: key);

  final File? image;
  final String loginAccount;

  @override
  State<StatefulWidget> createState() {
    return CropImageState(image: this.image,loginAccount: this.loginAccount);
  }
}

class CropImageState extends State<CropImageWidget>{
  final File? image;
  final String loginAccount;

  CropImageState({required this.image,required this.loginAccount});

  DateTime dateTime= DateTime.now();

  _updateHeadImage()async{
    String headImageUrl= 'http://a408599l51.wicp.vip/imgs/photo/$loginAccount${dateTime.toString().replaceAll(':', '：')}.jpg';
    Dio dio = Dio();
    String url = 'http://a408599l51.wicp.vip/Login/updateProfilePhoto';
    var response = await dio.post(url,queryParameters: {
      'loginAccount':loginAccount,
      'profilePhoto':headImageUrl
    });
  }

  _uploadImage(File image)async{
    String imagePath = image.path;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        imagePath,                                //图片路径
        filename: '$loginAccount.jpg',            //图片名称
      ),
      'name':'/photo/$loginAccount${dateTime.toString().replaceAll(':', '：')}'
    });
    Dio dio = Dio();
    var respone = await dio.post("http://a408599l51.wicp.vip/test/upload", data: formData);
    if (respone.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "图片上传成功",
          gravity: ToastGravity.CENTER,
          textColor: Colors.grey
      );
      // Navigator.pop(context,'true');
    }else{
      Fluttertoast.showToast(
          msg: "图片上传失败",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }
  final cropKey = GlobalKey<CropState>();

  void cropImage(image) async{
    final crop = cropKey.currentState;
    final sampledFile = await ImageCrop.sampleImage(
      file: image!,
      preferredWidth: (1024 / crop!.scale).round(),
      preferredHeight: (4096 / crop.scale).round(),
    );
    final croppedFile = await ImageCrop.cropImage(
      file: sampledFile,
      area: crop.area!,
    );
    _uploadImage(croppedFile);
    setState(() {
      image = croppedFile;
      Navigator.pop(context,image);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("移动和裁剪"),
          centerTitle: true,
          leading: IconButton(icon: const Icon(Icons.close),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: (){
                _updateHeadImage();
                cropImage(widget.image);

              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              color: Colors.black
          ),
          child: Center(
            child: Container(
              width: 400,
              height: 400,
              padding: const EdgeInsets.all(20),
              child: Crop.file(widget.image!,key: cropKey),
            ),
          ),
        )
    );
  }
}
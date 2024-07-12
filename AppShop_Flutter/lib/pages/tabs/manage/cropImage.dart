import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';

class CropImageWidget extends StatefulWidget{
  const CropImageWidget({Key? key,required this.image}) : super(key: key);

  final File? image;

  @override
  State<StatefulWidget> createState() {
    return CropImageState();
  }

}

class CropImageState extends State<CropImageWidget>{
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
    setState(() {
      image = croppedFile;
      Navigator.pop(context,image);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("裁剪"),backgroundColor: Colors.blue[800],
        leading: IconButton(icon: const Icon(Icons.close),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: [IconButton(icon: const Icon(Icons.check),
          onPressed: ()=> cropImage(widget.image),
        ),],
      ),
      body: Center(
        child: Container(
          width: 400,
          height: 400,
          padding: const EdgeInsets.all(10),
          child: Crop.file(widget.image!,key: cropKey),
        ),
      )
    );
  }
}
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imageLib;
import 'package:image_picker/image_picker.dart';

import 'main.dart';

void main() => runApp(new MaterialApp(home: Filters()));

class Filters extends StatefulWidget {
  @override
  _FiltersState createState() => _FiltersState();
}

String fileName;
List<Filter> filters = presetFiltersList;
File imageFilee;
bool mainStream = false;

class _FiltersState extends State<Filters> {

  Future getImage(context) async {
    imageFilee = await ImagePicker.pickImage(source: ImageSource.gallery);
    fileName = basename(imageFilee.path);
    var image = imageLib.decodeImage(imageFilee.readAsBytesSync());
    image = imageLib.copyResize(image, width: 600);
    Map imagefile = await Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new PhotoFilterSelector(
          title: Text("Photo Filter Example"),
          appBarColor: Colors.deepOrange,
          image: image,
          filters: presetFiltersList,
          filename: fileName,
          loader: Center(child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            backgroundColor: Colors.deepOrange,
          )),
          fit: BoxFit.contain,
        ),
      ),
    );
    if (imagefile != null && imagefile.containsKey('image_filtered')) {
      setState(() {
        imageFilee = imagefile['image_filtered'];
        mainStream = true;
      });
      print(imageFilee.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Photo Filter'),
      ),
      body: Center(
        child: new Container(
          child: imageFilee == null
              ? Center(
            child: new Text('No image selected.',
                style: TextStyle(
                fontSize: 20
            ),
          ),
          )
              : Image.file(imageFilee),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: (){
          if(mainStream == false){
            getImage(context);
          }else if(mainStream == true){
            _saveImage();
          }
        },
        tooltip: 'Pick Image',
        child: _buildButtonIcon(),
      ),
    );
  }
}



void _saveImage() async{
  GallerySaver.saveImage(imageFilee.path);
  Fluttertoast.showToast(
      msg: "The File is Saved Successfully",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0
  );
}




Widget _buildButtonIcon() {
  if (mainStream == false)
    return Icon(Icons.add_a_photo);
  else if (mainStream == true)
    return Icon(Icons.save_alt_outlined);
}
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'filter.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ImageCropper',
      theme: ThemeData.light().copyWith(primaryColor: Colors.deepOrange),
      home: MyHomePage(
        title: 'Image Cropper',
      ),
    );
  }
}

AppState state;
File imageFile;
class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum AppState {
  free,
  picked,
  cropped,
}
class _MyHomePageState extends State<MyHomePage> {
  TransformationController controller = TransformationController();

  @override
  void initState() {
    super.initState();
    state = AppState.free;
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            tooltip: "Crop Again",
            icon: Icon(
              Icons.refresh_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                if(imageFile != null){
                  state = AppState.picked;
                }else{
                    state = AppState.free;
                }
              });
            },
          ),
          IconButton(
            tooltip: "Crop Again",
            icon: Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                  if(imageFile != null){
                    imageFile = null;
                    state = AppState.free;
                  }
              });
            },
          )
        ],
      ),
      body: imageFile == null ? Center(
        child: Text(
            "No File Selected",
          style: TextStyle(
            fontSize: 20
          ),
        ),
      ) :
      InteractiveViewer(
        transformationController: controller,
        maxScale: 25.0,
        minScale: 0.1,
        boundaryMargin: EdgeInsets.all(5.0),
        child: Center(
          child: imageFile != null ? Image.file(imageFile) : Container(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
      currentIndex: 0, // this will be set when a new tab is tapped
      items: [
        BottomNavigationBarItem(
            icon: GestureDetector(
                onTap: (){
                  if (state == AppState.free)
                    _pickImage();
                  else if (state == AppState.picked)
                    _cropImage();
                  else if (state == AppState.cropped) _saveImage();
                },
                child: _buildButtonIcon()
            ),
            title: GestureDetector(
                onTap: (){
                  if (state == AppState.free)
                    _pickImage();
                  else if (state == AppState.picked)
                    _cropImage();
                  else if (state == AppState.cropped) _saveImage();
                },
                child: _textButton()
            )
        ),
        BottomNavigationBarItem(
            icon: GestureDetector(
                onTap: () {
                  mainStream = false;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Filters()),
                  );
                },
                child: Icon(Icons.movie_filter)
            ),
            title: GestureDetector(
                onTap: () {
                  mainStream = false;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Filters()),
                  );
                },
                child: Text('Filters')
            )
        ),
        BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: (){
                showDialog(
                    context: context,
                    builder: (_) => new AlertDialog(
                      title: new Text("Share Your Image"),
                      content: Wrap(
                        children: [
                          GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.blue
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if(imageFile != null){
                                    print(imageFile.path);
                                    Share.shareFiles([imageFile.path], text: 'Great picture');
                                  }else{
                                    Fluttertoast.showToast(
                                            msg: "No Image Selected",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.black,
                                            textColor: Colors.white,
                                            fontSize: 16.0
                                        );
                                      }
                                  },

                                child: ListTile(
                                  title: Align(alignment: Alignment.center, child: Text(
                                      'Share Cropped Image',
                                    style: TextStyle(
                                      color: Colors.white
                                    ),
                                  )),
                                ),
                              ),
                            ),
                          ),
                          Divider(color: Colors.white, thickness: 3,),
                          GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.blue
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  if(imageFilee != null){
                                    print(imageFilee.path);
                                    Share.shareFiles([imageFilee.path], text: 'Great picture');
                                  }else{
                                    Fluttertoast.showToast(
                                        msg: "No Image Selected",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.black,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  }
                                },
                                child: ListTile(
                                  title: Align(alignment: Alignment.center, child: Text('Share Filtered Image',
                                      style: TextStyle(
                                          color: Colors.white
                                    ),
                                  )),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ));
              },
                child: Icon(Icons.share_outlined)
            ),
            title: GestureDetector(
                onTap: (){
                  showDialog(
                      context: context,
                      builder: (_) => new AlertDialog(
                        title: new Text("Share Your Image"),
                        content: Wrap(
                          children: [
                            GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.blue
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    if(imageFile != null){
                                      print(imageFile.path);
                                      Share.shareFiles([imageFile.path], text: 'Great picture');
                                    }else{
                                      Fluttertoast.showToast(
                                          msg: "No Image Selected",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );
                                    }
                                  },

                                  child: ListTile(
                                    title: Align(alignment: Alignment.center, child: Text(
                                      'Share Cropped Image',
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                            ),
                            Divider(color: Colors.white, thickness: 3,),
                            GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.blue
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    if(imageFilee != null){
                                      print(imageFilee.path);
                                      Share.shareFiles([imageFilee.path], text: 'Great picture');
                                    }else{
                                      Fluttertoast.showToast(
                                          msg: "No Image Selected",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white,
                                          fontSize: 16.0
                                      );
                                    }
                                  },
                                  child: ListTile(
                                    title: Align(alignment: Alignment.center, child: Text('Share Filtered Image',
                                      style: TextStyle(
                                          color: Colors.white
                                      ),
                                    )),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ));
                },
                child: Text('Share')
            )
        )
      ],
    ),

   );
  }

  Widget _buildButtonIcon() {
    if (state == AppState.free)
      return Icon(Icons.add);
    else if (state == AppState.picked)
      return Icon(Icons.crop);
    else if (state == AppState.cropped)
      return Icon(Icons.save_alt_outlined);
    else
      return Container();
  }
  Widget _textButton(){
    if (state == AppState.free)
      return Text("Add");
    else if (state == AppState.picked)
      return Text("Crop");
    else if (state == AppState.cropped)
      return Text("Save");
    else
      return Container();
  }

  Future<Null> _pickImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ]
            : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        );
    if (croppedFile != null) {
      imageFile = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }


void _saveImage() async{
  Directory appDocDir = await getApplicationDocumentsDirectory();
  print(appDocDir);
  print("appDocDir Printed");
  String appDocPath = appDocDir.path;
  print(appDocPath);
  print("appDocPath Printed");
  final File localImage = await imageFile.copy('$appDocPath/image.png');
  print(localImage);
  print('Local Image Printed');
  GallerySaver.saveImage(imageFile.path);
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
}



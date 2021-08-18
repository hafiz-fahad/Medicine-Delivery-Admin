import 'package:al_asr_admin/providers/slider_service.dart';
import 'package:al_asr_admin/widgets/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class SliderPicker extends StatefulWidget {
  @override
  _SliderPickerState createState() => _SliderPickerState();
}

class _SliderPickerState extends State<SliderPicker> {

  SliderService sliderService = SliderService();
  File _image1;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252525),
      appBar: AppBar(
        backgroundColor: Color(0xff2f2f2f),
        elevation: 3,
        leading: IconButton(
          color: Color(0xff008db9),
          icon: Icon(Icons.arrow_back),
          iconSize: 20,
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Slider Picker",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: isLoading
            ? Loading()
            : Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if(_image1 == null)
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 120,
                            child: FlatButton(
                                onPressed: () {
                                  _selectImage(
                                    ImagePicker.pickImage(
                                        source: ImageSource.gallery),
                                  );
                                },
                                child: Image.asset('icons/addImage.png')
                            ),
                          ),
                        ),
                      ),
                    if(_image1 != null)
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 120,
                          child: FlatButton(
                              onPressed: () {
                                _selectImage(
                                  ImagePicker.pickImage(
                                      source: ImageSource.gallery),
                                );
                              },
                              child: _displayChild1()
                          ),
                        ),
                      ),
                    ),

                  ],
               ),
                SizedBox(
                    width: 300,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))
                      ),
                      color: Color(0xff008db9),
                      textColor: Colors.white,
                      child: Text('Upload Slider'),
                      onPressed: () {
                        validateAndUpload();
                      },
                    )
                )
              ],
            ),
      ),
    );
  }
  void _selectImage(Future<File> pickImage) async {
    File tempImg = await pickImage;
    setState(() => _image1 = tempImg);
  }

  Widget _displayChild1() {
    if (_image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: Colors.grey,
        ),
      );
    } else {
      return Image.file(
        _image1,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }
  void validateAndUpload() async {
//    if (_formKey.currentState.validate()) {
      setState(() => isLoading = true);
      if (_image1 != null) {
          String imageUrl1;

          final FirebaseStorage storage = FirebaseStorage.instance;
          final String picture1 =
              "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
          StorageUploadTask task1 =
          storage.ref().child(picture1).putFile(_image1);

          StorageTaskSnapshot snapshot1 =
          await task1.onComplete.then((snapshot) => snapshot);


          task1.onComplete.then((snapshot3) async {
            imageUrl1 = await snapshot1.ref.getDownloadURL();

      sliderService.uploadSlider({
        "sliderImg":imageUrl1,
      });
//      _formKey.currentState.reset();
      setState(() => isLoading = false);
      Navigator.pop(context);
          });
      } else {
        setState(() => isLoading = false);
      }
//    }
  }
}

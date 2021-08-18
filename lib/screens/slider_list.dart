import 'package:Medsway.pk_Admin/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

DocumentSnapshot _currentDocument;


class SliderList extends StatefulWidget {
  @override
  _SliderListState createState() => _SliderListState();
}

class _SliderListState extends State<SliderList> {

  navigateToDetail(DocumentSnapshot slider){
    _currentDocument = slider;
    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(image: slider,)));
  }


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
          "Sliders List",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        child: FutureBuilder(
//          future: getProductList(),
            builder: (_, snapshot){
              return ListView(
                padding: EdgeInsets.all(5.0),
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Divider(),
                  StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection('slider').snapshots(),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Loading();
                        }
                        else if (snapshot.hasData) {
                          return Column(
                            children: snapshot.data.documents.map((doc) {
                              return Card(
                                color: Color(0xff2f2f2f),
                                child: ListTile(
                                  leading:  Image.network(doc.data['sliderImg'],),
//                                ImageIcon(Image.network(),
//                                  size: 30, color: Color(0xff008db9),),
//                                title: Text(doc.data['name'],
//                                  style: TextStyle(color: Colors.white),),
                                  onTap: () => navigateToDetail(doc),

                                  trailing: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.redAccent),
                                    onPressed: ()
                                    {var alert = new AlertDialog(
                                      backgroundColor: Color(0xff252525),
                                      elevation: 7.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(8.0))
                                      ),
                                      content:
                                      Text('Are you sure you want to delete this Slider?',
                                          style: TextStyle(color: Colors.white)),
                                      actions: <Widget>[
                                        FlatButton(
                                            color: Color(0xff008db9),
                                            textColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            onPressed: ()async{
                                              Fluttertoast.showToast(msg: 'Product Deleted Successfully');
                                              Navigator.pop(context);
                                              await Firestore.instance
                                                  .collection('slider')
                                                  .document(doc.documentID)
                                                  .delete();
                                            }, child: Text('DELETE')),
                                        FlatButton(onPressed: (){
                                          Navigator.pop(context);
                                        }, child: Text('CANCEL'),
                                            textColor: Colors.white),
                                      ],
                                    );
                                    showDialog(context: context, builder: (_) => alert);
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        } else {
                          return SizedBox();
                        }
                      }),
                ],
              );
            }),
      ),

    );
  }
}

class DetailScreen extends StatefulWidget {
  final DocumentSnapshot image;

  DetailScreen({this.image});
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252525),
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: PhotoViewGallery.builder(
                        scrollPhysics: const BouncingScrollPhysics(),
                        builder: (BuildContext context, int index) {
                          return PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage(widget.image.data['sliderImg']),
//                            initialScale: PhotoViewComputedScale.contained * 0.8,
//                            heroAttributes: HeroAttributes(tag: galleryItems[index].id),
                          );
                        },
                        itemCount: widget.image.data.length-1,
                        loadingBuilder: (context, event) => Center(
                          child: Container(
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(
                              value: event == null
                                  ? 0
                                  : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                            ),
                          ),
                        ),
//                        backgroundDecoration: widget.backgroundDecoration,
//                        pageController: widget.pageController,
//                        onPageChanged: onPageChanged,
                      )
//            Image.network(widget.image.data['sliderImg']),
          ),
        ),
        onTap: () {
//          Navigator.pop(context);
        },
      ),
    );
  }
}

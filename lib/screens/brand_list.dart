import 'package:Medsway.pk_Admin/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BrandListPage extends StatefulWidget {
  @override
  _BrandListPageState createState() => _BrandListPageState();
}

class _BrandListPageState extends State<BrandListPage> {

  Future getBrandList() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore.collection('brands').getDocuments();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff252525),
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Color(0xff2f2f2f),
        leading: IconButton(
          color: Color(0xff008db9),
          icon: Icon(Icons.arrow_back),
          iconSize: 20,
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "Brands",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: FutureBuilder(
            future: getBrandList(),
            builder: (_, snapshot){
                return ListView(
                  padding: EdgeInsets.all(5.0),
                  children: <Widget>[
                    SizedBox(height: 10.0),
                    StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance.collection('brands').snapshots(),
                        builder: (context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return Loading();
                          }
                          else if (snapshot.hasData) {
                            return Column(
                              children: snapshot.data.documents.map((doc) {
                                return ListTile(
                                  leading: ImageIcon(AssetImage('icons/brands_icon.png'),
                                    size: 30, color: Color(0xff008db9),),
                                  title: Text(doc.data['brand'],
                                    style: TextStyle(color: Colors.white),),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.redAccent,),
                                    onPressed: ()
                                    {var alert = new AlertDialog(
                                      backgroundColor: Color(0xff252525),
                                      elevation: 7.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(8.0))
                                      ),
                                      content:
                                      Text('Are you sure you want to delete this brand?',
                                        style: TextStyle(color: Colors.white),),
                                      actions: <Widget>[
                                        FlatButton(
                                            color: Color(0xff008db9),
                                            textColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8.0),
                                            ),
                                            onPressed: ()async{
                                          await Firestore.instance
                                              .collection('brands')
                                              .document(doc.documentID)
                                              .delete();
                                          Fluttertoast.showToast(msg: 'Brand Deleted Successfully');
                                          Navigator.pop(context);
                                        }, child: Text('DELETE')),
                                        FlatButton(onPressed: (){
                                          Navigator.pop(context);
                                        }, child: Text('CANCEL'),
                                          textColor: Colors.white,),
                                      ],
                                    );
                                    showDialog(context: context, builder: (_) => alert);
                                    },
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

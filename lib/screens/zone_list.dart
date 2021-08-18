import 'package:al_asr_admin/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ZoneList extends StatefulWidget {
  @override
  _ZoneListState createState() => _ZoneListState();
}

class _ZoneListState extends State<ZoneList> {

  Future getZoneList() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore.collection('zone_area').getDocuments();
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
          "Zone Areas",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('zone_area').orderBy("zone_name").snapshots(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return Loading();
              }
              else if (snapshot.hasData) {
                return Column(
                  children: snapshot.data.documents.map((doc) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Color(0xff2f2f2f),
                        child: ListTile(
                          leading: ImageIcon(AssetImage('icons/brands.png'),
                            size: 25, color: Color(0xff008db9),),
                          title: Text(doc.data['zone_name'],
                              style: TextStyle(color: Colors.white)),
                          subtitle: Text(doc.data['zone_value'],
                              style: TextStyle(color: Colors.white)),
                          trailing: IconButton(
                            icon: Icon(Icons.delete,  color: Colors.redAccent),
                            onPressed: ()
                            {var alert = new AlertDialog(
                              backgroundColor: Color(0xff252525),
                              elevation: 7.0,
                              content:
                              Text('Are you sure you want to delete this Zone',
                                  style: TextStyle(color: Colors.white)),
                              actions: <Widget>[
                                FlatButton(
                                    color: Color(0xff008db9),
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    onPressed: ()async{
                                      await Firestore.instance
                                          .collection('zone_area')
                                          .document(doc.documentID)
                                          .delete();
                                      Fluttertoast.showToast(msg: 'Category Deleted Successfully');
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
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return SizedBox();
              }
            }),
      ),
    );
  }
}

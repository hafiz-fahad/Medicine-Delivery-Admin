import 'package:Medsway.pk_Admin/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Medsway.pk_Admin/providers/search_service.dart';
import 'package:Medsway.pk_Admin/screens/product_list.dart';

class Search extends StatefulWidget {
//  final DocumentSnapshot user;

//  Search({this.user});
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(value){
    if(value.length == 0){
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        value.substring(0,1).toUpperCase() + value.substring(1);

    if(queryResultSet.length == 0 && value.length == 1){
      SearchProductService().searchByName(value).then((QuerySnapshot docs){

        for(int i = 0; i < docs.documents.length; ++i){
          setState(() {
            queryResultSet.add(docs.documents[i].data);
            tempSearchStore.add(docs.documents[i].data);
          });
        }
      });
    }
    else{
      tempSearchStore = [];
      queryResultSet.forEach((element){

        if(element['name'].startsWith(capitalizedValue)){
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xff252525),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (val){
                initiateSearch(val);
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  color: Colors.grey,
                  icon: Icon(Icons.arrow_back),
                  iconSize: 20,
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                ),
                contentPadding: EdgeInsets.only(left: 25.0),
                hintText: 'Serach by name',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4.0,),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0,),
          ListView(
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
//              crossAxisCount: 2,
//              crossAxisSpacing: 4.0,
//              mainAxisSpacing: 4.0,
            primary: false,
            shrinkWrap: true,

            children: tempSearchStore.map((element){
//              if()
              return buildResultCard(element);
            }).toList(),
          )
        ],
      ),
    );
  }
  Widget buildResultCard(data){
//    DocumentSnapshot product;
//    StreamBuilder<QuerySnapshot>(
//        stream: Firestore.instance.collection('products').snapshots(),
//        builder: (context, snapshot) {
//          if (snapshot.hasData) {
//            return Column(
//              children: snapshot.data.documents.map((doc) {
//                if(doc.data['name'] == data['name'])
//                  product = doc;
//                return SizedBox();
//              }).toList(),
//            );
//          }
//          else {
//            return SizedBox();
//          }
//        });
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('products').snapshots(),
        builder: (context, snapshot) {
          return Container(
            child: GestureDetector(
              onTap: (){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Loading();
                }
                else if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data.documents.map((doc) {
                      if(doc.data['name'] == data['name'])
                        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetail(product: doc,)));
                      return SizedBox();
                    }).toList(),
                  );
                }
                else {
                  return SizedBox();
                }
//              Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetails(product: product,user: widget.user,)));
              },
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                elevation: 5.0,
                child: Container(
                  height: 50,
                  child: Center(
                    child: Text(data['name'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }
}

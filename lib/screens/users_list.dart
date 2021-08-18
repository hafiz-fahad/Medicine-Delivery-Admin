import 'package:Medsway.pk_Admin/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Medsway.pk_Admin/screens/search_bar.dart';

DocumentSnapshot _currentDocument;

class UsersListPage extends StatefulWidget {
  @override
  _UsersListPageState createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {

//  Future getUsersList() async {
//    var firestore = Firestore.instance;
//
//    QuerySnapshot qn = await firestore.collection('users').getDocuments();
//    return qn.documents;
//  }
  navigateToDetail(DocumentSnapshot user){
    _currentDocument = user;
    Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetail(user: user,)));
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
          "Users",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(5.0),
        child: FutureBuilder(
//            future: getUsersList(),
            builder: (_, snapshot){
                return ListView(
                  padding: EdgeInsets.all(5.0),
                  children: <Widget>[
                    SizedBox(height: 10.0),
//                    Search(),
                    StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance.collection('users').snapshots(),
                        builder: (context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return Loading();
                          }
                          else if (snapshot.hasData) {
                            return Column(
                              children: snapshot.data.documents.map((doc) {
                                return ListTile(
                                  leading: ImageIcon(AssetImage('icons/users_icon.png'),
                                    size: 30, color: Color(0xff008db9),),
                                  title: Text(doc.data['name'],
                                      style: TextStyle(color: Colors.white)),
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
                                      Text('Are you sure you want to delete this User?',
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
                                              .collection('users')
                                              .document(doc.documentID)
                                              .delete();
                                          Fluttertoast.showToast(msg: 'User Deleted Successfully');
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
class UserDetail extends StatefulWidget {

  final DocumentSnapshot user;

  UserDetail({this.user});
  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {

  TextEditingController _nameController;
  TextEditingController _addressController;
  TextEditingController _userIdController;
  TextEditingController _pCodeController;
  TextEditingController _phoneController;
  TextEditingController _zoneNameController;


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.data['name']);
    _addressController = TextEditingController(
        text: 'House # ${widget.user.data['house_no']}\, '
            '${widget.user.data['street_no']}\, '
            '${widget.user.data['area']}');
    _pCodeController = TextEditingController(text: widget.user.data['postal_code']);
    _userIdController = TextEditingController(text: widget.user.data['uid']);
    _phoneController = TextEditingController(text: widget.user.data['phone']);
    _zoneNameController = TextEditingController(text: widget.user.data['zone_name']);


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
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          "User Detail",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))
            ),
            color: Color(0xff2f2f2f),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: new TextStyle(color: Colors.white),
                    controller: _userIdController,
                    enabled: false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xff2f2f2f),
                        filled: true,
                        labelText: 'User ID:',
                        labelStyle: TextStyle(color: Colors.cyan)
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: new TextStyle(color: Colors.white),
                    controller: _nameController,
                    enabled: false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xff2f2f2f),
                        filled: true,
                        labelText: 'Name:',
                        labelStyle: TextStyle(color: Colors.cyan)
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: new TextStyle(color: Colors.white),
                    controller: _zoneNameController,
                    enabled: false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xff2f2f2f),
                        filled: true,
                        labelText: 'NearBy Zone:',
                        labelStyle: TextStyle(color: Colors.cyan)
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: new TextStyle(color: Colors.white),
                    controller: _addressController,
                    enabled: false,
                    maxLines: 3,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xff2f2f2f),
                        filled: true,
                        labelText: 'Address:',
                        labelStyle: TextStyle(color: Colors.cyan)
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: new TextStyle(color: Colors.white),
                    controller: _pCodeController,
                    enabled: false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xff2f2f2f),
                        filled: true,
                        labelText: 'Postal Code:',
                        labelStyle: TextStyle(color: Colors.cyan)
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: new TextStyle(color: Colors.white),
                    controller: _phoneController,
                    enabled: false,
                    maxLines: 3,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xff2f2f2f),
                        filled: true,
                        labelText: 'Phone #:',
                        labelStyle: TextStyle(color: Colors.cyan)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





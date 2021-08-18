import 'package:al_asr_admin/providers/sold_provider.dart';
import 'package:al_asr_admin/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'search_bar.dart';
import 'package:timeago/timeago.dart' as timeago;

DocumentSnapshot _currentDocument;

class SoldListPage extends StatefulWidget {
  @override
  _SoldListPageState createState() => _SoldListPageState();
}

class _SoldListPageState extends State<SoldListPage> {

  navigateToDetail(DocumentSnapshot sold){
    _currentDocument = sold;
    Navigator.push(context, MaterialPageRoute(builder: (context) => SoldDetail(sold: sold,)));
  }
  navigateToDetail2(DocumentSnapshot sold){
    _currentDocument = sold;
    Navigator.push(context, MaterialPageRoute(builder: (context) => SoldPDetail(sold: sold,)));
  }
  bool _listCounter = false;

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
          "Sold Orders",
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
//                  Search(),
                  StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection('sold').orderBy('date',descending: true).snapshots(),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Loading();
                        }
                        else if (snapshot.hasData) {
//                          _listCounter = true;
                          return Column(
                            children: snapshot.data.documents.map((doc) {
                              return ListTile(
                                leading: ImageIcon(AssetImage('icons/products_icon.png'),
                                  size: 30, color: Color(0xff008db9),),
                                title: Text(doc.data['customer_name'],
                                  style: TextStyle(color: Colors.white),),
                                subtitle: Text(timeago.format(DateTime.tryParse(doc.data['date'].toDate().toString())).toString(),
                                  style: TextStyle(color: Colors.white,fontSize: 10),),
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
                                    Text('Are you sure you want to delete this Order?',
                                        style: TextStyle(color: Colors.white)),
                                    actions: <Widget>[
                                      FlatButton(
                                          color: Color(0xff008db9),
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          onPressed: ()async{
                                            Fluttertoast.showToast(msg: 'Order Deleted Successfully');
                                            Navigator.pop(context);
                                            await Firestore.instance
                                                .collection('sold')
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
                              );
                            }).toList(),
                          );
                        } else {
                          return SizedBox();
                        }
                      }),
                  StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection('soldWithPrescription').orderBy('date',descending: true).snapshots(),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Loading();
                        }
                        else if (snapshot.hasData) {
//                          _listCounter = true;
                          return Column(
                            children: snapshot.data.documents.map((doc) {
                              return ListTile(
                                leading: ImageIcon(AssetImage('icons/products_icon.png'),
                                  size: 30, color: Color(0xff008db9),),
                                title: Text('${doc.data['customer_name']}',
                                  style: TextStyle(color: Colors.white),),
                                subtitle: Text('${timeago.format(DateTime.tryParse(doc.data['date'].toDate().toString())).toString()}'
                                    '\t\t\t\t(prescription)',
                                  style: TextStyle(color: Colors.white,fontSize: 10),),
                                onTap: () => navigateToDetail2(doc),
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
                                    Text('Are you sure you want to delete this Order?',
                                        style: TextStyle(color: Colors.white)),
                                    actions: <Widget>[
                                      FlatButton(
                                          color: Color(0xff008db9),
                                          textColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          onPressed: ()async{
                                            Fluttertoast.showToast(msg: 'Order Deleted Successfully');
                                            Navigator.pop(context);
                                            await Firestore.instance
                                                .collection('soldWithPrescription')
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
                              );
                            }).toList(),
                          );
                        } else {
                          return SizedBox();
                        }
                      }),
//                  if(_listCounter == false)
//                    Card(
//                      shape: RoundedRectangleBorder(
//                          borderRadius: BorderRadius.all(Radius.circular(30))
//                      ),
//                      color: Color(0xff2f2f2f),
//                      child: Padding(
//                        padding: const EdgeInsets.all(10.0),
//                        child: Text('No Oders To Show',
//                          style: TextStyle(color: Colors.cyan,fontSize: 25),),
//                      ),
//                    )
                ],
              );
            }),
      ),
    );
  }
}

class SoldDetail extends StatefulWidget {

  final DocumentSnapshot sold;

  SoldDetail({this.sold});
  @override
  _SoldDetailState createState() => _SoldDetailState();
}

class _SoldDetailState extends State<SoldDetail> {

  SoldService _soldService = SoldService();

  TextEditingController _nameController;
  TextEditingController _addressController;
  TextEditingController _userIDController;
  TextEditingController _orderIDController;
  TextEditingController _dateController;
  TextEditingController _pCodeController;
  TextEditingController _zoneNameController;
  TextEditingController _phoneController;


  bool onSale = false;
  bool featured = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.sold.data['customer_name']);
    _addressController = TextEditingController(text: widget.sold.data['address']);
    _userIDController = TextEditingController(text: widget.sold.data['userId']);
    _orderIDController = TextEditingController(text: widget.sold.data['orderId']);
    _dateController = TextEditingController(text:
    timeago.format(DateTime.tryParse(widget.sold.data['date'].toDate().toString())).toString());
    _pCodeController = TextEditingController(text: widget.sold.data['postal_code']);
    _zoneNameController = TextEditingController(text: widget.sold.data['zone_name']);
    _phoneController = TextEditingController(text: widget.sold.data['phone']);


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
          "Order Detail",
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
                Container(
                    child: Column(
                      children: <Widget>[
                        widget.sold.data['picture']==null
                          ?Container()
                          :Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Prescription',
                              style: TextStyle(color: Colors.cyan,fontSize: 20,fontWeight: FontWeight.bold),),
                          ),
                          Divider(color: Colors.white,),
                          SizedBox(
                            height: 150,
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (_) => PrescriptionView(image: widget.sold,)));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
                                  child: Image.network(
                                    widget.sold.data['picture'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Divider(color: Colors.cyan,),
                          Divider(color: Colors.cyan,),
                        ],
                      ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Products Details',
                            style: TextStyle(color: Colors.cyan,fontSize: 20,fontWeight: FontWeight.bold),),
                        ),
                        Divider(color: Colors.white,),
                        for(int i = 0; i < widget.sold.data['products_details'].length; i++)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(' *  ${widget.sold.data['products_details'][i]}',
                                  style: TextStyle(color: Colors.white,fontSize: 15),),
                              ),
                            ],
                          ),
                        Divider(color: Colors.white),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:  Text(' Product\'s Total :\t\t\t\t ${widget.sold.data['total_bill']}',
                                style: TextStyle(color: Colors.white,fontSize: 15),),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:  Text(' Delivery Amount :\t\t\t\t ${widget.sold.data['delivery_amount']}',
                                style: TextStyle(color: Colors.white,fontSize: 15),),
                            ),
                          ],
                        ),
                        Divider(color: Colors.white),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:  Text(' Total Payable :\t\t\t\t ${widget.sold.data['delivery_amount']+widget.sold.data['total_bill']}',
                                style: TextStyle(color: Colors.white,fontSize: 15),),
                            ),
                          ],
                        ),
                        Divider(color: Colors.cyan,),
                        Divider(color: Colors.cyan,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Customer Details',
                            style: TextStyle(color: Colors.cyan,fontSize: 20,fontWeight: FontWeight.bold),),
                        ),
                        Divider(color: Colors.white,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            style: new TextStyle(color: Colors.white),
                            controller: _dateController,
                            enabled: false,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xff2f2f2f),
                                filled: true,
                                labelText: 'Date n Time:',
                                labelStyle: TextStyle(color: Colors.cyan)
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            style: new TextStyle(color: Colors.white),
                            controller: _orderIDController,
                            enabled: false,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xff2f2f2f),
                                filled: true,
                                labelText: 'Order ID:',
                                labelStyle: TextStyle(color: Colors.cyan)
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            style: new TextStyle(color: Colors.white),
                            controller: _userIDController,
                            enabled: false,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xff2f2f2f),
                                filled: true,
                                labelText: 'Customer ID:',
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
                                labelText: 'Customer Name:',
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
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xff2f2f2f),
                                filled: true,
                                labelText: 'Contact Number:',
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
                      ],
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class SoldPDetail extends StatefulWidget {

  final DocumentSnapshot sold;

  SoldPDetail({this.sold});
  @override
  _SoldPDetailState createState() => _SoldPDetailState();
}

class _SoldPDetailState extends State<SoldPDetail> {

  SoldService _soldService = SoldService();

  TextEditingController _nameController;
  TextEditingController _addressController;
  TextEditingController _userIDController;
  TextEditingController _orderIDController;
  TextEditingController _dateController;
  TextEditingController _pCodeController;
  TextEditingController _zoneNameController;
  TextEditingController _phoneController;



  bool onSale = false;
  bool featured = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.sold.data['customer_name']);
    _addressController = TextEditingController(text: widget.sold.data['address']);
    _userIDController = TextEditingController(text: widget.sold.data['userId']);
    _orderIDController = TextEditingController(text: widget.sold.data['orderId']);
    _dateController = TextEditingController(text:
    timeago.format(DateTime.tryParse(widget.sold.data['date'].toDate().toString())).toString());
//    _productsTotalController = TextEditingController(text: widget.order.data['total_bill'].toString());
//    _deliveryAmountController = TextEditingController(text: widget.order.data['delivery_amount'].toString());
//    _productsController = TextEditingController(text: widget.order.data['products_details'].toString());
    _pCodeController = TextEditingController(text: widget.sold.data['postal_code']);
    _zoneNameController = TextEditingController(text: widget.sold.data['zone_name']);
    _phoneController = TextEditingController(text: widget.sold.data['phone']);


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
          "Order Detail",
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
                widget.sold.data['picture']==null
                    ?Container()
                    :Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Prescription',
                        style: TextStyle(color: Colors.cyan,fontSize: 20,fontWeight: FontWeight.bold),),
                    ),
                    Divider(color: Colors.white,),
                    SizedBox(
                      height: 150,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (_) => PrescriptionView(image: widget.sold,)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
                            child: Image.network(
                              widget.sold.data['picture'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Divider(color: Colors.cyan,),
                    Divider(color: Colors.cyan,),
                  ],
                ),
                Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Customer Details',
                            style: TextStyle(color: Colors.cyan,fontSize: 20,fontWeight: FontWeight.bold),),
                        ),
                        Divider(color: Colors.white,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            style: new TextStyle(color: Colors.white),
                            controller: _dateController,
                            enabled: false,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xff2f2f2f),
                                filled: true,
                                labelText: 'Date n Time:',
                                labelStyle: TextStyle(color: Colors.cyan)
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            style: new TextStyle(color: Colors.white),
                            controller: _orderIDController,
                            enabled: false,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xff2f2f2f),
                                filled: true,
                                labelText: 'Order ID:',
                                labelStyle: TextStyle(color: Colors.cyan)
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            style: new TextStyle(color: Colors.white),
                            controller: _userIDController,
                            enabled: false,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xff2f2f2f),
                                filled: true,
                                labelText: 'Customer ID:',
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
                                labelText: 'Customer Name:',
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
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                fillColor: Color(0xff2f2f2f),
                                filled: true,
                                labelText: 'Contact Number:',
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
                      ],
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PrescriptionView extends StatefulWidget {
  final DocumentSnapshot image;

  PrescriptionView({this.image});
  @override
  _PrescriptionViewState createState() => _PrescriptionViewState();
}

class _PrescriptionViewState extends State<PrescriptionView> {
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
                    imageProvider: NetworkImage(widget.image.data['picture']),
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


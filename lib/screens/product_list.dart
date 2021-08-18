import 'package:Medsway.pk_Admin/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'search_bar.dart';

DocumentSnapshot _currentDocument;

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {

  navigateToDetail(DocumentSnapshot product){
    _currentDocument = product;
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetail(product: product,)));
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
          "Products",
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
                  Card(
                    color: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text('Search Products here',style: TextStyle(color: Colors.grey),),
                      leading: IconButton(icon: Icon(Icons.search,color: Colors.grey,),),
                      onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
                      },
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance.collection('products').orderBy('name').snapshots(),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Loading();
                        }
                        else if (snapshot.hasData) {
                          return Column(
                            children: snapshot.data.documents.map((doc) {
                              return ListTile(
                                leading: ImageIcon(AssetImage('icons/products_icon.png'),
                                  size: 30, color: Color(0xff008db9),),
                                title: Text(doc.data['name'],
                                  style: TextStyle(color: Colors.white),),
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
                                    Text('Are you sure you want to delete this Product?',
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
                                            .collection('products')
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
                ],
              );
            }),
      ),
    );
  }
}

class ProductDetail extends StatefulWidget {

  final DocumentSnapshot product;

  ProductDetail({this.product});
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {

  GlobalKey<FormState> _updateFormKey = GlobalKey();
//  final _updateQuantityPerPackController = TextEditingController();
  TextEditingController _updatePriceController ;
  TextEditingController _updateFeaturedController ;
  TextEditingController _productNameController;
  TextEditingController _productIdController;
  TextEditingController _productCategoryController;
  TextEditingController _productBrandController;
  TextEditingController _productDescripController;
  TextEditingController _unitPriceController;
  TextEditingController _unitsPerPackController;
  TextEditingController _isFeaturedController;
  TextEditingController _prescriptionRequiredController;
  TextEditingController _onSaleController;

//  bool onSale ;
  bool prescriptionRequired ;
  bool featured;
  @override
  void initState() {
    super.initState();
    _productIdController = TextEditingController(text: widget.product.data['id']);
    _productNameController = TextEditingController(text: widget.product.data['name']);
    _productCategoryController = TextEditingController(text: widget.product.data['category']);
    _productBrandController = TextEditingController(text: widget.product.data['brand']);
    _productDescripController = TextEditingController(text: widget.product.data['description']);
    _unitPriceController = TextEditingController(text: '${widget.product.data['unit_price']}');
    _unitsPerPackController = TextEditingController(text: '${widget.product.data['quantity_units_per_pack']}');
    _isFeaturedController = TextEditingController(text: '${widget.product.data['featured']}');
    _prescriptionRequiredController = TextEditingController(text: '${widget.product.data['prescription_required']}');
//    _onSaleController = TextEditingController(text: '${widget.product.data['sale']}');
    _updatePriceController = TextEditingController(text: '${widget.product.data['unit_price']}');
    _updateFeaturedController = TextEditingController(text: '${widget.product.data['featured']}');

//    onSale = widget.product.data['sale'];
    prescriptionRequired = widget.product.data['prescription_required'];
    featured = widget.product.data['featured'];

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
          "Product Detail",
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
                    controller: _productIdController,
                    enabled: false,
                    maxLines: 2,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xff252525),
                        filled: true,
                        labelText: 'Product ID:',
                        labelStyle: TextStyle(color: Colors.cyan)
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: new TextStyle(color: Colors.white),
                    controller: _productNameController,
                    enabled: false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xff252525),
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
                    controller: _isFeaturedController,
                    enabled: false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xff252525),
                        filled: true,
                        labelText: 'Is Featured:',
                        labelStyle: TextStyle(color: Colors.cyan)
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: new TextStyle(color: Colors.white),
                    controller: _prescriptionRequiredController,
                    enabled: false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xff252525),
                        filled: true,
                        labelText: 'Prescription Required:',
                        labelStyle: TextStyle(color: Colors.cyan)
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: new TextStyle(color: Colors.white),
                    controller: _productDescripController,
                    enabled: false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xff252525),
                        filled: true,
                        labelText: 'Description:',
                        labelStyle: TextStyle(color: Colors.cyan)
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: new TextStyle(color: Colors.white),
                    controller: _productCategoryController,
                    enabled: false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xff252525),
                        filled: true,
                        labelText: 'Category:',
                        labelStyle: TextStyle(color: Colors.cyan)
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: new TextStyle(color: Colors.white),
                    controller: _productBrandController,
                    enabled: false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xff252525),
                        filled: true,
                        labelText: 'Brand:',
                        labelStyle: TextStyle(color: Colors.cyan)
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: new TextStyle(color: Colors.white),
                    controller: _unitsPerPackController,
                    enabled: false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xff252525),
                        filled: true,
                        labelText: 'Unit/Pack:',
                        labelStyle: TextStyle(color: Colors.cyan)
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    style: new TextStyle(color: Colors.white),
                    controller: _unitPriceController,
                    enabled: false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xff252525),
                        filled: true,
                        labelText: 'Unit Price:',
                        labelStyle: TextStyle(color: Colors.cyan)
                    ),
                  ),
                ),
                SizedBox(width: double.infinity,
                 child: FlatButton(
                  color: Color(0xff008db9),
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))
                  ),
                  child: Text('UPDATE PRODUCT', style: TextStyle(fontSize: 20),),
                  padding: EdgeInsets.all(13),
                  onPressed: () {
                    setState(() {
//                      prescriptionRequired = widget.product.data['prescription_required'];
//                      featured = widget.product.data['featured'];
                    });
                    _updateAlert();
                  },
                )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateAlert() {
    var alert = new AlertDialog(
      backgroundColor: Color(0xff252525),
      elevation: 7.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))
      ),
      content: Form(
        key: _updateFormKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Container(
                  color: Color(0xff2f2f2f),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Featured', style: TextStyle(color: Colors.cyan),),
                      ),
                      SizedBox(width: 20,),
                      Switch(
                          activeTrackColor: Colors.cyan,
                          activeColor: Colors.white,
                          value: featured,
                          onChanged: (bool value){
//                        if(value == true && featured == false){
////                    setState(() {
//                          featured = value;
////                    });
//                        }
//                        if(value == false && featured == true){
////                    setState(() {
//                          featured = value;
////                    });
//                        }
//                        setState(() {
                          featured = value;
//                        });
                      }),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:8.0),
                child: Container(
                  color: Color(0xff2f2f2f),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Prescription Required', style: TextStyle(color: Colors.cyan),),
                      ),
//                    SizedBox(width: 10,),
                      Switch(
                          activeTrackColor: Colors.cyan,
                          activeColor: Colors.white,
                          value: prescriptionRequired,
                          onChanged: (val){
//                        if(val == true && prescriptionRequired == false){
//                    setState(() {
//                          prescriptionRequired = val;
//
//                    });
//                        }
//                        if(val == false && prescriptionRequired == true){
//                    setState(() {
//                          prescriptionRequired = val;
//                          widget.product.data['prescription_required'] = val;
//                    });
//                        }
//                  setState(() {
                    prescriptionRequired = val;
//                  });
                      }),
                    ],
                  ),
                ),
              ),
//              Padding(
//                  padding: const EdgeInsets.only(top: 8, bottom: 5),
//                  child:TextFormField(
//                    style: TextStyle(color: Colors.white),
//                    controller: _updateFeaturedController,
//                    keyboardType: TextInputType.number,
//                    validator: (value){
//                      if(value.isEmpty){
//                        return 'price cannot be empty';
//                      }
//                    },
//                    decoration: InputDecoration(
//                        border: InputBorder.none,
//                        fillColor: Color(0xff2f2f2f),
//                        filled: true,
//                        labelText: "Featured",
//                        labelStyle: TextStyle(color: Colors.cyan, fontSize: 16),
//                        hintText: ""
//                    ),
//                  )
//              ),
            Padding(
               padding: const EdgeInsets.only(top: 8, bottom: 5),
              child:TextFormField(
                style: TextStyle(color: Colors.white),
                controller: _updatePriceController,
                keyboardType: TextInputType.number,
                validator: (value){
                  if(value.isEmpty){
                    return 'price cannot be empty';
                  }
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color(0xff2f2f2f),
                    filled: true,
                  labelText: "Update Unit Price",
                    labelStyle: TextStyle(color: Colors.cyan, fontSize: 16),
                    hintText: ""
                ),
              )
            ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
                // ignore: unnecessary_statements
          Fluttertoast.showToast(msg: 'Product Details Updated');
          Navigator.pop(context);
          _unitPriceController.text = _updatePriceController.text;
//          _isFeaturedController.text = _updateFeaturedController.text;
//          _onSaleController.text = onSale.toString();
          _isFeaturedController.text = featured.toString();
          _prescriptionRequiredController.text = prescriptionRequired.toString();
//          widget.product.data['sale'] = onSale;
//          widget.product.data['featured'] = featured;
//          widget.product.data['prescription_required'] = prescriptionRequired;

          _updateData();
//          _updateQuantityPerPackController.clear();
//          _updatePriceController.clear();
        },
            color: Color(0xff008db9),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text('UPDATE')),
        FlatButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('CANCEL'),
          textColor: Colors.white),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  _updateData() async {
    await Firestore.instance
        .collection('products')
        .document(_currentDocument.documentID)
        .updateData({
      'featured': featured,
      'prescription_required': prescriptionRequired,
//      'sale': onSale,
//      'quantity_of_packs': int.parse(_updateQuantityPerPackController.text),
      'unit_price': double.parse(_updatePriceController.text),
        });
  }

}
import 'package:al_asr_admin/providers/products_provider.dart';
import 'package:al_asr_admin/widgets/loading.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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

  navigateToDetail(Map<String, dynamic> product){
//    _currentDocument = product;
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
                  Container(
                    height: MediaQuery.of(context).size.height*.8,
                    child: ListView.builder(
                        itemCount: productsGetList.length,
                        itemBuilder: (context,index){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: Color(0xff2f2f2f),
                              child: ListTile(
                                leading: ImageIcon(AssetImage('icons/products_icon.png'),
                                  size: 30, color: Color(0xff008db9),),
                                title: Text(productsGetList[index]['name'].toString(),
                                  style: TextStyle(color: Colors.white),),
                                onTap: () => navigateToDetail(productsGetList[index]),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              );
            }),
      ),
    );
  }
}

class ProductDetail extends StatefulWidget {

  final product;

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
  TextEditingController _packPriceController;
  TextEditingController _updateUnitPerPackController;




//  bool onSale ;
  bool prescriptionRequired ;
  bool featured;
  Map<String, dynamic> selectedProduct;
  @override
  void initState() {
    super.initState();
    _productIdController = TextEditingController(text: widget.product['_id']);
    _productNameController = TextEditingController(text: widget.product['name']);
    _productCategoryController = TextEditingController(text: widget.product['category']);
    _productBrandController = TextEditingController(text: widget.product['brand']);
    _productDescripController = TextEditingController(text: widget.product['description']);
    _unitPriceController = TextEditingController(text: '${widget.product['unit_price']}');
    _packPriceController = TextEditingController(text: '${widget.product['pack_price']}');
    _unitsPerPackController = TextEditingController(text: '${widget.product['quantity_units_per_pack']}');
    _isFeaturedController = TextEditingController(text: '${widget.product['featured']}');
    _prescriptionRequiredController = TextEditingController(text: '${widget.product['prescription_required']}');
//    _onSaleController = TextEditingController(text: '${widget.product['sale']}');
    _updatePriceController = TextEditingController(text: '${widget.product['pack_price']}');
    _updateUnitPerPackController = TextEditingController(text: '${widget.product['quantity_units_per_pack']}');
    _updateFeaturedController = TextEditingController(text: '${widget.product['featured']}');

//    onSale = widget.product['sale'];
    prescriptionRequired = widget.product['prescription_required'];
    featured = widget.product['featured'];

  }

  deleteData(Map<String, dynamic> product) async {
    String url = 'https://globaltodobackend.herokuapp.com/api/v1/medicine/${product['_id']}';
    Dio dio = new Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['accept'] = 'application/json';
    Response productDeleteResponse = await dio.delete(url);
    print("Status Code =  ${productDeleteResponse.statusCode.toString()}");
    if (productDeleteResponse.statusCode == 200) {
      print("Product Delete Response = ${productDeleteResponse.toString()}");
    }
    if(productDeleteResponse.statusCode != 200){
      print("Status Code =  ${productDeleteResponse.statusCode.toString()}");
    }
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
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: TextField(
//                    style: new TextStyle(color: Colors.white),
//                    controller: _isFeaturedController,
//                    enabled: false,
//                    decoration: InputDecoration(
//                        border: InputBorder.none,
//                        fillColor: Color(0xff252525),
//                        filled: true,
//                        labelText: 'Is Featured:',
//                        labelStyle: TextStyle(color: Colors.cyan)
//                    ),
//                  ),
//                ),
//                Padding(
//                  padding: const EdgeInsets.all(8.0),
//                  child: TextField(
//                    style: new TextStyle(color: Colors.white),
//                    controller: _prescriptionRequiredController,
//                    enabled: false,
//                    decoration: InputDecoration(
//                        border: InputBorder.none,
//                        fillColor: Color(0xff252525),
//                        filled: true,
//                        labelText: 'Prescription Required:',
//                        labelStyle: TextStyle(color: Colors.cyan)
//                    ),
//                  ),
//                ),
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
                    controller: _packPriceController,
                    enabled: false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        fillColor: Color(0xff252525),
                        filled: true,
                        labelText: 'Pack Price:',
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
                Container(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: FlatButton(
                          color: Color(0xff008db9),
                          textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30))
                  ),
                          child: Text('UPDATE', style: TextStyle(fontSize: 20),),
                          padding: EdgeInsets.all(13),
                          onPressed: () {
                            _updateAlert();
                          },
                        ),
                      ),
                      VerticalDivider(),
                      Expanded(
                        child: FlatButton(
                          color: Colors.red,
                          textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(bottomRight: Radius.circular(30))
                  ),
                          child: Text('DELETE', style: TextStyle(fontSize: 20),),
                          padding: EdgeInsets.all(13),
                          onPressed: () {
                            var alert = new AlertDialog(
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
                                    onPressed: (){
                                      Fluttertoast.showToast(msg: 'Product Deleted Successfully');
                                      Navigator.pop(context);
                                      deleteData(widget.product);
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
                      )
                    ],
                  ),
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
//              Padding(
//                padding: const EdgeInsets.only(top:8.0),
//                child: Container(
//                  color: Color(0xff2f2f2f),
//                  child: Row(
//                    children: <Widget>[
//                      Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: Text('Featured', style: TextStyle(color: Colors.cyan),),
//                      ),
//                      SizedBox(width: 20,),
//                      Switch(
//                          activeTrackColor: Colors.cyan,
//                          activeColor: Colors.white,
//                          value: featured,
//                          onChanged: (bool value){
////                        if(value == true && featured == false){
//////                    setState(() {
////                          featured = value;
//////                    });
////                        }
////                        if(value == false && featured == true){
//////                    setState(() {
////                          featured = value;
//////                    });
////                        }
////                        setState(() {
//                          setState(() {
//                            featured = value;
//                          });
////                        });
//                      }),
//                    ],
//                  ),
//                ),
//              ),
//              Padding(
//                padding: const EdgeInsets.only(top:8.0),
//                child: Container(
//                  color: Color(0xff2f2f2f),
//                  child: Row(
//                    children: <Widget>[
//                      Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: Text('Prescription Required', style: TextStyle(color: Colors.cyan),),
//                      ),
////                    SizedBox(width: 10,),
//                      Switch(
//                          activeTrackColor: Colors.cyan,
//                          activeColor: Colors.white,
//                          value: prescriptionRequired,
//                          onChanged: (val){
////                        if(val == true && prescriptionRequired == false){
////                    setState(() {
////                          prescriptionRequired = val;
////
////                    });
////                        }
////                        if(val == false && prescriptionRequired == true){
////                    setState(() {
////                          prescriptionRequired = val;
////                          widget.product['prescription_required'] = val;
////                    });
////                        }
////                  setState(() {
//                          print("$val");
//                          setState(() {
//                            prescriptionRequired = val;
//                          });
////                  });
//                      }),
//                    ],
//                  ),
//                ),
//              ),
              Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 5),
                  child:TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _updateUnitPerPackController,
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
                        labelText: "Unit/pack",
                        labelStyle: TextStyle(color: Colors.cyan, fontSize: 16),
                        hintText: ""
                    ),
                  )
              ),
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
                  labelText: "Update Pack Price",
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
          _packPriceController.text = _updatePriceController.text;
//          _isFeaturedController.text = featured.toString();
//          _prescriptionRequiredController.text = prescriptionRequired.toString();

          _updateData();
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
    String url = 'https://globaltodobackend.herokuapp.com/api/v1/medicine/${widget.product["_id"]}';
    Dio dio = new Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['accept'] = 'application/json';
    String json = '{'
        '"name": "${widget.product['name']}", '
        '"category": "${widget.product['category']}", '
        '"pack_price": "${_updatePriceController.text}",'
        '"quantity_units_per_pack": "${_updateUnitPerPackController.text}",'
        '"unit_price": "${((int.parse(_updatePriceController.text))/(int.parse(_updateUnitPerPackController.text))).round()}",'
        '"featured": "${false}",'
        '"prescription_required": "${false}",'
        '"search_key": "${widget.product['search_key']}"}';
    Response productUpdateResponse = await dio.put(url, data: json);
    print("Status Code =  ${productUpdateResponse.statusCode.toString()}");
    if (productUpdateResponse.statusCode == 200) {
      print("Response Body =  ${productUpdateResponse.data.toString()}");
      print("Status Code =  ${productUpdateResponse.statusCode.toString()}");
    }
    if(productUpdateResponse.statusCode != 200){
      print("Status Code =  ${productUpdateResponse.statusCode.toString()}");
    }
  }

}
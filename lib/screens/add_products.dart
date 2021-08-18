import 'dart:io';

import 'package:Medsway.pk_Admin/widgets/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Medsway.pk_Admin/db/product.dart';
import 'package:Medsway.pk_Admin/db/product.dart';
import 'package:provider/provider.dart';
import 'package:Medsway.pk_Admin/providers/products_provider.dart';
import '../db/category.dart';
import '../db/brand.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  ProductService productService = ProductService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController quantityTabletPerPackController = TextEditingController();
  TextEditingController quantityPerPackController = TextEditingController();
//  TextEditingController quantityStripsPerPackController = TextEditingController();
//  TextEditingController quantityTabletPerStripController = TextEditingController();
  TextEditingController quantityUnitsPerPackController = TextEditingController();


  final pricePerTabletController = TextEditingController();
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
  <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  String _currentCategory;
  String _currentBrand;
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;
//  List<String> selectedSizes = <String>[];
//  List<String> colors = <String>[];
  bool onSale = false;
  bool featured = false;
  bool prescription_required = false;

  File _image1;
  bool isLoading = false;

  @override
  void initState() {
    _getCategories();
    _getBrands();
  }

  List<DropdownMenuItem<String>> getCategoriesDropdown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < categories.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(categories[i].data['category']),
                value: categories[i].data['category']));
      });
    }
    return items;
  }

  List<DropdownMenuItem<String>> getBrandsDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < brands.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(brands[i].data['brand']),
                value: brands[i].data['brand']));
      });
    }
    return items;
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
          "NEW PRODUCT",
          style: TextStyle(color: white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: isLoading
              ? Loading()
              : Column(
            children: <Widget>[
//              Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  if(_image1 == null)
//                    Container(
//                      child: Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: Container(
//                          width: 120,
//                          child: FlatButton(
//                              onPressed: () {
//                                _selectImage(
//                                  ImagePicker.pickImage(
//                                      source: ImageSource.gallery),
//                                );
//                              },
//                              child: Image.asset('icons/addImage.png')
//                          ),
//                        ),
//                      ),
//                    ),
//                  if(_image1 != null)
//                  Container(
//                    child: Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Container(
//                        width: 120,
//                        child: FlatButton(
//                            onPressed: () {
//                              _selectImage(
//                                ImagePicker.pickImage(
//                                    source: ImageSource.gallery),
//                              );
//                            },
//                            child: _displayChild1()
//                        ),
//                      ),
//                    ),
//                  ),
//
//                ],
//              ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
            ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Color(0xff2f2f2f),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('FEATURED',
                            style:
                            TextStyle(color: Colors.cyan, fontSize: 17, fontWeight: FontWeight.bold)
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*.5,),
                      Switch(
                          activeTrackColor: Colors.cyan,
                          activeColor: Colors.white,
                          value: featured,
                          onChanged: (value){
                        setState(() {
                          featured = value;
                        });
                      }),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Color(0xff2f2f2f),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Prescription Required',
                            style:
                            TextStyle(color: Colors.cyan, fontSize: 17, fontWeight: FontWeight.bold)
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*.26,),
                      Switch(
                          activeTrackColor: Colors.cyan,
                          activeColor: Colors.white,
                          value: prescription_required,
                          onChanged: (value){
                        setState(() {
                          prescription_required = value;
                        });
                      }),
                    ],
                  ),
                ),
              ),
              //              select category
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Color(0xff2f2f2f),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'CATEGORY: ',
                          style: TextStyle(color: Colors.cyan, fontSize: 17,fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width*.3,),
                      SizedBox(
                        width:90,
                        child: DropdownButton(
                          style: TextStyle(color: Colors.white, fontSize: 15, backgroundColor: Color(0xff2f2f2f)),
                          items: categoriesDropDown,
                          icon: Icon(Icons.arrow_drop_down,color: Colors.cyan,size: 30,),
                          onChanged: changeSelectedCategory,
                          value: _currentCategory,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Color(0xff2f2f2f),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'BRAND: ',
                            style: TextStyle(color: Colors.cyan, fontSize: 17,fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width*.375,),
                        DropdownButton(
                          style: TextStyle(color: Colors.white, fontSize: 15, backgroundColor: Color(0xff2f2f2f)),
                          items: brandsDropDown,
                          icon: Icon(Icons.arrow_drop_down,color: Colors.cyan,size: 30,),
                          onChanged: changeSelectedBrand,
                          value: _currentBrand,
                        ),
                      ],
                    ),
                  ),
                ),
              ),


              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: productNameController,
                  style: new TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color(0xff2f2f2f),
                    filled: true,
                    labelText: "Product Name",
                    labelStyle: TextStyle(color: Colors.cyan),),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'You must Fill the Field';
                    } else if (value.length > 20) {
                      return 'Product name cant have more than 20 letters';
                    }
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  '20 CHARACTERS MAX',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: red, fontSize: 15),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: descriptionController,
                  style: new TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Product Description",
                    labelStyle: TextStyle(color: Colors.cyan),
                    border: InputBorder.none,
                    fillColor: Color(0xff2f2f2f),
                    filled: true,
                    ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'You must Fill the Field';
                    } else if (value.length > 100) {
                      return 'Product name cant have more than 100 letters';
                    }
                  },
                ),
              ),

//              Padding(
//                padding: const EdgeInsets.all(12.0),
//                child: TextFormField(
//                  controller: quantityTabletPerStripController,
//                  keyboardType: TextInputType.number,
//                  decoration: InputDecoration(
//                    border: InputBorder.none,
//                    fillColor: Color(0xff2f2f2f),
//                    filled: true,
//                    labelText: 'Quantity of Tablets/Strip',
//                    labelStyle: TextStyle(color: Colors.grey[50]),
//                  ),
//                  validator: (value) {
//                    if (value.isEmpty) {
//                      return 'You must Fill the Field';
//                    }
//                  },
//                ),
//              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: quantityUnitsPerPackController,
                  keyboardType: TextInputType.number,
                  style: new TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color(0xff2f2f2f),
                    filled: true,
                    labelText: 'Units/Pack',
                    labelStyle: TextStyle(color: Colors.cyan),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'You must Fill the Field';
                    }
                  },
                ),
              ),

//              Padding(
//                padding: const EdgeInsets.all(12.0),
//                child: TextFormField(
//                  controller: quantityPerPackController,
//                  keyboardType: TextInputType.number,
//                  style: new TextStyle(color: Colors.white),
//                  decoration: InputDecoration(
//                    border: InputBorder.none,
//                    fillColor: Color(0xff2f2f2f),
//                    filled: true,
//                    labelText: "Quantity of Packs",
//                    labelStyle: TextStyle(color: Colors.grey[50]),),
//                  validator: (value) {
//                    if (value.isEmpty) {
//                      return 'You must Fill the Field';
//                    }
//                  },
//                ),
//              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: pricePerTabletController,
                  keyboardType: TextInputType.number,
                  style: new TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    fillColor: Color(0xff2f2f2f),
                    filled: true,
                    labelText: "Unit Price",
                    labelStyle: TextStyle(color: Colors.cyan),),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'You must Fill the Field';
                    }
                  },
                ),
              ),

              SizedBox(
                width: 300,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30))
                ),
                color: Color(0xff008db9),
                textColor: white,
                child: Text('ADD PRODUCT'),
                onPressed: () {
                  validateAndUpload();
                },
              )
              )
            ],
          ),
        ),
      ),
    );
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    print(data.length);
    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropdown();
      _currentCategory = categories[0].data['category'];
    });
  }

  _getBrands() async {
    List<DocumentSnapshot> data = await _brandService.getBrands();
    print(data.length);
    setState(() {
      brands = data;
      brandsDropDown = getBrandsDropDown();
      _currentBrand = brands[0].data['brand'];
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() => _currentCategory = selectedCategory);
  }

  changeSelectedBrand(String selectedBrand) {
    setState(() => _currentBrand = selectedBrand);
  }

//  void changeSelectedSize(String size) {
//    if (selectedSizes.contains(size)) {
//      setState(() {
//        selectedSizes.remove(size);
//      });
//    } else {
//      setState(() {
//        selectedSizes.insert(0, size);
//      });
//    }
//  }

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
          color: grey,
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
    if (_formKey.currentState.validate()) {
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

            productService.uploadProduct({
              "name":productNameController.text,
              "description":descriptionController.text,
              "unit_price":double.parse(pricePerTabletController.text),
//              "picture":imageUrl1,
//              "quantity_tablets_per_strip":int.parse(quantityTabletPerStripController.text),
              "quantity_units_per_pack":int.parse(quantityUnitsPerPackController.text),
//              "quantity_of_packs":int.parse(quantityPerPackController.text),
              "brand":_currentBrand,
              "category":_currentCategory,
//              'sale':onSale,
              'featured':featured,
              'prescription_required': prescription_required,
              "searchKey": setSearchParam(productNameController.text),
            });
            _formKey.currentState.reset();
            setState(() => isLoading = false);
            Navigator.pop(context);
//          });
//      } else {
//        setState(() => isLoading = false);
//      }
    }
  }
  setSearchParam(String caseNumber) {
    List<String> caseSearchList = List();
//    String caseSearchList = '';
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      i = (caseNumber.length)+1;
//      caseSearchList.add(temp);
    }
    return temp;
  }
}
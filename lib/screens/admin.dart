import 'package:Medsway.pk_Admin/screens/slider_list.dart';
import 'package:Medsway.pk_Admin/screens/slider_picker.dart';
import 'package:Medsway.pk_Admin/screens/sold_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Medsway.pk_Admin/providers/user_provider.dart';
import 'package:Medsway.pk_Admin/screens/add_products.dart';
import 'package:Medsway.pk_Admin/screens/product_list.dart';
import 'package:Medsway.pk_Admin/screens/users_list.dart';
import 'package:provider/provider.dart';
import '../db/category.dart';
import '../db/brand.dart';
import 'brand_list.dart';
import 'categories_list.dart';
import 'orders_list.dart';

enum Page { dashboard, manage }

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  MaterialColor active = Colors.blue;
  MaterialColor notActive = Colors.grey;
  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  GlobalKey<FormState> _brandFormKey = GlobalKey();
  BrandService _brandService = BrandService();
  CategoryService _categoryService = CategoryService();

  bool _icon;
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        backgroundColor: Color(0xff252525),
        elevation: 7.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))
        ),
        title: new Text('Are you sure?',style: TextStyle(color: Colors.white)),
        content: new Text('Do you want to exit an App',style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          FlatButton(
              color: Color(0xff008db9),
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              onPressed: (){
            Navigator.of(context).pop(true);
          }, child: Text('YES')),
          FlatButton(onPressed: (){
            Navigator.of(context).pop(false);
          }, child: Text('No'),
              textColor: Colors.white),
        ],
      ),
    ) ??
        false;
  }
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<UserProvider>(context);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: DefaultTabController(
        length: 2,
          child: Scaffold(
          backgroundColor: Color(0xff252525),
            appBar: AppBar(
              centerTitle: true,
             title: Image.asset('icons/AdminBar.png', height: 35),
              bottom: TabBar(
              isScrollable: false,
              indicatorColor: Color(0xff008db9),
              indicatorWeight: 2.0,
              onTap: (index){
                setState(() {
                  switch (index){
                    case 0:
                      _icon = true;
                      break;
                    case 1:
                     _icon = false;
                      break;
                    default:
                  }
                });

              },
              tabs: <Tab>[
                Tab(
                child: Container(
                    child: FlatButton.icon(
                        icon: Icon(
                          Icons.dashboard,
                          color: _icon == true
                              ? active
                              : notActive,
                        ),
                        label: Text('Dashboard',
                            style: TextStyle(color: Colors.white, fontSize: 18.0))))),
                Tab(
                    child: Container(
                       child: FlatButton.icon(
                        icon: Icon(
                          Icons.sort,
                          color:
                          _icon == false ? active : notActive,
                        ),
                        label: Text('Manage',
                            style: TextStyle(color: Colors.white, fontSize: 18.0))))),

              ],
              ),
            elevation: 3.0,
            backgroundColor: Color(0xff2f2f2f),
          ),
              body: new TabBarView(

              children: <Widget>[
                _dashboard(),
                _manage(),
              ]
          ),
            bottomNavigationBar: new Container(
              color: Color(0xff2f2f2f),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      users.signOut();
                    },
                    child: Container(
                      height: 40.0,
                      width: 300.0,
                      decoration: BoxDecoration(
                          color: Color(0xff008db9),
                          borderRadius: BorderRadius.all(Radius.circular(40.0))),
                      child: Center(
                        child: Text(
                          "LogOut",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16.5,
                              letterSpacing: 1.0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0,)
              ],
            ),
          ),
      )
      ),
    );
  }

  Widget _dashboard(){
    return Column(
      children: <Widget>[
        Divider(),
        Expanded(
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: ListTile(
                    title: FlatButton(
                      onPressed: (){
//                                child: Image.asset('icons/users_pressed.png');
                        Navigator.push(context, MaterialPageRoute(builder: (_) => UsersListPage()));
                      },
                      child: Image.asset('icons/users.png'),
//                              icon: ImageIcon(
//                                AssetImage('icons/users.png'), size: 115,),
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: ListTile(
                  title: FlatButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ProductListPage()));
                    },
                    child: Image.asset('icons/products.png'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: ListTile(
                  title: FlatButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => CategoriesListPage()));
                    },
                    child: Image.asset('icons/categories.png'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: ListTile(
                  title: FlatButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => BrandListPage()));
                    },
                    child: Image.asset('icons/brands.png'),),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: ListTile(
                  title: FlatButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => OrderListPage()));
                    },
                    child: Image.asset('icons/orders.png'),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: ListTile(
                  title: FlatButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => SoldListPage()));
                    },
                    child: Image.asset('icons/sold.png'),),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _manage(){
    return ListView(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.add, color: Color(0xff008db9)),
          title: Text('Add product',
            style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.bold),

          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => AddProduct()));
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.add,  color: Color(0xff008db9)),
          title: Text('Add Category',
            style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.bold),

          ),
          onTap: () {
            _categoryAlert();
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.add,  color: Color(0xff008db9)),
          title: Text('Add Brand',
            style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.bold),

          ),
          onTap: () {
            _brandAlert();
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.add, color: Color(0xff008db9)),
          title: Text('Add Slider',
            style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.bold),

          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => SliderPicker()));
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.arrow_forward_ios, color: Color(0xff008db9)),
          title: Text('Sliders List',
            style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.bold),

          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => SliderList()));
          },
        ),
        Divider(),
      ],
    );
  }

  void _categoryAlert() {
    var alert = new AlertDialog(
      backgroundColor: Color(0xff252525),
      elevation: 7.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))
      ),

      content: Form(
        key: _categoryFormKey,
        child: TextFormField(
          style: new TextStyle(color: Colors.white),
          controller: categoryController,
          validator: (value){
            if(value.isEmpty){
              return 'Field cannot be empty';
            }
          },
          decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xff2f2f2f),
                filled: true,
              labelText: "Add Category",
              labelStyle: TextStyle(color: Colors.grey[50]),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
            color: Color(0xff008db9),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
            ),

            onPressed: (){
              if(_categoryFormKey.currentState.validate()){
                Fluttertoast.showToast(msg: 'Category Created');
                Navigator.pop(context);
                _categoryService.createCategory(categoryController.text);
                categoryController.clear();
              }
            }, child: Text('ADD')),
        FlatButton(
            textColor: Colors.white,
            onPressed: (){
          Navigator.pop(context);
        }, child: Text('CANCEL',)),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  void _brandAlert() {
    var alert = new AlertDialog(
      backgroundColor: Color(0xff252525),
      elevation: 7.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))
      ),
      content: Form(
        key: _brandFormKey,
        child: TextFormField(
          controller: brandController,
          validator: (value){
            if(value.isEmpty){
              return 'Field cannot be empty';
            }
          },
          style: new TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Color(0xff2f2f2f),
            filled: true,
            labelText: "Add Brand",
            labelStyle: TextStyle(color: Colors.grey[50]),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
            color: Color(0xff008db9),
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            onPressed: (){
              if(_brandFormKey.currentState.validate()){
                Fluttertoast.showToast(msg: 'Brand added');
                Navigator.pop(context);
                _brandService.createBrand(brandController.text);
                brandController.clear();
              }

            }, child: Text('ADD')),
        FlatButton(
            textColor: Colors.white,
            onPressed: (){
          Navigator.pop(context);
        }, child: Text('CANCEL')),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }
}

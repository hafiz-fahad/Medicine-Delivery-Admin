import 'package:al_asr_admin/providers/zone_area_provider.dart';
import 'package:al_asr_admin/screens/create_admin_screen.dart';
import 'package:al_asr_admin/screens/search_bar.dart';
import 'package:al_asr_admin/screens/slider_list.dart';
import 'package:al_asr_admin/screens/slider_picker.dart';
import 'package:al_asr_admin/screens/sold_list.dart';
import 'package:al_asr_admin/screens/zone_list.dart';
import 'package:al_asr_admin/widgets/loading.dart';
import 'package:awesome_loader/awesome_loader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:al_asr_admin/providers/user_provider.dart';
import 'package:al_asr_admin/providers/products_provider.dart';
import 'package:al_asr_admin/screens/add_products.dart';
import 'package:al_asr_admin/screens/product_list.dart';
import 'package:al_asr_admin/screens/users_list.dart';
import 'package:provider/provider.dart';
import '../db/category.dart';
import '../db/brand.dart';
import 'categories_list.dart';
import 'login.dart';
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
  TextEditingController zoneAreaNameController = TextEditingController();
  TextEditingController zoneAreaValueController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  GlobalKey<FormState> _zoneFormKey = GlobalKey();
  BrandService _brandService = BrandService();
  CategoryService _categoryService = CategoryService();
  ZoneAreaService zoneAreaService = ZoneAreaService();

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

  Future<List<Note>> productsList() async {
    String url = 'https://globaltodobackend.herokuapp.com/api/v1/medicine';
    Dio dio = new Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['accept'] = 'application/json';

    Response productListResponse = await dio.get(url);
    print("Status Code =  ${productListResponse.statusCode.toString()}");
    if (productListResponse.statusCode == 200) {
      setState(() {
        productsGetList = productListResponse.data;
        for(var noteJson in productsGetList){
          productList.add(Note.fromJson(noteJson));
        }
      });
      print("Product List Length = ${productsGetList.length}");
      print("${productsGetList[4].toString()}");

    }
    if(productListResponse.statusCode != 200){
      print("Status Code =  ${productListResponse.statusCode.toString()}");
    }
    return productList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    productsList();
  }
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<UserProvider>(context);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: DefaultTabController(
        length: 2,
          child: productsGetList == null
              ?Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Color(0xff252525),
            child: Center(
              child: AwesomeLoader(
                loaderType: AwesomeLoader.AwesomeLoader2,
                color: Color(0xff008db9),
              ),
            ),
          )

              :Scaffold(
          backgroundColor: Color(0xff252525),
            appBar: AppBar(
//              centerTitle: true,
             title: Image.asset('icons/AdminBar.png', height: 35),
              bottom: emailCheck == 'employee@alasr.com'
                  ?null
                  :TabBar(
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
              body: emailCheck == 'employee@alasr.com'
                  ?_dashboard()
                  :new TabBarView(

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

                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => Login()));

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
                      Navigator.push(context, MaterialPageRoute(builder: (_) => ZoneList()));
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
    final users = Provider.of<UserProvider>(context);

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
          title: Text('Add ZoneArea',
            style: TextStyle(color: Colors.white,
                fontWeight: FontWeight.bold),

          ),
          onTap: () {
            _zoneAlert();
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
        // ListTile(
        //   leading: Icon(Icons.person_add, color: Color(0xff008db9)),
        //   title: Text('Create Admin',
        //     style: TextStyle(color: Colors.white,
        //         fontWeight: FontWeight.bold),
        //
        //   ),
        //   onTap: () {
        //     users.signOut();
        //     // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => CreateAdminScreen()));
        //   },
        // ),
        // Divider(),
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
//          keyboardType: TextInputType.,
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

  void _zoneAlert() {
    var alert = new AlertDialog(
      backgroundColor: Color(0xff252525),
      elevation: 7.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))
      ),
      content: Form(
        key: _zoneFormKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: zoneAreaNameController,
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
                  labelText: "Add ZoneArea Name",
                  labelStyle: TextStyle(color: Colors.grey[50]),
                ),
              ),
              Divider(),
              TextFormField(
                controller: zoneAreaValueController,
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
                  labelText: "Add ZoneArea Value",
                  labelStyle: TextStyle(color: Colors.grey[50]),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
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
              if(_zoneFormKey.currentState.validate()){
                Fluttertoast.showToast(msg: 'ZoneArea added');
                Navigator.pop(context);
               zoneAreaService.uploadZoneArea({
                 "zone_name": zoneAreaNameController.text,
                 "zone_value": zoneAreaValueController.text,
               });
                zoneAreaNameController.clear();
                zoneAreaValueController.clear();
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

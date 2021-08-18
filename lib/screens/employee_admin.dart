import 'package:al_asr_admin/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:provider/provider.dart';

import 'orders_list.dart';

class EmployeeAdmin extends StatefulWidget {
  @override
  _EmployeeAdminState createState() => _EmployeeAdminState();
}

class _EmployeeAdminState extends State<EmployeeAdmin> {

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
//              centerTitle: true,
              title: Image.asset('icons/AdminBar.png', height: 35),
              elevation: 3.0,
              backgroundColor: Color(0xff2f2f2f),
            ),
            body: _dashboard(),
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
                        showDialog(
                            context: context,
                            builder: (_) =>
                                NetworkGiffyDialog(
                                  image:
                                  Image.asset(
                                    'icons/baloo.gif',
                                    width: double.infinity,
                                    //  fit: BoxFit.cover,
                                  ),
                                  entryAnimation: EntryAnimation.TOP_LEFT,
                                  title: Text(
                                    'You didn\'t have access to this',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
//                                                              description: Text(
//                                                                'Go For Login Now',
//                                                                textAlign: TextAlign.center,
//                                                              ),
                                  buttonOkColor: Color(0xff008db9),

                                  buttonOkText:
                                  Text('Ok'),
//                                  buttonCancelText:
//                                  Text(
//                                      'SignUp'),
//                                  onCancelButtonPressed:
//                                      () {
//                                    Navigator
//                                        .pushAndRemoveUntil(
//                                      context,
//                                      MaterialPageRoute(
//                                          builder:
//                                              (context) =>
//                                              SignUp()),
//                                          (Route<dynamic>
//                                      route) =>
//                                      false,
//                                    );
//                                  },
                                  onOkButtonPressed:
                                      () {
                                    Navigator.pop(context);
                                  },
                                ));
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
                      showDialog(
                          context: context,
                          builder: (_) =>
                              NetworkGiffyDialog(
                                image:
                                Image.asset(
                                  'icons/baloo.gif',
                                  width: double.infinity,
                                  //  fit: BoxFit.cover,
                                ),
                                entryAnimation: EntryAnimation.TOP_LEFT,
                                title: Text(
                                  'You didn\'t have access to this',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
//                                                              description: Text(
//                                                                'Go For Login Now',
//                                                                textAlign: TextAlign.center,
//                                                              ),
                                buttonOkColor: Color(0xff008db9),

                                buttonOkText:
                                Text('Ok'),
//                                  buttonCancelText:
//                                  Text(
//                                      'SignUp'),
//                                  onCancelButtonPressed:
//                                      () {
//                                    Navigator
//                                        .pushAndRemoveUntil(
//                                      context,
//                                      MaterialPageRoute(
//                                          builder:
//                                              (context) =>
//                                              SignUp()),
//                                          (Route<dynamic>
//                                      route) =>
//                                      false,
//                                    );
//                                  },
                                onOkButtonPressed:
                                    () {
                                  Navigator.pop(context);
                                },
                              ));
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
                      showDialog(
                          context: context,
                          builder: (_) =>
                              NetworkGiffyDialog(
                                image:
                                Image.asset(
                                  'icons/baloo.gif',
                                  width: double.infinity,
                                  //  fit: BoxFit.cover,
                                ),
                                entryAnimation: EntryAnimation.TOP_LEFT,
                                title: Text(
                                  'You didn\'t have access to this',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
//                                                              description: Text(
//                                                                'Go For Login Now',
//                                                                textAlign: TextAlign.center,
//                                                              ),
                                buttonOkColor: Color(0xff008db9),

                                buttonOkText:
                                Text('Ok'),
//                                  buttonCancelText:
//                                  Text(
//                                      'SignUp'),
//                                  onCancelButtonPressed:
//                                      () {
//                                    Navigator
//                                        .pushAndRemoveUntil(
//                                      context,
//                                      MaterialPageRoute(
//                                          builder:
//                                              (context) =>
//                                              SignUp()),
//                                          (Route<dynamic>
//                                      route) =>
//                                      false,
//                                    );
//                                  },
                                onOkButtonPressed:
                                    () {
                                  Navigator.pop(context);
                                },
                              ));
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
                      showDialog(
                          context: context,
                          builder: (_) =>
                              NetworkGiffyDialog(
                                image:
                                Image.asset(
                                  'icons/baloo.gif',
                                  width: double.infinity,
                                  //  fit: BoxFit.cover,
                                ),
                                entryAnimation: EntryAnimation.TOP_LEFT,
                                title: Text(
                                  'You didn\'t have access to this',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
//                                                              description: Text(
//                                                                'Go For Login Now',
//                                                                textAlign: TextAlign.center,
//                                                              ),
                                buttonOkColor: Color(0xff008db9),

                                buttonOkText:
                                Text('Ok'),
//                                  buttonCancelText:
//                                  Text(
//                                      'SignUp'),
//                                  onCancelButtonPressed:
//                                      () {
//                                    Navigator
//                                        .pushAndRemoveUntil(
//                                      context,
//                                      MaterialPageRoute(
//                                          builder:
//                                              (context) =>
//                                              SignUp()),
//                                          (Route<dynamic>
//                                      route) =>
//                                      false,
//                                    );
//                                  },
                                onOkButtonPressed:
                                    () {
                                  Navigator.pop(context);
                                },
                              ));
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
                      showDialog(
                          context: context,
                          builder: (_) =>
                              NetworkGiffyDialog(
                                image:
                                Image.asset(
                                  'icons/baloo.gif',
                                  width: double.infinity,
                                  //  fit: BoxFit.cover,
                                ),
                                entryAnimation: EntryAnimation.TOP_LEFT,
                                title: Text(
                                  'You didn\'t have access to this',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
//                                                              description: Text(
//                                                                'Go For Login Now',
//                                                                textAlign: TextAlign.center,
//                                                              ),
                                buttonOkColor: Color(0xff008db9),

                                buttonOkText:
                                Text('Ok'),
//                                  buttonCancelText:
//                                  Text(
//                                      'SignUp'),
//                                  onCancelButtonPressed:
//                                      () {
//                                    Navigator
//                                        .pushAndRemoveUntil(
//                                      context,
//                                      MaterialPageRoute(
//                                          builder:
//                                              (context) =>
//                                              SignUp()),
//                                          (Route<dynamic>
//                                      route) =>
//                                      false,
//                                    );
//                                  },
                                onOkButtonPressed:
                                    () {
                                  Navigator.pop(context);
                                },
                              ));
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

}

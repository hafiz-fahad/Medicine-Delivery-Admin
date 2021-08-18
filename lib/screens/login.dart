import 'package:al_asr_admin/providers/app_states.dart';
import 'package:al_asr_admin/screens/create_admin_screen.dart';
import 'package:al_asr_admin/screens/employee_admin.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:al_asr_admin/widgets/loading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'admin.dart';
import 'package:al_asr_admin/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _createAdminAccessController = TextEditingController();


  bool invisible = true;

  void inContact(TapDownDetails details) {
    setState(() {
      invisible = false;
    });
  }

  void outContact(TapUpDetails details) {
    setState(() {
      invisible=true;
    });
  }

  void changeScreenReplacement(BuildContext context, Widget widget){

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget));
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: Color(0xff252525),
      key: _key,
      body:user.status == Status.Authenticating ? Loading() : Stack(
        children: <Widget>[
          Container(
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Container(
//                decoration: BoxDecoration(
////                  color: Colors.white,
//                  borderRadius: BorderRadius.circular(16),
//                  boxShadow: [
//                    BoxShadow(
//                      color: Colors.grey[350],
//                      blurRadius:
//                      20.0, // has the effect of softening the shadow
//                    )
//                  ],
//                ),
                child: Form(
                    key: _formKey,
                    child: ListView(
                      children: <Widget>[
                        SizedBox(height:40),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                          child: Container(
                              alignment: Alignment.topCenter,
                              child: Image.asset(
                                'icons/admin.png',
                                width: 250.0,
                              )),
                        ),

                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey.withOpacity(0.2),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: ListTile(
                                title: TextFormField(
                                  controller: _email,
                                  keyboardType: TextInputType.emailAddress,

                                  style: new TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Colors.grey[50]),
                                    hintText: "Email",
                                    icon: Icon(Icons.alternate_email,color: Colors.blue,),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      Pattern pattern =
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                      RegExp regex = new RegExp(pattern);
                                      if (!regex.hasMatch(value))
                                        return 'Please make sure your email address is valid';
                                      else
                                        return null;
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey.withOpacity(0.2),
                            elevation: 0.0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: ListTile(
                                title: TextFormField(
                                  controller: _password,
                                  obscureText: invisible,
                                  style: new TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Colors.grey[50]),
                                    hintText: "Password",
                                    icon: Icon(Icons.lock_outline,color: Colors.blue,),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "The password field cannot be empty";
                                    } else if (value.length < 6) {
                                      return "the password has to be at least 6 characters long";
                                    }
                                    return null;
                                  },
                                ),
                                trailing: InkWell(
                                  onTap: (){
                                    setState(() {
                                      invisible = !invisible;
                                    });
                                  },
                                  child: Icon(
                                    invisible
                                        ?Icons.visibility
                                        :Icons.visibility_off,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                          child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Color(0xff008db9),
                              elevation: 0.0,
                              child: MaterialButton(
//                                color: Colors.indigoAccent,
                                onPressed: () async{
                                  // user.signOut();
                                  setState(() {
                                    emailCheck = _email.text;
                                  });
                                  if(_formKey.currentState.validate()){
                                    if(_email.text != 'admin@alasr.com' &&
                                        _email.text != 'employee@alasr.com'&&
                                        !_email.toString().contains('@admin')
                                    )
                                      _key.currentState.showSnackBar(SnackBar(content: Text("Invalid Email")));
                                    if(
                                    _email.text == 'admin@alasr.com' ||
                                    _email.text == 'employee@alasr.com' ||
                                    _email.toString().contains('@admin')
                                    ){
                                      if(!await user.signIn(_email.text, _password.text)) {
                                          _key.currentState.showSnackBar(SnackBar(content: Text("Sign in failed")));
                                        }else{
                                        changeScreenReplacement(context, Admin());
                                      }

                                      // switch(box.read('session').toString()){
                                      //   case 'inActive':
                                      //     return Login();
                                      //   case 'AdminActive':
                                      //     return Admin();
                                      //   case 'EmployeeActive':
                                      //     return EmployeeAdmin();
                                      //   default: return Login();
                                      // }
                                      // switch(user.status){
                                      //   case Status.AuthenticatedAdmin:
                                      //     return Admin();
                                      //   case Status.AuthenticatedEmployee:
                                      //     return EmployeeAdmin();
                                      //   default: return Login();
                                      // }
                                    }
                                  }
                                  else{
                                    return Login();
                                  }
                                },
                                minWidth: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Login",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                              )),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height*.01,
                        ),
                        AutoSizeText('OR',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12,color: Colors.white),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height*.01,
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(14.0, 8.0, 14.0, 8.0),
                          child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Color(0xff008db9),
                              elevation: 0.0,
                              child: MaterialButton(
//                                color: Colors.indigoAccent,
                                onPressed: () async{

                                  _createAdminAccessDialogue();

                                },
                                minWidth: MediaQuery.of(context).size.width,
                                child: Text(
                                  "Create Admin",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0),
                                ),
                              )
                          ),
                        ),
                      ],
                    )),

              ),
            ),
          ),
        ],
      ),
    );
  }
  void _createAdminAccessDialogue() {
    var alert = new AlertDialog(
      backgroundColor: Color(0xff252525),
      elevation: 7.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))
      ),

      content: Form(
        key: _formKey2,
        child: TextFormField(
          style: new TextStyle(color: Colors.white),
          controller: _createAdminAccessController,
          validator: (value){
            if(value.isEmpty){
              return 'Field cannot be empty';
            }else return null;
          },
//          keyboardType: TextInputType.,
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Color(0xff2f2f2f),
            filled: true,
            labelText: "Enter access key",
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
              if(_formKey2.currentState.validate()){
                if(_createAdminAccessController.text == "Alasrcheck123"){
                  Fluttertoast.showToast(msg: 'Access Granted');
                  Navigator.pop(context);
                  changeScreenReplacement(context, CreateAdminScreen());
                  _createAdminAccessController.clear();
                }else{
                  Fluttertoast.showToast(msg: 'Wrong key');

                }

              }
            }, child: Text('Go')),
        FlatButton(
            textColor: Colors.white,
            onPressed: (){
              Navigator.pop(context);
            }, child: Text('CANCEL',)),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

}
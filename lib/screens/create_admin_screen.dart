import 'package:al_asr_admin/providers/user_provider.dart';
import 'package:al_asr_admin/screens/admin.dart';
import 'package:al_asr_admin/screens/employee_admin.dart';
import 'package:al_asr_admin/widgets/loading.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login.dart';

class CreateAdminScreen extends StatefulWidget {
  @override
  _CreateAdminScreenState createState() => _CreateAdminScreenState();
}

class _CreateAdminScreenState extends State<CreateAdminScreen> {

  void changeScreenReplacement(BuildContext context, Widget widget){

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => widget));
  }

  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();

  bool invisible = true;
  bool invisibleConfirm = true;



  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Scaffold(
      key: _key,

      backgroundColor: Color(0xff252525),
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
                                width: 150.0,
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
                                    else return null;
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
                                    child: Icon(invisible
                                        ?Icons.visibility
                                        :Icons.visibility_off,
                                      color: Colors.blue,
                                    )
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
                                  controller: _confirmPassword,
                                  obscureText: invisibleConfirm,
                                  style: new TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: Colors.grey[50]),
                                    hintText: "Confirm Password",
                                    icon: Icon(Icons.lock_outline,color: Colors.blue,),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "The password field cannot be empty";
                                    } else if(_password.text != _confirmPassword.text){
                                      return "Password not match";
                                    }
                                    return null;
                                  },
                                ),
                                trailing: InkWell(
                                  onTap: (){
                                    setState(() {
                                      invisibleConfirm = !invisibleConfirm;
                                    });
                                  },
                                    child: Icon(invisibleConfirm
                                        ?Icons.visibility
                                        :Icons.visibility_off,
                                      color: Colors.blue,
                                    )
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
                                  if(_formKey.currentState.validate() && _email.toString().contains('@admin')){
                                    if(!await user.signUp(_email.text, _password.text,))
                                    {
                                      _key.currentState.showSnackBar(SnackBar(content: Text("Sign up failed")));
                                      return null;
                                    }{
                                      print("yesyesyes");
                                      changeScreenReplacement(context, Admin());
                                    }

                                  }else{
                                    _key.currentState.showSnackBar(SnackBar(content: Text("Email should contain \"admin\" domain")));

                                    print("nonononononononon");
                                  }
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
                    )
                ),
              ),
            ),
          ),
        ],
      ),
    );  }
}

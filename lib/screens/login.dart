import 'package:flutter/material.dart';
import 'package:Medsway.pk_Admin/widgets/loading.dart';
import 'admin.dart';
import 'package:Medsway.pk_Admin/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

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
                                trailing: GestureDetector(
                                  onTapDown: inContact,//call this method when incontact
                                  onTapUp: outContact,//call this method when contact with screen is removed
                                  child: Icon(
                                    Icons.remove_red_eye,
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
                                  if(_formKey.currentState.validate()){
                                    if(_email.text != 'admin@admin.com')
                                      _key.currentState.showSnackBar(SnackBar(content: Text("Invalid Email")));
                                    if(_email.text == 'admin@admin.com'){
                                      if(!await user.signIn(_email.text, _password.text))
                                        _key.currentState.showSnackBar(SnackBar(content: Text("Sign in failed")));
                                      switch(user.status){
                                        case Status.Authenticated:
                                          return Admin();
                                        default: return Login();
                                      }
//                                    if(!await user.signIn(_email.text, _password.text))
//                                      _key.currentState.showSnackBar(SnackBar(content: Text("Sign in failed")));
//                                    switch(user.status){
//                                      case Status.Authenticated:
//                                        return Admin();
//                                      default: return Login();
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
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                          children: <Widget>[
//                            Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: Text(
//                                "Forgot password",
//                                textAlign: TextAlign.center,
//                                style: TextStyle(
//                                  color: Colors.blue,
//                                  fontWeight: FontWeight.w400,
//                                ),
//                              ),
//                            ),
////                            Padding(
////                                padding: const EdgeInsets.all(8.0),
////                                child: InkWell(
////                                    onTap: () {
//////                                      Navigator.push(
//////                                          context,
//////                                          MaterialPageRoute(
//////                                              builder: (context) => SignUp()));
////                                    },
////                                    child: Text(
////                                      "Create an account",
////                                      textAlign: TextAlign.center,
////                                      style: TextStyle(color: Colors.blue),
////                                    ))),
//                          ],
//                        ),

//                        Padding(
//                          padding: const EdgeInsets.all(16.0),
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: <Widget>[
//
//                              Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: Text("or sign in with", style: TextStyle(fontSize: 18,color: Colors.grey),),
//                              ),
//                              Padding(
//                                padding: const EdgeInsets.all(8.0),
//                                child: MaterialButton(
//                                    onPressed: () {},
//                                    child: Image.asset("images/ggg.png", width: 30,)
//                                ),
//                              ),
//
//                            ],
//                          ),
//                        ),

                      ],
                    )),

              ),
            ),
          ),
        ],
      ),
    );
  }

}
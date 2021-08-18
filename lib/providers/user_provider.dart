import 'dart:async';
import 'package:al_asr_admin/providers/app_states.dart';
import 'package:al_asr_admin/screens/add_products.dart';
import 'package:al_asr_admin/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum Status{Uninitialized, AuthenticatedAdmin, Authenticating, Unauthenticated,AuthenticatedEmployee}

class UserProvider with ChangeNotifier{
  FirebaseAuth _auth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;
  Status get status => _status;
  FirebaseUser get user => _user;
  Firestore _firestore = Firestore.instance;

  UserProvider.initialize(): _auth = FirebaseAuth.instance{
    _auth.onAuthStateChanged.listen(_onStateChanged);
  }

  Future<bool> signIn(String email, String password)async{
      try{
        _status = Status.Authenticating;
        notifyListeners();
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        return true;
      }catch(e){
        _status = Status.Unauthenticated;
        notifyListeners();
        print(e.toString());
        return false;
      }
  }

  Future<bool> signUp(
      String email,
      String password,
     )async{
    try{
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      //     .then((user){
      //   _firestore.collection('adminUser').document(user.uid).setData({
      //     'email':email,
      //     'uid':user.uid,
      //   });
      // });
      return true;
    }catch(e){
      _status = Status.Unauthenticated;
      notifyListeners();
      print(e.toString());
      return false;
    }
  }

  Future signOut()async{
    _auth.signOut();
    box.write("session","inActive");
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onStateChanged(FirebaseUser user) async{
    if(user == null){
      _status = Status.Unauthenticated;
    }else{
      _user = user;
      if(user.email == 'admin@alasr.com' || user.email.contains('@admin')){
        box.write("session","AdminActive");
        _status = Status.AuthenticatedAdmin;
        print("STATUSSSSSSSS   ${_status.toString()}");
        print("EMAILLLLLLLLL   ${user.email.toString()}");
      }

      if(user.email == 'employee@alasr.com'){
        box.write("session","EmployeeActive");
        _status = Status.AuthenticatedEmployee;
        print("STATUSSSSSSSS   ${_status.toString()}");
        print("EMAILLLLLLLLL   ${user.email.toString()}");
      }
    }
    notifyListeners();
  }
}
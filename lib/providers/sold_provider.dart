import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class SoldService {
  Firestore _firestore = Firestore.instance;
  String ref = 'sold';
  String ref1 = 'soldWithPrescription';


  void soldProduct(Map<String, dynamic> data) {
    var id = Uuid();
    String soldId = id.v1();
    data["id"] = soldId;
    _firestore.collection(ref).document(soldId).setData(data);
  }

  void soldPresProduct(Map<String, dynamic> data) {
    var id = Uuid();
    String soldId = id.v1();
    data["id"] = soldId;
    _firestore.collection(ref1).document(soldId).setData(data);
  }
}
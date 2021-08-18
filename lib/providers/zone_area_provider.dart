import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ZoneAreaService {
  Firestore _firestore = Firestore.instance;
  String ref = 'zone_area';

  void uploadZoneArea(Map<String, dynamic> data) {
    var id = Uuid();
    String sliderID = id.v1();
    data["id"] = sliderID;
    _firestore.collection(ref).document(sliderID).setData(data);
  }
}
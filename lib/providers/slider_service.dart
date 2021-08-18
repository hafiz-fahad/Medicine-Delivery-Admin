import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class SliderService {
  Firestore _firestore = Firestore.instance;
  String ref = 'slider';

  void uploadSlider(Map<String, dynamic> data) {
    var id = Uuid();
    String sliderID = id.v1();
    data["id"] = sliderID;
    _firestore.collection(ref).document(sliderID).setData(data);
  }
}

import 'models.dart';

class Address extends Model{
  static const String TITLE_KEY = "title";
  static const String ADDRESS_LINE_1_KEY= "address_line_1";
  static const String ADDRESS_LINE_2_KEY = "address_line_2";
  static const String CITY_KEY = "city";
  static const String DISTRICT_KEY = "district";
  static const String STATE_KEY = "state";
  static const String LANDMARK_KEY = "landmark";
  static const String PINCODE_KEY = "pincode";
  static const String RECEIVER_KEY = "receiver";
  static const String PHONE_KEY = "phone";

  String title;
  String receiver;
  String addressLine1;
  String addressLine2;
  String city;
  String district;
  String state;
  String landmark;
  String pincode;
  String phone;

  Address({
    required String id,
    required this.title,
    required this.receiver,
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.district,
    required this.state,
    required this.landmark,
    required this.pincode,
    required this.phone,
}): super(id);

  factory Address.fromMap(Map<String,dynamic> map, {required String id}){
    return Address(id: id,
        title: map[TITLE_KEY],
        receiver: map[RECEIVER_KEY],
        addressLine1: map[ADDRESS_LINE_1_KEY],
        addressLine2: map[ADDRESS_LINE_2_KEY],
        city: map[CITY_KEY],
        district: map[DISTRICT_KEY],
        state: map[STATE_KEY],
        landmark: map[LANDMARK_KEY],
        pincode: map[PINCODE_KEY],
        phone: map[PHONE_KEY],
    );
  }

  @override
  Map<String, dynamic> toMap(){
    final map = <String, dynamic>{
      TITLE_KEY: title,
      RECEIVER_KEY: receiver,
      ADDRESS_LINE_1_KEY: addressLine1,
      ADDRESS_LINE_2_KEY: addressLine2,
      CITY_KEY: city,
      DISTRICT_KEY: district,
      STATE_KEY: state,
      LANDMARK_KEY: landmark,
      PINCODE_KEY: pincode,
      PHONE_KEY: phone,
    };
    return map;
  }
  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (title != null) map[TITLE_KEY] = title;
    if (receiver != null) map[RECEIVER_KEY] = receiver;
    if (addressLine1 != null) map[ADDRESS_LINE_1_KEY] = addressLine1;
    if (addressLine2 != null) map[ADDRESS_LINE_2_KEY] = addressLine2;
    if (city != null) map[CITY_KEY] = city;
    if (district != null) map[DISTRICT_KEY] = district;
    if (state != null) map[STATE_KEY] = state;
    if (landmark != null) map[LANDMARK_KEY] = landmark;
    if (pincode != null) map[PINCODE_KEY] = pincode;
    if (phone != null) map[PHONE_KEY] = phone;
    return map;
  }
}
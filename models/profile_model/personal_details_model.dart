class PersonalDetailsModel {
  final String name;
  final String gmail;
  final String dob;
  final String imgurl;
  final String mobileno;
  final String wtappNo;
  final String gender;
  final String addressDoorno;
  final String addressStreet;
  final String addressCity;
  final String addressState;
  final String addressPincode;

  PersonalDetailsModel({
    required this.name,
    required this.gmail,
    required this.dob,
    required this.imgurl,
    required this.mobileno,
    required this.wtappNo,
    required this.gender,
    required this.addressDoorno,
    required this.addressStreet,
    required this.addressCity,
    required this.addressState,
    required this.addressPincode,
  });

  factory PersonalDetailsModel.fromJson(Map<String, dynamic> json) {
    return PersonalDetailsModel(
      name: json['name'],
      gmail: json['gmail'],
      dob: json['dob'],
      imgurl: json['imgurl'],
      mobileno: json['mobileno'],
      wtappNo: json['wtappNo'],
      gender: json['gender'],
      addressDoorno: json['addressDoorno'],
      addressStreet: json['addressStreet'],
      addressCity: json['addressCity'],
      addressState: json['addressState'],
      addressPincode: json['addressPincode'],
    );
  }
}
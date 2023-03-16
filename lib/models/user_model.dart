class UserModel {
  String? uId;
  String? name;
  String? phone;
  String? photo;

  UserModel({
    this.name,
    this.phone,
    this.photo,
    this.uId,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    name = json['name'];
    phone = json['phone'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'name': name,
      'phone': phone,
      'photo': photo,
    };
  }
}

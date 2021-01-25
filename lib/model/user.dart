class User {
  String id;
  String name;
  String email;
  String sex;
  String about;
  String url;

  User({this.id, this.name, this.email, this.sex, this.about, this.url});

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    sex = json['sex'];
    about = json['about'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['sex'] = this.sex;
    data['about'] = this.about;
    data['url'] = this.url;
    return data;
  }
}

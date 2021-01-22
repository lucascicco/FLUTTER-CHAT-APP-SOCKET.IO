import '../core/constant.dart';
import '../helper/preferences_helper.dart';
import '../model/message.dart';
import '../model/user.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ServiceManager {
  static final shared = ServiceManager();
  final header = {"Content-Type": "application/json"};

  // Save to locale when user sign up.
  Future<void> _saveUserInfoForLocale() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = await SharedPreferencesHelper.shared.getUserToken();
    var body = json.encode({"token": token});
    var response = await http.post("http://192.168.15.33:3000/user/userinfo",
        headers: header, body: body);
    var data = jsonDecode(response.body);

    await pref.setString('myID', data['_id']);
  }

  void signUp(Map<String, dynamic> userData,
      {void Function(String message) completionHandler}) async {
    var body = json.encode(userData);
    print(Constant.shared.baseURL);
    var response = await http.post("http://192.168.15.33:3000/user/signup",
        headers: header, body: body);
    var data = jsonDecode(response.body);
    var dataMessage = data['message'];

    if (dataMessage is bool) {
      if (dataMessage) {
        completionHandler("Registro criado, faça login.");
      } else {
        completionHandler("O registro do usuário já existe, por favor.");
      }
    } else {
      completionHandler(dataMessage as String);
    }
  }

  void signIn(Map<String, dynamic> userData,
      {void Function(bool status, String message) completionHandler}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var body = json.encode(userData);

    try {
      var response = await http.post("http://192.168.15.33:3000/user/signin",
          headers: header, body: body);
      var jsonBody = jsonDecode(response.body);

      print(jsonBody);

      if (jsonBody['message'] is bool) {
        var status = jsonBody['message'];

        if (status) {
          await pref.setString('token', jsonBody['token']);
          await _saveUserInfoForLocale();
          completionHandler(true, 'Login de usuário');
        } else {
          completionHandler(false, 'Nome de usuário ou senha está incorreta');
        }
      } else {
        completionHandler(false, jsonBody['message']);
      }
    } catch (error) {
      print(error);
    }
  }

  Future<List<User>> fetchShuffleList() async {
    var token = await SharedPreferencesHelper.shared.getUserToken();

    var response =
        await http.get("http://192.168.15.33:3000/user/shuffle", headers: {
      "Content-Type": "application/json",
      "Authorization": 'Bearer $token',
    });

    if (response.statusCode == 200) {
      var list = (json.decode(response.body) as List)
          .map((element) => User.fromJson(element))
          .toList();
      return list;
    } else {
      return List<User>();
    }
  }

  Future<List<Message>> fetchMessageList(String receiverID) async {
    var myID = await SharedPreferencesHelper.shared.getMyID();

    var body = json.encode({"sender": myID, "receiver": receiverID});

    var response = await http.post(
        "http://192.168.15.33:3000/message/fetchmessage",
        headers: header,
        body: body);

    if (response.statusCode == 200) {
      var list = (json.decode(response.body) as List)
          .map((e) => Message.fromJson(e))
          .toList();
      return list;
    } else {
      return List<Message>();
    }
  }
}

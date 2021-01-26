import 'package:path/path.dart';
import '../helper/preferences_helper.dart';
import '../model/message.dart';
import '../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/constant.dart';

class ServiceManager {
  static final shared = ServiceManager();
  final header = {"Content-Type": "application/json"};

  // Save to locale when user sign up.
  Future<void> _saveUserInfoForLocale() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var token = await SharedPreferencesHelper.shared.getUserToken();

    var response =
        await http.get(Constant.shared.baseURL + "/user/userinfo", headers: {
      "Content-Type": "application/json",
      "Authorization": 'Bearer $token',
    });

    var data = jsonDecode(response.body);
    await pref.setString('myID', data['_id']);
  }

  void signUp(Map<String, dynamic> userData,
      {void Function(String message) completionHandler}) async {
    var postUri = Uri.parse(Constant.shared.baseURL + "/user/signup");

    var request = new http.MultipartRequest("POST", postUri);

    var stream =
        new http.ByteStream(Stream.castFrom(userData['file'].openRead()));

    var length = await userData['file'].length();

    request.fields['name'] = userData['name'];
    request.fields['password'] = userData['password'];
    request.fields['email'] = userData['email'];
    request.fields['sex'] = userData['sex'];
    request.fields['about'] = userData['about'];

    request.files.add(new http.MultipartFile('file', stream, length,
        filename: basename(userData['file'].path)));

    http.StreamedResponse response = await request.send();

    var result = await http.Response.fromStream(response);

    var resultDecoded = jsonDecode(result.body);

    if (resultDecoded["message"] is bool) {
      if (resultDecoded["message"]) {
        completionHandler("Registro criado, faça login.");
      } else {
        completionHandler("O registro do usuário já existe, por favor.");
      }
    } else {
      completionHandler(resultDecoded["message"] as String);
    }
  }

  void signIn(Map<String, dynamic> userData,
      {void Function(bool status, String message) completionHandler}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    var body = json.encode(userData);

    try {
      var response = await http.post(Constant.shared.baseURL + "/user/signin",
          headers: header, body: body);

      var jsonBody = jsonDecode(response.body);

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
        await http.get(Constant.shared.baseURL + "/user/shuffle", headers: {
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
        Constant.shared.baseURL + "/message/fetchmessage",
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

import './core/get_it.dart';
import './helper/preferences_helper.dart';
import './views/shuffle/shuffle.dart';
import './views/signin/signin.dart';
import 'package:flutter/material.dart';

void main() {
  XuGetIt.setup();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferencesHelper.shared.userControl(completionHandler: (status) {
    runApp(MaterialApp(
        home: status ? ShuffleView() : SignInView(),
        debugShowCheckedModeBanner: false));
  });
}

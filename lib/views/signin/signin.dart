import '../../component/alert.dart';
import '../../component/textformfield.dart';
import '../../service/service_manager.dart';
import '../../views/shuffle/shuffle.dart';
import '../../views/signup/signup.dart';
import 'package:flutter/material.dart';

class SignInView extends StatelessWidget {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: formValidation(context),
      ),
    );
  }

  Widget formValidation(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(
            height: 35,
          ),
          Image.asset('assets/TalkyAppIcon.png', width: 200, height: 200),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 20, left: 20),
            child: EGTextFormField(
              controller: _email,
              hintText: 'Email',
              labelText: 'Email',
              obscureText: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 20, left: 20),
            child: EGTextFormField(
              controller: _password,
              hintText: 'Senha',
              labelText: 'Senha',
              obscureText: true,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton(
                  color: Colors.blueAccent,
                  child: Text(
                    'Entrar',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  onPressed: () {
                    //User Data For Service
                    var userData = <String, dynamic>{
                      "email": _email.text,
                      "password": _password.text
                    };
                    ServiceManager.shared.signIn(userData,
                        completionHandler: (status, message) {
                      if (status) {
                        Navigator.of(context).pushAndRemoveUntil(
                            (MaterialPageRoute(
                                builder: (context) => ShuffleView())),
                            (route) => false);
                      } else {
                        showDialog(
                            context: context,
                            builder: (context) => EGAlert(
                                  title: 'Erro',
                                  bodyMessage: message,
                                ));
                      }
                    });
                  }),
              RaisedButton(
                  color: Colors.cyan,
                  child: Text(
                    'Cadastrar',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SignUpView()));
                  })
            ],
          )
        ],
      ),
    );
  }
}

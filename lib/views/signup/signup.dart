import '../../component/alert.dart';
import '../../component/textformfield.dart';
import '../../service/service_manager.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController _name = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _email = TextEditingController();

  String _value = "male";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar conta'),
      ),
      body: Center(
        child: SingleChildScrollView(child: formValidation()),
      ),
    );
  }

  Widget formValidation() {
    return Form(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 20, left: 20),
            child: EGTextFormField(
              hintText: 'Nome de usuário',
              controller: _name,
              labelText: 'Nome de usuário',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 20, left: 20),
            child: EGTextFormField(
              hintText: 'Senha',
              controller: _password,
              labelText: 'Senha',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 20, left: 20),
            child: EGTextFormField(
              hintText: 'Email',
              controller: _email,
              labelText: 'Email',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, right: 20, left: 20),
            child: dropDownMenu(),
          ),
          validationButton(text: "Registrar")
        ],
      ),
    );
  }

  Widget validationButton({String text}) {
    return RaisedButton(
        color: Colors.cyan,
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          var data = <String, dynamic>{
            "name": _name.text,
            "password": _password.text,
            "email": _email.text,
            "sex": _value,
            "about": "Hi There"
          };
          print(data);
          ServiceManager.shared.signUp(data, completionHandler: (message) {
            showDialog(
                context: context,
                builder: (context) =>
                    EGAlert(title: "Aviso", bodyMessage: message));
            [_name, _password, _email].forEach((element) {
              element.clear();
            });
          });
        });
  }

  Widget dropDownMenu() {
    return InputDecorator(
      decoration: const InputDecoration(
          contentPadding:
              const EdgeInsets.only(bottom: 10, right: 20, left: 10),
          border: const OutlineInputBorder()),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
            value: _value,
            hint: Text('Gênero'),
            items: [
              DropdownMenuItem(value: "male", child: Text('Masculino')),
              DropdownMenuItem(value: "female", child: Text('Feminino')),
            ],
            onChanged: (value) {
              setState(() {
                _value = value;
              });
            }),
      ),
    );
  }
}

import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../component/alert.dart';
import '../../component/textformfield.dart';
import '../../service/service_manager.dart';

class SignUpView extends StatefulWidget {
  get receiverID => null;

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController _name = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _email = TextEditingController();

  String _value = "male";

  File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(child: formValidation(context)),
      ),
    );
  }

  Widget formValidation(BuildContext context) {
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
          Padding(
              padding: const EdgeInsets.only(bottom: 10, right: 20, left: 20),
              child: Row(
                children: [
                  IconButton(icon: Icon((Icons.image)), onPressed: getImage),
                  Text(_image != null
                      ? 'Avatar selecionado'
                      : 'Selecione seu avatar'),
                ],
              )),
          validationButton(text: "Registrar"),
          SizedBox(height: 15),
          InkWell(
            child: Text('Já possui conta?'),
            onTap: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  Widget dropDownMenu() {
    return InputDecorator(
      decoration: const InputDecoration(
          contentPadding:
              const EdgeInsets.only(bottom: 10, right: 20, left: 10)),
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

  Future<void> getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      } else {
        print('No image selected.');
      }
    });
  }

  Widget validationButton({String text}) {
    return RaisedButton(
        color: Colors.cyan,
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          if (_image == null) {
            return EGAlert(
                title: "Escolha uma imagem!",
                bodyMessage:
                    'O avatar é obrigatório, adicione sua foto antes de prosseguir.');
          }

          var data = <String, dynamic>{
            "name": _name.text,
            "password": _password.text,
            "email": _email.text,
            "sex": _value,
            "about": "Hi There",
            "file": _image
          };

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
}

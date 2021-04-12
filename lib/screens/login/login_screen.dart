import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontSize: 16.0);

    return Scaffold(
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.person_outline,
                      size: 150,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _userController,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Informe o email.';
                        }
                        return null;
                      },
                      style: style,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                    ),
                    SizedBox(height: 25.0),
                    TextFormField(
                      controller: _passController,
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Informe a senha.';
                        }
                        if (text.length < 6) {
                          return 'Informe o mínimo 6 caracteres';
                        }
                        return null;
                      },
                      obscureText: true,
                      style: style,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          hintText: "Senha",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                    ),
                    SizedBox(
                      height: 35.0,
                    ),
                    MaterialButton(
                      color: Colors.teal,
                      minWidth: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          if (_userController.text == 'root@user.com' &&
                              _passController.text == '123456') {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setBool('isLogged', true);

                            Navigator.pushNamedAndRemoveUntil(
                                context, '/home', ModalRoute.withName('/'));
                          } else {
                            final snackBar = SnackBar(
                                content: Text('Usuário ou senha Inválidos!'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        }
                      },
                      child: Text("Login",
                          textAlign: TextAlign.center,
                          style: style.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

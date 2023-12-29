import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'map.dart';
import 'dart:async';

class AuthModel extends ChangeNotifier {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  void loginAndPassword() {
    String login = _loginController.text.trim();
    String password = _passwordController.text.trim();

    print('Login: $login, Password: $password');

    try {
      if (login.isEmpty || password.isEmpty) {
        _errorMessage = 'Заполните поля логин/пароль';
        print('Error message: $_errorMessage');
        notifyListeners();
        Timer(const Duration(seconds: 5), () {
          _errorMessage = '';
          notifyListeners();
        });
      } else if (login == 'bool' && password == 'bool') {
        _errorMessage = '';
        notifyListeners();
      } else {
        _errorMessage = 'Неверный логин или пароль';
        print('Error message: $_errorMessage');
        notifyListeners();
        Timer(const Duration(seconds: 5), () {
          _errorMessage = '';
          notifyListeners();
        });
      }
    } catch (e) {
      print('Произошла ошибка: $e');
    }
    notifyListeners();
  }
}

class Authorization extends StatefulWidget {
  const Authorization({Key? key}) : super(key: key);

  @override
  _AuthorizationState createState() => _AuthorizationState();
}

class _AuthorizationState extends State<Authorization> {
  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<AuthModel>(context);
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: authModel.errorMessage.isNotEmpty,
              child: Container(
                height: 15.0,
                width: double.infinity,
                color: Color.fromARGB(255, 241, 153, 147),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Image.asset(
                        'lib/assets/Icon_cross.png',
                        width: 10.0,
                        height: 10.0,
                      ),
                    ),
                    const SizedBox(width: 15.0),
                    const Text(
                      'Неверный логин или пароль',
                      style: TextStyle(fontSize: 12.0, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 35,
                  width: 81,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                  ),
                  child: const Center(
                    child: Text(
                      'Логин:',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  height: 35,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.5,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: authModel._loginController,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                    decoration: InputDecoration(
                      hintText: 'email/username',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(5, 10, 10, 10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 35,
                  width: 81,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                  ),
                  child: const Center(
                    child: Text(
                      'Пароль:',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  height: 35,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1.5,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: authModel._passwordController,
                    obscureText: true,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                    decoration: const InputDecoration(
                      hintText: '******',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(5, 5, 10, 10),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                authModel.loginAndPassword();
                if (authModel.errorMessage.isEmpty) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MapScreen()),
                  );
                }
              },
              child: Text('Войти',
                  style: TextStyle(
                    color: Colors.black87,
                  )),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(130, 30),
                primary: Colors.white60,
                onPrimary: Color.fromARGB(230, 0, 0, 0),
                side: const BorderSide(color: Colors.black, width: 1.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

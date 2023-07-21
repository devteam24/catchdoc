import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    final String apiUrl = "http://192.168.100.19:8000/login";
    var response = await http.post(Uri.parse(apiUrl), body: {
      "email": emailController.text,
      "password": passwordController.text
    });

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('user', json.encode(body));
      Navigator.pushNamed(context, '/home'); //------
    } else if (response.statusCode == 401) {
      var body = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(body['message']),
          backgroundColor: Colors.red,
        ),
      );
    } else if (response.statusCode == 409) {
      var body = jsonDecode(response.body);
      String message = '';
      for (var item in body) {
        message += item + '\n';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Une erreur s'est produite!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Connexion'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Image.asset('assets/logo.jfif'),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  labelText: 'Adresse e-mail',
                  prefixIcon: const Icon(Icons.email)),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: const Icon(Icons.key),
                labelText: 'Mot de passe',
              ),
            ),
            const SizedBox(height: 24.0),
            Container(
              width: 170,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blueAccent,
              ),
              child: TextButton(
                child: const Text(
                  'Se Connecter',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () => login(context),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () => login(context),
            //   child: Text('Se connecter'),
            // ),
          ],
        ),
      ),
    );
  }
}

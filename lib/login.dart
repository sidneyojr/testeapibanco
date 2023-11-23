import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

var apiUrl = 'http://192.168.20.50/flutter/usuarios/listar_usuarios.php';

class User {
  final int id;
  final String local;
  final String nome;
  final String celular;
  final String email;

  User(this.id, this.local, this.nome, this.celular, this.email);

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      json['id'],
      json['local'],
      json['nome'],
      json['celular'],
      json['email'],
    );
  }
}

class UserModel extends Model {
  late User _currentUser;

  User get currentUser => _currentUser;

  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }
}

class LoginModel extends Model {
  late UserModel _userModel;

  UserModel get userModel => _userModel;

  LoginModel(UserModel userModel) {
    _userModel = userModel;
  }

  Future<void> fetchUserByCode(int id) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl?id=$id'));
      if (kDebugMode) {
        print('Response status code: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('code') && data['code'] == 1) {
          List<dynamic> users = data['result'];

          if (users.isNotEmpty) {
            // Aqui, pegamos o primeiro usuário da lista.
            Map<String, dynamic>? userData = users.firstWhere(
              (user) => user['id'] == id,
              orElse: () => null,
            );
            if (userData != null) {
              User user = User.fromJson(userData);
              _userModel.setCurrentUser(user);
            }
          } else {
            throw Exception('Usuário não encontrado');
          }
        } else {
          throw Exception('Resposta da API não possui o código esperado');
        }
      } else {
        throw Exception('Erro ao obter usuário: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Erro ao obter usuário: $error');
    }
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final codigoUsuarioController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<LoginModel>(
      model: LoginModel(UserModel()),
      child: ScopedModelDescendant<LoginModel>(
        builder: (context, child, model) => Scaffold(
          appBar: AppBar(
            title: const Text('AUTO LEITURA - LOGIN'),
            backgroundColor: const Color.fromARGB(255, 0, 5, 8),
            centerTitle: true,
          ),
          body: Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Coloque seu código aqui',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: codigoUsuarioController,
                    decoration: const InputDecoration(
                      labelText: 'Código Único de Usuário',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      String idString = codigoUsuarioController.text;

                      try {
                        int id = int.parse(idString);
                        await model.fetchUserByCode(id);
                        _mostrarDialog(
                          context,
                          'Código válido. Nome: ${model.userModel.currentUser.nome}',
                        );
                      } catch (error) {
                        print('Erro ao validar código: $error');
                        _mostrarDialog(context, 'Código inválido');
                      }
                    },
                    child: const Text('Enviar para Validação'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _mostrarDialog(BuildContext context, String mensagem) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Resultado da Validação'),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

void main() {
  runApp(const MaterialApp(
    home: Login(),
  ));
}

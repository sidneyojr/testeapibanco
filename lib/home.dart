import 'package:testeapibanco/login.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('TESTE API BANCO - INÍCIO'),
        backgroundColor:
            Color.fromARGB(255, 0, 5, 8), // Manter a app bar no azul
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Seja Bem-Vindo ao sistema de Auto Leitura"),
            SizedBox(height: 25),
            Material(
              color: Colors.blueAccent, // Azul mais claro
              borderRadius: BorderRadius.circular(20.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(20.0),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "Clique para inserir seu código",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

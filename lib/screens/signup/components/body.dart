import 'package:flutter/material.dart';
import 'package:tcc/components/rounded_button.dart';
import 'package:tcc/components/rounded_input_field.dart';
import 'package:tcc/components/rounded_password_field.dart';
import 'package:tcc/screens/login/login_screen.dart';
import 'package:tcc/screens/signup/components/background.dart';
import 'package:tcc/service/auth_service.dart';

class Body extends StatefulWidget {
  const Body({super.key, required Column child});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _grupoController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _showValidation = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.05),
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Colors.blue[300]!, Colors.blue[100]!],
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: const Text(
                "SIGN UP",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: Colors.white,
                ),
              ),
            ),
            Image.asset(
              "assets/icons/png/family-2.png",
              height: size.height * 0.35,
            ),
            Form(
              key: _formKey,
              autovalidateMode: _showValidation
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: Column(
                children: [
                  RoundedInputField(
                    hintText: "NOME DE USUÁRIO",
                    icon: Icons.person,
                    controller: _nomeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório";
                      }
                      return null;
                    },
                  ),
                  RoundedInputField(
                    hintText: "EMAIL",
                    icon: Icons.email,
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório";
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return "Informe um email válido";
                      }
                      return null;
                    },
                  ),
                  RoundedInputField(
                    hintText: "GRUPO PARTICIPANTE",
                    icon: Icons.group_rounded,
                    controller: _grupoController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório";
                      }
                      if (!RegExp(r'^[a-zA-Z]$').hasMatch(value)) {
                        return "Digite apenas uma letra";
                      }
                      return null;
                    },
                  ),
                  RoundedPasswordField(
                    controller: _senhaController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            RoundedButton(
              text: "SIGN UP",
              press: () async {
                setState(() => _showValidation = true);

                if (_formKey.currentState!.validate()) {
                  final auth = AuthService();

                  final sucesso = await auth.cadastrar(
                    nome: _nomeController.text,
                    email: _emailController.text,
                    senha: _senhaController.text,
                    grupo: _grupoController.text,
                  );

                  if (sucesso) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Usuário criado com sucesso!")),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Erro ao cadastrar usuário.")),
                    );
                  }
                }
              },
            ),
            SizedBox(height: size.height * 0.01),
          ],
        ),
      ),
    );
  }
}

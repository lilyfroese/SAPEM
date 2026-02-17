import 'package:flutter/material.dart';
import 'package:tcc/components/already_have_an_account.dart';
import 'package:tcc/components/forget_your_password.dart';
import 'package:tcc/components/rounded_button.dart';
import 'package:tcc/components/rounded_input_field.dart';
import 'package:tcc/components/rounded_password_field.dart';
import 'package:tcc/screens/login/components/background.dart';
import 'package:tcc/screens/principal/principal.dart';
import 'package:tcc/screens/signup/signup_screen.dart';
import 'package:tcc/service/auth_service.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();
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
                "LOGIN",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: Colors.white,
                ),
              ),
            ),
            Image.asset(
              "assets/icons/png/women-pc.png",
              height: size.height * 0.38,
            ),
            Form(
              key: _formKey,
              autovalidateMode: _showValidation
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: Column(
                children: [
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
              text: "LOGIN",
              press: () async {
                setState(() => _showValidation = true);

                if (_formKey.currentState!.validate()) {
                  final auth = AuthService();

                  final sucesso = await auth.login(
                    email: _emailController.text,
                    senha: _senhaController.text,
                  );

                  if (sucesso) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PrincipalScreen()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Login inválido")),
                    );
                  }
                }
              },
            ),
            AlreadyHaveAnAccountCheck(
              login: true,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpScreen()),
                );
              },
            ),
            ForgetYourPassword(
              press: () {
                // TODO: implementar rota correta
                Navigator.pushNamed(context, " ");
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:tcc/screens/metas/cadastro/sign_up_goal.dart';
import 'package:tcc/components/bottom_navegation_bar.dart';
import 'package:tcc/components/custom_drawer.dart';
import 'package:tcc/components/rounded_button.dart';
import 'package:tcc/screens/principal/components/puzzle/puzzle_goal.dart';
import 'package:tcc/service/fake_meta_service.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    final metas = FakeMetaService.instance.metas;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height + 40, // Garante espaço extra pra rolar
          child: Stack(
            children: [
              // Fundo da tela
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.brown.shade50,
                      Colors.brown.shade50,
                    ],
                  ),
                ),
              ),
              
              SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 250), // Espaço antes do primeiro grupo
                    
                    PuzzleGoal(
                      metas: metas,
                      verticalPaddingBottom: 20, // botão fica quase colado
                      onPieceTap: (index) { 
                        print('Peça $index tocada'); 
                      },
                    ),

                    const SizedBox(height: 10), // Espaço entre puzzle e botão
                    RoundedButton(
                      text: 'Adicionar Metas',
                      press: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => SignUpGoalScreen(),
                        )).then((_) => setState(() {})); // Atualiza ao voltar
                       },
                      textColor: Colors.white,
                      gradientColors: [Colors.grey.shade300, Colors.grey.shade300], // cinza claro
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const ButtomNavigationBar(),
    );
  }
}

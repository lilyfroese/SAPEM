import 'package:flutter/material.dart';
import 'package:tcc/components/rounded_button.dart';
import 'package:tcc/core/api/api.dart';
import 'package:tcc/models/meta.dart';
import 'package:tcc/service/fake_meta_service.dart';
import 'dart:ui';

import 'package:tcc/service/meta.service.dart';


class SignUpGoalScreen extends StatefulWidget {
  final Meta? editMeta;

  const SignUpGoalScreen({super.key, this.editMeta});

  @override
  State<SignUpGoalScreen> createState() => _SignUpGoalScreenState();
}

class _SignUpGoalScreenState extends State<SignUpGoalScreen> {
  final TextEditingController tituloController = TextEditingController();
  final TextEditingController metaController = TextEditingController();
  final TextEditingController prazoController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();

  String categoriaSelecionada = 'Pessoal';
  Color corSelecionada = Colors.transparent;
  bool notificar = true;
  IconData? iconeSelecionado;

  final List<Color> cores = [
    Colors.white,
    const Color(0xFFFFCBA4),
    const Color(0xFFF4A4B4),
    const Color(0xFFD1B3FF),
    const Color(0xFFAEC8FF),
    const Color(0xFFB9E5C8),
    const Color(0xFF6BA6A6),
  ]; 

  final List<IconData> icones = [
  Icons.bubble_chart,   
  Icons.nightlight_round, 
  Icons.local_florist,  
  Icons.menu_book,      
  Icons.fitness_center,
  Icons.star,           
  Icons.favorite,       
];


  DateTime? dataSelecionada;

  Future<void> selecionarData() async {
    DateTime? selecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );

    if (selecionada != null) {
      dataSelecionada = selecionada;
      prazoController.text =
          "${selecionada.day}/${selecionada.month}/${selecionada.year}";
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.editMeta != null) {
      final m = widget.editMeta!;
      tituloController.text = m.title;
      descricaoController.text = m.description;
      categoriaSelecionada = m.category!;
      metaController.text = m.goalValue?.toString() ?? '';
      dataSelecionada = m.deadline;
      corSelecionada = m.color;
      iconeSelecionado = m.icon;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Nova Meta',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Text('Título da Meta',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                controller: tituloController,
                decoration: _inputDecoration('Título da Meta'),
              ),

              const SizedBox(height: 16),
              const Text('Categoria',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: categoriaSelecionada,
                items: ['Pessoal', 'Saúde', 'Estudos', 'Financeira']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                decoration: _inputDecoration('Categoria'),
                onChanged: (v) => setState(() => categoriaSelecionada = v!),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Meta',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: metaController,
                          keyboardType: TextInputType.number,
                          decoration: _inputDecoration('0'),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Prazo',
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: prazoController,
                          readOnly: true,
                          onTap: selecionarData,
                          decoration: _inputDecoration('dd/mm/aaaa'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Text('Descrição',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              TextField(
                controller: descricaoController,
                decoration: _inputDecoration('Descrição'),
                maxLines: 3,
              ),

              const SizedBox(height: 16),

              const Text('Cor', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: cores
                    .map(
                      (color) => GestureDetector(
                        onTap: () => setState(() => corSelecionada = color),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: corSelecionada == color
                                  ? Colors.blue
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),

              const SizedBox(height: 16),
              const Text('Ícone', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: icones.map((iconData) {
                  return GestureDetector(
                    onTap: () => setState(() => iconeSelecionado = iconData),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,  // fundo cinza claro
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: iconeSelecionado == iconData ? Colors.blue : Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        iconData,
                        size: 22,
                        color: Colors.black87,
                      ),
                    ),
                  );
                }).toList(),
              ),


              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Notificar',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  Switch(
                    value: notificar,
                    onChanged: (v) => setState(() => notificar = v),
                    activeColor: Colors.white,
                    activeTrackColor: Colors.blue,
                  ),
                ],
              ),

              const SizedBox(height: 20),
              RoundedButton(
                text: widget.editMeta == null ? "Salvar Meta" : "Salvar Alterações",
                press: () {
                  if (widget.editMeta == null) {
                    FakeMetaService.instance.addMeta(
                      title: tituloController.text,
                      description: descricaoController.text,
                      category: categoriaSelecionada,
                      goalValue: int.tryParse(metaController.text),
                      deadline: dataSelecionada,
                      color: corSelecionada,
                      icon: iconeSelecionado ?? Icons.star,
                    );
                  } else {
                    FakeMetaService.instance.updateMeta(
                      widget.editMeta!,
                      widget.editMeta!.copyWith(
                        title: tituloController.text,
                        description: descricaoController.text,
                        category: categoriaSelecionada,
                        goalValue: int.tryParse(metaController.text),
                        deadline: dataSelecionada,
                        color: corSelecionada,
                        icon: iconeSelecionado ?? Icons.star,
                      ),
                    );
                  }

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}

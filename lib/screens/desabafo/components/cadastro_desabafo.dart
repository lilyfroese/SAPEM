import 'package:flutter/material.dart';
import 'package:tcc/screens/desabafo/components/body.dart';

class CadastroDesabafoScreen extends StatefulWidget {
  final List<PastaModel> pastas;
  final int nextId;
  final String? tituloInicial;  
  final String? conteudoInicial;
  final String? categoriaInicial;
  final int? pastaInicial;


  const CadastroDesabafoScreen({
  super.key,
  required this.pastas,
  required this.nextId,
  this.tituloInicial,
  this.conteudoInicial,
  this.categoriaInicial,
  this.pastaInicial,
});


  @override
  State<CadastroDesabafoScreen> createState() =>
      _CadastroDesabafoScreenState();
}

class _CadastroDesabafoScreenState
  extends State<CadastroDesabafoScreen> {
  final _tituloController = TextEditingController();
  final _conteudoController = TextEditingController();
  String? _categoria;
  int? _selectedPastaId;

  final List<String> categorias = [
    'Não listado',
    'Atenção',
    'Resolvido'
  ];

  @override
  void initState() {
    super.initState();
    _tituloController.text = widget.tituloInicial ?? '';
    _conteudoController.text = widget.conteudoInicial ?? '';
    _categoria = widget.categoriaInicial;
    _selectedPastaId = widget.pastaInicial;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Desabafo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration:
                  const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: _conteudoController,
              decoration:
                  const InputDecoration(labelText: 'Conteúdo'),
              maxLines: 6,
            ),
            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: _categoria,
              hint: const Text('Categoria'),
              items: categorias
                  .map((c) =>
                      DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _categoria = v),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<int?>(
              value: _selectedPastaId,
              hint: const Text('Selecione uma pasta (opcional)'),
              items: [
                const DropdownMenuItem<int?>(
                    value: null, child: Text('Nenhuma')),
                ...widget.pastas.map(
                  (p) => DropdownMenuItem<int?>(
                      value: p.id, child: Text(p.nome)),
                ),
              ],
              onChanged: (v) =>
                  setState(() => _selectedPastaId = v),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _salvar,
                    child: const Text('Salvar Desabafo'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

 void _salvar() {
  final titulo = _tituloController.text.trim();
  final conteudo = _conteudoController.text.trim();

  if (titulo.isEmpty || conteudo.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Preencha título e conteúdo')),
    );
    return;
  }

    final novo = DesabafoModel(
      id: widget.nextId, // IMPORTANTE: mantém mesmo ID se for edição
      titulo: titulo,
      conteudo: conteudo,
      categoria: _categoria ?? 'Não listado',
      pastaId: _selectedPastaId,
      userId: 1,
    );

    Navigator.pop(context, novo);
  }
}

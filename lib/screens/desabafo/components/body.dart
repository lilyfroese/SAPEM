import 'package:flutter/material.dart';
import 'package:tcc/screens/desabafo/components/cadastro_desabafo.dart';

class PastaModel {
  final int id;
  final String nome;
  PastaModel({required this.id, required this.nome});
}

class DesabafoModel {
  final int id;
  final String titulo;
  final String conteudo;
  final String? categoria;
  final int? pastaId;
  final int userId;

  DesabafoModel({
    required this.id,
    required this.titulo,
    required this.conteudo,
    this.categoria,
    this.pastaId,
    required this.userId,
  });
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<PastaModel> pastas = [];
  List<DesabafoModel> desabafos = [];

  String search = '';
  bool isAdmin = false;

  int _nextPastaId = 1;
  int _nextDesabafoId = 1;

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    pastas = [
      PastaModel(id: _nextPastaId++, nome: 'Diário'),
      PastaModel(id: _nextPastaId++, nome: 'Escola'),
      PastaModel(id: _nextPastaId++, nome: 'Família'),
    ];

    desabafos = [
      DesabafoModel(
        id: _nextDesabafoId++,
        titulo: 'Acordei Mal',
        conteudo: 'Hoje a noite foi estranha porque tive pesadelos.',
        categoria: 'Não listado',
        pastaId: null,
        userId: 1,
      ),
      DesabafoModel(
        id: _nextDesabafoId++,
        titulo: 'Entrega difícil',
        conteudo: 'Tive muitas preocupações com um trabalho na escola.',
        categoria: 'Atenção',
        pastaId: pastas[1].id,
        userId: 1,
      ),
    ];
  }

  Future<void> _criarPastaDialog() async {
    final controller = TextEditingController();
    final result = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Criar Pasta'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Nome da pasta'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Criar'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        pastas.insert(0, PastaModel(id: _nextPastaId++, nome: result));
      });
    }
  }

  Future<void> _abrirCadastroDesabafo() async {
    final novo = await Navigator.push<DesabafoModel?>(
      context,
      MaterialPageRoute(
        builder: (_) => CadastroDesabafoScreen(
          pastas: pastas,
          nextId: _nextDesabafoId,
        ),
      ),
    );

    if (novo != null) {
      setState(() {
        desabafos.insert(0, novo);
        _nextDesabafoId++;
      });
    }
  }

  List<DesabafoModel> get _filteredDesabafos {
    if (search.trim().isEmpty) return desabafos;
    final q = search.toLowerCase();
    return desabafos
        .where((d) =>
            d.titulo.toLowerCase().contains(q) ||
            d.conteudo.toLowerCase().contains(q))
        .toList();
  }

  void _abrirPasta(PastaModel pasta) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PastaViewScreen(
          pasta: pasta,
          desabafos:
              desabafos.where((d) => d.pastaId == pasta.id).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Desabafo'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text(isAdmin ? 'Admin' : 'Usuário')),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _abrirCadastroDesabafo,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.amberAccent, Colors.amber.shade200],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.note_add, color: Colors.white70),
                          SizedBox(height: 8),
                          Text(
                            'Adicionar Desabafo',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: _criarPastaDialog,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blueAccent, Colors.lightBlueAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.create_new_folder, color: Colors.white70),
                          SizedBox(height: 8),
                          Text(
                            'Adicionar Pasta',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            TextField(
              decoration: InputDecoration(
                hintText: 'Buscar...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onChanged: (v) => setState(() => search = v),
            ),

            const SizedBox(height: 16),

            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: pastas.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: () => setState(() => search = ''),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(child: Text('Todas')),
                      ),
                    );
                  }

                  final pasta = pastas[index - 1];
                  return GestureDetector(
                    onTap: () => _abrirPasta(pasta),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Center(child: Text(pasta.nome)),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: _filteredDesabafos.length,
                itemBuilder: (context, index) {
                  final d = _filteredDesabafos[index];
                  final pasta = d.pastaId == null
                      ? null
                      : pastas.firstWhere(
                          (p) => p.id == d.pastaId,
                          orElse: () => PastaModel(id: -1, nome: '—'),
                        );

                  return Dismissible(
                    key: Key(d.id.toString()),
                    background: Container(
                      color: Colors.green,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Icon(Icons.edit, color: Colors.white),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        final editado = await Navigator.push<DesabafoModel?>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CadastroDesabafoScreen(
                              pastas: pastas,
                              nextId: d.id,
                              tituloInicial: d.titulo,
                              conteudoInicial: d.conteudo,
                              categoriaInicial: d.categoria,
                              pastaInicial: d.pastaId,
                            ),
                          ),
                        );

                        if (editado != null) {
                          setState(() {
                            final idx = desabafos.indexWhere((x) => x.id == d.id);
                            desabafos[idx] = editado;
                          });
                        }
                        return false; 
                      } else {
                        final confirmar = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Excluir?"),
                            content: const Text("Deseja realmente excluir este desabafo?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancelar"),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Excluir"),
                              ),
                            ],
                          ),
                        );

                        if (confirmar == true) {
                          setState(() {
                            desabafos.removeWhere((x) => x.id == d.id);
                          });
                          return true;
                        }
                        return false;
                      }
                    },

                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  d.titulo,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (pasta != null && pasta.id != -1)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    pasta.nome,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(d.conteudo),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            children: [
                              if (d.categoria == null || d.categoria == 'Não listado')
                                _tag('Não listado', Colors.grey[300]!),
                              if (d.categoria == 'Atenção')
                                _tag('Atenção', Colors.red[200]!),
                              if (d.categoria == 'Resolvido')
                                _tag('Resolvido', Colors.amber),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );

                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}

class PastaViewScreen extends StatelessWidget {
  final PastaModel pasta;
  final List<DesabafoModel> desabafos;
  const PastaViewScreen(
      {super.key, required this.pasta, required this.desabafos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pasta.nome),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: desabafos.length,
          itemBuilder: (context, index) {
            final d = desabafos[index];
            return Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    d.titulo,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(d.conteudo),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}


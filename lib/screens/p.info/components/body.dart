import 'package:flutter/material.dart';
import 'package:tcc/screens/login/login_screen.dart';
import 'package:tcc/screens/login/components/background.dart';
import 'package:tcc/service/auth_service.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Map<String, dynamic>? usuario;
  final auth = AuthService();

  @override
  void initState() {
    super.initState();
    carregarUsuario();
  }

  Future<void> carregarUsuario() async {
    final data = await auth.getUsuario();
    setState(() => usuario = data);
  }

  @override
  Widget build(BuildContext context) {
    final themeBlue = const Color.fromARGB(255, 155, 198, 248);
    final themeYellow = const Color(0xFFFFC107);
    final backgroundCard = Colors.white.withOpacity(0.0);

    // enquanto carrega
    if (usuario == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Background(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // VOLTAR
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: themeBlue),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Avatar + Nome
                CircleAvatar(
                  radius: 50,
                  backgroundColor: themeYellow.withOpacity(0.3),
                  child: const CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage('assets/profile.jpg'),
                    backgroundColor: Colors.transparent,
                  ),
                ),

                const SizedBox(height: 15),

                Text(
                  usuario!["username"] ?? "Nome Não Encontrado",
                  style: TextStyle(
                    color: Colors.blue[200],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                _buildInfoSection(themeBlue, backgroundCard),

                const SizedBox(height: 20),

                _buildUtilitySection(themeBlue),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(Color azul, Color fundo) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Informações Pessoais",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),

        _buildInfoCard(Icons.person, "Usuário", usuario!["username"], azul, fundo),
        _buildInfoCard(Icons.email, "Email", usuario!["email"], azul, fundo),
        _buildInfoCard(Icons.groups, "Grupo", usuario!["grupo"], azul, fundo),
      ],
    );
  }

  Widget _buildUtilitySection(Color azul) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Utilidades",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),

        _buildUtilityTile(Icons.logout, "Log-Out", Colors.red, () async {
          await auth.logout();
          if (!mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }),
      ],
    );
  }

  Widget _buildInfoCard(
      IconData icon, String label, String value, Color iconColor, Color background) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 12),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }

  Widget _buildUtilityTile(
      IconData icon, String title, Color iconColor, VoidCallback action) {
    return GestureDetector(
      onTap: action,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/quiz_provider.dart';
import '../providers/theme_provider.dart';
import '../models/question_model.dart';
import '../data/dummy_question.dart';
import 'quiz_screen.dart';
import 'login_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final userName = userProvider.userName;
    final userEmail = userProvider.userEmail;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Utama'),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
              accountEmail: Text(userEmail),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.blue),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Ubah Nama'),
              onTap: () {
                Navigator.pop(context);
                _showEditNameDialog(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Riwayat Kuis'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryScreen()),
                );
              },
            ),

            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return SwitchListTile(
                  secondary: const Icon(Icons.dark_mode),
                  title: const Text('Mode Gelap'),
                  value: themeProvider.themeMode == ThemeMode.dark,
                  onChanged: (bool value) {
                    themeProvider.toggleTheme(value);
                  },
                );
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                context.read<UserProvider>().logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Halo, $userName! 👋',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pilih kategori kuis di bawah ini untuk menguji pengetahuanmu:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            _buildQuizCard(
              context,
              title: 'Pengetahuan Umum',
              icon: Icons.public,
              color: Colors.blue,
              questions: generalQuestions,
            ),
            _buildQuizCard(
              context,
              title: 'Matematika Dasar',
              icon: Icons.calculate,
              color: Colors.green,
              questions: mathQuestions,
            ),
            _buildQuizCard(
              context,
              title: 'Sejarah Indonesia',
              icon: Icons.history_edu,
              color: Colors.orange,
              questions: historyQuestions,
            ),
          ],
        ),
      ),
    );
  }

  void _showEditNameDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    nameController.text = context.read<UserProvider>().userName;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Ubah Nama'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'Nama Baru',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isNotEmpty) {
                  context.read<UserProvider>().updateName(nameController.text.trim());
                  Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nama berhasil diubah!')),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuizCard(BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required List<Question> questions,
  }) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          context.read<QuizProvider>().startQuiz(questions, title);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const QuizScreen()),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'directeur_dashboard_screen.dart';
import 'dashboard_screen.dart';
import '../widgets/safecare_appbar.dart';
import 'directeur_dashboard_v2.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final wachtwoordController = TextEditingController();

  bool laden = false;

  Future<void> login() async {
    try {
      setState(() {
        laden = true;
      });

      await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: wachtwoordController.text.trim(),
      );

      if (!mounted) return;

      final user = Supabase.instance.client.auth.currentUser;

if (user == null) {
  return;
}

final profiel = await Supabase.instance.client
    .from('profielen')
    .select('rol')
    .eq('id', user.id)
    .maybeSingle();

final rol = profiel?['rol']?.toString();

if (!mounted) return;

Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) {
      if (rol == 'directeur') {
  return const DirecteurDashboardV2();
}

      return DashboardScreen();
    },
  ),
);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          laden = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SafeCareAppBar(
  titel: "Dashboard Login",
),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400,
            ),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "E-mailadres",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: wachtwoordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Wachtwoord",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: laden ? null : login,
                    child: laden
                        ? const CircularProgressIndicator()
                        : const Text("INLOGGEN"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
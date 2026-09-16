import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dashboard_screen.dart';
import 'login_screen.dart';
import 'directeur_dashboard_screen.dart';
import 'veiligheidscoordinator_dashboard_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<String?> _laadRol() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return null;
    }

    final resultaat = await Supabase.instance.client
        .from('profielen')
        .select('rol')
        .eq('id', user.id)
        .maybeSingle();

    return resultaat?['rol']?.toString();
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    print("Current user:");
    print(user?.email);

    if (user == null) {
      return const LoginScreen();
    }

    return FutureBuilder<String?>(
      future: _laadRol(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final rol = snapshot.data;

        print('ROL GEVONDEN: $rol');
print('USER ID: ${user.id}');

        if (rol == 'directeur') {
  return const Scaffold(
    body: Center(
      child: Text(
        'AUTH GATE DIRECTEUR',
        style: TextStyle(
          fontSize: 40,
        ),
      ),
    ),
  );
}
if (rol == 'Veiligheidsmedewerker') {
  return const VeiligheidsCoordinatorDashboardScreen();
}

        return DashboardScreen();
      },
    );
  }
}
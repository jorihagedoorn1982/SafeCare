import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'dashboard_home_screen.dart';
import 'directeur_dashboard_screen.dart';
import 'login_screen.dart';
import 'directeur_dashboard_v2.dart';
import 'veiligheidscoordinator_dashboard_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<String?> _laadRol() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return null;
    }
print('EMAIL IN DASHBOARDSCREEN: ${user.email}');

final resultaat = await Supabase.instance.client
    .from('profielen')
    .select()
    .eq('email', user.email!);

print('RESULTAAT DASHBOARDSCREEN: $resultaat');

if (resultaat.isEmpty) {
  return null;
}

return resultaat.first['rol']?.toString();
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

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
print('ROL IN DASHBOARDSCREEN: $rol');
        if (rol == 'directeur') {
  return const DirecteurDashboardV2();
}

if (rol == 'Veiligheidsmedewerker') {
  return const VeiligheidsCoordinatorDashboardScreen();
}

return const DashboardHomeScreen();
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'dashboard_home_screen.dart';
import 'directeur_dashboard_screen.dart';
import 'login_screen.dart';
import 'directeur_dashboard_v2.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<String?> _laadRol() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      return null;
    }

    final profiel = await Supabase.instance.client
        .from('profielen')
        .select('rol')
        .eq('id', user.id)
        .maybeSingle();

    return profiel?['rol']?.toString();
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

        if (rol == 'directeur') {
  return const DirecteurDashboardV2();
}

        return const DashboardHomeScreen();
      },
    );
  }
}
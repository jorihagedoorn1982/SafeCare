import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'dashboard_screen.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final user =
    Supabase.instance.client.auth.currentUser;

print("Current user:");
print(user?.email);

    if (user == null) {
      return const LoginScreen();
    }

    return DashboardScreen();
  }
}
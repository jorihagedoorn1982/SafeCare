import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../widgets/safecare_appbar.dart';
import 'dashboard_home_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool loading = false;

  Future<void> login() async {
    try {
      setState(() {
        loading = true;
      });

      await Supabase.instance.client.auth.signInWithPassword(
        email: 'jori@safecareinitiative.nl',
        password: 'Okidoki-2712',
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardHomeScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login mislukt: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SafeCareAppBar(
        titel: "Dashboard toegang",
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: loading ? null : login,
          child: Text(
            loading ? "Bezig..." : "INLOGGEN",
          ),
        ),
      ),
    );
  }
}
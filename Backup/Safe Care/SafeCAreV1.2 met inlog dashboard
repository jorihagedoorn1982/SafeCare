import 'package:flutter/material.dart';

import 'welcome_screen.dart';

class Eindscherm extends StatelessWidget {
  const Eindscherm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Color(0xFF22415B),
                size: 100,
              ),

              const SizedBox(height: 30),

              const Text(
                'Melding ontvangen',
                style: TextStyle(
                  fontFamily: 'SourceSerif4',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10212D),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Veiligheid zichtbaar maken.\nSamen signaleren. Samen oplossen.\n\n'
                'De melding is succesvol opgeslagen in SafeCare.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'SourceSerif4',
                  fontSize: 18,
                  color: Color(0xFF10212D),
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: 280,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const WelcomeScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    'TERUG NAAR START',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class SafeCareAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String titel;

  const SafeCareAppBar({
    super.key,
    required this.titel,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
  toolbarHeight: 80,
  centerTitle: true,

  iconTheme: const IconThemeData(
    color: Colors.white,
  ),

  title: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
          Image.asset(
            'assets/images/SCI_mark.png',
            width: 50,
            height: 50,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 12),
          Text(
  titel,
  style: const TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  ),
),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(80);
}
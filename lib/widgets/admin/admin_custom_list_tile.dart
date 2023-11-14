import 'package:flutter/material.dart';

class AdminCustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onTap;

  const AdminCustomListTile({super.key, required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: const Color.fromARGB(255, 34, 34, 34),
      onTap: onTap,
      title: Text(title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
          textAlign: TextAlign.left),
      leading: Icon(icon, color: Colors.white, size: 20),
    );
  }
}

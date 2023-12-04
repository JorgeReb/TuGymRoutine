import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onTap;

  const CustomListTile({super.key, required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      onTap: onTap,
      title: Text(title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: 20,
          fontWeight: FontWeight.w300,
        ),
        textAlign: TextAlign.left
      ),
      leading: Icon(icon, color: Theme.of(context).colorScheme.secondary, size: 20),
    );
  }
}

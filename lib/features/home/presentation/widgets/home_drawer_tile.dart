import 'package:flutter/material.dart';

class HomeDrawerTile extends StatelessWidget {
  const HomeDrawerTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      ),
      leading: Icon(
        icon,
        color: Theme.of(context).colorScheme.primary,
      ),
      onTap: onTap,
    );
  }
}

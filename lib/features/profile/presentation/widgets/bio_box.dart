import 'package:flutter/material.dart';

class BioBox extends StatelessWidget {
  final String text;

  const BioBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(25.0),
      width: double.infinity,
      margin: EdgeInsets.only(top: 15.0),
      decoration: BoxDecoration(
        color: colors.secondary,
      ),
      child: Text(
        text.isNotEmpty ? text : "Empty bio...",
        style: TextStyle(
          color: colors.primary,
          fontSize: 16.0,
        ),
      ),
    );
  }
}

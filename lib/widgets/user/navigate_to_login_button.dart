import 'package:flutter/material.dart';


class NavigateToLoginButton extends StatelessWidget {
  const NavigateToLoginButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => Navigator.pushNamed(context, "/"),
      style: const ButtonStyle(
        side: MaterialStatePropertyAll(BorderSide.none)),
      child: Text(
        '¿Ya tienes cuenta?',
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
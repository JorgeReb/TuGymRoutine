import 'package:flutter/material.dart';

class NavigateToRegisterButton extends StatelessWidget {
  const NavigateToRegisterButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => Navigator.pushNamed(context, "/register"),
      style: const ButtonStyle(side: MaterialStatePropertyAll(BorderSide.none),
      ),
      child: Text('¿No tienes cuenta? Regístrate',style: TextStyle(decoration: TextDecoration.underline,color: Theme.of(context).colorScheme.secondary,),
      ),
    );
  }
}
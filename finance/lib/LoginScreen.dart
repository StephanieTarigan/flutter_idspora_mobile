import 'package:flutter/material.dart';
import 'finance/index.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Login'),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => FinanceIndex(),
            ));
          },
        ),
      ),
    );
  }
}

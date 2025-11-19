import 'package:flutter/material.dart';
import 'package:pointmaster/screens/register_screen.dart';
import 'package:pointmaster/widgets/screens/textfield_passwordfield.dart';
import 'package:pointmaster/widgets/screens/login_register_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  

  @override
  Widget build(BuildContext context) {

    final textFieldWidth = MediaQuery.of(context).size.width*0.8;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            child: Image.asset(
              "assets/images/LogoTFG.png",
              fit: BoxFit.contain,
            ),
          ),
          Center(
            child: SizedBox(
              width: textFieldWidth,
              child: FieldWidget(
                hintText: "Email", 
                prefixIcon: Icon(Icons.email)
              )
            )
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          Center(
            child: SizedBox(
              width: textFieldWidth,
              child: PasswordWidget(
                hintText: "Password", 
                obscureText: true),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          Center(
            child: SizedBox(
              width: textFieldWidth,
              child: RegisterButton(text: "Login"),
            ),
          ),

          const SizedBox(height: 30),

              // Texto de registro
              const Text(
                '¿Aún no tienes cuenta?',
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),

              // Botón para ir a registro
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFC4AD55), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 14,
                  ),
                ),
                child: const Text(
                  'Registrarse',
                  style: TextStyle(
                    color: Color(0xFFC4AD55),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
        ] 
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointmaster/screens/admin/admin_screen.dart';
import 'package:pointmaster/screens/register_screen.dart';
import 'package:pointmaster/screens/users/select_club_screen.dart';
import 'package:pointmaster/widgets/screens/textfield_passwordfield.dart';
import 'package:provider/provider.dart';
import 'package:pointmaster/providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final spaceBetweenButtons = MediaQuery.of(context).size.height * 0.04;
    final textFieldWidth = MediaQuery.of(context).size.width*0.8;
    final height = MediaQuery.of(context).size.height;
    final userProvider = context.watch<UserProvider>();

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
          Expanded(
            child: SingleChildScrollView (
            child: Column(
              children: [
                Center(
                  child: SizedBox(
                    width: textFieldWidth,
                    child: FieldWidget(
                      controller: usernameController,
                      hintText: "username", 
                      prefixIcon: Icon(Icons.person)
                    )
                  )
                ),
                SizedBox(height: spaceBetweenButtons),
                Center(
                  child: SizedBox(
                    width: textFieldWidth,
                    child: PasswordWidget(
                      controller: passwordController,
                      hintText: "Password", 
                      obscureText: true),
                  ),
                ),
                SizedBox(height: spaceBetweenButtons),
                SizedBox(
                  width: textFieldWidth,
                  child: ElevatedButton(
                    onPressed: userProvider.loading
                        ? null
                        : () async {
                            await userProvider.login(
                              usernameController.text.trim(),
                              passwordController.text.trim(),
                            );

                            final user = userProvider.activeUser;

                            if (user != null) {
                              if (user.role == 'ROLE_ADMIN') {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AdminScreen(),
                                  ),
                                );
                              } else if (user.role == 'ROLE_USER') {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SelectClubScreen(),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(userProvider.errorMessage!),
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC4AD55),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: userProvider.loading
                        ? const CircularProgressIndicator(
                            color: Color.fromARGB(255, 255, 255, 255),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                 SizedBox(height: height * 0.03),
                    // Texto de registro
                    const Text(
                      '¿Aún no tienes cuenta?',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: height * 0.01),

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
            )
          ),
          )
        ] 
      ),
    );
  }
}
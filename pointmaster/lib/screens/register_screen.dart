import 'package:flutter/material.dart';
import 'package:pointmaster/providers/user_provider.dart';
import 'package:pointmaster/screens/login_screen.dart';
import 'package:pointmaster/widgets/screens/login_register_button.dart';
import 'package:pointmaster/widgets/screens/textfield_passwordfield.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  //Function to validate email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final textFieldWidth = MediaQuery.of(context).size.width*0.8;
    final spaceBetweenButtons = MediaQuery.of(context).size.height * 0.03;
    final userProvider = context.watch<UserProvider>();


    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            /*
              Button to return to the login view
              And 'Crea tu cuenta' text
            */
            Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                IconButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                }, icon: Icon(Icons.arrow_back_rounded, size: 35)),
                SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                Text("Crea tu cuenta", style: TextStyle(
                    fontSize: 40,
                    color: Color(0xFFC4AD55)
                  ),
                )
              ],
            ),

            //Button list

            SizedBox(height: MediaQuery.of(context).size.height * 0.08),

            Expanded(
              child: SingleChildScrollView(
                //Name
                child: Column(
                  children: [
                    Center(
                      child: SizedBox(
                        width: textFieldWidth,
                        child: FieldWidget(
                          controller: nameController,
                            hintText: "Nombre", 
                            prefixIcon: Icon(Icons.person)
                          ),
                      ),
                    ),

                    SizedBox(height: spaceBetweenButtons),

                    Center(
                      child: SizedBox(
                        width: textFieldWidth,
                        child: FieldWidget(
                          controller: secondNameController,
                            hintText: "Apellidos", 
                            prefixIcon: Icon(Icons.person)
                          ),
                      ),
                    ),

                    SizedBox(height: spaceBetweenButtons),

                    Center(
                      child: SizedBox(
                        width: textFieldWidth,
                        child: FieldWidget(
                          controller: usernameController,
                            hintText: "Nombre de usuario", 
                            prefixIcon: Icon(Icons.person)
                          ),
                      ),
                    ),

                    SizedBox(height: spaceBetweenButtons),
                    //Email
                    Center(
                      child: SizedBox(
                        width: textFieldWidth,
                        child: FieldWidget(
                          controller: emailController,
                          hintText: "Email", 
                          prefixIcon: Icon(Icons.email),

                        )
                      )
                    ),
                    SizedBox(height: spaceBetweenButtons),

                  //Password
                    Center(
                      child: SizedBox(
                        width: textFieldWidth,
                        child: PasswordWidget(
                          controller: passwordController,
                          hintText: "Contraseña", 
                          obscureText: true,
                        )
                      )
                    ),
                    SizedBox(height: spaceBetweenButtons),

                    //Confirm password
                    Center(
                      child: SizedBox(
                        width: textFieldWidth,
                        child: PasswordWidget(
                          controller: confirmPasswordController,
                          hintText: "Confirmar contraseña", 
                          obscureText: true,
                        )
                      )
                    ),

                    SizedBox(height: spaceBetweenButtons),

                    // Register Button

                  SizedBox(
                    width: textFieldWidth,
                    child: ElevatedButton(
                      onPressed: userProvider.loading
                          ? null
                          : () async {
                              // Validate fields
                              if (nameController.text.isEmpty ||
                                  secondNameController.text.isEmpty ||
                                  emailController.text.isEmpty ||
                                  usernameController.text.isEmpty ||
                                  passwordController.text.isEmpty ||
                                  confirmPasswordController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("All fields are required"),
                                  ),
                                );
                                return;
                              }

                              if (!_isValidEmail(emailController.text.trim())) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please enter a valid email address",
                                    ),
                                  ),
                                );
                                return;
                              }

                              if (passwordController.text !=
                                  confirmPasswordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Passwords don't match"),
                                  ),
                                );
                                return;
                              }

                              await userProvider.register(
                                nameController.text.trim(),
                                secondNameController.text.trim(),
                                emailController.text.trim(),
                                usernameController.text.trim(),
                                passwordController.text.trim(),
                              );

                              if (userProvider.errorMessage == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Registered successfully"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(userProvider.errorMessage!),
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFC4AD55),
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
                              "Register",
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                )
                    
                  ],
                ),
              ),
            )

          ]
      ),
    );
  }
}
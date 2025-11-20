import 'package:flutter/material.dart';
import 'package:pointmaster/screens/login_screen.dart';
import 'package:pointmaster/widgets/screens/textfield_passwordfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  
  @override
  Widget build(BuildContext context) {
    final textFieldWidth = MediaQuery.of(context).size.width*0.8;
    final spaceBetweenButtons = MediaQuery.of(context).size.height * 0.03;


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
                            hintText: "Nombre", 
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
                          hintText: "Contraseña", 
                          obscureText: true,
                        )
                      )
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                    //Confirm password
                    Center(
                      child: SizedBox(
                        width: textFieldWidth,
                        child: PasswordWidget(
                          hintText: "Confirmar contraseña", 
                          obscureText: true,
                        )
                      )
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                    //MovilPhone 

                    Center(
                      child: SizedBox(
                        width: textFieldWidth,
                        child: FieldWidget(
                          keyboardType: TextInputType.phone,
                            hintText: "Número de teléfono", 
                            prefixIcon: Icon(Icons.phone),
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
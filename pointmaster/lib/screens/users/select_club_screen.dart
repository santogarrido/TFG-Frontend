import 'package:flutter/material.dart';

class SelectClubScreen extends StatefulWidget {
  const SelectClubScreen({super.key});

  @override
  State<SelectClubScreen> createState() => _SelectClubScreenState();
}

class _SelectClubScreenState extends State<SelectClubScreen> {
  @override
  Widget build(BuildContext context) {

    final spaceBetweenButtons = MediaQuery.of(context).size.height * 0.03;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height *0.001),
            child: Image.asset(
              "assets/images/LogoTFG.png",
              height: MediaQuery.of(context).size.height * 0.4,
              fit: BoxFit.contain,
            ),
          ),

          SizedBox(height: spaceBetweenButtons,),
          //Clubs list
          ...List.generate(5, (index){
                      return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Club ${index + 1}',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          }),
          
        ],
      )
    );
  }
}
import 'package:flutter/material.dart';

class SelectClubScreen extends StatefulWidget {
  const SelectClubScreen({super.key});

  @override
  State<SelectClubScreen> createState() => _SelectClubScreenState();
}

class _SelectClubScreenState extends State<SelectClubScreen> {
  @override
  Widget build(BuildContext context) {

      // Clubs list
    final List<String> clubs = ['Club 1', 'Club 2', 'Club 3', 'Club 4', 'Club 5', 'Club 6', 'Club 7'];
    
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text("PointMaster", style: TextStyle(color: Color(0xFFC4AD55))),
        leading: Padding(
          padding: EdgeInsets.only(left: width * 0.05),
          child: Container(
            width: width * 0.1,
            height: width * 0.1,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: width * 0.03,
                  offset: Offset(0, width * 0.01),
                ),
              ],
            ),
            child: RawMaterialButton(
              shape: CircleBorder(),  
              onPressed: () {},
              elevation: 0,
              fillColor: Colors.white,
              child: Icon(
                Icons.person,
                size: width * 0.055,
                color: Colors.black87,
              ),
            ),
          ),
        )
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: height * 0.02),
        itemCount: clubs.length,
        itemBuilder: (context, index) {
          final clubName = clubs[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.1),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: height * 0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                
              },
              child: Text(
                clubName,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 16),
      ),
    );
  }
}
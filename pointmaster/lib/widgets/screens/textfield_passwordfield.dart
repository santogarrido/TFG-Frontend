import 'package:flutter/material.dart';

// Widget for the password textfield
class PasswordWidget extends StatefulWidget {
  final String hintText;
  final bool obscureText;

  const PasswordWidget({
    super.key,
    required this.hintText,
    required this.obscureText,
  });

  @override
  PasswordWidgetState createState() => PasswordWidgetState();
}

class PasswordWidgetState extends State<PasswordWidget> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField( 
      obscureText: _obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.black,  // <-- Prueba este para ver si aparece
            width: 2,
          ),
        ),
        hintText: widget.hintText,
        filled: true,
        fillColor: Colors.white,
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}

class FieldWidget extends StatelessWidget {
  const FieldWidget({
    super.key,
    required String hintText,
    required Icon prefixIcon,

  }) : _hintText = hintText, _prefixIcon = prefixIcon;

  final String _hintText;
  final Icon _prefixIcon;


  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: _prefixIcon,
        hintText: _hintText,
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.black,  // <-- Prueba este para ver si aparece
            width: 2,
          ),
        ),
      ),
    );
  }
}
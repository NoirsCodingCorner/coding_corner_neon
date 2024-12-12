import 'package:coding_corner/NeonWidgets/NeonButton.dart';
import 'package:coding_corner/NeonWidgets/neonCard.dart';
import 'package:coding_corner/NeonWidgets/neonContainer.dart';
import 'package:coding_corner/NeonWidgets/neonProgressBar.dart';
import 'package:coding_corner/NeonWidgets/neonSlider.dart';
import 'package:coding_corner/NeonWidgets/neonText.dart';
import 'package:coding_corner/NeonWidgets/neonTextField.dart';
import 'package:coding_corner/StarBackground.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_firebase/auth.dart';

// Assuming these custom widgets are defined elsewhere in your project
// import 'neon_widgets.dart'; // Replace with your actual import path

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // State variable to track whether the user is on the login or registration form
  bool _isLogin = true;

  // Controllers for text fields (optional but recommended)
  final ValueNotifier<String> _email = ValueNotifier("");
  final ValueNotifier<String> _password = ValueNotifier("");
  final ValueNotifier<String> _username = ValueNotifier("");
  final ValueNotifier<String> _confirmPassword = ValueNotifier("");

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed
    _email.dispose();
    _password.dispose();
    _username.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  // Function to toggle between login and registration forms
  void _toggleForm() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  // Function to handle form submission (Login/Register)
  Future<void> _handleSubmit() async {
    if (_isLogin) {
      // Handle login logic
      String email = _email.value.trim();
      String password = _password.value.trim();
      // Add your login logic here
      print("Login with Email: $email, Password: $password");
      User? user= await Auth().signInWithEmail(email, password);
      print(user?.uid);

    } else {
      // Handle registration logic
      String username = _username.value.trim();
      String email = _email.value.trim();
      String password = _password.value.trim();
      String confirmPassword = _confirmPassword.value.trim();

      if (password != confirmPassword) {
        // Show error if passwords do not match
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Passwords do not match!"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Add your registration logic here
      User? user= await Auth().registerWithEmail(email, password);
      print(user?.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PulsingStarsBackground(
            spawnDuration: const Duration(milliseconds: 50),
            maxStars: 50,
          ),
          Center(
          child: Container(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("NeonText",style: TextStyle(color: Colors.white),), NeonText(text: "NeonText",)],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("NeonButton",style: TextStyle(color: Colors.white),), NeonButton(icon: Icons.abc, onPressed: () {},size: 60,neonColor: Colors.pink,)],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("NeonCard",style: TextStyle(color: Colors.white),), NeonCard(children: [Text("NeonCard",style: TextStyle(color: Colors.white))], neonColor: Colors.greenAccent)],
                  ),
                  SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("NeonContainer",style: TextStyle(color: Colors.white),), NeonContainer(neonColor: Colors.purpleAccent,child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("NeonContainer",style: TextStyle(color: Colors.white)),
                    ),)],
                  ),
                  SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("NeonSlider",style: TextStyle(color: Colors.white),), SizedBox(width: 100,height: 20,child: NeonSlider(segments: 5,neonColor: Colors.blueAccent, value: 0.5, onChanged: (double value) {  },))],
                  ),
                  SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("NeonProgressBar",style: TextStyle(color: Colors.white),), SizedBox(width: 100,height: 20,child: NeonProgressBar(progress: 0.5,neonColor: Colors.red,))],
                  ),
                  SizedBox(height: 20,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text("NeonTextField",style: TextStyle(color: Colors.white),), SizedBox(width: 100,height: 20,child: NeonTextField(neonColor: Colors.orangeAccent, textValue: ValueNotifier("ValueNotifier"),))],
                  ),
                ],
              ),
            )
            ,
          ),),
        ],
      ),
    );
  }
}

import 'package:app/pages/homePage.dart';
import 'package:app/pages/onBordingPage.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate() && _agreeToTerms) {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // الذهاب للصفحة الرئيسية بعد التسجيل
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred";
      if (e.code == 'email-already-in-use') {
        errorMessage = 'This email is already in use.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is invalid.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  } else if (!_agreeToTerms) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You must agree to the terms.')),
    );
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4B47F5),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Gap(100),
            const Text(
              "Sign Up",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(50),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Gap(50, 0),
                      _buildTextField(
                        hintText: "Email",
                        icon: Icons.email_outlined,
                        controller: emailController,
                        validator: (val) =>
                            val!.isEmpty || !val.contains("@")
                                ? "Enter valid email"
                                : null,
                      ),
                      Gap(15, 0),
                      _buildTextField(
                        hintText: "Enter password",
                        icon: Icons.lock_outline,
                        controller: passwordController,
                        obscure: _obscurePassword,
                        validator: (val) => val!.length < 6
                            ? "Password must be 6+ characters"
                            : null,
                        toggleVisibility: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      Gap(15, 0),
                      _buildTextField(
                        hintText: "Confirm password",
                        icon: Icons.lock_outline,
                        controller: confirmPasswordController,
                        obscure: _obscureConfirmPassword,
                        validator: (val) =>
                            val != passwordController.text
                                ? "Passwords do not match"
                                : null,
                        toggleVisibility: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      Gap(15, 0),
                      Row(
                        children: [
                          Checkbox(
                            value: _agreeToTerms,
                            onChanged: (val) {
                              setState(() {
                                _agreeToTerms = val ?? false;
                              });
                            },
                          ),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text:
                                    "By creating an account you agree with our ",
                                style: TextStyle(fontSize: 16),
                                children: [
                                  TextSpan(
                                    text: "Terms & Conditions.",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Gap(15, 0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: const Color(0xFF4B47F5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: _signUp,
                        child: const Text(
                          "SIGN UP",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Gap(15, 0),
                      Row(
                        children: const [
                          Expanded(child: Divider(thickness: 1)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text("Or"),
                          ),
                          Expanded(child: Divider(thickness: 1)),
                        ],
                      ),
                      Gap(15, 0),
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon:
                            Image.asset("images/google.png", height: 20),
                        label: const Text("Continue with Google"),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          side: const BorderSide(color: Colors.black12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.facebook, color: Colors.white),
                        label: const Text(
                          "Continue with Facebook",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4267B2),
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      Gap(15, 0),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: "Already have an account? ",
                            children: [
                              TextSpan(
                                text: "Sign In",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    required IconData icon,
    bool obscure = false,
    required TextEditingController controller,
    required String? Function(String?) validator,
    VoidCallback? toggleVisibility,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(141, 211, 211, 211),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixIcon: toggleVisibility != null
            ? IconButton(
                icon: Icon(obscure
                    ? Icons.visibility_off
                    : Icons.visibility),
                onPressed: toggleVisibility,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }
}


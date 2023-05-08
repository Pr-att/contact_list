import 'dart:convert';
import 'package:contact_list/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget with InputValidationMixin {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final _signInFormKey = GlobalKey<FormState>();
var _isSignUp = false;
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
var _passwordVisibility = false;

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isSignUp ? 'Sign Up' : 'Sign In',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 250,
                width: 300,
                child: Form(
                  key: _signInFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!widget.isEmailValid(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          ),
                          labelText: 'Email',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (!widget.isPasswordValid(value)) {
                            return 'Password must be 8 characters long';
                          }
                          return null;
                        },
                        obscureText: _passwordVisibility,
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide:
                                BorderSide(color: Colors.black, width: 2),
                          ),
                          labelText: 'Password',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: const Text("Forgot Password?"),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (_passwordVisibility) {
                                  _passwordVisibility = false;
                                } else {
                                  _passwordVisibility = true;
                                }
                              });
                            },
                            icon: _passwordVisibility
                                ? const Icon(Icons.visibility_off)
                                : const Icon(Icons.visibility),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_signInFormKey.currentState!.validate() == true) {
                    var status = _isSignUp
                        ? await AuthService().signUpUser(
                            email: _emailController.text,
                            password: _passwordController.text,
                            context: context)
                        : await AuthService().signInUser(
                            email: _emailController.text,
                            password: _passwordController.text,
                            context: context);
                    if (status == 200) {
                      Navigator.popAndPushNamed(context, '/home-screen');
                    }
                    // else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text(
                    //           "The password is invalid or the user does not have a password."),
                    //       duration: Duration(seconds: 2),
                    //     ),
                    //   );
                    // }
                  }
                },
                child:
                    _isSignUp ? const Text("Sign Up") : const Text("Sign In"),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    if (_isSignUp) {
                      _isSignUp = false;
                    } else {
                      _isSignUp = true;
                    }
                  });
                },
                child: _isSignUp
                    ? const Text("Already have an account? Sign In")
                    : const Text("Don't have an account? Sign Up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

mixin InputValidationMixin {
  bool isPasswordValid(String password) => password.length == 8;

  bool isEmailValid(String email) {
    RegExp regex = RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]');
    return regex.hasMatch(email);
  }
}

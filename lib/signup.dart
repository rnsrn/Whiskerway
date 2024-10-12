// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_mobile_whiskerway/login.dart';

// class SignupPage extends StatefulWidget {
//   const SignupPage({super.key});

//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: const Color(0xff006296),
//       body: Stack(
//         children: [
//           // Background Image
//           Container(
//             decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                   Color(0xff393939),
//                   Color(0xffbbbbbc),
//                   Color(0xff626363),
//                 ])),
//           ),
//           // Background Image
//           Positioned.fill(
//             child: Image.asset(
//               'images/PawCaresBg.png',
//               fit: BoxFit.scaleDown,
//               alignment: Alignment.center,
//               color: Colors.grey.withOpacity(0.3),
//               colorBlendMode: BlendMode.modulate,
//             ),
//           ),

//           // Page Content
//           SingleChildScrollView(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 40),
//               height: MediaQuery.of(context).size.height - 5,
//               width: double.infinity,
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     const Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           'Sign Up',
//                           style: TextStyle(
//                               fontSize: 40,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white),
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           'Welcome back!',
//                           style: TextStyle(fontSize: 25, color: Colors.grey),
//                         )
//                       ],
//                     ),
//                     const SizedBox(
//                       height: 30,
//                     ),
//                     Container(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 2, right: 2, bottom: 5),
//                             child: Container(
//                               padding: const EdgeInsets.all(10),
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(15),
//                                   color: Colors.grey.withOpacity(0.8)),
//                               child: Column(
//                                 children: <Widget>[
//                                   inputFile(
//                                     label: "Username",
//                                     controller: _usernameController,
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please enter your username';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                   inputFile(
//                                     label: "Email",
//                                     controller: _emailController,
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please enter your email';
//                                       }
//                                       // Add your email validation logic here
//                                       return null;
//                                     },
//                                   ),
//                                   inputFile(
//                                     label: "Password",
//                                     obscureText: _obscurePassword,
//                                     suffixIcon: _obscurePassword
//                                         ? Icons.visibility_off
//                                         : Icons.visibility,
//                                     controller: _passwordController,
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please enter your password';
//                                       }
//                                       // Add your password validation logic here
//                                       return null;
//                                     },
//                                     toggleVisibility: () {
//                                       setState(() {
//                                         _obscurePassword = !_obscurePassword;
//                                       });
//                                     },
//                                   ),
//                                   inputFile(
//                                     label: "Confirm Password",
//                                     obscureText: _obscureConfirmPassword,
//                                     suffixIcon: _obscureConfirmPassword
//                                         ? Icons.visibility_off
//                                         : Icons.visibility,
//                                     controller: _confirmPasswordController,
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Please confirm your password';
//                                       }
//                                       if (value != _passwordController.text) {
//                                         return 'Passwords do not match';
//                                       }
//                                       return null;
//                                     },
//                                     toggleVisibility: () {
//                                       setState(() {
//                                         _obscureConfirmPassword =
//                                             !_obscureConfirmPassword;
//                                       });
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 110),
//                     Padding(
//                       padding: const EdgeInsets.only(
//                         top: 30,
//                       ),
//                       child: Container(
//                         padding: const EdgeInsets.only(top: 3, left: 3),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(50),
//                         ),
//                         child: MaterialButton(
//                           minWidth: double.infinity,
//                           height: 75,
//                           onPressed: () {
//                             if (_formKey.currentState!.validate()) {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => const LoginPage()),
//                               );
//                             }
//                           },
//                           color: const Color(0xff013958),
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                           child: const Text(
//                             "Sign up",
//                             style: TextStyle(
//                               fontWeight: FontWeight.normal,
//                               fontSize: 18,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         const Text(
//                           "I have an account. ",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => const LoginPage()),
//                             );
//                           },
//                           child: const Text(
//                             "Login",
//                             style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 18,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget inputFile({
//     required String label,
//     bool obscureText = false,
//     IconData? suffixIcon,
//     required TextEditingController controller,
//     required String? Function(String?) validator,
//     VoidCallback? toggleVisibility,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Text(
//           label,
//           style: const TextStyle(
//               fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),
//         ),
//         const SizedBox(
//           height: 5,
//         ),
//         TextFormField(
//           controller: controller,
//           obscureText: obscureText,
//           validator: validator,
//           decoration: InputDecoration(
//             contentPadding:
//                 const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//             filled: true,
//             fillColor: Colors.white,
//             suffixIcon: obscureText
//                 ? IconButton(
//                     icon: Icon(suffixIcon),
//                     onPressed: toggleVisibility,
//                   )
//                 : IconButton(
//                     icon: Icon(suffixIcon),
//                     onPressed: toggleVisibility,
//                   ),
//             enabledBorder: const OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(32.0)),
//               borderSide: BorderSide(
//                 color: Colors.white,
//               ),
//             ),
//             border: const OutlineInputBorder(
//               borderRadius: BorderRadius.all(Radius.circular(32.0)),
//               borderSide: BorderSide(color: Colors.green),
//             ),
//           ),
//         ),
//         const SizedBox(
//           height: 10,
//         )
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_mobile_whiskerway/cons.dart';
import 'package:flutter_mobile_whiskerway/login.dart';
import 'package:flutter_mobile_whiskerway/mongodb.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mongo_dart/mongo_dart.dart' as mdb;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fname = TextEditingController();
  final TextEditingController lname = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController cpassword = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    fname.dispose();
    email.dispose();
    password.dispose();
    cpassword.dispose();
    super.dispose();
  }

  register() async {
    var db = await mdb.Db.create(MONGO_URL);
    await db.open();

    var collection = db.collection('users');
    await collection.insertOne({
      'firstname': fname.text,
      'lastname': lname.text,
      'password': password.text,
      'mobile': phone.text,
      'email': email.text,
      'pets': [],
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
      'role': 'user',
    });
  }

  final box = GetStorage();
  Future<void> registerUser() async {
    try {
      register();

      box.write('email', email.text);
      box.write('password', password.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registered Succesfully!'),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      // Handle registration failure
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xff006296),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color(0xff393939),
                  Color(0xffbbbbbc),
                  Color(0xff626363),
                ])),
          ),
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'images/PawCaresBg.png',
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              color: Colors.grey.withOpacity(0.3),
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          // Page Content
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              height: MediaQuery.of(context).size.height - 5,
              width: double.infinity,
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Welcome back!',
                            style: TextStyle(fontSize: 25, color: Colors.grey),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 2, right: 2, bottom: 5),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.grey.withOpacity(0.8)),
                                child: Column(
                                  children: <Widget>[
                                    inputFile(
                                      label: "First Name",
                                      controller: fname,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your first name';
                                        }
                                        return null;
                                      },
                                    ),
                                    inputFile(
                                      label: "Last Name",
                                      controller: lname,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your last name';
                                        }
                                        return null;
                                      },
                                    ),
                                    inputFile(
                                      label: "Contact Number",
                                      controller: phone,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your contact number';
                                        }
                                        return null;
                                      },
                                    ),
                                    inputFile(
                                      label: "Email",
                                      controller: email,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        // Add your email validation logic here
                                        return null;
                                      },
                                    ),
                                    inputFile(
                                      label: "Password",
                                      obscureText: _obscurePassword,
                                      suffixIcon: _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      controller: password,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your password';
                                        }
                                        // Add your password validation logic here
                                        return null;
                                      },
                                      toggleVisibility: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                    inputFile(
                                      label: "Confirm Password",
                                      obscureText: _obscureConfirmPassword,
                                      suffixIcon: _obscureConfirmPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      controller: cpassword,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please confirm your password';
                                        }
                                        if (value != password.text) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                      toggleVisibility: () {
                                        setState(() {
                                          _obscureConfirmPassword =
                                              !_obscureConfirmPassword;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 110),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 30,
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(top: 3, left: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 75,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                registerUser();
                              }
                            },
                            color: const Color(0xff013958),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Text(
                              "Sign up",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "I have an account. ",
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget inputFile({
    required String label,
    bool obscureText = false,
    IconData? suffixIcon,
    required TextEditingController controller,
    required String? Function(String?) validator,
    VoidCallback? toggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: Icon(suffixIcon),
                    onPressed: toggleVisibility,
                  )
                : null,
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}

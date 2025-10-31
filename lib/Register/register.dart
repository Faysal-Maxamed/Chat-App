import 'package:chat_app/Register/register_controller.dart';
import 'package:chat_app/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Consumer<RegisterController>(
      builder: (context, register, child) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Login Here",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        onChanged: (value) => register.getPhoneNumber(value),
                        decoration: InputDecoration(
                          hintText: "Enter Phone number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                       TextFormField(
                        onChanged: (value) => register.getEmail(value),
                        decoration: InputDecoration(
                          hintText: "Enter Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        obscureText: true,
                        onChanged: (value) => register.getPassword(value),
                        decoration: InputDecoration(
                          hintText: "Enter Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Forget password?",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      const SizedBox(height: 45),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text("I don't have any account!"),
                          Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => register.register(context),
                              child: const Text("Login"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

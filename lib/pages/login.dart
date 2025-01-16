
import 'package:expense_tracker_frontend1/pages/home_page.dart';
import 'package:expense_tracker_frontend1/viewmodels/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final bool _isLoading = false;

  void _login() async {
    // check the form is valid
    if (_formKey.currentState!.validate()) {
      bool success = await context.read<AuthViewmodel>().login(
            email: _emailController.text,
            password: _passwordController.text,
          );
      if (success) {
        if (context.mounted) {
          // Navigate to the home screen
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expenso',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<AuthViewmodel>(builder: (context, snapshot, _) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                snapshot.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        child: const Text('Login'),
                      ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don\'t have an account ?'),
                    TextButton(
                      onPressed: () {
                        /// Navigate to the register screen
                      },
                      child: const Text('Register'),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                SizedBox(
                  child: snapshot.isError
                      ? Text(
                          snapshot.errorMessage,
                          style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w700),
                        )
                      : null,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

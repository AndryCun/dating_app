import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dating_app/screens/sign_in_screen.dart';
import 'package:flutter/services.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
            ),
             SizedBox(height: 20),
             TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
              ),
            ),
             SizedBox(height: 20),
             TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
             TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10.0),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType
                    .number, // Tampilkan keyboard khusus untuk angka
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'No Telepon',
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              child: const Text('Daftar'),
              onPressed: () {
                _registerAccount();
              },
            )
          ],
        ),
      ),
    );
  }

  void _registerAccount() async {
    if (_usernameController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Mohon lengkapi semua kolom input sebelum mendaftar')));
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Password dan Konfirmasi Password Tidak Sama')));
      return;
    }
    
    try {
      // Buat pengguna dengan email dan password menggunakan Firebase Authentication
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      // Dapatkan pengguna yang saat ini terautentikasi
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;


        if (mounted) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const SignInScreen()));
        }
      } else {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'Tidak ada pengguna yang terautentikasi.',
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal Mendaftar : ${e.message}')));
      }
    }
  }
}
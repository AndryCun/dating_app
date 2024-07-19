import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dating_app/screens/edit_screen.dart';
import 'package:dating_app/screens/sign_in_screen.dart';
import 'package:dating_app/services/register.dart';
import 'package:dating_app/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SignOutService signOutService = SignOutService();
  final UserService userService = UserService();
  User? currentUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    currentUser = await userService.getCurrentUser();
    if (currentUser == null) {
      // Handle if user is not logged in
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
      );
    } else {
      setState(() {});  // Update state to reflect currentUser
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: currentUser == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: StreamBuilder<DocumentSnapshot>(
                stream: userService.getUserData(currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print("Snapshot data: ${snapshot.data?.data()}");  // Log data snapshot
                  }
                  if (snapshot.hasData && snapshot.data?.data() != null) {
                    final currentUserData =
                        snapshot.data?.data() as Map<String, dynamic>;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Uncomment if you want to display the avatar
                        // CircleAvatar(
                        //   radius: 50,
                        //   backgroundImage: currentUserData['imageUrl'] != null
                        //       ? NetworkImage(currentUserData['imageUrl'])
                        //       : const AssetImage('assets/images/default_avatar.png')
                        //           as ImageProvider,
                        // ),
                        const SizedBox(height: 20),
                        _buildProfileField(
                          label: 'Username',
                          value: currentUserData['username'] ?? '',
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 20),
                        _buildProfileField(
                          label: 'Phone Number',
                          value: currentUserData['phoneNumber'] ?? '',
                          icon: Icons.phone,
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const EditScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Edit',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 40),
                            backgroundColor: const Color.fromRGBO(27, 26, 85, 1),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: ElevatedButton(
                            onPressed: () async {
                              await signOutService.signOut();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const SignInScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Logout',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 40),
                              backgroundColor: const Color.fromRGBO(27, 26, 85, 1),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildProfileField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
    );
  }
}

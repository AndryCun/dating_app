import 'dart:io';
import 'package:dating_app/models/user.dart';
import 'package:dating_app/services/image.dart';
import 'package:dating_app/services/register.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  XFile? _imageFile;

  late User currentUser;
  late CollectionReference usersCollection;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    currentUser = FirebaseAuth.instance.currentUser!;
    usersCollection = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot userDoc = await usersCollection.doc(currentUser.uid).get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    _usernameController.text = userData['username'];
    _phoneNumberController.text = userData['phoneNumber'];
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = selectedImage;
    });
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      try {
        String? imageUrl;
        if (_imageFile != null) {
          imageUrl =
              await PostService.uploadImage(_imageFile!, 'foto_profile');
        }

        MyUser updatedUser = MyUser(
          id: currentUser.uid,
          username: _usernameController.text,
          phoneNumber: _phoneNumberController.text,
          imageUrl: imageUrl,
        );

        await RegistrationService.updateUser(updatedUser);
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(27, 26, 85, 1),
        title: const Text('Edit Profile'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.contain,
                      image: _imageFile != null
                          ? FileImage(File(_imageFile!.path))
                          : const AssetImage('assets/images/default_avatar.png')
                              as ImageProvider,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _usernameController,
                label: 'Full Name',
                icon: Icons.person,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _phoneNumberController,
                label: 'Phone Number',
                icon: Icons.phone,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProfile,
                child: const Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 40),
                  backgroundColor: const Color.fromRGBO(27, 26, 85, 1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}

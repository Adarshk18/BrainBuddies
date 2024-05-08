import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/app_export.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ProfileWidget(),
      ),
    );
  }
}

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late bool _isEditing = false;
  File? _image;
  late User? _user;
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();

    _getUserProfile();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _getUserProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      setState(() {
        _user = user;
        _nameController = TextEditingController(text: user?.displayName ?? '');
        _usernameController = TextEditingController(text: user?.displayName ?? '');
        _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
      });
    } catch (e) {
      // Error handling
      print('Error fetching user profile: $e');
    }
  }

  Future<void> _getImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _saveChanges() {
    // Save changes logic here
    if (_user != null) {
      _user!.updateDisplayName(_nameController.text);
      _user!.updatePhoneNumber(_phoneController.text as PhoneAuthCredential);
      // Saving profile image logic goes here
    }
    setState(() {
      _isEditing = false;
    });
  }

  Widget _buildTextFormField(
      String label,
      TextEditingController controller,
      IconData icon,
      ) {
    return TextFormField(
      controller: controller,
      readOnly: !_isEditing,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _animation,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _getImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _image != null ? FileImage(_image!) : null,
                ),
              ),
              SizedBox(height: 20),
              Text(
                _user!.email ?? 'No Email',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text('Dark Theme'),
                trailing: IconButton(
                  icon: Icon(
                    Icons.wb_sunny_outlined,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  onPressed: () {
                    ThemeMode mode =
                    Theme.of(context).brightness == Brightness.dark
                        ? ThemeMode.light
                        : ThemeMode.dark;
                    Provider.of<ThemeProvider>(context, listen: false)
                        .setThemeMode(mode);
                  },
                ),
              ),
              SizedBox(height: 20),
              _isEditing
                  ? _buildTextFormField(
                'Name',
                _nameController,
                Icons.person,
              )
                  : Text('Name: ${_nameController.text}'),
              SizedBox(height: 10),
              _isEditing
                  ? _buildTextFormField(
                'Username',
                _usernameController,
                Icons.person_outline,
              )
                  : Text('Username: ${_usernameController.text}'),
              SizedBox(height: 10),
              _isEditing
                  ? _buildTextFormField(
                'Phone',
                _phoneController,
                Icons.phone,
              )
                  : Text('Phone: ${_phoneController.text}'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
                child: Text(_isEditing ? 'Cancel' : 'Edit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}

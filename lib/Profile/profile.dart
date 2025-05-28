import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = "Gloria";
  String email = "user@gmail.com";
  String phone = "+60 123 456 789";
  File? _selectedImage;

  //handle image selection from gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  //handle username change
  Future<void> _changeUsername() async {
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Username'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter new username'),
          onChanged: (value) => userName = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, userName),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newName != null && newName.isNotEmpty) {
      setState(() {
        userName = newName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            children: [
              // Profile Avatar Section
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue.shade100,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha((0.3 * 255).toInt()),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                          )
                      ],
                    ),
                    child: ClipOval(
                      child: _selectedImage != null
                          ? Image.file(_selectedImage!, fit: BoxFit.cover)
                          : Image.asset(
                              'assets/images/photo111.jpg',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Username Section
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _changeUsername,
                    child: const Icon(
                      Icons.edit,
                      size: 20,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Contact Information Section
              _buildInfoCard(
                child: Column(
                  children: [
                    _buildInfoRow(
                      icon: Icons.email,
                      label: 'Email',
                      value: email,
                    ),
                    const Divider(height: 20, thickness: 1),
                    _buildInfoRow(
                      icon: Icons.phone,
                      label: 'Phone',
                      value: phone,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Action Buttons Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Orders Button
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.receipt,
                      label: 'My Orders',
                      onTap: () {
                        // Navigate to orders page
                      },
                    ),
                  ),
                  const SizedBox(width: 20),

                  // Favorites Button
                  Expanded(
                    child: _buildActionButton(
                      icon: Icons.star,
                      label: 'Favorites',
                      onTap: () {
                        // Navigate to favorites page
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable widget for info cards
  Widget _buildInfoCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.3 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  // Reusable widget for info rows (email/phone)
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Reusable widget for action buttons (orders/favorites)
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha((0.2 * 255).toInt()),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.blue),
            const SizedBox(height: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
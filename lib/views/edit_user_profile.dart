import 'package:flutter/material.dart';
import 'package:linktree/constants.dart';
import 'package:linktree/views/widgets/custom_text_form_field.dart';
import 'package:linktree/views/widgets/secondary_button_widget.dart';

import '../models/user.dart';

class EditUserProfile extends StatefulWidget {
  static String id = '/EditProfile';
  final Future<User> user;

  const EditUserProfile({super.key, required this.user});

  @override
  State<EditUserProfile> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.user.then((user) {
      nameController.text = user.user?.name ?? '';
      emailController.text = user.user?.email ?? '';
      countryController.text = user.user?.country ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightPrimaryColor,
        title: const Text(
          'Edit User Profile',
          style: TextStyle(fontSize: 16, color: kPrimaryColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage('assets/imgs/img.png'),
                ),
                CustomTextFormField(
                  controller: nameController,
                  hint: 'Dana AbuAlkhair',
                  keyboardType: TextInputType.text,
                  label: 'Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                CustomTextFormField(
                  controller: emailController,
                  label: 'Enter Your User Email',
                  hint: 'dana@gmail.com',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomTextFormField(
                  controller: countryController,
                  hint: 'Palestine',
                  label: 'Country',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your country';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SecondaryButtonWidget(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  text: 'SAVE',
                  width: 100,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

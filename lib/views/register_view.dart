import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linktree/assets.dart';
import 'package:linktree/controller/auth_conttroller.dart';
import 'package:linktree/views/home_view.dart';
import 'package:linktree/views/login_view.dart';
import 'package:linktree/views/widgets/custom_text_form_field.dart';
import 'package:linktree/views/widgets/secondary_button_widget.dart';

import '../../views/widgets/google_button_widget.dart';

class RegisterView extends StatefulWidget {
  static String id = '/registerView';

  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  void submit() {
    if (_formKey.currentState!.validate()) {
      final body = {
        "name": nameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "password_confirmation": passwordConfirmationController.text
      };
      register(body).then((user) {
        // Navigator.pushReplacementNamed(context, HomeView.id, arguments: user);
        Navigator.pushNamed(context, LoginView.id);
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
          //replace with our own icon data.
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Spacer(),
                  SizedBox(
                      height: MediaQuery.of(context).size.height / 8,
                      child: Hero(
                          tag: 'authImage',
                          child: SvgPicture.asset(AssetsData.authImage))),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomTextFormField(
                    controller: nameController,
                    hint: 'John Doe',
                    label: 'Name',
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  CustomTextFormField(
                    controller: emailController,
                    hint: 'example@gmail.com',
                    label: 'Email',
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  CustomTextFormField(
                    controller: passwordController,
                    hint: 'Enter password',
                    label: 'password',
                    password: true,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  CustomTextFormField(
                    controller: passwordConfirmationController,
                    hint: 'confirmation password',
                    label: 'confirmation password',
                    password: true,
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  SecondaryButtonWidget(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          submit();
                        }
                      },
                      text: 'REGISTER'),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    '-  or  -',
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 18,
                        fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  GoogleButtonWidget(onTap: () {}),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

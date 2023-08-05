import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:linktree/controller/auth_conttroller.dart';
import 'package:linktree/models/user.dart';
import 'package:linktree/views/main_app_view.dart';
import 'package:linktree/views/widgets/custom_text_form_field.dart';
import 'package:linktree/views/widgets/secondary_button_widget.dart';
import 'package:linktree/assets.dart';
import 'package:linktree/views/register_view.dart';
import 'package:linktree/views/widgets/primary_outlined_button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/google_button_widget.dart';

class LoginView extends StatefulWidget {
  static String id = '/loginView';

  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void submit() {
    if (_formKey.currentState!.validate()) {
      final body = {
        "email": emailController.text,
        "password": passwordController.text
      };
      login(body).then((user) async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', userToJson(user));
        if (mounted) {
          Navigator.pushNamed(context, MainAppView.id);
        }
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Spacer(),
                  SizedBox(
                      height: MediaQuery.of(context).size.height / 5,
                      child: Hero(
                          tag: 'authImage',
                          child: SvgPicture.asset(AssetsData.authImage))),
                  const Spacer(),
                  CustomTextFormField(
                    controller: emailController,
                    hint: 'example@gmail.com',
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    label: 'Email',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter the email';
                      } else if (!EmailValidator.validate(value)) {
                        return 'please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  CustomTextFormField(
                    controller: passwordController,
                    hint: 'Enter password',
                    label: 'password',
                    autofillHints: const [AutofillHints.password],
                    password: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter the password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  SecondaryButtonWidget(onTap: submit, text: 'LOGIN'),
                  const SizedBox(
                    height: 24,
                  ),
                  PrimaryOutlinedButtonWidget(
                      onTap: () {
                        Navigator.pushNamed(context, RegisterView.id);
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

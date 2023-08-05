import 'package:flutter/material.dart';
import 'package:linktree/constants.dart';
import 'package:linktree/models/Links.dart';
import 'package:linktree/views/widgets/custom_text_form_field.dart';
import 'package:linktree/views/widgets/secondary_button_widget.dart';

import '../controller/link_controller.dart';

class AddLink extends StatefulWidget {
  static String id = '/AddLink';
  final Links? linkData;
  final List<Links>? linksData;
  const AddLink({Key? key, this.linkData, this.linksData}) : super(key: key);

  @override
  State<AddLink> createState() => _AddLinkState();
}

class _AddLinkState extends State<AddLink> {
  TextEditingController titleController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.linkData != null) {
      titleController.text = widget.linkData!.title!;
      linkController.text = widget.linkData!.link!;
      userNameController.text = widget.linkData!.username!;
    }
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      final body = {
        "title": titleController.text,
        "link": linkController.text,
        "username": userNameController.text,
      };

      if (widget.linkData == null) {
        addLink(body).then((addedLink) {
          setState(() {
            widget.linksData?.add(addedLink);
          });
          Navigator.pop(context, addedLink);
        });
      } else {
        if (widget.linkData?.id != null) {
          editLink(widget.linkData!.id!, body).then((editedLink) {
            if (mounted) {
              Navigator.pop(context, editedLink);
            }
          });
        }
      }

      titleController.clear();
      linkController.clear();
      userNameController.clear();
      Navigator.pop(
        context,
        Links(
          title: body["title"]!,
          link: body["link"]!,
          username: body["username"]!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightPrimaryColor,
        title: const Text(
          'Add Link',
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
                CustomTextFormField(
                  controller: titleController,
                  hint: 'Instagram',
                  keyboardType: TextInputType.text,
                  label: 'Title',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                CustomTextFormField(
                  controller: userNameController,
                  hint: 'Enter Your User Name',
                  label: 'User Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomTextFormField(
                  controller: linkController,
                  hint: 'Enter Your Link',
                  label: 'Link',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter link';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SecondaryButtonWidget(
                  onTap: submit,
                  text: widget.linkData == null ? 'ADD' : 'SAVE',
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

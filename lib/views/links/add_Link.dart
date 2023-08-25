import 'package:flutter/material.dart';
import 'package:linktree/provider/link_provider.dart';
import 'package:linktree/core/utilies/constants.dart';
import 'package:linktree/models/link_response_model.dart';
import 'package:linktree/views/widgets/custom_text_form_field.dart';
import 'package:linktree/views/widgets/secondary_button_widget.dart';

class AddLink extends StatefulWidget {
  static String id = '/AddLink';
  final Link? linkData;

  const AddLink({Key? key, this.linkData}) : super(key: key);

  @override
  State<AddLink> createState() => _AddLinkState();
}

class _AddLinkState extends State<AddLink> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.linkData != null) {
      final linkData = widget.linkData!;
      titleController.text = linkData.title!;
      linkController.text = linkData.link!;
      userNameController.text = linkData.username!;
    }
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      if (widget.linkData == null) {
        LinkProvider().addLink(
          titleController.text,
          linkController.text,
          userNameController.text,
        );
      } else if (widget.linkData?.id != null) {
        LinkProvider().editLink(
          widget.linkData?.id!,
          titleController.text,
          linkController.text,
          userNameController.text,
        );
      }
      Navigator.of(context).pop();
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

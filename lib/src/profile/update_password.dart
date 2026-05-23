import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:laundrylane/src/apis/mutations.dart';
import 'package:laundrylane/widgets/password_input.dart';
import 'package:laundrylane/widgets/progress_button.dart';

class UpdatePassword extends StatefulWidget {
  static const String routeName = "/update-password";
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    // print(formKey.currentState?.getRawValue("newPassword"));
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Update Password")),
      body: FormBuilder(
        autovalidateMode: AutovalidateMode.onUserInteractionIfError,
        key: formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 32),
              Text(
                "Change Password",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              SizedBox(height: 8),
              Text(
                "Enter your current password and new password to update your password",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 48),
              Text(
                "Current Password",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 8),
              PasswordInput(
                name: "password",
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(6),
                  FormBuilderValidators.password(
                    checkNullOrEmpty: true,
                    minLength: 6,
                    minSpecialCharCount: 1,
                    minLowercaseCount: 1,
                    minNumberCount: 1,
                    minUppercaseCount: 1,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                "New Password",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 8),
              PasswordInput(
                name: "newPassword",
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(6),
                  FormBuilderValidators.password(
                    checkNullOrEmpty: true,
                    minLength: 6,
                    minSpecialCharCount: 1,
                    minLowercaseCount: 1,
                    minNumberCount: 1,
                    minUppercaseCount: 1,
                  ),
                ],
                onChanged: (p0) {
                  setState(() {});
                },
              ),
              SizedBox(height: 16),
              Text(
                "Confirm Password",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 8),
              PasswordInput(
                name: "confirmPassword",
                validators: [
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(6),
                  FormBuilderValidators.password(
                    checkNullOrEmpty: true,
                    minLength: 6,
                    minSpecialCharCount: 1,
                    minLowercaseCount: 1,
                    minNumberCount: 1,
                    minUppercaseCount: 1,
                  ),
                  FormBuilderValidators.equal(
                    formKey.currentState?.getRawValue("newPassword") ?? "",
                    errorText: "Password does not match",
                  ),
                ],
              ),
              SizedBox(height: 48),

              ProgressButton(
                onPress: () async {
                  if (formKey.currentState?.saveAndValidate() == true) {
                    Map formData = formKey.currentState!.value;
                    final response = await changePassword(
                      formData['password'],
                      formData['newPassword'],
                    );
                    if (response.success) {
                      formKey.currentState?.reset();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(response.message),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(response.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
                label: "Update Password",
                textStyle: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.white),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

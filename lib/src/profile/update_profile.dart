import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:laundrylane/models/auth_response.dart';
import 'package:laundrylane/providers/token_provider.dart';
import 'package:laundrylane/src/apis/mutations.dart';
import 'package:laundrylane/utils/constants.dart';
import 'package:laundrylane/widgets/progress_button.dart';

class UpdateProfile extends StatefulHookConsumerWidget {
  const UpdateProfile({super.key});
  static const String routeName = "/update-profile";

  @override
  ConsumerState<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends ConsumerState<UpdateProfile> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController dobController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider).value;
    print(user?.toJson());
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Edit Profile")),
      body: FormBuilder(
        initialValue: {
          "avatar": user?.avatar,
          "name": user?.name,
          "phone": user?.phone,
          "date_of_birth": user?.dateOfBirth,
          "email": user?.email,
          "userName": user?.userName,
          "gender": user?.gender,
        },
        key: _formKey,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(height: 24),
                FormBuilderField<String?>(
                  name: "avatar",
                  builder: (field) {
                    return Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(48),
                          ),
                          child: CircleAvatar(
                            radius: 48,
                            foregroundImage:
                                field.value != null && field.value != ""
                                    ? NetworkImage(field.value!)
                                    : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: ProgressButton(
                            builder: (isloading, setLoadingSate) {
                              return InkWell(
                                onTap: () async {
                                  setLoadingSate(true);
                                  XFile? pickedFile = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  if (pickedFile != null) {
                                    CloudinaryFile file =
                                        CloudinaryFile.fromFile(
                                          pickedFile.path,
                                        );

                                    CloudinaryResponse response =
                                        await cloudinary.uploadFile(file);
                                    field.didChange(response.secureUrl);
                                  }
                                  setLoadingSate(false);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(36),
                                  ),
                                  child:
                                      isloading
                                          ? CircularProgressIndicator.adaptive(
                                            backgroundColor: Colors.white,
                                          )
                                          : Icon(
                                            Icons.camera_alt_outlined,
                                            color: Colors.white,
                                            size: 22,
                                          ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 24),
                Text(
                  "${user?.name}",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 4),
                Text("${user?.email}"),
                SizedBox(height: 24),
                Divider(thickness: 1.5),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width:
                          Theme.of(
                            context,
                          ).inputDecorationTheme.border?.borderSide.width ??
                          1.2,
                      color: Color.fromRGBO(214, 214, 214, 1),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  child: FormBuilderTextField(
                    validator: FormBuilderValidators.required(),
                    name: "name",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      label: Text("Full name"),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width:
                                Theme.of(context)
                                    .inputDecorationTheme
                                    .border
                                    ?.borderSide
                                    .width ??
                                1.2,
                            color: Color.fromRGBO(214, 214, 214, 1),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 2,
                        ),
                        child: FormBuilderTextField(
                          validator: FormBuilderValidators.required(),
                          name: "gender",
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start,
                            label: Text("Gender"),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width:
                                Theme.of(context)
                                    .inputDecorationTheme
                                    .border
                                    ?.borderSide
                                    .width ??
                                1.2,
                            color: Color.fromRGBO(214, 214, 214, 1),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 2,
                        ),
                        child: FormBuilderField<DateTime?>(
                          name: "date_of_birth",
                          builder: (field) {
                            return TextField(
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: field.value ?? DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime.now(),
                                );
                                if (pickedDate != null) {
                                  field.didChange(pickedDate);
                                  dobController.text = Jiffy.parseFromDateTime(
                                    pickedDate,
                                  ).format(pattern: "dd-MM-yyyy");
                                }
                              },
                              readOnly: true,
                              controller: dobController,
                              decoration: InputDecoration(
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                floatingLabelAlignment:
                                    FloatingLabelAlignment.start,
                                label: Text("Birthday"),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width:
                          Theme.of(
                            context,
                          ).inputDecorationTheme.border?.borderSide.width ??
                          1.2,
                      color: Color.fromRGBO(214, 214, 214, 1),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  child: FormBuilderTextField(
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.phoneNumber(),
                    ]),
                    name: "phone",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      label: Text("Phone Number"),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width:
                          Theme.of(
                            context,
                          ).inputDecorationTheme.border?.borderSide.width ??
                          1.2,
                      color: Color.fromRGBO(214, 214, 214, 1),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  child: FormBuilderTextField(
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.email(),
                    ]),
                    name: "email",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      label: Text("Email address"),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      width:
                          Theme.of(
                            context,
                          ).inputDecorationTheme.border?.borderSide.width ??
                          1.2,
                      color: Color.fromRGBO(214, 214, 214, 1),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  child: FormBuilderTextField(
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                    name: "userName",
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      label: Text("Username"),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                ProgressButton(
                  onPress: () async {
                    if (_formKey.currentState!.saveAndValidate()) {
                      Map formData = _formKey.currentState!.value;
                      AuthResponse response = await updateUser(
                        email: formData["email"],
                        avatar: formData['avatar'],
                        gender: formData['gender'],
                        dateOfBirth: formData['date_of_birth'],
                        phone: formData['phone'],
                        name: formData['name'],
                        username: formData['userName'],
                      );
                      if (response.success) {
                        saveUserModel(response.user!);
                        ref.invalidate(userProvider);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(response.message),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(response.message),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  label: "Save",
                  textStyle: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
                SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

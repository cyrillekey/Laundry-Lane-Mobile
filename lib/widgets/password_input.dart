import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tabler_icons/tabler_icons.dart';
import 'package:zxcvbn/zxcvbn.dart';

class PasswordInput extends StatefulWidget {
  const PasswordInput({
    super.key,
    required this.name,
    this.showStrength = true,
    this.validators,
  });
  final bool showStrength;
  final List<String? Function(String)>? validators;
  final String name;
  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool obscure = true;
  PasswordStrength? strength;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormBuilderTextField(
          name: widget.name,
          obscureText: obscure,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.password(),
            FormBuilderValidators.required(),
            ...(widget.validators ?? []) as List,
          ]),
          keyboardType: TextInputType.visiblePassword,
          onChanged: (value) {
            if (value != null && value != "" && mounted) {
              setState(() {
                strength = checkPasswordStrengh(value);
              });
            }
          },
          decoration: InputDecoration(
            hintText: "****",
            hintStyle: GoogleFonts.almarai(),
            prefixIcon: Icon(TablerIcons.lock),
            filled: true,
            suffixIcon: InkWell(
              child: Icon(obscure ? TablerIcons.eye : TablerIcons.eye_off),
              onTap: () {
                setState(() {
                  obscure = !obscure;
                });
              },
            ),
            // fillColor: Color.fromRGBO(245, 248, 254, 1),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Color.fromRGBO(245, 248, 254, 1),
                width: 1.5,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Color.fromRGBO(245, 248, 254, 1),
                width: 1.5,
              ),
            ),
          ),
        ),
        if (widget.showStrength) SizedBox(height: 8),
        if (widget.showStrength && strength != null)
          Row(
            children: [
              PasswordStrengthCard(
                passwordStrength: strength,
                color:
                    strength == null
                        ? Color.fromRGBO(204, 208, 211, 1)
                        : strength == PasswordStrength.weak
                        ? Color.fromRGBO(219, 71, 101, 1)
                        : strength == PasswordStrength.moderate
                        ? Color.fromRGBO(250, 198, 40, 1)
                        : strength == PasswordStrength.strong
                        ? Color.fromRGBO(45, 111, 241, 1)
                        : Color.fromRGBO(89, 202, 166, 1),
              ),
              SizedBox(width: 6),
              PasswordStrengthCard(
                passwordStrength: strength,
                color:
                    strength == null || strength == PasswordStrength.weak
                        ? Color.fromRGBO(204, 208, 211, 1)
                        : strength == PasswordStrength.moderate
                        ? Color.fromRGBO(250, 198, 40, 1)
                        : strength == PasswordStrength.strong
                        ? Color.fromRGBO(45, 111, 241, 1)
                        : Color.fromRGBO(89, 202, 166, 1),
              ),
              SizedBox(width: 6),
              PasswordStrengthCard(
                passwordStrength: strength,
                color:
                    strength == null ||
                            strength == PasswordStrength.weak ||
                            strength == PasswordStrength.moderate
                        ? Color.fromRGBO(204, 208, 211, 1)
                        : strength == PasswordStrength.strong
                        ? Color.fromRGBO(45, 111, 241, 1)
                        : Color.fromRGBO(89, 202, 166, 1),
              ),
              SizedBox(width: 6),
              PasswordStrengthCard(
                passwordStrength: strength,
                color:
                    strength == null ||
                            strength == PasswordStrength.weak ||
                            strength == PasswordStrength.moderate ||
                            strength == PasswordStrength.strong
                        ? Color.fromRGBO(204, 208, 211, 1)
                        : Color.fromRGBO(89, 202, 166, 1),
              ),
            ],
          ),
        if (widget.showStrength && strength != null) SizedBox(height: 12),
        if (widget.showStrength && strength != null)
          Text(
            "Password strength: ${strength?.name}",
            style: GoogleFonts.almarai(color: Colors.black, fontSize: 14),
          ),
      ],
    );
  }
}

class PasswordStrengthCard extends StatelessWidget {
  const PasswordStrengthCard({
    super.key,
    this.passwordStrength,
    required this.color,
  });
  final PasswordStrength? passwordStrength;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
      ),
    );
  }
}

enum PasswordStrength { weak, strong, moderate, secure }

PasswordStrength checkPasswordStrengh(String password) {
  final result = (Zxcvbn()).evaluate(password);
  double score = result.score ?? 0.0;

  if (score >= 4) {
    return PasswordStrength.secure;
  } else if (score >= 3) {
    return PasswordStrength.strong;
  } else if (score >= 2) {
    return PasswordStrength.moderate;
  } else {
    return PasswordStrength.weak;
  }
}

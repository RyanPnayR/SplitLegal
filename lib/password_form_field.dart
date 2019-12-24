import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class PasswordFormField extends StatefulWidget {
  final String attribute;
  final String labelText;
  final TextStyle labelStyle;
  final TextStyle style;
  final List<String Function(dynamic)> validators;

  const PasswordFormField(
      {Key key,
      String attribute,
      String labelText,
      TextStyle labelStyle,
      TextStyle style,
      List<String Function(dynamic)> validators})
      : attribute = attribute,
        labelText = labelText,
        validators = validators,
        labelStyle = labelStyle,
        style = style,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _showPassword = true;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return FormBuilderTextField(
      attribute: widget.attribute,
      style: widget.style != null ? widget.style : theme.textTheme.display1,
      obscureText: _showPassword,
      decoration: InputDecoration(
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _showPassword = !_showPassword;
              });
            },
            child: Icon(
              _showPassword ? Icons.visibility : Icons.visibility_off,
            ),
          ),
          labelText: widget.labelText,
          labelStyle: widget.labelStyle != null ? widget.labelStyle : theme.inputDecorationTheme.labelStyle),
      validators: widget.validators +
          [
            FormBuilderValidators.minLength(8),
            FormBuilderValidators.required(),
          ],
    );
  }
}

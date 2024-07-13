import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:teach_app/core/custom_border_container.dart';
import 'package:teach_app/core/extensions.dart';
import 'package:teach_app/core/paddings_borders.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.suffixIcon,
    required this.controller,
    this.isPassword,
    this.prefixIcon,
    this.inputType,
    this.validator,
    this.inputAction,
    this.inputFormatters,
    this.autofocus,
    this.onChanged,
    this.margin,
  });
  final String hintText;
  final Widget? suffixIcon;
  final TextEditingController controller;
  final bool? isPassword;
  final Widget? prefixIcon;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final TextInputAction? inputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool? autofocus;
  final Function(String value)? onChanged;
  final EdgeInsetsGeometry? margin;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isVisible;

  @override
  void initState() {
    _isVisible = widget.isPassword ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return customContainer(
        margin: widget.margin,
        color: Colors.white,
        padding: PaddingConstant.paddingOnlyLeft,
        borderRadius: BorderRadiusConstant.borderRadiusMedium,
        context: context,
        child: ClipRRect(
          child: TextFormField(
            style: TextStyle(letterSpacing: (widget.isPassword ?? false) ? 4 : null),
            onChanged: widget.onChanged,
            autofocus: widget.autofocus ?? false,
            inputFormatters: widget.inputFormatters,
            controller: widget.controller,
            obscureText: _isVisible,
            keyboardType: widget.inputType,
            validator: widget.validator,
            textInputAction: widget.inputAction,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintStyle: context.textTheme.titleSmall?.copyWith(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
              border: InputBorder.none,
              contentPadding: PaddingConstant.paddingVertical,
              hintText: widget.hintText,
              icon: widget.prefixIcon,
              suffixIcon: (widget.isPassword ?? false)
                  ? PasswordVisibility(visibilityCallback: (isVisible) {
                      setState(() {
                        _isVisible = isVisible;
                      });
                    })
                  : widget.suffixIcon,
            ),
          ),
        ));
  }
}

class PasswordVisibility extends StatefulWidget {
  const PasswordVisibility({
    super.key,
    required this.visibilityCallback,
  });
  final Function(bool isVisible) visibilityCallback;

  @override
  State<PasswordVisibility> createState() => _PasswordVisibilityState();
}

class _PasswordVisibilityState extends State<PasswordVisibility> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isVisible = !_isVisible;
          widget.visibilityCallback.call(_isVisible);
        });
      },
      child: Container(
        constraints: BoxConstraints.loose(Size.zero),
        alignment: Alignment.center,
        child: AnimatedCrossFade(
            firstChild: const Icon(Icons.visibility_rounded, size: 25),
            secondChild: const Icon(Icons.visibility_off_rounded, size: 25),
            crossFadeState: _isVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 500)),
      ),
    );
  }
}

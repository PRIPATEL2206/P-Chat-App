import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController? textEditingController;
  final bool? ishide;
  final String? lableText;
  final String? initialText;
  final Icon? prefixIcon;
  final double? height;
  final String? hintText;
  final EdgeInsetsGeometry? margin;
  final void Function(String value)? onChange;
  final void Function()? onSubmit;
  final BorderRadius? borderRedius;
  final bool isOnDoneClear;
  final TextInputType? inputType;
  final TextInputAction? inputAction;

  const AppTextField(
      {super.key,
      this.textEditingController,
      this.ishide,
      this.lableText,
      this.prefixIcon,
      this.margin,
      this.onChange,
      this.onSubmit,
      this.height,
      this.hintText,
      this.initialText,
      this.borderRedius,
      this.isOnDoneClear = false,
      this.inputType,
      this.inputAction});

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController editingControler;
  @override
  void initState() {
    super.initState();
    editingControler = widget.textEditingController ??
        TextEditingController(text: widget.initialText);
  }

  @override
  void dispose() {
    super.dispose();
    editingControler.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // editingControler.
    return Container(
      height: widget.height,
      margin: widget.margin,
      child: TextField(
        textInputAction: widget.inputAction,
        keyboardType: widget.inputType,
        style: const TextStyle(decoration: TextDecoration.none),
        controller: editingControler,
        obscureText: widget.ishide ?? false,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: widget.borderRedius ?? BorderRadius.circular(25),
          ),
          labelText: widget.lableText,
          prefixIcon: widget.prefixIcon,
        ),
        onChanged: widget.onChange,
        onEditingComplete: () {
          if (widget.isOnDoneClear) {
            editingControler.clear();
          }
          if (widget.onSubmit != null) {
            widget.onSubmit!();
          }
        },
      ),
    );
  }
}

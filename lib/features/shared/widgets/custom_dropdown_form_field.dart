import 'package:flutter/material.dart';

class CustomDropdownButtonFormField<T> extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorMessage;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final Widget? suffixIcon;
  final Color? labelColor;
  final bool enableWriting;

  const CustomDropdownButtonFormField({
    super.key,
    this.label,
    this.hint,
    this.errorMessage,
    this.value,
    required this.items,
    this.onChanged,
    this.suffixIcon,
    this.labelColor,
    this.enableWriting = true,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(40),
    );

    return Container(
      padding: const EdgeInsets.only(bottom: 5, top: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<T>(
              decoration: InputDecoration(
                floatingLabelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
                enabledBorder: border,
                focusedBorder: border,
                errorBorder: border.copyWith(
                    borderSide: const BorderSide(color: Colors.transparent)),
                focusedErrorBorder: border.copyWith(
                    borderSide: const BorderSide(color: Colors.transparent)),
                disabledBorder: border.copyWith(
                    borderSide: const BorderSide(color: Colors.transparent)),
                isDense: true,
                label: label != null ? Text(label!) : null,
                hintText: hint,
                errorText: errorMessage,
                focusColor: Theme.of(context).colorScheme.primary,
                suffixIcon: suffixIcon,
                labelStyle: TextStyle(color: labelColor),
              ),
              value: value,
              items: items,
              onChanged: enableWriting ? onChanged : null,
              style: const TextStyle(fontSize: 20, color: Colors.black54),
              dropdownColor: Colors.white,
              icon: const Icon(Icons.arrow_downward,
                  color: Color.fromRGBO(89, 89, 89, 1)),
              isExpanded: true, // Ensure the dropdown expands to fit the content
            ),
          ),
        ],
      ),
    );
  }
}

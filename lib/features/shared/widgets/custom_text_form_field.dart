import 'package:flutter/material.dart';


class CustomTextFormField extends StatelessWidget {

  final String? label;
  final String? hint;
  final String? errorMessage;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String initialValue;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Color? labelColor;
  final bool
      enableWriting; // New property to enable or disable writing abilities

  const CustomTextFormField({
    super.key, 
    this.label, 
    this.hint, 
    this.errorMessage, 
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.initialValue = '',
    this.onChanged, 
    this.onFieldSubmitted, 
    this.validator,
    this.suffixIcon,
    this.labelColor,
    this.enableWriting = true, // Default value is true
  });
  

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(40)
    );

    const borderRadius = Radius.circular(15);

    return Container(
      padding: const EdgeInsets.only(bottom: 5, top: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(topLeft: borderRadius, bottomLeft: borderRadius, bottomRight: borderRadius ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0,5)
          )
        ]
      ),
      child: TextFormField(
        onChanged: enableWriting
            ? onChanged
            : null,
        onFieldSubmitted: enableWriting
            ? onFieldSubmitted
            : null,
        validator: enableWriting
            ? validator
            : null,
        enabled: enableWriting,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle( fontSize: 20, color: Colors.black54 ),
        initialValue: initialValue,
        decoration: InputDecoration(
          floatingLabelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          enabledBorder: border,
          focusedBorder: border,
          errorBorder: border.copyWith( borderSide: const BorderSide( color: Colors.transparent )),
          focusedErrorBorder: border.copyWith( borderSide: const BorderSide( color: Colors.transparent )),
          disabledBorder: border.copyWith(borderSide: const BorderSide(color: Colors.transparent)),
          isDense: true,
          label: label != null ? Text(label!) : null,
          hintText: hint,
          errorText: errorMessage,
          focusColor: colors.primary,
          suffixIcon: suffixIcon,
          labelStyle: TextStyle(
          color: labelColor),
          // icon: Icon( Icons.supervised_user_circle_outlined, color: colors.primary, )
        ),
      ),
    );
  }
}

class DatePickerFormField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? errorMessage;
  final String? initialValue;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final Color? labelColor;

  const DatePickerFormField({
    super.key,
    this.label,
    this.hint,
    this.errorMessage,
    this.initialValue,
    this.onChanged,
    this.onFieldSubmitted,
    this.labelColor,
  });

  @override
  _DatePickerFormFieldState createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  late TextEditingController _controller;
  late DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate =
        widget.initialValue != '' ? DateTime.parse(widget.initialValue!) : null;
    _controller = TextEditingController(
      text: _selectedDate != null ? _selectedDate.toString().split(' ')[0] : '',
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(40),
    );

    const borderRadius = Radius.circular(15);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: borderRadius,
            bottomLeft: borderRadius,
            bottomRight: borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Stack(
        children: [
          TextFormField(
            readOnly: true,
            controller: _controller,
            onTap: () {
              _selectDate(context);
            },
            style: const TextStyle(fontSize: 20, color: Colors.black54),
            decoration: InputDecoration(
              floatingLabelStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              isDense: true,
              label: widget.label != null ? Text(widget.label!) : null,
              hintText: widget.hint,
              errorText: widget.errorMessage,
              focusColor: colors.primary,
              suffixIcon: _selectedDate != null
                  ? IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedDate = null;
                          _controller.clear();
                        });
                        widget.onChanged?.call('');
                        widget.onFieldSubmitted?.call('');
                      },
                    )
                  : const Icon(Icons.calendar_today),
              labelStyle: TextStyle(color: widget.labelColor),
              enabledBorder: border,
              focusedBorder: border,
              errorBorder: border.copyWith(
                  borderSide: const BorderSide(color: Colors.transparent)),
              focusedErrorBorder: border.copyWith(
                  borderSide: const BorderSide(color: Colors.transparent)),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _controller.text = _selectedDate.toString().split(' ')[0];
      });
      widget.onChanged?.call(_controller.text);
      widget.onFieldSubmitted?.call(_controller.text);
    }
  }
  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDate ?? DateTime.now(),
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime(2100),
  //   );
  //   if (picked != null && picked != _selectedDate) {
  //     setState(() {
  //       _selectedDate = picked;
  //       // Formato día, mes, año
  //       _controller.text = "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
  //     });
  //     widget.onChanged?.call(_controller.text);
  //     widget.onFieldSubmitted?.call(_controller.text);
  //   }
  // }

}


class CustomAutofillTextFormField extends StatelessWidget {

  final String? label;
  final String? hint;
  final String? errorMessage;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Color? labelColor;
  final bool enableWriting; 

  const CustomAutofillTextFormField({
    super.key, 
    this.label, 
    this.hint, 
    this.errorMessage, 
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.onChanged, 
    this.onFieldSubmitted, 
    this.validator,
    this.suffixIcon,
    this.labelColor,
    this.enableWriting = true,
  });
  

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;

    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(40)
    );

    const borderRadius = Radius.circular(15);

    return Container(
      padding: const EdgeInsets.only(bottom: 5, top: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(topLeft: borderRadius, bottomLeft: borderRadius, bottomRight: borderRadius ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0,5)
          )
        ]
      ),
      child: TextFormField(
        onChanged: enableWriting
            ? onChanged
            : null,
        onFieldSubmitted: enableWriting
            ? onFieldSubmitted
            : null,
        validator: enableWriting
            ? validator
            : null,
        enabled: enableWriting,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle( fontSize: 20, color: Colors.black54 ),
        controller: controller,
        decoration: InputDecoration(
          floatingLabelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          enabledBorder: border,
          focusedBorder: border,
          errorBorder: border.copyWith( borderSide: const BorderSide( color: Colors.transparent )),
          focusedErrorBorder: border.copyWith( borderSide: const BorderSide( color: Colors.transparent )),
          disabledBorder: border.copyWith(borderSide: const BorderSide(color: Colors.transparent)),
          isDense: true,
          label: label != null ? Text(label!) : null,
          hintText: hint,
          errorText: errorMessage,
          focusColor: colors.primary,
          suffixIcon: suffixIcon,
          labelStyle: TextStyle(
          color: labelColor),
        ),
      ),
    );
  }
}
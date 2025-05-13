import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneNumberInput extends StatefulWidget {
  final TextEditingController phoneController;

  const PhoneNumberInput({super.key, required this.phoneController});
  @override
  _PhoneNumberInputState createState() => _PhoneNumberInputState();
}

class _PhoneNumberInputState extends State<PhoneNumberInput> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log(widget.phoneController.text);
  }

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      // controller: widget.phoneController,
      initialValue: widget.phoneController.text,
      decoration: InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
      initialCountryCode: 'IN', // Set default country
      onCountryChanged: (value) => log(value.code),
      onChanged: (phone) {
        setState(() {
          widget.phoneController.text = phone.completeNumber;
        });
      },
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Allow only numbers
      ],
    );
  }
}

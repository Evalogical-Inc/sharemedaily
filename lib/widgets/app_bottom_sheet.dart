import 'package:flutter/material.dart';

class AppBottomSheet {
  static void showBottomSheet({
    required BuildContext context,
    required Widget body,
    bool isScrollControlled = false,
  }) {
    showModalBottomSheet(
      isScrollControlled: isScrollControlled,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(26),
          topRight: Radius.circular(26),
        ),
      ),
      context: context,
      builder: (context) {
        return body;
      },
    );
  }
}

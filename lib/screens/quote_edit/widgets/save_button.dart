import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaveButton extends StatefulWidget {
  final Function() onSave;
  const SaveButton({Key? key, required this.onSave}) : super(key: key);

  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  bool isLoading = false;

  Future<void> _handleSave() async {
    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 1)); // Simulating save action

    widget.onSave(); // Call the actual save function

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleSave,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: isLoading ? Colors.grey : Colors.blueAccent,
          elevation: isLoading ? 0 : 5,
          shadowColor: Colors.black54,
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.save, size: 12, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    "Save",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

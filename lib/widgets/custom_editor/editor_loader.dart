import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotify/provider/editor_provider.dart';
import 'package:quotify/routes/route_names.dart';

class EditorLoader extends StatefulWidget {
  const EditorLoader({super.key});

  @override
  State<EditorLoader> createState() => _EditorLoaderState();
}

class _EditorLoaderState extends State<EditorLoader> {
  late EditProvider editProvider;

  @override
  void initState() {
    super.initState();
     editProvider = Provider.of<EditProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      editProvider.addListener(_onStatusChange);
    });
  }

  void _onStatusChange() {
    Navigator.pop(context); // Close the current screen
    Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.landing, (route) => false,
        arguments: {"showEdited": true});
  }

  @override
  void dispose() {
    editProvider.removeListener(_onStatusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      ),
    );
  }
}

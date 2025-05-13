import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotify/widgets/custom_editor/story_maker_provider.dart';

class TextEditor extends StatefulWidget {
  final String fontFamily;
  const TextEditor({super.key, required this.fontFamily});

  @override
  State<TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  late StoryMakerProvider storyMakerProvider;
  late TextEditingController textEditingController;
  var content = "";

  @override
  void initState() {
    super.initState();
    storyMakerProvider = Provider.of<StoryMakerProvider>(
      context,
      listen: false,
    );
    textEditingController = TextEditingController(
      text: storyMakerProvider.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double contentWidth = MediaQuery.of(context).size.width - 40;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: SizedBox(),
        actions: [
          TextButton(
            onPressed: () {
              storyMakerProvider.isEditorEnabled = false;
              Navigator.pop(context);
            },
            child: Text(
              "Done",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(10),
        child: Consumer<StoryMakerProvider>(
          builder: (context, data, _) {
            return Stack(
              children: [
                Center(
                  child: Hero(
                    tag: "txt",
                    child: Material(
                      color: Colors.transparent,
                      child: ConstrainedBox(
                        
                        constraints: BoxConstraints(minWidth: 50, maxWidth:  contentWidth -150),
                        child: IntrinsicWidth(
                          
                          child: TextFormField(
                            controller: textEditingController,
                            autofocus: true,
                            maxLines: null,
                            cursorColor: Colors.lightBlueAccent,
                            textAlign: data.textAlign,
                            style: TextStyle(
                              inherit: true,
                              fontFamily: widget.fontFamily,
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              data.text = textEditingController.text;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

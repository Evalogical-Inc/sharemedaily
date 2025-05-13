// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:pro_image_editor/pro_image_editor.dart';
// import 'package:pro_image_editor/shared/services/import_export/export_state_history.dart';
// import 'package:provider/provider.dart';
// import 'package:quotify/config/constants/colors.dart';
// import 'package:quotify/config/constants/spacing.dart';
// import 'package:quotify/provider/editor_provider.dart';
// import 'package:quotify/screens/quote_edit/widgets/save_button.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import './editor_helper.dart';

// class QuoteArguments {
//   final String tagName;
//   final String imagePath;
//   final String imageAuthor;
//   final String quote;
//   final dynamic editJson;
//   final int? editId;

//   QuoteArguments(
//       {this.editId,
//       required this.imagePath,
//       required this.imageAuthor,
//       required this.quote,
//       required this.tagName,
//       this.editJson = ''});
// }

// class QuoteEdit extends StatefulWidget {
//   final QuoteArguments arguments;
//   const QuoteEdit({super.key, required this.arguments});

//   @override
//   State<QuoteEdit> createState() => _QuoteEditState();
// }

// class _QuoteEditState extends State<QuoteEdit> with EditorExampleState {
//   Map<String, dynamic> savedData = {};
//   late ProImageEditorState editorState;
//   final List<TextStyle> _customTextStyles = [
//     GoogleFonts.roboto(fontWeight: FontWeight.w500),
//     GoogleFonts.averiaLibre(),
//     GoogleFonts.lato(),
//     GoogleFonts.comicNeue(),
//     GoogleFonts.actor(),
//     GoogleFonts.odorMeanChey(),
//     GoogleFonts.tinos(),
//     GoogleFonts.lexendGiga(),
//     GoogleFonts.pacifico(),
//     GoogleFonts.meowScript(),
//     GoogleFonts.barrio(),
//     GoogleFonts.kablammo(),
//     GoogleFonts.lavishlyYours(),
//     GoogleFonts.ballet(),
//     GoogleFonts.tangerine(),
//     GoogleFonts.shadowsIntoLight(),
//     GoogleFonts.sixtyfour(),
//     GoogleFonts.foldit(),
//     GoogleFonts.bungeeSpice()
//   ];

//   @override
//   initState() {
//     // _getJsonData();
//     // textKey = GlobalKey(); // Initialize the key for measuring text
//     // EditProvider editProvider = Provider.of<EditProvider>(context, listen: false);
//     // log(editProvider.editData.toString());
//     super.initState();
//   }

//   Future<String> saveImageToDownloads(Uint8List bytes) async {
//     try {
//       // Request storage permission (for Android 10 and below)
//       if (await Permission.storage.request().isDenied) {
//         print("Storage permission denied");
//         return '';
//       }

//       // Get the Downloads directory
//       Directory? downloadsDirectory = Directory('/storage/emulated/0/Download');

//       if (!downloadsDirectory.existsSync()) {
//         downloadsDirectory = await getExternalStorageDirectory(); // Fallback
//       }

//       String filePath =
//           '${downloadsDirectory?.path}/share_me_daily_${DateTime.now().millisecondsSinceEpoch}.jpg';

//       // Save the file
//       File file = File(filePath);
//       await file.writeAsBytes(bytes);

//       print('✅ Image saved at: $filePath');
//       return filePath;
//     } catch (e) {
//       print('❌ Error saving image: $e');
//       return '';
//     }
//   }

//   void _showBottomSheet(BuildContext context, ProImageEditorState editor) {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: Icon(Icons.copy, color: Colors.blue),
//                 title: Text("Save a Copy"),
//                 onTap: () {
//                   editor.doneEditing();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       behavior: SnackBarBehavior.floating,
//                       content: Text('Image Saved Successfully'),
//                     ),
//                   );
//                   // Navigator.pop(context);
//                   // Handle "Save a Copy" action here
//                 },
//               ),
//               // ListTile(
//               //   leading: Icon(Icons.share, color: Colors.green),
//               //   title: Text("Share Image"),
//               //   onTap: () async {
//               //     Navigator.pop(context);
//               //     _shareImage();
//               //   },
//               // ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Future<File> convertBytesToFile(Uint8List bytes, String filename) async {
//     final directory = await getTemporaryDirectory();
//     final filePath = '${directory.path}/$filename';
//     File file = File(filePath);
//     await file.writeAsBytes(bytes);
//     return file;
//   }

//   // void _shareImage() async {
//   //   // Replace with your image path (ensure the image exists)
//   //   String imagePath = "/storage/emulated/0/Download/sample_image.jpg";

//   //   try {
//   //     await Share.shareUri([imagePath], text: "Check out this image!");
//   //   } catch (e) {
//   //     print("Error sharing image: $e");
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<EditProvider>(builder: (context, dataClass, _) {
//       return Scaffold(
//           body: ProImageEditor.network(
//             key: editorKey,
//             widget.arguments.imagePath,
//             callbacks: ProImageEditorCallbacks(onImageEditingStarted: () {
//               log('Image editing started');
//             }, onImageEditingComplete: (Uint8List bytes) async {
//               log('image editing completed');

//               var history = await editorState.exportStateHistory(
//                 configs: const ExportEditorConfigs(
//                     historySpan: ExportHistorySpan.current
//                     // configs...
//                     ),
//               );
//               var dt = await history.toMap();
//               EditProvider editProvider =
//                   Provider.of<EditProvider>(context, listen: false);
//               File imageFile =
//                   await convertBytesToFile(bytes, "edited_image.jpg");
//               log(imageFile.toString());
//               await editProvider.addToEditQuotes(
//                   quote: widget.arguments.quote,
//                   quoteImage: widget.arguments.imagePath,
//                   imageAuthor: widget.arguments.imageAuthor,
//                   categoryId: 0,
//                   quoteEditThumbnail: imageFile,
//                   quoteEditJson: dt,
//                   editId: widget.arguments.editId);
//               String savedPath = await saveImageToDownloads(bytes);
//               if (savedPath.isNotEmpty) {
//                 log('Image saved at: $savedPath');
//               }
//               // Navigator.pop(context);
//               // log('Image editing complete ${bytes}');
//               /*
//                    Your code to handle the edited image. Upload it to your server as an example.
//                    You can choose to use await, so that the loading-dialog remains visible until your code is ready, or no async, so that the loading-dialog closes immediately.
//                    By default, the bytes are in `jpg` format.
//                   */
//             }),
//             configs: ProImageEditorConfigs(
//               i18n: const I18n(
//                 various: I18nVarious(),
//                 paintEditor: I18nPaintEditor(),
//                 textEditor: I18nTextEditor(),
//                 cropRotateEditor: I18nCropRotateEditor(),
//                 filterEditor: I18nFilterEditor(filters: I18nFilters()),
//                 emojiEditor: I18nEmojiEditor(),
//                 stickerEditor: I18nStickerEditor(),
//                 // More translations...
//               ),
//               mainEditor: MainEditorConfigs(
//                 widgets: MainEditorWidgets(
//                   appBar: (editor, rebuildStream) {
//                     return ReactiveAppbar(
//                         builder: (_) => _buildAppBar(editor),
//                         stream: rebuildStream);
//                   },
//                 ),
//                 enableCloseButton: true,
//               ),
//               emojiEditor: const EmojiEditorConfigs(enabled: false),
//               paintEditor: const PaintEditorConfigs(enabled: false),
//               textEditor: TextEditorConfigs(
//                 showSelectFontStyleBottomBar: true,
//                 customTextStyles: _customTextStyles,
//               ),
//               cropRotateEditor: const CropRotateEditorConfigs(
//                 transformLayers: false,
//                 canChangeAspectRatio: false,
//                 initAspectRatio: 9.0 / 16.0,
//                 aspectRatios: [
//                   AspectRatioItem(text: '9*16', value: 9.0 / 16.0)
//                 ],
//               ),
//               filterEditor: const FilterEditorConfigs(enabled: false),
//               stateHistory: StateHistoryConfigs(
//                   initStateHistory: ImportStateHistory.fromJson(
//                 widget.arguments.editJson.isEmpty
//                     ? dataClass.getEditData(widget.arguments.quote)
//                     : widget.arguments.editJson,
//                 configs: ImportEditorConfigs(
//                   recalculateSizeAndPosition: true,
//                   mergeMode: ImportEditorMergeMode.replace,
//                   widgetLoader: (
//                     String id, {
//                     Map<String, dynamic>? meta,
//                   }) {
//                     switch (id) {
//                       case 'my-special-container':
//                         return Container(
//                           width: 100,
//                           height: 100,
//                           color: Colors.amber,
//                         );

//                       /// ... other widgets
//                     }
//                     throw ArgumentError(
//                       'No widget found for the given id: $id',
//                     );
//                   },
//                 ),
//               )),
//             ),
//           ));
//     });
//   }

//   AppBar _buildAppBar(ProImageEditorState editor) {
//     return AppBar(
//       automaticallyImplyLeading: false,
//       foregroundColor: Colors.white,
//       backgroundColor: Colors.black,
//       actions: [
//         if (!isDesktopMode(context))
//           IconButton(
//               tooltip: 'Cancel',
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               icon: const Icon(Icons.arrow_back),
//               onPressed: editor.closeEditor),
//         const Text('Edit Quote',style: TextStyle(fontSize: 20),),
//         const Spacer(),
//         // IconButton(
//         //   tooltip: 'My Button',
//         //   color: Colors.amber,
//         //   padding: const EdgeInsets.symmetric(horizontal: 8),
//         //   icon: const Icon(
//         //     Icons.bug_report,
//         //     color: Colors.amber,
//         //   ),
//         //   onPressed: () {},
//         // ),
//         IconButton(
//           tooltip: 'Undo',
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//           icon: Icon(
//             Icons.undo,
//             color: editor.canUndo == true
//                 ? Colors.white
//                 : Colors.white.withAlpha(80),
//           ),
//           onPressed: editor.undoAction,
//         ),
//         IconButton(
//           tooltip: 'Redo',
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//           icon: Icon(
//             Icons.redo,
//             color: editor.canRedo == true
//                 ? Colors.white
//                 : Colors.white.withAlpha(80),
//           ),
//           onPressed: editor.redoAction,
//         ),
//         SaveButton(onSave: () {
//           setState(() {
//             editorState = editor;
//           });
//           editor.doneEditing();
//         }),
//         // IconButton(
//         //   icon: Icon(Icons.more_vert), // Three-dot vertical menu
//         //   onPressed: () => _showBottomSheet(context, editor),
//         // ),
//         // IconButton(
//         //   tooltip: 'Done',
//         //   padding: const EdgeInsets.symmetric(horizontal: 8),
//         //   icon: const Icon(Icons.done),
//         //   iconSize: 28,
//         //   onPressed: () async {
//         //     var history = await editor.exportStateHistory(
//         //       configs: const ExportEditorConfigs(
//         //           historySpan: ExportHistorySpan.current
//         //           // configs...
//         //           ),
//         //     );
//         //     var dt = await history.toMap();
//         //     EditProvider editProvider =
//         //         Provider.of<EditProvider>(context, listen: false);
//         //     editProvider.addToEditQuotes(
//         //         quote: widget.arguments.quote,
//         //         quoteImage: widget.arguments.imagePath,
//         //         categoryId: 0,
//         //         quoteEditJson: dt,
//         //         editId: widget.arguments.editId);
//         //     // editProvider.setEditData(dt);
//         //     // await _writeToDownloads('history.json', history);
//         //     // debugPrint(await history.toJson());
//         //     // editor.doneEditing();
//         //   },
//         // ),
//       ],
//     );
//   }

//   Future<void> _writeToDownloads(
//       String fileName, ExportStateHistory history) async {
//     try {
//       // Request storage permission
//       if (await Permission.manageExternalStorage.request().isGranted) {
//         // Get the Downloads directory path (Android only)
//         var data = await history.toJson();
//         Directory? downloadsDir = Directory('/storage/emulated/0/Download');

//         if (!downloadsDir.existsSync()) {
//           debugPrint('Downloads directory not found!');
//           return;
//         }

//         File file = File('${downloadsDir.path}/$fileName');

//         // Write or append to the log file
//         await file.writeAsString('$data\n', mode: FileMode.append);
        
//         debugPrint('Log saved to: ${file.path}');
//       } else {
//         debugPrint('Storage permission denied');
//       }
//     } catch (e) {
//       debugPrint('Error writing log file: $e');
//     }
//   }

//   // Future<Map<String, dynamic>?> _getJsonData() async {
//   //   SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   String? history = prefs.getString('history');
//   //   log(history.toString());
//   //   if (history != null) {
//   //     try {
//   //       setState(() {
//   //         savedData = {
//   //           "v": "5.0.0",
//   //           "m": true,
//   //           "p": 2,
//   //           "h": [
//   //             {
//   //               "t": {
//   //                 "angle": 0.0,
//   //                 "cropRect": {
//   //                   "left": 103.21428571428572,
//   //                   "top": 0.0,
//   //                   "right": 227.0714285714286,
//   //                   "bottom": 220.1904761904762
//   //                 },
//   //                 "originalSize": {
//   //                   "width": 330.28571428571433,
//   //                   "height": 220.1904761904762
//   //                 },
//   //                 "cropEditorScreenRatio": 0.47572016460905353,
//   //                 "scaleUser": 1.0,
//   //                 "scaleRotation": 1.0,
//   //                 "aspectRatio": 0.5625,
//   //                 "flipX": false,
//   //                 "flipY": false,
//   //                 "offset": {"dx": 0.0, "dy": 0.0}
//   //               }
//   //             },
//   //             {
//   //               "l": [
//   //                 {"id": "A"}
//   //               ]
//   //             },
//   //             {
//   //               "l": [
//   //                 {"id": "A", "x": -4.997767857142833, "y": 48.135044642857224}
//   //               ]
//   //             }
//   //           ],
//   //           "r": {
//   //             "A": {
//   //               "x": 0.0,
//   //               "y": 0.0,
//   //               "r": 0.0,
//   //               "s": 1.0,
//   //               "fx": false,
//   //               "fy": false,
//   //               "ei": true,
//   //               "t": "text",
//   //               "te": "Hello world",
//   //               "cm": "onlyColor",
//   //               "c": 4292664540,
//   //               "b": 0,
//   //               "cp": 0.1076865433673469,
//   //               "a": "center",
//   //               "f": 1.0,
//   //               "ff": "Roboto_regular"
//   //             }
//   //           },
//   //           "i": {"w": 1080.0, "h": 720.0},
//   //           "l": {"w": 411.42857142857144, "h": 274.2857142857143}
//   //         };
//   //       });
//   //       log(savedData.toString());
//   //     } catch (e) {
//   //       print("Error decoding JSON: $e");
//   //     }
//   //   }
//   // }
// }

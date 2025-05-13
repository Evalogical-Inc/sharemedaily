import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/constants/globals/globals.dart';
import 'package:quotify/provider/editor_provider.dart';
import 'package:quotify/widgets/custom_editor/editor_loader.dart';
import 'package:quotify/widgets/custom_editor/feature_btn_modal.dart';
import 'package:quotify/widgets/custom_editor/feature_button.dart';
import 'package:quotify/widgets/custom_editor/font_family_modal.dart';
import 'package:quotify/widgets/custom_editor/font_srtyle_button.dart';
import 'package:quotify/widgets/custom_editor/story_maker_provider.dart';
import 'package:quotify/widgets/custom_editor/text_align_button.dart';
import 'package:quotify/widgets/custom_editor/text_align_modal.dart';
import 'package:quotify/widgets/custom_editor/text_editor.dart';
import 'package:screenshot/screenshot.dart';

class EditorArgumetns {
  final String tagName;
  final String imagePath;
  final String imageAuthor;
  final String quote;
  final dynamic editJson;
  final int? editId;

  EditorArgumetns({
    this.editId,
    required this.imagePath,
    required this.imageAuthor,
    required this.quote,
    required this.tagName,
    this.editJson = '',
  });
}

class Editor extends StatefulWidget {
  final EditorArgumetns arguments;
  const Editor({super.key, required this.arguments});

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  final StoryMakerProvider _storyMakerProvider =
      Provider.of<StoryMakerProvider>(scaffoldKey.currentContext!);
  final EditProvider _editProvider =
      Provider.of<EditProvider>(scaffoldKey.currentContext!, listen: false);

  Offset position = Offset.zero;
  double scale = 1.0;
  double rotation = 0.0;

  Offset _lastFocalPoint = Offset.zero;
  double _startScale = 1.0;
  double _startRotation = 0.0;

  bool showVerticalCenterGuide = false;
  bool showHorizontalCenterGuide = false;

  final GlobalKey _textKey = GlobalKey();
  final GlobalKey _parentKey = GlobalKey();

  String _fontFamily = 'Poppins';

  final ImagePicker picker = ImagePicker();

  Uint8List? localImage;
  Uint8List? screenShot;

  List<FontFamilyModal> fontStyles = [
    FontFamilyModal(isActive: true, fontFamily: "Poppins", label: "Poppins"),
    FontFamilyModal(
      isActive: false,
      fontFamily: "DancingScript",
      label: "DancingScript",
    ),
    FontFamilyModal(
      isActive: false,
      fontFamily: "LeagueScript",
      label: "LeagueScript",
    ),
    FontFamilyModal(
      isActive: false,
      fontFamily: "PoetsenOne",
      label: "PoetsenOne",
    ),
    FontFamilyModal(isActive: false, fontFamily: "Alegreya", label: "Alegreya"),
    FontFamilyModal(
      isActive: false,
      fontFamily: "IBMPlexSans",
      label: "IBMPlexSans",
    ),
    FontFamilyModal(
      isActive: false,
      fontFamily: "NationalPark",
      label: "NationalPark",
    ),
    FontFamilyModal(
      isActive: false,
      fontFamily: "OleoScript",
      label: "OleoScript",
    ),
    FontFamilyModal(
        isActive: false, fontFamily: "Birthstone", label: "Birthstone"),
    FontFamilyModal(
        isActive: false, fontFamily: "FunnelDisplay", label: "FunnelDisplay"),
    FontFamilyModal(isActive: false, fontFamily: "Lexend", label: "Lexend"),
    FontFamilyModal(isActive: false, fontFamily: "Figtree", label: "Figtree"),
    FontFamilyModal(isActive: false, fontFamily: "DMSans", label: "DMSans"),
  ];

  List<TextAlignModal> alignOptions = [
    TextAlignModal(
      isActive: false,
      textAlign: TextAlign.left,
      icon: Icons.format_align_left_rounded,
      label: 'Left',
    ),
    TextAlignModal(
      isActive: true,
      textAlign: TextAlign.center,
      icon: Icons.format_align_center_rounded,
      label: 'Center',
    ),
    TextAlignModal(
      isActive: false,
      textAlign: TextAlign.right,
      icon: Icons.format_align_right_rounded,
      label: 'Right',
    ),
  ];

  List<FeatureButtonStatus> featureBtnStatusList = [
    FeatureButtonStatus(index: 0, status: true),
    FeatureButtonStatus(index: 1, status: false),
  ];

  final ScrollController _fontScrollController = ScrollController();
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _waitForRenderAndCenter();
  }

  void _waitForRenderAndCenter() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.ensureVisualUpdate();

      _storyMakerProvider.setInitialValu(widget.arguments.quote);

      final parentContext = _parentKey.currentContext;
      final textContext = _textKey.currentContext;

      if (parentContext != null && textContext != null) {
        final parentBox = parentContext.findRenderObject();
        final textBox = textContext.findRenderObject();

        // Check if sizes are available
        if (parentBox is RenderBox &&
            textBox is RenderBox &&
            parentBox.hasSize &&
            textBox.hasSize) {
          final parentSize = parentBox.size;
          final textSize = textBox.size;

          final centerX = (parentSize.width - textSize.width) / 2;
          final centerY = (parentSize.height - textSize.height) / 2;

          setState(() {
            position = Offset(centerX, centerY);
            rotation = 0.0;
            resetTextAlign(1);
          });
        } else {
          Future.delayed(
              const Duration(microseconds: 300), _waitForRenderAndCenter);
        }
      } else {
        Future.delayed(
            const Duration(microseconds: 300), _waitForRenderAndCenter);
      }
    });
  }

  void _checkGuidelines(Offset newPosition, Size containerSize) {
    final textContext = _textKey.currentContext;
    final parentContext = _parentKey.currentContext;

    if (textContext == null || parentContext == null) return;

    final textBox = textContext.findRenderObject() as RenderBox?;
    final parentBox = parentContext.findRenderObject() as RenderBox?;

    if (textBox == null ||
        parentBox == null ||
        !textBox.hasSize ||
        !parentBox.hasSize) {
      return;
    }

    final textSize = textBox.size;
    final parentSize = parentBox.size;

    final expectedCenterX = (parentSize.width - textSize.width) / 2;
    final expectedCenterY = (parentSize.height - textSize.height) / 2;

    const double threshold = 5.0; // 🔹 increased from 0.5 to 5.0

    setState(() {
      showVerticalCenterGuide =
          (newPosition.dx - expectedCenterX).abs() < threshold;
      showHorizontalCenterGuide =
          (newPosition.dy - expectedCenterY).abs() < threshold;
    });
  }

  void resetTextAlign(int index) {
    for (int i = 0; i < alignOptions.length; i++) {
      alignOptions[i].isActive = i == index;
    }
    setState(() {});
  }

  void updateActiveFont(int selectedIndex) {
    for (int i = 0; i < fontStyles.length; i++) {
      fontStyles[i].isActive = i == selectedIndex;
    }
    setState(() {
      _fontFamily = fontStyles[selectedIndex].fontFamily;
    });
  }

  Future<File> convertBytesToFile(Uint8List bytes, String filename) async {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$filename';
    File file = File(filePath);
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<String> saveImageToDownloads(Uint8List bytes) async {
    try {
      // Request storage permission (for Android 10 and below)
      if (await Permission.storage.request().isDenied) {
        debugPrint("Storage permission denied");
        return '';
      }

      // Get the Downloads directory
      Directory? downloadsDirectory = Directory('/storage/emulated/0/Download');

      if (!downloadsDirectory.existsSync()) {
        downloadsDirectory = await getExternalStorageDirectory(); // Fallback
      }

      String filePath =
          '${downloadsDirectory?.path}/share_me_daily_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Save the file
      File file = File(filePath);
      await file.writeAsBytes(bytes);

      debugPrint('✅ Image saved at: $filePath');
      return filePath;
    } catch (e) {
      debugPrint('❌ Error saving image: $e');
      return '';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Only trigger once
    if (position == Offset.zero) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _waitForRenderAndCenter();
      });
    }
  }

  @override
  void dispose() {
    _fontScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          elevation: 0,
          leading: Consumer<StoryMakerProvider>(
            builder: (context, data, _) {
              return Visibility(
                visible: !data.isEditorEnabled,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(
                        context); // this is for close the alert dialog
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          actions: [
            Consumer<StoryMakerProvider>(
              builder: (context, data, _) {
                return Visibility(
                  visible: !data.isEditorEnabled,
                  child: SizedBox(
                    height: 30,
                    child: Row(
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            _waitForRenderAndCenter();
                            data.text = data.initialValue;
                            data.textAlign = data.initailTextAlign;
                            updateActiveFont(0);
                            resetTextAlign(0);
                          },
                          child: Row(
                            children: [
                              Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()..scale(-1.0, 1.0),
                                child: const Icon(
                                  Icons.refresh_rounded,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Text(
                                'Reset',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[100],
                          ),
                          onPressed: () async {
                            await _screenshotController
                                .capture()
                                .then((Uint8List? bytes) async {
                              //Capture Done
                              screenShot = bytes;

                              File imageFile = await convertBytesToFile(
                                  bytes!, "edited_image.jpg");
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  opaque: false,
                                  barrierColor:
                                      Colors.black.withValues(alpha: 0.5),
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const EditorLoader(),
                                ),
                              );

                              Map<String, dynamic> quoteEditJson = {};
                              await _editProvider.addToEditQuotes(
                                quote: widget.arguments.quote,
                                quoteImage: widget.arguments.imagePath,
                                imageAuthor: widget.arguments.imageAuthor,
                                categoryId: 0,
                                quoteEditThumbnail: imageFile,
                                quoteEditJson: quoteEditJson,
                                editId: widget.arguments.editId,
                              );
                              await saveImageToDownloads(bytes);
                            }).catchError((onError) {
                              debugPrint(onError);
                            });
                          },
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          final double contentHeight = constraints.maxHeight - 160;
          final double contentWidth = constraints.maxWidth - 40;
          return Consumer<StoryMakerProvider>(builder: (context, data, _) {
            return Column(
              children: [
                SizedBox(
                  height: contentHeight,
                  width: contentWidth,
                  child: Screenshot(
                    controller: _screenshotController,
                    child: Stack(
                      children: [
                        Container(
                          key: _parentKey,
                          height: contentHeight,
                          width: contentWidth,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: localImage != null
                                  ? MemoryImage(
                                      localImage!) // For captured Uint8List screenshot
                                  : NetworkImage(widget.arguments.imagePath)
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          height: contentHeight,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(
                              alpha: 0.5,
                            ), // Adjust opacity as needed
                          ),
                        ),
                        Positioned(
                          left: position.dx,
                          top: position.dy,
                          child: GestureDetector(
                            onScaleStart: (details) {
                              _lastFocalPoint = details.focalPoint;
                              _startScale = scale;
                              _startRotation = rotation;

                              final RenderBox parentBox =
                                  _parentKey.currentContext!.findRenderObject()
                                      as RenderBox;
                              final Size parentSize = parentBox.size;
                              _checkGuidelines(position, parentSize);
                            },
                            onScaleUpdate: (details) {
                              setState(() {
                                scale = _startScale * details.scale;

                                double rawRotation =
                                    _startRotation + details.rotation;

                                const snapAngle = 45 *
                                    3.1415926535 /
                                    180; // 45 degrees in radians
                                const snapThreshold =
                                    0.1; // ~5.7 degrees in radians

                                double nearestSnap =
                                    (rawRotation / snapAngle).round() *
                                        snapAngle;

                                if ((rawRotation - nearestSnap).abs() <
                                    snapThreshold) {
                                  rotation = nearestSnap;
                                } else {
                                  rotation = rawRotation;
                                }

                                final delta =
                                    details.focalPoint - _lastFocalPoint;
                                position += delta;
                                _lastFocalPoint = details.focalPoint;

                                _checkGuidelines(
                                  position,
                                  Size(
                                    MediaQuery.of(context).size.width,
                                    contentHeight,
                                  ),
                                );
                              });
                            },
                            onScaleEnd: (details) async {
                              await Future.delayed(
                                const Duration(microseconds: 100),
                                () {
                                  setState(() {
                                    showVerticalCenterGuide = false;
                                    showHorizontalCenterGuide = false;
                                  });
                                },
                              );
                            },
                            child: Transform(
                              transform: Matrix4.identity()
                                ..scale(scale)
                                ..rotateZ(rotation),
                              alignment: Alignment.center,
                              child: Hero(
                                tag: "txt",
                                child: Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    width: contentWidth - 150,
                                    decoration: const BoxDecoration(),
                                    key: _textKey,
                                    margin: const EdgeInsets.all(500),
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        data.isEditorEnabled = true;
                                        _routeToTextEditor(
                                          context,
                                          _fontFamily,
                                        );
                                      },
                                      child: Text(
                                        data.text,
                                        textAlign: data.textAlign,
                                        style: TextStyle(
                                          fontFamily: _fontFamily,
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (showHorizontalCenterGuide ||
                            showHorizontalCenterGuide)
                          Positioned.fill(
                            child: IgnorePointer(
                              child: CustomPaint(
                                painter: _GuidelinePainter(
                                  showVerticalCenterGuide:
                                      showVerticalCenterGuide,
                                  showHorizontalCenterGuide:
                                      showHorizontalCenterGuide,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _options(context),
                const SizedBox(height: 10),
                _features(context),
              ],
            );
          });
        }),
      ),
    );
  }

  Widget _features(BuildContext context) {
    double buttonWidth = 74;

    void updateActiveFeature(int index) {
      for (int i = 0; i < featureBtnStatusList.length; i++) {
        featureBtnStatusList[i].status = i == index;
      }
      setState(() {});
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 70,
        width: double.infinity,
        child: Consumer<StoryMakerProvider>(
          builder: (context, data, _) {
            return ListView(
              scrollDirection: Axis.horizontal,
              children: [
                FeatureButton(
                  width: buttonWidth,
                  onPressed: () {
                    data.isEditorEnabled = true;
                    _routeToTextEditor(context, _fontFamily);
                  },
                  icon: Icons.text_fields,
                  buttonText: 'Text',
                ),
                const SizedBox(width: 10),
                FeatureButton(
                  isActive: featureBtnStatusList[0].status,
                  width: buttonWidth,
                  onPressed: () {
                    updateActiveFeature(0);
                    data.isFontStyle = true;
                  },
                  icon: Icons.font_download,
                  buttonText: 'Font Style',
                ),
                const SizedBox(width: 10),
                FeatureButton(
                  isActive: featureBtnStatusList[1].status,
                  width: buttonWidth,
                  onPressed: () {
                    updateActiveFeature(1);
                    data.isFontStyle = false;
                  },
                  icon: Icons.format_align_center_rounded,
                  buttonText: 'Alignment',
                ),
                const SizedBox(width: 10),
                FeatureButton(
                  width: buttonWidth,
                  onPressed: () async {
                    if (Platform.isAndroid) {
                      final status = await Permission.storage.request();
                      if (!status.isGranted) {
                        // Handle denial
                      }
                    } else if (Platform.isIOS) {
                      final status = await Permission.photos.request();
                      if (!status.isGranted) {
                        // Handle denial
                      }
                    }
                    final picker = ImagePicker();
                    final picked = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (picked != null) {
                      localImage = await picked
                          .readAsBytes(); // ✅ convert XFile to Uint8List;
                      setState(() {});
                    }
                  },
                  icon: Icons.image,
                  buttonText: 'Image',
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _options(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: 60,
        child: Consumer<StoryMakerProvider>(
          builder: (context, data, _) {
            return Stack(
              children: [
                SizedBox(
                  child: Visibility(
                    visible: data.isFontStyle,
                    maintainState: true,
                    maintainAnimation: true,
                    maintainSize: true,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListView.separated(
                        controller: _fontScrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: fontStyles.length,
                        itemBuilder: (context, index) {
                          return FontStyleButton(
                            onPressed: () {
                              updateActiveFont(index);
                            },
                            text: 'Abc',
                            fontFamily: fontStyles[index].fontFamily,
                            isActive: fontStyles[index].isActive,
                          );
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: !data.isFontStyle,
                  maintainState: true,
                  maintainAnimation: true,
                  maintainSize: true,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: alignOptions.asMap().entries.map((entry) {
                        int index = entry.key;
                        var option = entry.value;
                        return Padding(
                          padding: EdgeInsets.only(
                            right: index == alignOptions.length - 1 ? 0 : 10,
                          ),
                          child: TextAlignButton(
                            onPressed: () {
                              data.textAlign = option.textAlign;
                              resetTextAlign(index);
                            },
                            icon: option.icon,
                            text: option.label,
                            isActive: option.isActive,
                          ),
                        );
                      }).toList(),
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

  void _routeToTextEditor(BuildContext context, String fontFamily) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.5),
        pageBuilder: (context, animation, secondaryAnimation) =>
            TextEditor(fontFamily: fontFamily),
      ),
    );
  }
}

class _GuidelinePainter extends CustomPainter {
  final bool showVerticalCenterGuide;
  final bool showHorizontalCenterGuide;

  _GuidelinePainter({
    required this.showVerticalCenterGuide,
    required this.showHorizontalCenterGuide,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.9)
      ..strokeWidth = 2;
    if (showVerticalCenterGuide) {
      canvas.drawLine(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, size.height),
        paint,
      );
    }
    if (showHorizontalCenterGuide) {
      canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

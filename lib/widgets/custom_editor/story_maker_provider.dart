import 'package:flutter/material.dart';
import 'package:quotify/widgets/custom_editor/font_family_modal.dart';

class StoryMakerProvider extends ChangeNotifier {

String _initialValue = '';

  String get initialValue => _initialValue;

  set initialValue(String value) {
    _initialValue = value;
    notifyListeners();
  }

  String _text = '';

  String get text => _text;

  set text(String value) {
    _text = value;
    notifyListeners();
  }

  // text align
  TextAlign _initailTextAlign = TextAlign.center;

  TextAlign get initailTextAlign => _initailTextAlign;

  set initailTextAlign(TextAlign value) {
    _initailTextAlign = value;
    notifyListeners();
  }

  TextAlign _textAlign = TextAlign.center;

  TextAlign get textAlign => _textAlign;

  set textAlign(TextAlign value) {
    _textAlign = value;
    notifyListeners();
  }

  bool _isFontStyle = true;

  bool get isFontStyle => _isFontStyle;

  set isFontStyle(bool value) {
    _isFontStyle = value;
    notifyListeners();
  }

  // text-align icon
  IconData _txtAlignIcon = Icons.format_align_center_rounded;

  IconData get txtAlignIcon => _txtAlignIcon;

  set txtAlignIcon(IconData value) {
    _txtAlignIcon = value;
    notifyListeners();
  }


  bool _isEditorEnabled = false;

  bool get isEditorEnabled => _isEditorEnabled;

  set isEditorEnabled(bool value) {
    _isEditorEnabled = value;
    notifyListeners();
  }


  List<FontFamilyModal> _fontStyles = [
    FontFamilyModal(isActive: true, fontFamily: "Poppins", label: "Poppins"),
    FontFamilyModal(
      isActive: false,
      fontFamily: "DancingScript",
      label: "DancingScript",
    ),
    FontFamilyModal(
      isActive: false,
      fontFamily: "WinkyRough",
      label: "WinkyRough",
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
      fontFamily: " ",
      label: "NationalPark",
    ),
    FontFamilyModal(
      isActive: false,
      fontFamily: "OleoScript",
      label: "OleoScript",
    ),
    FontFamilyModal(isActive: false, fontFamily: "Playfair", label: "Playfair"),
    FontFamilyModal(isActive: false, fontFamily: "Spectral", label: "Spectral"),
    FontFamilyModal(isActive: false, fontFamily: "Vollkorn", label: "Vollkorn"),
  ];

  List<FontFamilyModal> get fontStyles => _fontStyles;

  set fontStyles(List<FontFamilyModal> value) {
    _fontStyles = value;
    notifyListeners();
  }

  void  setInitialValu(String quote) {  
    initialValue = quote;
    text = quote;
  }

  void updateActiveFont(int selectedIndex) {
    for (int i = 0; i < fontStyles.length; i++) {
      fontStyles[i].isActive = i == selectedIndex;
    }
    notifyListeners();
  }

}

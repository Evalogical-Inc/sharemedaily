import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFontStyles {
  static TextStyle textStyle(String? fontFamily, double? fontSize,
      double? fontWeight, bool? isItalics) {
    FontWeight getFontWeight(double? fontWeight) {
      if (fontWeight != null) {
        switch (fontWeight) {
          case 100:
            return FontWeight.w100;
          case 200:
            return FontWeight.w200;
          case 300:
            return FontWeight.w300;
          case 400:
            return FontWeight.w400;
          case 500:
            return FontWeight.w500;
          case 600:
            return FontWeight.w600;
          case 700:
            return FontWeight.w700;
          default:
            return FontWeight.bold;
        }
      } else {
        return FontWeight.normal;
      }
    }

    final fontStyle =
        isItalics == null || !isItalics ? FontStyle.normal : FontStyle.italic;
    final fntWeight = getFontWeight(fontWeight);
    switch (fontFamily) {
      case 'playfairDisplay':
        return GoogleFonts.playfairDisplay(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'elsie':
        return GoogleFonts.elsie(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'sourceSerif4':
        return GoogleFonts.sourceSerif4(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'zillaSlab':
        return GoogleFonts.zillaSlab(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'yesteryear':
        return GoogleFonts.yesteryear(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'yesevaOne':
        return GoogleFonts.yesevaOne(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'yellowtail':
        return GoogleFonts.yellowtail(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'wellfleet':
        return GoogleFonts.wellfleet(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'vollkorn':
        return GoogleFonts.vollkorn(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'vidaloka':
        return GoogleFonts.vidaloka(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'simonetta':
        return GoogleFonts.simonetta(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'satisfy':
        return GoogleFonts.satisfy(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'sail':
        return GoogleFonts.sail(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'purplePurse':
        return GoogleFonts.purplePurse(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'ptSerif':
        return GoogleFonts.ptSerif(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'pinyonScript':
        return GoogleFonts.pinyonScript(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'petitFormalScript':
        return GoogleFonts.petitFormalScript(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'patrickHand':
        return GoogleFonts.patrickHand(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'parisienne':
        return GoogleFonts.parisienne(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'pacifico':
        return GoogleFonts.pacifico(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'mrDeHaviland':
        return GoogleFonts.mrDeHaviland(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'frederickaTheGreat':
        return GoogleFonts.frederickaTheGreat(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'damion':
        return GoogleFonts.damion(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'cinzel':
        return GoogleFonts.cinzel(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'averiaSerifLibre':
        return GoogleFonts.averiaSerifLibre(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'rancho':
        return GoogleFonts.rancho(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'prata':
        return GoogleFonts.prata(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'oleoScript':
        return GoogleFonts.oleoScript(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      case 'libreBaskerville':
        return GoogleFonts.libreBaskerville(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
      default:
        return GoogleFonts.aBeeZee(
          fontSize: fontSize,
          fontWeight: fntWeight,
          fontStyle: fontStyle,
        );
    }
  }
}

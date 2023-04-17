part of 'widgets.dart';

class TextCustom extends StatelessWidget {
  final String text;
  final double fontSize;
  final bool isTitle;
  final FontWeight fontWeight;
  final Color color;
  final int maxLines;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final double? letterSpacing;
  final double? height;

  const TextCustom(
      {Key? key,
      required this.text,
      this.fontSize = 18,
      this.fontWeight = FontWeight.normal,
      this.color = Colors.black,
      this.maxLines = 1,
      this.overflow = TextOverflow.visible,
      this.textAlign = TextAlign.left,
      this.letterSpacing,
      this.isTitle = false,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'NanumSquare',
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          letterSpacing: letterSpacing,
          height: height),
      // style: GoogleFonts.getFont( isTitle ? 'Poppins' :'Roboto', fontSize: fontSize, fontWeight: fontWeight, color: color, letterSpacing: letterSpacing),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}

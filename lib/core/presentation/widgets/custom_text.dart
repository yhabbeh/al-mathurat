import 'package:flutter/material.dart';
import '../../theme/text_styles.dart';

enum CustomTextStyleType {
  header,
  subHeader,
  arabicTitle,
  arabicSubtitle,
  body,
  caption,
}

class CustomText extends StatelessWidget {
  final String text;
  final CustomTextStyleType styleType;
  final TextAlign? textAlign;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CustomText(
    this.text, {
    super.key,
    this.styleType = CustomTextStyleType.body,
    this.textAlign,
    this.color,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle style;

    switch (styleType) {
      case CustomTextStyleType.header:
        style = AppTextStyles.header;
        break;
      case CustomTextStyleType.subHeader:
        style = AppTextStyles.subHeader;
        break;
      case CustomTextStyleType.arabicTitle:
        style = AppTextStyles.arabicTitle;
        break;
      case CustomTextStyleType.arabicSubtitle:
        style = AppTextStyles.arabicSubtitle;
        break;
      case CustomTextStyleType.caption:
        style = const TextStyle(fontSize: 12, color: Colors.grey);
        break;
      case CustomTextStyleType.body:
        style = const TextStyle(fontSize: 14, color: Colors.black87);
        break;
    }

    if (color != null || fontSize != null || fontWeight != null) {
      style = style.copyWith(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      );
    }

    return Text(text, style: style, textAlign: textAlign);
  }
}

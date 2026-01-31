import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/custom_text.dart';
import '../../../../core/util/localization_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/bloc/language_bloc.dart';

class HeaderWidget extends StatelessWidget {
  final String greeting;

  const HeaderWidget({super.key, required this.greeting});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () {
              final currentLocale = Localizations.localeOf(context);
              final newLocale = currentLocale.languageCode == 'en'
                  ? const Locale('ar')
                  : const Locale('en');
              context.read<LanguageBloc>().add(ChangeLanguage(newLocale));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.5)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Localizations.localeOf(context).languageCode == 'ar'
                        ? 'English'
                        : 'العربية',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.translate, size: 16),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        // Container(
        //   width: 80,
        //   height: 80,
        //   decoration: BoxDecoration(
        //     color: Colors.white.withOpacity(0.5),
        //     shape: BoxShape.circle,
        //     boxShadow: [
        //       BoxShadow(
        //         color: Colors.black.withOpacity(0.05),
        //         blurRadius: 10,
        //         offset: const Offset(0, 4),
        //       ),
        //     ],
        //   ),
        //   child:
        //    const Icon(
        //     Icons.wb_sunny_outlined,
        //     size: 40,
        //     color: Colors.amber,
        //   ),
        // ),
        const SizedBox(height: 24),
        CustomText(
          greeting, // This comes from BLoC, which might need localization too or be dynamic
          styleType: CustomTextStyleType.arabicTitle,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        CustomText(
          context.tr.welcomeMessage,
          styleType: CustomTextStyleType.arabicSubtitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

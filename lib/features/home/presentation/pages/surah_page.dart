import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/colors.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SurahPage extends StatefulWidget {
  final int surahNumber;
  final int verseNumber;

  const SurahPage({
    super.key,
    required this.surahNumber,
    required this.verseNumber,
  });

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  Map<String, dynamic>? _surahData;
  bool _isLoading = true;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    _loadSurah();
  }

  Future<void> _loadSurah() async {
    try {
      final jsonString = await rootBundle.loadString(
        'assets/bundle/quraan/surah/surah_${widget.surahNumber}.json',
      );
      final data = json.decode(jsonString);
      setState(() {
        _surahData = data;
        _isLoading = false;
      });

      // Simple delay to scroll after build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToVerse();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error loading surah: $e');
    }
  }

  void _scrollToVerse() {
    if (widget.verseNumber > 0 && _surahData != null) {
      // Verse numbers are 1-based, list indices are 0-based
      // Also ensure we don't go out of bounds
      final verses = _surahData!['verses'] as List;
      final targetIndex = widget.verseNumber - 1;

      if (targetIndex >= 0 && targetIndex < verses.length) {
        _itemScrollController.jumpTo(index: targetIndex);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_surahData == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Failed to load Surah')),
      );
    }

    final surahName = _surahData!['name']['ar'];
    final verses = _surahData!['verses'] as List;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'سورة $surahName',
          style: const TextStyle(
            fontFamily: 'Amiri',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryText),
      ),
      body: ScrollablePositionedList.builder(
        itemScrollController: _itemScrollController,
        itemPositionsListener: _itemPositionsListener,
        padding: const EdgeInsets.all(16),
        itemCount: verses.length,
        itemBuilder: (context, index) {
          final verse = verses[index];
          final text = verse['text']['ar'];
          final number = verse['number'];
          final isHighlighted = number == widget.verseNumber;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isHighlighted
                  ? AppColors.orangeAction.withOpacity(0.1)
                  : AppColors.cardSurface,
              borderRadius: BorderRadius.circular(16),
              border: isHighlighted
                  ? Border.all(color: AppColors.orangeAction, width: 2)
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.grey.withOpacity(0.1),
                      child: Text(
                        '$number',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isHighlighted)
                      const Text(
                        'الآية المختارة',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.orangeAction,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  text,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Amiri',
                    height: 1.8,
                    color: AppColors.primaryText,
                    fontWeight: isHighlighted
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

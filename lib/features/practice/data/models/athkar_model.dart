class AthkarData {
  final String version;
  final String language;
  final String sourcePolicy;
  final List<AthkarCategory> categories;

  AthkarData({
    required this.version,
    required this.language,
    required this.sourcePolicy,
    required this.categories,
  });

  factory AthkarData.fromJson(Map<String, dynamic> json) {
    return AthkarData(
      version: json['version'] ?? '',
      language: json['language'] ?? '',
      sourcePolicy: json['source_policy'] ?? '',
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => AthkarCategory.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class AthkarCategory {
  final String id;
  final String title;
  final String? timeRange;
  final String? audio;
  final String? filename;
  final List<AthkarItem> items;

  AthkarCategory({
    required this.id,
    required this.title,
    this.timeRange,
    this.audio,
    this.filename,
    required this.items,
  });

  factory AthkarCategory.fromJson(Map<String, dynamic> json) {
    return AthkarCategory(
      id: json['id']?.toString() ?? '',
      title:
          json['category'] ??
          json['title'] ??
          '', // Handle "category" key from new JSON
      timeRange: json['time_range'],
      audio: json['audio'],
      filename: json['filename'],
      items:
          (json['array'] as List<dynamic>?) // Handle "array" key from new JSON
              ?.map((e) => AthkarItem.fromJson(e))
              .toList() ??
          (json['items'] as List<dynamic>?)
              ?.map((e) => AthkarItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class AthkarItem {
  final int id;
  final String? title;
  final String text;
  final int repeat;
  final String? audio;
  final String? filename;
  final AthkarSource? source;
  final VirtueNotification? virtueNotification;

  AthkarItem({
    required this.id,
    this.title,
    required this.text,
    required this.repeat,
    this.audio,
    this.filename,
    this.source,
    this.virtueNotification,
  });

  factory AthkarItem.fromJson(Map<String, dynamic> json) {
    return AthkarItem(
      id: json['id'] ?? 0,
      title: json['title'],
      text: json['text'] ?? '',
      repeat:
          json['count'] ??
          json['repeat'] ??
          1, // Handle "count" key from new JSON
      audio: json['audio'],
      filename: json['filename'],
      source: json['source'] != null
          ? AthkarSource.fromJson(json['source'])
          : null,
      virtueNotification: json['virtue_notification'] != null
          ? VirtueNotification.fromJson(json['virtue_notification'])
          : null,
    );
  }
}

class AthkarSource {
  final String book;
  final int hadithNumber;
  final String grade;

  AthkarSource({
    required this.book,
    required this.hadithNumber,
    required this.grade,
  });

  factory AthkarSource.fromJson(Map<String, dynamic> json) {
    return AthkarSource(
      book: json['book'] ?? '',
      hadithNumber: json['hadith_number'] ?? 0,
      grade: json['grade'] ?? '',
    );
  }
}

class VirtueNotification {
  final bool enabled;
  final String? text;

  VirtueNotification({required this.enabled, this.text});

  factory VirtueNotification.fromJson(Map<String, dynamic> json) {
    return VirtueNotification(
      enabled: json['enabled'] ?? false,
      text: json['text'],
    );
  }
}

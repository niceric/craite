class MediaItem {
  final String id;
  final String imageUrl;
  final String prompt;
  final String name;
  final DateTime createdAt;
  final MediaType type;

  MediaItem({
    required this.id,
    required this.imageUrl,
    required this.prompt,
    required this.name,
    required this.createdAt,
    required this.type,
  });

  MediaItem copyWith({
    String? id,
    String? imageUrl,
    String? prompt,
    String? name,
    DateTime? createdAt,
    MediaType? type,
  }) {
    return MediaItem(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      prompt: prompt ?? this.prompt,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'prompt': prompt,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'type': type.toString().split('.').last,
    };
  }

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      prompt: json['prompt'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      type: MediaType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => MediaType.image,
      ),
    );
  }
}

enum MediaType {
  image,
  video,
}

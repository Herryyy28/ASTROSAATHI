import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _bookmarksKey = 'saved_bookmarks_v1';

@immutable
class BookmarkItem {
  final String id;
  final String title;
  final String category; // 'AI Kundli', 'Horoscope', 'Remedy', 'Astrologer', 'Panchang'
  final String subtitle;
  final String content;
  final DateTime savedAt;
  final Map<String, String> metadata;

  const BookmarkItem({
    required this.id,
    required this.title,
    required this.category,
    required this.subtitle,
    required this.content,
    required this.savedAt,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'category': category,
        'subtitle': subtitle,
        'content': content,
        'savedAt': savedAt.toIso8601String(),
        'metadata': metadata,
      };

  factory BookmarkItem.fromJson(Map<String, dynamic> json) {
    return BookmarkItem(
      id: json['id'] as String? ?? 'bm_${DateTime.now().millisecondsSinceEpoch}',
      title: json['title'] as String? ?? 'Saved Insight',
      category: json['category'] as String? ?? 'AI Kundli',
      subtitle: json['subtitle'] as String? ?? '',
      content: json['content'] as String? ?? '',
      savedAt: json['savedAt'] != null
          ? DateTime.tryParse(json['savedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      metadata: (json['metadata'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v.toString()),
          ) ??
          {},
    );
  }
}

class BookmarksNotifier extends StateNotifier<List<BookmarkItem>> {
  BookmarksNotifier() : super([]) {
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_bookmarksKey);
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw) as List<dynamic>;
        final list = decoded
            .map((e) => BookmarkItem.fromJson(e as Map<String, dynamic>))
            .toList();
        state = list;
      }
    } catch (e) {
      debugPrint('Error loading bookmarks: $e');
    }
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(state.map((e) => e.toJson()).toList());
      await prefs.setString(_bookmarksKey, encoded);
    } catch (e) {
      debugPrint('Error persisting bookmarks: $e');
    }
  }

  Future<bool> addBookmark(BookmarkItem item) async {
    if (state.any((b) => b.id == item.id)) {
      return false;
    }
    state = [item, ...state];
    await _persist();
    return true;
  }

  Future<void> removeBookmark(String id) async {
    state = state.where((b) => b.id != id).toList();
    await _persist();
  }

  Future<void> toggleBookmark(BookmarkItem item) async {
    if (isBookmarked(item.id)) {
      await removeBookmark(item.id);
    } else {
      await addBookmark(item);
    }
  }

  bool isBookmarked(String id) {
    return state.any((b) => b.id == id);
  }

  Future<void> clearAll() async {
    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_bookmarksKey);
  }
}

final bookmarksProvider =
    StateNotifierProvider<BookmarksNotifier, List<BookmarkItem>>((ref) {
  return BookmarksNotifier();
});

final isBookmarkedProvider = Provider.family<bool, String>((ref, id) {
  final bookmarks = ref.watch(bookmarksProvider);
  return bookmarks.any((b) => b.id == id);
});

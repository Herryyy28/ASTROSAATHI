import 'dart:io';

void main() {
  final dir = Directory('lib');
  final List<FileSystemEntity> entities = dir.listSync(recursive: true);
  
  print('=== Suspicious Files ===');
  for (var entity in entities) {
    if (entity is File) {
      final path = entity.path.toLowerCase();
      if (path.contains('old') || path.contains('backup') || path.contains('v2') || path.contains('temp') || path.contains('unused') || path.contains('legacy')) {
        print(entity.path);
      }
    }
  }
}

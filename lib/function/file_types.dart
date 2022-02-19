import 'package:mime/mime.dart';

getFileTypeFromPath(String path) {
  final mimeType = lookupMimeType(path);

  if (mimeType.startsWith('image/')) {
    return 'image';
  } else if (mimeType.startsWith('video/')) {
    return 'video';
  } else if (mimeType.startsWith('audio/')) {
    return 'audio';
  } else if (mimeType.startsWith('application/')) {
    return 'document';
  } else  {
    return 'unknown';
  }
}

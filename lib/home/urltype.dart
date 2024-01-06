import 'package:path/path.dart' as p;
enum UrlType { img, vid, unk }

final List<String> imagetypes = [
  'jpg',
  'jpeg',
  'jfif',
  'pjpeg',
  'pjp',
  'png',
  'svg',
  'gif',
  'apng',
  'webp',
  'avif'
];

final List<String> videotypes = [
  "3g2",
  "3gp",
  "aaf",
  "asf",
  "avchd",
  "avi",
  "drc",
  "flv",
  "m2v",
  "m3u8",
  "m4p",
  "m4v",
  "mkv",
  "mng",
  "mov",
  "mp2",
  "mp4",
  "mpe",
  "mpeg",
  "mpg",
  "mpv",
  "mxf",
  "nsv",
  "ogg",
  "ogv",
  "qt",
  "rm",
  "rmvb",
  "roq",
  "svi",
  "vob",
  "webm",
  "wmv",
  "yuv"
];

UrlType getType(url) {
  try {
    Uri uri = Uri.parse(url);
    String extension = p.extension(uri.path).toLowerCase();
    if (extension.isEmpty) {
      return UrlType.unk;
    }

    extension = extension.split('.').last;
    if (imagetypes.contains(extension)) {
      return UrlType.img;
    } else if (videotypes.contains(extension)) {
      return UrlType.vid;
    }
  } catch (e) {
    return UrlType.unk;
  }
  return UrlType.unk;
}
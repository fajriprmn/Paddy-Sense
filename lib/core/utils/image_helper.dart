import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

class ImageHelper {
  /// Compress image to max 512x512 pixels
  static Future<File> compressImage(File file, {int maxSize = 512}) async {
    final bytes = await file.readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    
    if (image == null) {
      throw Exception('Failed to decode image');
    }
    
    // Resize if larger than maxSize
    if (image.width > maxSize || image.height > maxSize) {
      image = img.copyResize(
        image,
        width: image.width > image.height ? maxSize : null,
        height: image.height > image.width ? maxSize : null,
      );
    }
    
    // Encode to JPEG with quality 85
    final compressedBytes = img.encodeJpg(image, quality: 85);
    
    // Write to temp file
    final tempPath = '${file.parent.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final compressedFile = File(tempPath);
    await compressedFile.writeAsBytes(compressedBytes);
    
    return compressedFile;
  }
  
  /// Convert image to base64 string
  static Future<String> imageToBase64(File file) async {
    final bytes = await file.readAsBytes();
    return String.fromCharCodes(bytes);
  }
  
  /// Get image bytes
  static Future<Uint8List> getImageBytes(File file) async {
    return await file.readAsBytes();
  }
}

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quotify/services/permission_services.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:image/image.dart' as img;
import 'dart:typed_data';
import 'dart:ui' as ui;

class ScreenshotServices {
  static Future<String?> capture({
    required BuildContext context,
    required ScreenshotController screenshotController,
    required bool isDownload,
  }) async {
    String path = '';
    try {
      final image = await screenshotController.capture();
      if (image != null) {
        Directory? directory;
        if (Platform.isIOS) {
          directory = await getApplicationDocumentsDirectory();
        } else if (Platform.isAndroid) {
          if (isDownload && await isAndroid11OrAbove()) {
            // Use MediaStore API for Android 11+
            // Decode image
            Uint8List watermarkedBytes =
                await _addWatermarkBeforeDownload(image);
            await SaverGallery.saveImage(watermarkedBytes,
                quality: 100,
                fileName:
                    'sharemedaily_${DateTime.now().millisecondsSinceEpoch}',
                skipIfExists: true);
          } else {
            directory = await getExternalStorageDirectory();
          }
        }
        // Create a file path and save image
        if (directory != null) {
          final time = DateTime.now()
              .toIso8601String()
              .replaceAll('.', '')
              .replaceAll(':', '')
              .replaceAll('-', '');

          final filePath = isDownload
              ? Platform.isIOS
                  ? '${directory.path}/sharemedaily_$time.jpg'
                  : '/storage/emulated/0/Download/sharemedaily_$time.jpg'
              : '${directory.path}/sharemedaily_$time.jpg';

          final file = File(filePath);
          await file.create(recursive: true);
          await file.writeAsBytes(image);

          if (isDownload) {
            log('adding watermark');
            // Step 1: Apply Watermark and Get the Path of Watermarked Image
            String watermarkedPath = await _addWatermark(file);

            // Step 2: Convert Watermarked Path to File
            File watermarkedFile = File(watermarkedPath);

            // // Step 3: Get the App's Permanent Directory
            // final directory = await getExternalStorageDirectory();
            // final finalPath = '${file.path}/sharemedaily_$time.jpg';

            // Step 4: Move/Copy the File to Permanent Storage
            await watermarkedFile.copy(filePath);

            print('Watermarked image saved at: ${filePath}');
          }

          print('Image saved to $filePath');
          return file.path;
        }
      }
    } catch (e) {
      print('Error saving image: $e');
    }
    return path;
  }

  static Future<Uint8List> _addWatermarkBeforeDownload(
      Uint8List imageBytes) async {
    // Load the original image
    final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    final ui.Image originalImage = frameInfo.image;

    // Create a canvas to draw the image and watermark
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Paint paint = Paint();

    // Draw the original image
    canvas.drawImage(originalImage, Offset.zero, paint);

    // Define the watermark text
    const String text = 'sharemedaily.com';
    final TextSpan textSpan = TextSpan(
      text: text,
      style: TextStyle(
          color: Color.fromRGBO(
              186, 186, 186, 0.5), // Adjust opacity here (0.5 = 50%)
          fontSize: 24,
          fontWeight: FontWeight.bold),
    );
    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Calculate the position for the watermark
    final double watermarkX = (originalImage.width / 2) - (textPainter.width / 2) ;
    final double watermarkY = originalImage.height * 0.8;

    // Draw semi-transparent black rectangle as background
    final Rect rect = Rect.fromLTRB(
      watermarkX - 5,
      watermarkY - 5,
      watermarkX + textPainter.width + 10,
      watermarkY + textPainter.height + 10,
    );
    final Paint rectPaint = Paint()
      ..color = Color.fromRGBO(0, 0, 0, 0.5) // Semi-transparent black
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(14)),
      rectPaint,
    );

    // Draw white border around the rectangle
    final Paint borderPaint = Paint()
      ..color = Color.fromRGBO(255, 255, 255, 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(14)),
      borderPaint,
    );

    // Draw watermark text
    textPainter.paint(canvas, Offset(watermarkX + 5, watermarkY + 5));

    // Convert the canvas to an image
    final ui.Image watermarkedImage = await recorder.endRecording().toImage(
          originalImage.width,
          originalImage.height,
        );

    // Convert the image to Uint8List
    final ByteData? byteData =
        await watermarkedImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  // Request permissions
  static Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  // Check if the device is running Android 11 or above
  static Future<bool> isAndroid11OrAbove() async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      return androidInfo.version.sdkInt >=
          30; // Android 11+ // Android 11 is API 30
    }
    return false;
  }

  // Get platform version (API level)
  static Future<int> getPlatformVersion() async {
    return int.parse(
        Platform.operatingSystemVersion.split(' ')[1].replaceAll(')', ''));
  }

  static Future<void> shareWatermarkedImage(Uint8List imageBytes) async {
    // Create a temporary file to store the watermarked image
    final String fileName =
        'sharemedaily_${DateTime.now().millisecondsSinceEpoch}.png';
    final String path = '${Directory.systemTemp.path}/$fileName';
    final File file = File(path);

    // Write the watermarked image to the file
    await file.writeAsBytes(imageBytes);

    // Share the file using Share.shareXFiles()
    await Share.shareXFiles([XFile(file.path)]);
  }

  static Future<ShareResult?> share({
    required BuildContext context,
    required ScreenshotController screenshotController,
  }) async {
    log(context.toString());
    log(screenshotController.toString());
    Future<ShareResult>? result;
    String? path = await capture(
      context: context,
      screenshotController: screenshotController,
      isDownload: false,
    );
    if (path != null) {
      final image = await screenshotController.capture();
      Uint8List watermarkedBytes = await _addWatermarkBeforeDownload(image as Uint8List);
      // String watermarkedPath = await _addWatermark(File(path));
      // result = Share.shareXFiles([XFile(watermarkedPath)]);
      shareWatermarkedImage(watermarkedBytes);
    } else {
      var snackBar = SnackBar(
        content: const Text('Unable to share image!'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {},
        ),
      );
      Timer(const Duration(microseconds: 500), () {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }

    return result;
  }

  static Future<String> _addWatermark(File imageFile) async {
    Uint8List imageBytes = await imageFile.readAsBytes();
    img.Image original = img.decodeImage(imageBytes)!;

    int imgWidth = original.width;
    int imgHeight = original.height;
    String text = 'sharemedaily.com';

    int textWidth = text.length * 12; // Approximate width per character
    int textHeight = 24;

    int watermarkX = (imgWidth * 0.33).toInt(); // 40% from left
    int watermarkY = (imgHeight * 0.8).toInt(); // 80% from top

    img.fillRect(
      original,
      x1: watermarkX - 5, // Add some padding
      y1: watermarkY - 5,
      x2: watermarkX + textWidth + 10,
      y2: watermarkY + textHeight + 10,
      radius: 14,
      color: img.ColorFloat16.rgba(0, 0, 0, 128), // Black with 50% opacity
    );

    // Draw border around the rectangle
    img.drawRect(
      radius: 8,
      original,
      x1: watermarkX - 5,
      y1: watermarkY - 5,
      x2: watermarkX + textWidth + 10,
      y2: watermarkY + textHeight + 10,
      color: img.ColorFloat16.rgba(255, 255, 255, 255), // White border
      thickness: 2,
    );

    // Define watermark text
    img.drawString(original, text,
        x: watermarkX + 5,
        y: watermarkY + 5,
        color: img.ColorFloat32.rgba(186, 186, 186, 256),
        font: img.arial24); // White with transparency

    // Convert back to Uint8List
    Uint8List watermarkedBytes = Uint8List.fromList(img.encodePng(original));

    // Save watermarked image to a new file
    final directory = await getTemporaryDirectory();
    final watermarkedPath = '${directory.path}/watermarked_image.png';
    File watermarkedFile = File(watermarkedPath);
    await watermarkedFile.writeAsBytes(watermarkedBytes);

    return watermarkedPath;
  }

  static Future<String?> download({
    required BuildContext context,
    required ScreenshotController screenshotController,
  }) async {
    String? path;
    // var status = await Permission.photos.isGranted;
    var status = await Permission.storage.request();
    // if permission is granded!
    if (status.isGranted) {
      await Future.delayed(
        const Duration(milliseconds: 500),
        () async {
          path = await capture(
            // ignore: use_build_context_synchronously
            context: context,
            screenshotController: screenshotController,
            isDownload: true,
          );
        },
      );
      if (path != null) {
        Timer(
          const Duration(milliseconds: 500),
          () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                behavior: SnackBarBehavior.floating,
                content: Text('Downloaded Successfully!'),
              ),
            );
          },
        );
      }
    } else {
      final permissionStatus = await PermissionServices.requestPermission(
          permission: Permission.photos);
      if (permissionStatus.isGranted) {
        await Future.delayed(
          const Duration(milliseconds: 500),
          () async {
            path = await capture(
              context: context,
              screenshotController: screenshotController,
              isDownload: true,
            );

            if (path != null) {
              Timer(const Duration(milliseconds: 500), () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text('Downloaded Successfully!'),
                  ),
                );
              });
            }
          },
        );
      } else {
        Timer(
          const Duration(milliseconds: 500),
          () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                content: SizedBox(
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Sharemedaily, ',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        TextSpan(
                          text:
                              'needs to access your storage to download images?',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () async {
                      await openAppSettings();
                      Timer(const Duration(milliseconds: 500), () {
                        Navigator.pop(context);
                      });
                    },
                    child: const Text('Settings'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
        );
      }
    }
    return path;
  }
}

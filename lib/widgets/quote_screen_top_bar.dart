import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/constants/colors.dart';
import 'package:quotify/config/constants/spacing.dart';
import 'package:quotify/provider/theme_provider.dart';
import 'package:quotify/services/screenshot_services.dart';
import 'package:screenshot/screenshot.dart' show ScreenshotController;

class QuoteScreenTopBar extends StatelessWidget {
  final ScreenshotController? screenshotController;
  const QuoteScreenTopBar({super.key, this.screenshotController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Consumer<ThemeProvier>(builder: (context, dataClass, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: dataClass.isDarkMode ? AppColors.white : AppColors.black,
              ),
            ),
            screenshotController != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
                      ),
                      onPressed: () async {
                        await ScreenshotServices.download(
                          context: context,
                          screenshotController: screenshotController!,
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.file_download_outlined,
                            color: dataClass.isDarkMode
                                ? AppColors.white
                                : AppColors.black,
                          ),
                          AppSpacing.width10,
                          Text(
                            'Download',
                            style: TextStyle(
                              color: dataClass.isDarkMode
                                  ? AppColors.white
                                  : AppColors.black,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
          ],
        );
      }),
    );
  }
}

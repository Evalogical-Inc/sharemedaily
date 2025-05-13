import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/constants/spacing.dart';
import 'package:quotify/config/constants/system_theme.dart';
import 'package:quotify/provider/theme_provider.dart';
import 'package:quotify/utilities/user_util.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Provider.of<ThemeProvier>(context, listen: false).isDarkMode
                ? Colors.white
                : Colors.black,
          ),
        ),
        title: Text(
          'Theme',
          style: textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<ThemeProvier>(builder: (context, themeProvider, _) {
            var textTheme = Theme.of(context).textTheme;
            var userData = UserData();
            return Column(
              children: [
                RadioListTile<ThemeMode>(
                  value: ThemeMode.light,
                  groupValue: themeProvider.themeMode,
                  onChanged: (ThemeMode? value) async {
                    themeProvider.toggleTheme(value!);
                    themeProvider.brightness = Brightness.light;
                    await userData.setIsDarkMode(SystemTheme.light);
                  },
                  title: Row(
                    children: [
                      const Icon(Icons.light_mode),
                      AppSpacing.width10,
                      Text(
                        'Light',
                        style: textTheme.bodyMedium?.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.dark,
                  groupValue: themeProvider.themeMode,
                  onChanged: (ThemeMode? value) async {
                    themeProvider.toggleTheme(value!);
                    themeProvider.brightness = Brightness.dark;
                    await userData.setIsDarkMode(SystemTheme.dark);
                  },
                  title: Row(
                    children: [
                      const Icon(Icons.dark_mode),
                      AppSpacing.width10,
                      Text(
                        'Dark',
                        style: textTheme.bodyMedium?.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.system,
                  groupValue: themeProvider.themeMode,
                  onChanged: (ThemeMode? value) async {
                    themeProvider.toggleTheme(value!);
                    var brightness = MediaQuery.of(context).platformBrightness;
                    themeProvider.brightness = brightness;
                    await userData.setIsDarkMode(SystemTheme.system);
                  },
                  title: Row(
                    children: [
                      const Icon(Icons.brightness_6),
                      AppSpacing.width10,
                      Text(
                        'System default',
                        style: textTheme.bodyMedium?.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class WidgetGuidePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Color backgroundColor = isDarkMode ? Colors.black : Colors.white;
    Color cardColor = isDarkMode ? Colors.grey[900]! : Colors.grey[200]!;
    Color textColor = isDarkMode ? Colors.white70 : Colors.black87;
    Color dividerColor = isDarkMode ? Colors.white24 : Colors.grey[400]!;
    Color circleAvatarColor = isDarkMode ? Color(0xFF64748B) : Colors.blueGrey[200]!;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Widgets", style: TextStyle(color: textColor)),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              "How to add a widget to your phone's home screen",
              style: TextStyle(color: textColor, fontSize: 16),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildStep("1", "Long press on empty space in your Home Screen", textColor, circleAvatarColor),
                  _buildDivider(dividerColor),
                  _buildStep("2", "Tap \"+\" at the top left or Tap  at the bottom", textColor, circleAvatarColor),
                  _buildDivider(dividerColor),
                  _buildStep("3", "Scroll down and tap \"sharemedaily\"", textColor, circleAvatarColor),
                  _buildDivider(dividerColor),
                  _buildStep("4", "Tap the \"sharemedaily\" widget", textColor, circleAvatarColor),
                  _buildDivider(dividerColor),
                  const SizedBox(height: 16),
                  Container(
                    height: 200,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1739698124907-32a5d9d497c4?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w0NTQ2MTF8MHwxfGFsbHwzfHx8fHx8fHwxNzM5OTM5NTU2fA&ixlib=rb-4.0.3&q=80&w=1080', // Replace with actual image asset or URL
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(Color color) {
    return Divider(
      color: color,
      thickness: 1,
      height: 16,
    );
  }

  Widget _buildStep(String number, String text, Color textColor, Color circleAvatarColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: circleAvatarColor,
            child: Text(number, style: TextStyle(color: Colors.white)),
            radius: 14,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: textColor, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

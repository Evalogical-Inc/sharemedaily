import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About Us',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            // const SizedBox(height: 8.0),
            // const Text(
            //   'Last updated: December 18, 2024',
            //   style: TextStyle(
            //     fontSize: 16.0,
            //     fontStyle: FontStyle.italic,
            //   ),
            // ),
            const SizedBox(height: 16.0),
            const Text(
              'Welcome to ShareMeDaily, your daily source of inspiration, positivity, and motivation! Developed by the talented team at Evalogical, ShareMeDaily was created with the vision of bringing uplifting quotes and meaningful messages to your fingertips every single day. At ShareMeDaily, we believe in the power of words to transform perspectives and brighten lives. Whether you’re starting your day, seeking encouragement during challenging times, or simply looking for a moment of reflection, our carefully curated quotes are here to resonate with your thoughts and emotions. ',
            ),
            const SizedBox(height: 16.0),
            _buildSectionTitle('What Sets Us Apart?'),
            _buildListItem('Daily Motivation: Fresh, handpicked quotes delivered every day to inspire your journey'),
            _buildListItem('Beautiful Design: A user-friendly interface designed with care to make your experience seamless and enjoyable.'),
            _buildListItem('Personal Connection: Content that speaks to your heart, sparking positivity and motivation.'),
            _buildSectionTitle('Our Mission'),
            _buildSectionContent('Our mission is simple: to make your every day a little brighter and a lot more meaningful. With ShareMeDaily, you can carry the wisdom of great thinkers, authors, and visionaries wherever you go.'),
            _buildSectionContent('Built with passion and expertise by the Evalogical team, ShareMeDaily reflects our commitment to innovation, creativity, and delivering exceptional digital experiences.'),
            _buildSectionContent('Stay inspired, stay motivated, and let ShareMeDaily be your daily companion for positivity and growth.'),
            _buildSectionTitle('Join Us on This Journey'),
            _buildSectionContent('Join Us on This Journey')
            // Row(
            //   children: [
            //     Expanded(
            //       child: RichText(
            //         textAlign: TextAlign.center,
            //         text: TextSpan(
            //           text: 'By visiting this page on our website:',
            //           style: Theme.of(context).textTheme.bodyMedium,
            //           children: const <InlineSpan>[
            //             TextSpan(
            //               text: 'By visiting this page on our website:'
            //             ),
            //             WidgetSpan(
            //               alignment: PlaceholderAlignment.baseline,
            //               baseline: TextBaseline.alphabetic,
            //               child: LinkButton(
            //                   urlLabel: "evalogical.com",
            //                   url: "https://evalogical.com/"),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSectionSubtitle(String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        content,
        style: const TextStyle(
          fontSize: 16.0,
        ),
      ),
    );
  }

  Widget _buildListItem(String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('•'.toString(), style: const TextStyle(fontSize: 20.0)),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              content,
              style: const TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}

class LinkButton extends StatelessWidget {
  const LinkButton({Key? key, required this.urlLabel, required this.url})
      : super(key: key);

  final String urlLabel;
  final String url;

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri)) {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        minimumSize: const Size(0, 0),
        textStyle: Theme.of(context).textTheme.bodySmall,
      ),
      onPressed: () {
        _launchUrl(url);
      },
      child: Text(urlLabel),
    );
  }
}

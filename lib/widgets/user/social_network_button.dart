import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: unused_element
class SocialNetworkButton extends StatelessWidget {
  final IconData socialNetworkIcon;
  final String network;

  const SocialNetworkButton({
    super.key, 
    required this.socialNetworkIcon, 
    required this.network,
  });

  @override
  Widget build(BuildContext context) {

    final Uri url = Uri.parse(network);

    // ignore: no_leading_underscores_for_local_identifiers
    Future<void> _launchUrl() async {
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }

    return Container(
      margin: const EdgeInsets.only(left: 6),
      child: ElevatedButton(
        onPressed: () {
          _launchUrl();
        },
        style: ButtonStyle(
          iconSize: const MaterialStatePropertyAll(20),
          shadowColor: const MaterialStatePropertyAll(Colors.transparent),
          shape: MaterialStateProperty.all(const CircleBorder()),
          padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
          backgroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.background), 
          surfaceTintColor: MaterialStateProperty.all(Theme.of(context).colorScheme.background)
        ),
        child: Icon(
          socialNetworkIcon,
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
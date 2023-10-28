import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './social_network_button.dart';


class CustomFooter extends StatelessWidget {
  const CustomFooter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SocialNetworkButton(socialNetworkIcon: FontAwesomeIcons.instagram,network: 'https://www.instagram.com/'),
        SocialNetworkButton(socialNetworkIcon: FontAwesomeIcons.xTwitter,network: 'https://twitter.com/'),
        SocialNetworkButton(socialNetworkIcon: FontAwesomeIcons.google, network: 'https://www.google.com/'),
        SocialNetworkButton(socialNetworkIcon: FontAwesomeIcons.tiktok, network: 'https://www.tiktok.com/es/'),
      ],
    );
  }
}
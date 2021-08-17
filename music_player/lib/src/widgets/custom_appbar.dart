import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.only(top: size.width * 0.08),
        child: Row(
          children: [
            SizedBox(width: size.width * 0.01),
            FaIcon(FontAwesomeIcons.chevronLeft),
            Spacer(
              flex: 1,
            ),
            FaIcon(FontAwesomeIcons.commentAlt),
            SizedBox(width: size.width * 0.05),
            FaIcon(FontAwesomeIcons.headphonesAlt),
            SizedBox(width: size.width * 0.05),
            FaIcon(FontAwesomeIcons.externalLinkAlt),
            SizedBox(width: size.width * 0.01),
          ],
        ));
  }
}

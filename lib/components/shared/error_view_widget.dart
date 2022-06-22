import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastosrecorrentes/shared/text_styles.dart';

class ErrorViewWidget extends StatelessWidget {
  const ErrorViewWidget({
    Key? key,
    required this.errorText,
  }) : super(key: key);

  final String errorText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(FontAwesomeIcons.triangleExclamation, size: 80, color: Colors.grey[700]),
          const SizedBox(height: 24),
          Text(errorText, style: TextStyles.bodyText2()),
        ],
      ),
    );
  }
}

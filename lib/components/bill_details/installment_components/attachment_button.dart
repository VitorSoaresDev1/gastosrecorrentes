import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastosrecorrentes/models/installment.dart';
import 'package:gastosrecorrentes/services/local/multi_language.dart';
import 'package:gastosrecorrentes/shared/text_styles.dart';

class AttachmentButton extends StatelessWidget {
  final Installment? installment;

  const AttachmentButton({Key? key, required this.installment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Tooltip(
        message: MultiLanguage.translate("attach"),
        child: SizedBox(
          height: 40,
          width: 50,
          child: ElevatedButton(
            onPressed: () => {},
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              elevation: 4,
              side: const BorderSide(
                width: 1,
                color: Colors.white,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              textStyle: TextStyles.bodySubtitle(light: true),
            ),
            child: Center(
              child: Icon(FontAwesomeIcons.paperclip, color: Colors.grey[800]!),
            ),
          ),
        ),
      ),
    );
  }
}

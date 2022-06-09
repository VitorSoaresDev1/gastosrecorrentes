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
    bool hasAttachment = false;
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Tooltip(
        message: MultiLanguage.translate("attach"),
        child: SizedBox(
          height: 40,
          width: 50,
          child: ElevatedButton(
            onPressed: () => {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                ),
                builder: (context) {
                  return SafeArea(
                    bottom: true,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "${MultiLanguage.translate("installment")}: ${installment!.index}",
                                  style: TextStyles.titles2(),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text("Comprovante", style: TextStyles.titles2()),
                            ),
                            const Expanded(flex: 1, child: SizedBox()),
                          ],
                        ),
                        ListTile(
                          minLeadingWidth: 20,
                          leading: Icon(FontAwesomeIcons.paperclip, size: 20, color: Colors.grey[900]),
                          title: const Text("Anexar"),
                        ),
                        ListTile(
                          minLeadingWidth: 20,
                          leading: Icon(FontAwesomeIcons.fileLines,
                              size: 20, color: hasAttachment ? Colors.grey[900] : Colors.grey),
                          title: const Text("Visualizar"),
                          enabled: hasAttachment,
                        ),
                        ListTile(
                          minLeadingWidth: 20,
                          leading: Icon(FontAwesomeIcons.ban,
                              size: 20, color: hasAttachment ? Colors.grey[900] : Colors.grey),
                          title: const Text("Remover"),
                          enabled: hasAttachment,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                },
              )
            },
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

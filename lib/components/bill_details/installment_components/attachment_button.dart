import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gastosrecorrentes/models/installment.dart';
import 'package:gastosrecorrentes/services/local/image_picker_handler.dart';
import 'package:gastosrecorrentes/services/local/multi_language.dart';
import 'package:gastosrecorrentes/services/local/navigation_service.dart';
import 'package:gastosrecorrentes/shared/text_styles.dart';
import 'package:gastosrecorrentes/view_models/bills_view_model.dart';
import 'package:provider/provider.dart';

class AttachmentButton extends StatefulWidget {
  final Installment? installment;

  const AttachmentButton({Key? key, required this.installment}) : super(key: key);

  @override
  State<AttachmentButton> createState() => _AttachmentButtonState();
}

class _AttachmentButtonState extends State<AttachmentButton> with TickerProviderStateMixin {
  late AnimationController _controller;
  late ImagePickerHandler imagePicker;
  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    imagePicker = ImagePickerHandler(_controller);
    imagePicker.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Tooltip(
        message: MultiLanguage.translate("attachProof"),
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
                  BillsViewModel billsViewModel = context.watch<BillsViewModel>();
                  bool hasAttachment = widget.installment?.attachment?.isNotEmpty ?? false;
                  return SafeArea(
                    bottom: true,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "${MultiLanguage.translate("installment")}: ${widget.installment!.index}",
                                style: TextStyles.titles2(),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(MultiLanguage.translate("proofOfPayment"), style: TextStyles.titles2()),
                            ),
                          ],
                        ),
                        ListTile(
                          minLeadingWidth: 20,
                          leading: Icon(FontAwesomeIcons.paperclip, size: 20, color: Colors.grey[900]),
                          title: Text(MultiLanguage.translate("attach")),
                          onTap: () async {
                            String? imageString = await imagePicker.showDialog(context);
                            if (imageString != null) {
                              billsViewModel.updateCurrentAttachment(widget.installment!, imageString);
                            }
                          },
                        ),
                        ListTile(
                          minLeadingWidth: 20,
                          leading: Icon(FontAwesomeIcons.fileLines,
                              size: 20, color: hasAttachment ? Colors.grey[900] : Colors.grey),
                          title: Text(MultiLanguage.translate("view")),
                          enabled: hasAttachment,
                          onTap: () {
                            billsViewModel.setCurrentSelectedInstallment = widget.installment!;
                            NavigationService.openAttachmentViewScreen(context);
                          },
                        ),
                        ListTile(
                            minLeadingWidth: 20,
                            leading: Icon(FontAwesomeIcons.ban,
                                size: 20, color: hasAttachment ? Colors.grey[900] : Colors.grey),
                            title: Text(MultiLanguage.translate("remove")),
                            enabled: hasAttachment,
                            onTap: () async {
                              billsViewModel.setCurrentSelectedInstallment = widget.installment!;
                              billsViewModel.updateCurrentAttachment(widget.installment!, null);
                            }),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                },
              )
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
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

  // @override
  // userImage(CroppedFile _image) {
  //   AttachmentsViewModel
  //   updateCurrentAttachment();
  // }
}

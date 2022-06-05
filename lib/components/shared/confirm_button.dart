import 'package:flutter/material.dart';
import 'package:gastosrecorrentes/shared/text_styles.dart';

class ConfirmButton extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String tooltipMessage;
  final VoidCallback? onPressed;
  const ConfirmButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.tooltipMessage = '',
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Tooltip(
        message: tooltipMessage,
        child: SizedBox(
          height: 40,
          width: 50,
          child: ElevatedButton(
            onPressed: isLoading ? () {} : onPressed,
            style: ElevatedButton.styleFrom(
              elevation: 2,
              side: const BorderSide(
                width: .3,
                color: Colors.white,
              ),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              textStyle: TextStyles.bodySubtitle(light: true),
            ),
            child: isLoading
                ? Container(
                    width: 20,
                    height: 20,
                    padding: const EdgeInsets.all(2.0),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    ),
                  )
                : child,
          ),
        ),
      ),
    );
  }
}

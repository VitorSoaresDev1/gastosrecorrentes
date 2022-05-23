import 'package:flutter/material.dart';

class ButtonWithLoading extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final String title;

  const ButtonWithLoading({Key? key, required this.isLoading, required this.onPressed, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: isLoading
          ? Container(
              width: 24,
              height: 24,
              padding: const EdgeInsets.all(2.0),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            )
          : Text(title),
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(6),
        fixedSize: MaterialStateProperty.all(const Size.fromWidth(160)),
      ),
      onPressed: isLoading ? () {} : onPressed,
    );
  }
}

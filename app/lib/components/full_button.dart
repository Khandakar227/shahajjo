import 'package:flutter/material.dart';

class FullButton extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isLoading;
  final Widget child;
  final Color? backgroundColor;
  final double? width;
  final double? height;

  const FullButton({
    super.key,
    required this.onTap,
    this.isLoading = false,
    required this.child,
    this.backgroundColor = const Color(0xFF9B0A18),
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Padding(padding: const EdgeInsets.all(8), child: child),
      ),
    );
  }
}

// // Usage:
// FullButton(
//  onTap: _handleLogin,
//  isLoading: _isLoading,
//  text: 'লগইন',
//  // Optional parameters
//  // backgroundColor: Colors.blue,
//  // width: 100,
//  // height: 50,
// )
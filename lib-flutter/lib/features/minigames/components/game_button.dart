import 'package:flutter/material.dart';

/// Styled game button with Bitcoin theme
class GameButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isOutlined;
  final bool isLoading;
  final bool isDisabled;
  final double width;
  final double height;
  final double fontSize;

  const GameButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.isOutlined = false,
    this.isLoading = false,
    this.isDisabled = false,
    this.width = 200,
    this.height = 50,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    final bitcoinOrange = const Color(0xFFF7931A);
    final darkBg = const Color(0xFF1A1A2E);
    final darkCard = const Color(0xFF16213E);

    Color bgColor = backgroundColor ?? bitcoinOrange;
    Color txtColor = textColor ?? Colors.white;

    if (isOutlined) {
      return SizedBox(
        width: width,
        height: height,
        child: OutlinedButton(
          onPressed: isDisabled || isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: bgColor, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.transparent,
          ),
          child: _buildContent(txtColor: bgColor),
        ),
      );
    }

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isDisabled || isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          disabledBackgroundColor: Colors.grey.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          shadowColor: bgColor.withOpacity(0.5),
        ),
        child: _buildContent(txtColor: txtColor),
      ),
    );
  }

  Widget _buildContent({required Color txtColor}) {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(txtColor),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: txtColor, size: fontSize + 4),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: txtColor,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: TextStyle(
        color: txtColor,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

/// Icon game button for quick actions
class IconButtonGame extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final String? tooltip;

  const IconButtonGame({
    super.key,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 48,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final bitcoinOrange = const Color(0xFFF7931A);
    final darkCard = const Color(0xFF16213E);

    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: backgroundColor ?? darkCard,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: bitcoinOrange.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: iconColor ?? bitcoinOrange,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

enum AppButtonType {
  primary,
  secondary,
  outline,
  text,
  danger,
}

enum AppButtonSize {
  small,
  medium,
  large,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isLoading;
  final Widget? icon;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final buttonStyle = _getButtonStyle(colorScheme);
    final textStyle = _getTextStyle(theme);
    final padding = _getPadding();
    final borderRadius = _getBorderRadius();

    Widget buttonChild = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: _getIconSize(),
            height: _getIconSize(),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getTextColor(colorScheme),
              ),
            ),
          ),
          const SizedBox(width: 8),
        ] else if (icon != null) ...[
          icon!,
          const SizedBox(width: 8),
        ],
        Text(text, style: textStyle),
      ],
    );

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonStyle.backgroundColor?.resolve({}),
          foregroundColor: buttonStyle.foregroundColor?.resolve({}),
          elevation: buttonStyle.elevation?.resolve({}),
          shadowColor: buttonStyle.shadowColor?.resolve({}),
          side: buttonStyle.side?.resolve({}),
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
        ),
        child: buttonChild,
      ),
    );
  }

  ButtonStyle _getButtonStyle(ColorScheme colorScheme) {
    switch (type) {
      case AppButtonType.primary:
        return ButtonStyle(
          backgroundColor: WidgetStateProperty.all(colorScheme.primary),
          foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
          elevation: WidgetStateProperty.all(2),
          shadowColor: WidgetStateProperty.all(colorScheme.shadow),
        );
      case AppButtonType.secondary:
        return ButtonStyle(
          backgroundColor: WidgetStateProperty.all(colorScheme.secondary),
          foregroundColor: WidgetStateProperty.all(colorScheme.onSecondary),
          elevation: WidgetStateProperty.all(1),
          shadowColor: WidgetStateProperty.all(colorScheme.shadow),
        );
      case AppButtonType.outline:
        return ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.all(colorScheme.primary),
          elevation: WidgetStateProperty.all(0),
          side: WidgetStateProperty.all(
            BorderSide(color: colorScheme.primary, width: 1),
          ),
        );
      case AppButtonType.text:
        return ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.all(colorScheme.primary),
          elevation: WidgetStateProperty.all(0),
        );
      case AppButtonType.danger:
        return ButtonStyle(
          backgroundColor: WidgetStateProperty.all(colorScheme.error),
          foregroundColor: WidgetStateProperty.all(colorScheme.onError),
          elevation: WidgetStateProperty.all(2),
          shadowColor: WidgetStateProperty.all(colorScheme.shadow),
        );
    }
  }

  TextStyle _getTextStyle(ThemeData theme) {
    switch (size) {
      case AppButtonSize.small:
        return theme.textTheme.labelSmall ?? const TextStyle(fontSize: 12);
      case AppButtonSize.medium:
        return theme.textTheme.labelMedium ?? const TextStyle(fontSize: 14);
      case AppButtonSize.large:
        return theme.textTheme.labelLarge ?? const TextStyle(fontSize: 16);
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }

  BorderRadius _getBorderRadius() {
    switch (size) {
      case AppButtonSize.small:
        return BorderRadius.circular(6);
      case AppButtonSize.medium:
        return BorderRadius.circular(8);
      case AppButtonSize.large:
        return BorderRadius.circular(12);
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 12;
      case AppButtonSize.medium:
        return 16;
      case AppButtonSize.large:
        return 20;
    }
  }

  Color _getTextColor(ColorScheme colorScheme) {
    switch (type) {
      case AppButtonType.primary:
        return colorScheme.onPrimary;
      case AppButtonType.secondary:
        return colorScheme.onSecondary;
      case AppButtonType.outline:
      case AppButtonType.text:
        return colorScheme.primary;
      case AppButtonType.danger:
        return colorScheme.onError;
    }
  }
}

import 'package:flutter/material.dart';

enum AppCardType {
  elevated,
  outlined,
  filled,
}

class AppCard extends StatelessWidget {
  final Widget child;
  final AppCardType type;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? elevation;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.type = AppCardType.elevated,
    this.padding,
    this.margin,
    this.elevation,
    this.backgroundColor,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final cardStyle = _getCardStyle(colorScheme);
    final defaultPadding = _getDefaultPadding();
    final defaultBorderRadius = _getDefaultBorderRadius();

    Widget cardContent = Container(
      padding: padding ?? defaultPadding,
      decoration: BoxDecoration(
        color: backgroundColor ?? cardStyle.backgroundColor,
        borderRadius: borderRadius ?? defaultBorderRadius,
        border: cardStyle.border,
        boxShadow: cardStyle.boxShadow,
      ),
      child: child,
    );

    if (onTap != null) {
      return Container(
        margin: margin,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? defaultBorderRadius,
          child: cardContent,
        ),
      );
    }

    return Container(
      margin: margin,
      child: cardContent,
    );
  }

  CardStyle _getCardStyle(ColorScheme colorScheme) {
    switch (type) {
      case AppCardType.elevated:
        return CardStyle(
          backgroundColor: colorScheme.surface,
          border: null,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        );
      case AppCardType.outlined:
        return CardStyle(
          backgroundColor: colorScheme.surface,
          border: Border.all(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: null,
        );
      case AppCardType.filled:
        return CardStyle(
          backgroundColor: colorScheme.surfaceVariant,
          border: null,
          boxShadow: null,
        );
    }
  }

  EdgeInsets _getDefaultPadding() {
    return const EdgeInsets.all(16);
  }

  BorderRadius _getDefaultBorderRadius() {
    return BorderRadius.circular(12);
  }
}

class CardStyle {
  final Color backgroundColor;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  CardStyle({
    required this.backgroundColor,
    this.border,
    this.boxShadow,
  });
}

import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final void Function()? onPressed;
  final String? text;
  final Widget? child;
  final bool isLoading;
  final bool isDisabled;
  final IconData? icon;
  final double? iconSize;
  final Color? color;

  const AppButton({
    super.key,
    this.onPressed,
    this.text,
    this.child,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.iconSize = 20,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled || isLoading ? null : onPressed,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        width: double.infinity,
        child: isLoading && icon == null
            ? SizedBox(
                width: 21,
                height: 21,
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(
                    color ?? Colors.grey.shade700,
                  ),
                ),
              )
            : child ??
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      isLoading
                          ? SizedBox(
                              width: iconSize,
                              height: iconSize,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  color,
                                ),
                              ),
                            )
                          : Icon(icon, size: iconSize, color: color),
                      const SizedBox(width: 8),
                    ],
                    if (text != null)
                      Text(
                        text!,
                        style: TextStyle(
                          color: color,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
      ),
    );
  }
}

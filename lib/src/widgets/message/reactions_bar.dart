

import 'package:flutter/material.dart';
import '../state/inherited_chat_theme.dart';

class ReactionsBar extends StatelessWidget {
  final Map<String, String> reactions; // userId -> emoji
  final void Function()? onTap;

  const ReactionsBar({
    super.key,
    required this.reactions,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = InheritedChatTheme.of(context).theme;
    final uniqueEmojis = reactions.values.toSet().toList(); // extract unique emoji values
    final visibleEmojis = uniqueEmojis.length > 4 ? uniqueEmojis.sublist(0, 4) : uniqueEmojis;
    final overflow = uniqueEmojis.length > 4 ? uniqueEmojis.length - 4 : 0;

    return GestureDetector(
      onTap: () => onTap?.call(),
      child: Container(
        height: 28,
        decoration: BoxDecoration(
          color: theme.secondaryColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.backgroundColor, width: 3),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...visibleEmojis.map((emoji) => TweenAnimationBuilder<double>(
                    key: ValueKey(emoji),
                    duration: const Duration(milliseconds: 250),
                    tween: Tween(begin: 0.0, end: 1.0),
                    curve: Curves.easeInOut,
                    builder: (context, scale, child) => Transform.scale(
                      scale: scale,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Text(emoji, style: const TextStyle(fontSize: 14)),
                      ),
                    ),
                  )),
            if (overflow > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text('+$overflow', style: const TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
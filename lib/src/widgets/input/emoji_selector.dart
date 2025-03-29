import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

import '../state/inherited_chat_theme.dart';

void showEmojiReactionOverlay({
  required BuildContext context,
  required Color primaryColor,
  required Color backgroundColor,
  required void Function(String emoji) onEmojiSelected,
  required void Function() onPop,
}) {
      showPopover(
        onPop: () => onPop(),
        backgroundColor: backgroundColor,
        context: context,
        radius: 20,
        shadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 34,
            offset: Offset(0, 12),
          ),
        ],
        transition: PopoverTransition.other,
        transitionDuration: const Duration(milliseconds: 150),
        bodyBuilder: (context) => ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
          height: 320,
          width: 300,
          child: EmojiPicker(
          onEmojiSelected: (category, emoji) {
            Navigator.of(context).pop();
            onEmojiSelected(emoji.emoji);
          },
          config: Config(
          emojiViewConfig: EmojiViewConfig(
            emojiSizeMax: 28,
            columns: 7,
            backgroundColor: backgroundColor,
          ),
          categoryViewConfig: CategoryViewConfig(
            backgroundColor: backgroundColor,
            initCategory: Category.SMILEYS,
            indicatorColor:  primaryColor,
            iconColorSelected: primaryColor,
            dividerColor: Colors.grey.shade300,
            categoryIcons: const CategoryIcons(
              recentIcon: Icons.history,
              flagIcon: Icons.flag_outlined,
              animalIcon: Icons.pets_outlined,
              foodIcon: Icons.fastfood_outlined,
              travelIcon: Icons.travel_explore_outlined,
              activityIcon: Icons.person_2_outlined
            ),

          ),
          skinToneConfig: const SkinToneConfig(),
          searchViewConfig: SearchViewConfig(
            backgroundColor: backgroundColor,
            hintText: 'Search...',
          ),
          bottomActionBarConfig: BottomActionBarConfig(
              backgroundColor: backgroundColor,
              showSearchViewButton: false,
              showBackspaceButton: false,
            ),
          ),
        ),
      ),
    ),
    direction: PopoverDirection.bottom,
    width: 300,
    height: 320,
    arrowHeight: 10,
    arrowWidth: 20,
    barrierColor: Colors.transparent,
  );
}


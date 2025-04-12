import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:intl/intl.dart' as intl;
import 'package:pull_down_button/pull_down_button.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../conditional/conditional.dart';
import '../../models/bubble_rtl_alignment.dart';
import '../../models/emoji_enlargement_behavior.dart';
import '../../util.dart';
import '../input/emoji_selector.dart';
import '../state/inherited_chat_theme.dart';
import '../state/inherited_user.dart';
import 'file_message.dart';
import 'image_message.dart';
import 'message_status.dart';
import 'reactions_bar.dart';
import 'text_message.dart';
import 'user_avatar.dart';

/// Base widget for all message types in the chat. Renders bubbles around
/// messages and status. Sets maximum width for a message for
/// a nice look on larger screens.
class Message extends StatelessWidget {
  /// Creates a particular message from any message type.
 Message({
    super.key,
    this.audioMessageBuilder,
    this.avatarBuilder,
    this.bubbleBuilder,
    this.bubbleRtlAlignment,
    this.customMessageBuilder,
    this.customStatusBuilder,
    required this.emojiEnlargementBehavior,
    this.fileMessageBuilder,
    required this.hideBackgroundOnEmojiMessages,
    this.imageHeaders,
    this.imageMessageBuilder,
    this.imageProviderBuilder,
    required this.message,
    required this.messageWidth,
    this.nameBuilder,
    this.onAvatarTap,
    this.onMessageDoubleTap,
    this.onMessageLongPress,
    this.onMessageStatusLongPress,
    this.onMessageStatusTap,
    this.onMessageTap,
    this.onMessageReactionTap,
    this.onCurrentMessageReactionsTap,
    this.onMessageReplyTap,
    this.onMessageCopyTap,
    this.onMessageUnsendTap,
    this.onMessageReportTap,
    this.onMessageReactionRemoveTap,
    this.onMessageMenuItemTap,
    this.onMessageVisibilityChanged,
    this.onPreviewDataFetched,
    required this.roundBorder,
    required this.isFirstMessageInGroup,
    required this.isLastMessageInGroup,
    required this.isMessageInGroup,
    required this.showAvatar,
    required this.showName,
    required this.showStatus,
    required this.isLeftStatus,
    required this.showUserAvatars,
    this.textMessageBuilder,
    required this.textMessageOptions,
    required this.usePreviewData,
    this.userAgent,
    this.videoMessageBuilder,
  });

  /// Build an audio message inside predefined bubble.
  final Widget Function(types.AudioMessage, {required int messageWidth})?
      audioMessageBuilder;

  /// This is to allow custom user avatar builder
  /// By using this we can fetch newest user info based on id.
  final Widget Function(types.User author)? avatarBuilder;

  /// Customize the default bubble using this function. `child` is a content
  /// you should render inside your bubble, `message` is a current message
  /// (contains `author` inside) and `nextMessageInGroup` allows you to see
  /// if the message is a part of a group (messages are grouped when written
  /// in quick succession by the same author).
  final Widget Function(
    Widget child, {
    required types.Message message,
    required bool nextMessageInGroup,
  })? bubbleBuilder;

  /// Determine the alignment of the bubble for RTL languages. Has no effect
  /// for the LTR languages.
  final BubbleRtlAlignment? bubbleRtlAlignment;

  /// Build a custom message inside predefined bubble.
  final Widget Function(types.CustomMessage, {required int messageWidth})?
      customMessageBuilder;

  /// Build a custom status widgets.
  final Widget Function(types.Message message, {required BuildContext context})?
      customStatusBuilder;

  /// Controls the enlargement behavior of the emojis in the
  /// [types.TextMessage].
  /// Defaults to [EmojiEnlargementBehavior.multi].
  final EmojiEnlargementBehavior emojiEnlargementBehavior;

  /// Build a file message inside predefined bubble.
  final Widget Function(types.FileMessage, {required int messageWidth})?
      fileMessageBuilder;

  /// Hide background for messages containing only emojis.
  final bool hideBackgroundOnEmojiMessages;

  /// See [Chat.imageHeaders].
  final Map<String, String>? imageHeaders;

  /// Build an image message inside predefined bubble.
  final Widget Function(types.ImageMessage, {required int messageWidth})?
      imageMessageBuilder;

  /// See [Chat.imageProviderBuilder].
  final ImageProvider Function({
    required String uri,
    required Map<String, String>? imageHeaders,
    required Conditional conditional,
  })? imageProviderBuilder;

  /// Any message type.
  final types.Message message;

  /// Maximum message width.
  final int messageWidth;

  /// See [TextMessage.nameBuilder].
  final Widget Function(types.User)? nameBuilder;

  /// See [UserAvatar.onAvatarTap].
  final void Function(types.User)? onAvatarTap;

  /// Called when user double taps on any message.
  final void Function(BuildContext context, types.Message)? onMessageDoubleTap;

  /// Called when user makes a long press on any message.
  final void Function(BuildContext context, types.Message)? onMessageLongPress;

  /// Called when user makes a long press on status icon in any message.
  final void Function(BuildContext context, types.Message)?
      onMessageStatusLongPress;

  /// Called when user taps on status icon in any message.
  final void Function(BuildContext context, types.Message)? onMessageStatusTap;

  /// Called when user taps on any message.
  final void Function(BuildContext context, types.Message)? onMessageTap;

  /// Called when user taps on message copy.
  final void Function(BuildContext context, types.Message)? onMessageCopyTap;

  /// Called when user taps on message reaction.
  final void Function(BuildContext context, types.Message, String reaction)? onMessageReactionTap;

  /// Called when user taps on existing message reactions.
  final void Function(BuildContext context, types.Message)? onCurrentMessageReactionsTap;

  /// Called when user taps on message reply.
  final void Function(BuildContext context, types.Message)? onMessageReplyTap;

  /// Called when message owner taps unsend Message. 
  final void Function(BuildContext context, types.Message)? onMessageUnsendTap;

  /// Called when reporting message not by owner.
  final void Function(BuildContext context, types.Message)? onMessageReportTap;
  
  /// Called when message owner taps remove reaction.
  final void Function(BuildContext context, types.Message)? onMessageReactionRemoveTap;

  /// Called when the message's visibility changes.
  final void Function(types.Message, bool visible)? onMessageVisibilityChanged;

  /// Called when user taps message menu item on any message. 
  final void Function(String value)? onMessageMenuItemTap;

  /// See [TextMessage.onPreviewDataFetched].
  final void Function(types.TextMessage, types.PreviewData)?
      onPreviewDataFetched;

  /// Rounds border of the message to visually group messages together.
  final bool roundBorder;

  /// Show user avatar for the received message. Useful for a group chat.
  final bool showAvatar;

  /// This is used to determine if the message is the first in a grouped message. Also used to show user name for the message.
  final bool isFirstMessageInGroup;

  /// This is used to determine if the message is the last message in a grouped message.
  final bool isLastMessageInGroup;

  /// This is used to determine if the message is apart of grouped message.
  final bool isMessageInGroup;

  /// See [TextMessage.showName].
  final bool showName;

  /// Show message's status.
  final bool showStatus;

  /// This is used to determine if the status icon should be on the left or
  /// right side of the message.
  /// This is only used when [showStatus] is true.
  /// Defaults to false.
  final bool isLeftStatus;

  /// Show user avatars for received messages. Useful for a group chat.
  final bool showUserAvatars;

  /// Build a text message inside predefined bubble.
  final Widget Function(
    types.TextMessage, {
    required int messageWidth,
    required bool showName,
  })? textMessageBuilder;

  /// See [TextMessage.options].
  final TextMessageOptions textMessageOptions;

  /// See [TextMessage.usePreviewData].
  final bool usePreviewData;

  /// See [TextMessage.userAgent].
  final String? userAgent;

  /// Build an audio message inside predefined bubble.
  final Widget Function(types.VideoMessage, {required int messageWidth})?
      videoMessageBuilder;

  final _hoverNotifier = ValueNotifier<bool>(false);
  final _emojiPickerVisibleNotifier = ValueNotifier<bool>(false);

  Widget _avatarBuilder() => showAvatar
      ? avatarBuilder?.call(message.author) ??
          UserAvatar(
            author: message.author,
            bubbleRtlAlignment: bubbleRtlAlignment,
            imageHeaders: imageHeaders,
            onAvatarTap: onAvatarTap,
          )
      : const SizedBox(width: 40);

  Widget _popupMenuBuilder(ValueNotifier<bool> hoverNotifier, bool currentUserIsAuthor, bool hasReaction) => ValueListenableBuilder<bool>(
  valueListenable: _emojiPickerVisibleNotifier,
    builder: (context, isEmojiPickerVisible, _) => ValueListenableBuilder<bool>(
          valueListenable: hoverNotifier,
          builder: (context, isHovered, child) {
            if (!isHovered && !isEmojiPickerVisible) return const SizedBox.shrink();
      
            final primaryColor = InheritedChatTheme.of(context).theme.primaryColor;
            final secondarColor = InheritedChatTheme.of(context).theme.secondaryColor;
      
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(CupertinoIcons.smiley, size: 18, color: primaryColor),
                onPressed: () {
                  _emojiPickerVisibleNotifier.value = true;
                  showEmojiReactionOverlay(
                    context: context,
                    primaryColor: primaryColor,
                    backgroundColor: secondarColor,
                    onEmojiSelected: (emoji) {
                      _emojiPickerVisibleNotifier.value = false;
                      onMessageReactionTap?.call(context, message, emoji);
                    },
                    onPop: () => _emojiPickerVisibleNotifier.value = false,
                  );
                },
                tooltip: 'React',
              ),
              if (MediaQuery.of(context).size.width > 650) IconButton(
                icon: Icon(CupertinoIcons.arrow_uturn_left, size: 18, color: primaryColor),
                onPressed: () => onMessageReplyTap?.call(context, message),
                tooltip: 'Reply',
              ),
              _moreBuilder(
                context, 
                currentUserIsAuthor,
                hasReaction,
              ),
            ],
          ),
        );
      },
    ),
  );
  

  Widget _moreBuilder(BuildContext context, bool currentUserIsAuthor, bool hasReaction) {
    final timestamp = message.createdAt != null
        ? intl.DateFormat('MMM d, hh:mm a')
            .format(DateTime.fromMillisecondsSinceEpoch(message.createdAt!))
        : null;
 
      return PullDownButton(
          onCanceled: () => _emojiPickerVisibleNotifier.value = false,
          itemBuilder: (context) => [
            if (timestamp != null)
              PullDownMenuItem(
                enabled: false,
                title: timestamp,
                onTap: null,
              ),
            if (timestamp != null) const PullDownMenuDivider.large(),
            PullDownMenuItem(
              title: 'Copy',
              icon: CupertinoIcons.doc_on_clipboard,
              onTap: () {
                onMessageCopyTap?.call(context, message);
                _emojiPickerVisibleNotifier.value = false;
              }, 
            ),
            PullDownMenuItem(
              title: 'Reply',
              icon: CupertinoIcons.arrow_uturn_left,
              onTap: () {
                onMessageReplyTap?.call(context, message);
                _emojiPickerVisibleNotifier.value = false;
              }, 
            ),
            if (!currentUserIsAuthor) 
            PullDownMenuItem(
              title: 'Report',
              icon: CupertinoIcons.flag,
              isDestructive: true,
              onTap: () {
                onMessageReportTap?.call(context, message);
              }
            ),
            if (currentUserIsAuthor && hasReaction) 
            PullDownMenuItem(
              title: 'Remove reaction',
              icon: CupertinoIcons.smiley,
              isDestructive: true,
              onTap: () {
                onMessageReactionRemoveTap?.call(context, message);
              },
            ),
            if (currentUserIsAuthor)
            PullDownMenuItem(
              title: 'Unsend',
              icon: CupertinoIcons.delete,
              isDestructive: true,
              onTap: () {
                onMessageUnsendTap?.call(context, message);
                _emojiPickerVisibleNotifier.value = false;
              },
            ),
          ],
          position: PullDownMenuPosition.automatic,
          buttonBuilder: (context, showMenu) => IconButton(
            icon: Icon(
              CupertinoIcons.ellipsis,
              size: 18,
              color: InheritedChatTheme.of(context).theme.primaryColor,
            ),
            onPressed: () {
              _emojiPickerVisibleNotifier.value = true;
              showMenu();
            },
            tooltip: 'More',
          ),
        );
  }

  Widget _bubbleBuilder(
    BuildContext context,
    BorderRadius borderRadius,
    types.Message currentMessage,
    bool currentUserIsAuthor,
    bool enlargeEmojis,
    Map<String, String> reactions,
  ) {
    final defaultMessage = Stack(
            clipBehavior: Clip.none,
            alignment: (currentUserIsAuthor) ? Alignment.bottomRight : Alignment.bottomLeft,
            children: [
              if (enlargeEmojis && hideBackgroundOnEmojiMessages) _messageBuilder(),
              if (!(enlargeEmojis && hideBackgroundOnEmojiMessages)) Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: !currentUserIsAuthor ||
                          currentMessage.type == types.MessageType.image
                      ? InheritedChatTheme.of(context).theme.secondaryColor
                      : InheritedChatTheme.of(context).theme.primaryColor,
                ),
                child: ClipRRect(
                  borderRadius: borderRadius,
                  child: _messageBuilder(),
                ),
              ),
              if (reactions.isNotEmpty)
                Positioned(
                  bottom: -15,
                  right: (currentUserIsAuthor) ? 20 : null,
                  left: (currentUserIsAuthor) ? null : 10,
                  child: ReactionsBar(
                    reactions: reactions,
                    onTap: () => onCurrentMessageReactionsTap?.call(context, currentMessage),
                  ),
                ),
            ],
          );
    return bubbleBuilder != null
        ? bubbleBuilder!(
            _messageBuilder(),
            message: currentMessage,
            nextMessageInGroup: roundBorder,
          )
        : defaultMessage;
  }

  Widget _messageBuilder() {
    switch (message.type) {
      case types.MessageType.audio:
        final audioMessage = message as types.AudioMessage;
        return audioMessageBuilder != null
            ? audioMessageBuilder!(audioMessage, messageWidth: messageWidth)
            : const SizedBox();
      case types.MessageType.custom:
        final customMessage = message as types.CustomMessage;
        return customMessageBuilder != null
            ? customMessageBuilder!(customMessage, messageWidth: messageWidth)
            : const SizedBox();
      case types.MessageType.file:
        final fileMessage = message as types.FileMessage;
        return fileMessageBuilder != null
            ? fileMessageBuilder!(fileMessage, messageWidth: messageWidth)
            : FileMessage(message: fileMessage);
      case types.MessageType.image:
        final imageMessage = message as types.ImageMessage;
        return imageMessageBuilder != null
            ? imageMessageBuilder!(imageMessage, messageWidth: messageWidth)
            : ImageMessage(
                imageHeaders: imageHeaders,
                imageProviderBuilder: imageProviderBuilder,
                message: imageMessage,
                messageWidth: messageWidth,
              );
      case types.MessageType.text:
        final textMessage = message as types.TextMessage;
        return textMessageBuilder != null
            ? textMessageBuilder!(
                textMessage,
                messageWidth: messageWidth,
                showName: showName,
              )
            : TextMessage(
                emojiEnlargementBehavior: emojiEnlargementBehavior,
                hideBackgroundOnEmojiMessages: hideBackgroundOnEmojiMessages,
                message: textMessage,
                nameBuilder: nameBuilder,
                onPreviewDataFetched: onPreviewDataFetched,
                options: textMessageOptions,
                showName: showName,
                usePreviewData: usePreviewData,
                userAgent: userAgent,
              );
      case types.MessageType.video:
        final videoMessage = message as types.VideoMessage;
        return videoMessageBuilder != null
            ? videoMessageBuilder!(videoMessage, messageWidth: messageWidth)
            : const SizedBox();
      default:
        return const SizedBox();
    }
  }

  Widget _repliedMessageBuilder() {
    switch (message.repliedMessage?.type) {
      case types.MessageType.audio:
        final audioMessage = message.repliedMessage as types.AudioMessage;
        return audioMessageBuilder != null
            ? audioMessageBuilder!(audioMessage, messageWidth: messageWidth)
            : const SizedBox();
      case types.MessageType.custom:
        final customMessage = message.repliedMessage as types.CustomMessage;
        return customMessageBuilder != null
            ? customMessageBuilder!(customMessage, messageWidth: messageWidth)
            : const SizedBox();
      case types.MessageType.file:
        final fileMessage = message.repliedMessage as types.FileMessage;
        return fileMessageBuilder != null
            ? fileMessageBuilder!(fileMessage, messageWidth: messageWidth)
            : FileMessage(message: fileMessage);
      case types.MessageType.image:
        final imageMessage = message.repliedMessage as types.ImageMessage;
        return imageMessageBuilder != null
            ? imageMessageBuilder!(imageMessage, messageWidth: messageWidth)
            : ImageMessage(
                imageHeaders: imageHeaders,
                imageProviderBuilder: imageProviderBuilder,
                message: imageMessage,
                messageWidth: (messageWidth * 0.35).toInt(),
            );
        case types.MessageType.text:
        final textMessage = message.repliedMessage as types.TextMessage;
        return textMessageBuilder != null
          ? textMessageBuilder!(
              textMessage,
              messageWidth: messageWidth,
              showName: showName,
            )
          : TextMessage(
              emojiEnlargementBehavior: emojiEnlargementBehavior,
              hideBackgroundOnEmojiMessages: hideBackgroundOnEmojiMessages,
              message: textMessage,
              showName: false,
              usePreviewData: false,
            );
        case types.MessageType.video: 
        final videoMessage = message.repliedMessage as types.VideoMessage;
        return videoMessageBuilder != null
            ? videoMessageBuilder!(videoMessage, messageWidth: messageWidth)
            : const SizedBox();
        default:
        return const SizedBox();
    }
  }

  Widget _statusIcon(
    BuildContext context,
  ) {
    if (!showStatus) return const SizedBox.shrink();

    return Padding(
      padding: InheritedChatTheme.of(context).theme.statusIconPadding,
      child: GestureDetector(
        onLongPress: () => onMessageStatusLongPress?.call(context, message),
        onTap: () => onMessageStatusTap?.call(context, message),
        child: customStatusBuilder != null
            ? customStatusBuilder!(message, context: context)
            : MessageStatus(status: message.status),
      ),
    );
  }

  Widget _buildRepliedMessagePreview(
  BuildContext context,
  types.Message repliedMessage,
  bool currentUserIsAuthor
) {
  final user = InheritedUser.of(context).user;
  final theme = InheritedChatTheme.of(context).theme;
  final replyMessageIsAuthor = repliedMessage.author.id == user.id;

  final replyLabel = currentUserIsAuthor
      ? 'You replied to ${(replyMessageIsAuthor) ? 'Yourself' : repliedMessage.author.firstName}'
      : '${message.author.firstName} replied to ${repliedMessage.author.firstName}';

  final borderRadius = BorderRadius.circular(theme.messageBorderRadius);

    return Column(
      crossAxisAlignment: (currentUserIsAuthor) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (repliedMessage.author.firstName != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              replyLabel,
              style: theme.dateDividerTextStyle,
            ),
          ),

          IntrinsicHeight(
            child: Row(
              children: [
                if (!currentUserIsAuthor) 
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: InheritedChatTheme.of(context).theme.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: messageWidth.toDouble(),
                  ),
                  child: Opacity(
                    opacity: 0.4,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Container(
                            decoration: BoxDecoration(
                              borderRadius: borderRadius,
                              color: !replyMessageIsAuthor ||
                                      repliedMessage.type == types.MessageType.image
                                  ? InheritedChatTheme.of(context).theme.secondaryColor.withOpacity(0.4)
                                  : InheritedChatTheme.of(context).theme.primaryColor.withOpacity(0.4),
                            ),
                            child: ClipRRect(
                              borderRadius: borderRadius,
                              child: _repliedMessageBuilder(),
                        ),
                      ),
                    ),
                  ),
                ),
                if (currentUserIsAuthor) 
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: InheritedChatTheme.of(context).theme.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    final user = InheritedUser.of(context).user;
    final currentUserIsAuthor = user.id == message.author.id;
    final enlargeEmojis =
        emojiEnlargementBehavior != EmojiEnlargementBehavior.never &&
            message is types.TextMessage &&
            isConsistsOfEmojis(
              emojiEnlargementBehavior,
              message as types.TextMessage,
            );
    final messageBorderRadius =
        InheritedChatTheme.of(context).theme.messageBorderRadius;

    final reactions = (message.metadata?['reactions'] as Map?)?.cast<String, String>() ?? {};
    final currentUserHasReportedMessage = message.metadata?['reported'] != null && (message.metadata?['reported'] as Map<String, dynamic>).containsKey(user.id);
    final userHasReacted = reactions.containsKey(user.id);

    final repliedMessage = message.repliedMessage;
    
    final borderRadius = (!isMessageInGroup)
        ? BorderRadius.circular(messageBorderRadius)
        : BorderRadius.only(
            topLeft: Radius.circular(
              currentUserIsAuthor
                  ? messageBorderRadius
                  : isFirstMessageInGroup
                      ? messageBorderRadius
                      : 0,
            ),
            topRight: Radius.circular(
              currentUserIsAuthor
                  ? isFirstMessageInGroup
                      ? messageBorderRadius
                      : 0
                  : messageBorderRadius,
            ),
            bottomLeft: Radius.circular(
              currentUserIsAuthor
                  ? messageBorderRadius
                  : isLastMessageInGroup
                      ? messageBorderRadius
                      : 0,
            ),
            bottomRight: Radius.circular(
              currentUserIsAuthor
                  ? isLastMessageInGroup
                      ? messageBorderRadius
                      : 0
                  : messageBorderRadius,
            ),
          );

    final bubbleMargin = InheritedChatTheme.of(context).theme.bubbleMargin ??
        (bubbleRtlAlignment == BubbleRtlAlignment.left
            ? EdgeInsetsDirectional.only(
                bottom: 4,
                end: isMobile ? query.padding.right : 0,
                start: 20 + (isMobile ? query.padding.left : 0),
              )
            : EdgeInsets.only(
                bottom: 4,
                left: 20 + (isMobile ? query.padding.left : 0),
                right: isMobile ? query.padding.right : 0,
              )
            );
      
    return MouseRegion(
      onEnter: (_) => _hoverNotifier.value = true,
      onExit: (_) => _hoverNotifier.value = false,
      child: Container(
        alignment: bubbleRtlAlignment == BubbleRtlAlignment.left
            ? currentUserIsAuthor
                ? AlignmentDirectional.centerEnd
                : AlignmentDirectional.centerStart
            : currentUserIsAuthor
                ? Alignment.centerRight
                : Alignment.centerLeft,
        margin: bubbleMargin,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          textDirection: bubbleRtlAlignment == BubbleRtlAlignment.left
              ? null
              : TextDirection.ltr,
          children: [
            if (!currentUserIsAuthor && showUserAvatars) _avatarBuilder(),
            Column(
              crossAxisAlignment: (currentUserIsAuthor) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: (currentUserIsAuthor) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                        if (repliedMessage != null) _buildRepliedMessagePreview(context, repliedMessage, currentUserIsAuthor),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (currentUserIsAuthor) _popupMenuBuilder(_hoverNotifier, currentUserIsAuthor, userHasReacted),
                            Flexible(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                maxWidth: messageWidth.toDouble(),
                                ),
                                child: GestureDetector(
                                  onDoubleTap: () => onMessageDoubleTap?.call(context, message),
                                  onLongPress: () => onMessageLongPress?.call(context, message),
                                  onTap: () => onMessageTap?.call(context, message),
                                  child: onMessageVisibilityChanged != null
                                      ? VisibilityDetector(
                                          key: Key(message.id),
                                          onVisibilityChanged: (visibilityInfo) =>
                                            onMessageVisibilityChanged!(
                                            message,
                                            visibilityInfo.visibleFraction > 0.1,
                                          ),
                                          child: _bubbleBuilder(
                                            context,
                                            borderRadius.resolve(Directionality.of(context)),
                                            message,
                                            currentUserIsAuthor,
                                            enlargeEmojis,
                                            reactions,
                                          ),
                                        )
                                      : _bubbleBuilder(
                                          context,
                                          borderRadius.resolve(Directionality.of(context)),
                                          message,
                                          currentUserIsAuthor,
                                          enlargeEmojis,
                                          reactions,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (reactions.isNotEmpty) const SizedBox(height: 14),
                      ],
                    ),
                if (currentUserIsAuthor) _statusIcon(context),
                if (!currentUserIsAuthor && currentUserHasReportedMessage) Text('Reported by you', style: TextStyle(color: Theme.of(context).colorScheme.error)),
              ],
            ),
            if (!currentUserIsAuthor) _popupMenuBuilder(_hoverNotifier, currentUserIsAuthor, userHasReacted),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/core/design/app_radius.dart';
import 'package:bac_nafa/features/ai_assistant/providers/ai_providers.dart';

class ChatInput extends ConsumerStatefulWidget {
  final Function(String) onSend;
  const ChatInput({super.key, required this.onSend});

  @override
  ConsumerState<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends ConsumerState<ChatInput> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() => _hasFocus = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final isSending = ref.watch(isSendingProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.fromLTRB(16, 8, 16, MediaQuery.of(context).padding.bottom + 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: _hasFocus ? colorScheme.outlineVariant : Colors.transparent,
            width: _hasFocus ? 1 : 0,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(28),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLines: 4,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Pose ta question…',
                  hintStyle: TextStyle(color: AppColors.textTertiary, fontSize: 15),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.fromLTRB(20, 14, 8, 14),
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 46,
            height: 46,
            child: FilledButton(
              onPressed: isSending ? null : _send,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                disabledBackgroundColor: AppColors.surfaceContainerHigh,
                disabledForegroundColor: AppColors.textTertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.circular),
                ),
                padding: EdgeInsets.zero,
                elevation: 0,
              ),
              child: isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.onPrimary,
                      ),
                    )
                  : const Icon(Icons.send_rounded, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
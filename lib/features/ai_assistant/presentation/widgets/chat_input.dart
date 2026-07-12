import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
import 'package:bac_nafa/features/ai_assistant/providers/ai_providers.dart';

class ChatInput extends ConsumerWidget {
  final Function(String) onSend;

  const ChatInput({super.key, required this.onSend});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSending = ref.watch(isSendingProvider);
    final controller = TextEditingController();

    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Posez votre question...',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
              onSubmitted: (val) {
                if (val.trim().isNotEmpty) {
                  onSend(val);
                  controller.clear();
                }
              },
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          CircleAvatar(
            radius: 24,
            backgroundColor: isSending ? AppColors.outline : AppColors.primary,
            child: isSending 
              ? const SizedBox(
                  width: 20, 
                  height: 20, 
                  child: CircularProgressIndicator(
                    strokeWidth: 2, 
                    color: Colors.white,
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.send, color: Colors.white, size: 20),
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      onSend(controller.text);
                      controller.clear();
                    }
                  },
                ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:bac_nafa/app/theme/app_colors.dart';
import 'package:bac_nafa/app/theme/app_text_styles.dart';
import 'package:bac_nafa/core/design/app_spacing.dart';
import 'package:bac_nafa/features/ai_assistant/domain/models/chat_models.dart';

class AIMessageRenderer extends StatelessWidget {
  final ChatMessage message;

  const AIMessageRenderer({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: message.contents.map((content) {
        switch (content.type) {
          case MessageContentType.markdown:
            return _MarkdownRenderer(content: content);
          case MessageContentType.latex:
            return _LatexRenderer(content: content);
          case MessageContentType.table:
            return _TableRenderer(content: content);
          case MessageContentType.image:
            return _ImageRenderer(content: content);
          case MessageContentType.document:
            return _DocumentRenderer(content: content);
          case MessageContentType.artifact:
            return _ArtifactRenderer(content: content);
          case MessageContentType.text:
            return _TextRenderer(content: content);
        }
      }).toList(),
    );
  }
}

class _TextRenderer extends StatelessWidget {
  final MessageContent content;
  const _TextRenderer({required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Text(
        content.text,
        style: AppTextStyles.bodyMedium,
      ),
    );
  }
}

class _MarkdownRenderer extends StatelessWidget {
  final MessageContent content;
  const _MarkdownRenderer({required this.content});

  @override
  Widget build(BuildContext context) {
    // Future implementation: Use flutter_markdown package
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Text(
        '[Markdown] ${content.text}',
        style: AppTextStyles.bodyMedium.copyWith(fontStyle: FontStyle.italic),
      ),
    );
  }
}

class _LatexRenderer extends StatelessWidget {
  final MessageContent content;
  const _LatexRenderer({required this.content});

  @override
  Widget build(BuildContext context) {
    // Future implementation: Use flutter_math_fork or similar
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.outline),
      ),
      child: Center(
        child: Text(
          '\$ ${content.text} \$',
          style: AppTextStyles.bodyMedium.copyWith(
            fontFamily: 'Courier', 
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _TableRenderer extends StatelessWidget {
  final MessageContent content;
  const _TableRenderer({required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Info')),
            DataColumn(label: Text('Valeur')),
          ],
          rows: [
            DataRow(cells: [
              DataCell(Text('Contenu')),
              DataCell(Text(content.text)),
            ]),
          ],
        ),
      ),
    );
  }
}

class _ImageRenderer extends StatelessWidget {
  final MessageContent content;
  const _ImageRenderer({required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          content.text,
          errorBuilder: (context, error, stackTrace) => Container(
            height: 100,
            color: AppColors.surface,
            child: const Center(child: Icon(Icons.broken_image)),
          ),
        ),
      ),
    );
  }
}

class _DocumentRenderer extends StatelessWidget {
  final MessageContent content;
  const _DocumentRenderer({required this.content});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.description, color: AppColors.primary),
      title: Text(content.text, style: AppTextStyles.bodySmall),
      trailing: const Icon(Icons.download, size: 18),
      onTap: () {},
    );
  }
}

class _ArtifactRenderer extends StatelessWidget {
  final MessageContent content;
  const _ArtifactRenderer({required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.aiAccent, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, size: 16, color: AppColors.aiAccent),
              SizedBox(width: 8),
              Text(
                'Fiche Pédagogique',
                style: AppTextStyles.titleSmall.copyWith(color: AppColors.aiAccent),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            content.text,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }
}

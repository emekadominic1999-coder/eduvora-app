import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../legal_content.dart';

/// Shows the Terms of Use or Privacy Policy, from the generated
/// [LegalContent] (see tools/gen_legal.py).
class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key, required this.doc});

  final LegalDoc doc;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        title: Text(doc.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColours.border),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                AppSpacing.lg,
                AppSpacing.screenPadding,
                AppSpacing.xxl,
              ),
              children: <Widget>[
                Text(
                  'Last updated: ${doc.updated}',
                  style: text.bodySmall?.copyWith(color: AppColours.textFaint),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(doc.intro, style: text.bodyMedium?.copyWith(height: 1.55)),
                for (final LegalSection s in doc.sections) ...<Widget>[
                  const SizedBox(height: AppSpacing.xl),
                  Text(s.heading, style: text.titleMedium),
                  for (final String p in s.paragraphs) ...<Widget>[
                    const SizedBox(height: AppSpacing.sm),
                    Text(p, style: text.bodyMedium?.copyWith(height: 1.55)),
                  ],
                  for (final String b in s.bullets) ...<Widget>[
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.only(top: 1, right: 8, left: 4),
                          child: Text('•'),
                        ),
                        Expanded(
                          child: Text(
                            b,
                            style: text.bodyMedium?.copyWith(height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// lib/widgets/contact_section.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portifolio/Models/resume_models.dart';
import 'package:portifolio/Theme/ds3_pallet.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  final Profile profile;

  ContactSection({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _ContactCard(
          icon: Icons.email_outlined,
          title: 'Email',
          value: profile.email,
          onPrimaryTap: () => _openEmail(context, profile.email),
          onSecondaryTap: () => _copyToClipboard(context, profile.email, 'Email copiado'),
        ),
        _ContactCard(
          icon: Icons.phone_outlined,
          title: 'Telefone',
          value: profile.phone,
          onPrimaryTap: () => _callPhone(context, profile.phone),
          onSecondaryTap: () => _copyToClipboard(context, profile.phone, 'Telefone copiado'),
        ),
        if ((profile.linkedin ?? '').isNotEmpty)
          _ContactCard(
            icon: Icons.link,
            title: 'LinkedIn',
            value: profile.linkedin,
            onPrimaryTap: () => _openLink(context, profile.linkedin),
            onSecondaryTap: () => _copyToClipboard(context, profile.linkedin, 'Link do LinkedIn copiado'),
            primaryLabel: 'Abrir',
          ),
        if ((profile.github ?? '').isNotEmpty)
          _ContactCard(
            icon: Icons.code,
            title: 'GitHub',
            value: profile.github,
            onPrimaryTap: () => _openLink(context, profile.github),
            onSecondaryTap: () => _copyToClipboard(context, profile.github, 'Link do GitHub copiado'),
            primaryLabel: 'Abrir',
          ),
        // localização (opcional)
        if ((profile.location ?? '').isNotEmpty)
          _ContactCard(
            icon: Icons.location_on_outlined,
            title: 'Localização',
            value: profile.location,
            onPrimaryTap: null,
            onSecondaryTap: () => _copyToClipboard(context, profile.location!, 'Localização copiada'),
            showCopyOnly: true,
          ),
      ],
    );
  }

  Future<void> _openLink(BuildContext context, String url) async {
    try {
      final uri = Uri.tryParse(url) ?? Uri();
      if (uri.toString().isEmpty) throw 'URL inválida';
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Não foi possível abrir o link')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao abrir link: $e')));
    }
  }

  Future<void> _openEmail(BuildContext context, String email) async {
    try {
      final uri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {
          'subject': 'Contato via portfólio'
        },
      );
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cliente de e-mail não encontrado')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao abrir email: $e')));
    }
  }

  Future<void> _callPhone(BuildContext context, String phone) async {
    try {
      final cleaned = phone.replaceAll(RegExp(r'[^0-9+]'), '');
      final uri = Uri(scheme: 'tel', path: cleaned);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Não foi possível iniciar chamada')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao iniciar chamada: $e')));
    }
  }

  Future<void> _copyToClipboard(BuildContext context, String text, String msg) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback? onPrimaryTap;
  final VoidCallback? onSecondaryTap;
  final String primaryLabel;
  final bool showCopyOnly;

  const _ContactCard({
    Key? key,
    required this.icon,
    required this.title,
    this.value,
    this.onPrimaryTap,
    this.onSecondaryTap,
    this.primaryLabel = 'Abrir',
    this.showCopyOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool hasValue = (value ?? '').isNotEmpty;

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 200, maxWidth: 420),
      child: Container(
        decoration: BoxDecoration(
          color: CyberpunkColors.charcoalGray,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CyberpunkColors.mediumGray.withOpacity(0.12)),
          boxShadow: [
            BoxShadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: CyberpunkColors.darkGray,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: CyberpunkColors.screenTeal),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: TextStyle(color: Colors.white70, fontSize: 12)),
                  SizedBox(height: 4),
                  if (hasValue)
                    SelectableText(
                      value!,
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      maxLines: 2,
                      scrollPhysics: NeverScrollableScrollPhysics(),
                    )
                  else
                    Text('Não informado', style: TextStyle(color: Colors.white38)),
                ],
              ),
            ),
            SizedBox(width: 12),
            // ações
            if (!showCopyOnly) ...[
              IconButton(
                tooltip: primaryLabel,
                visualDensity: VisualDensity.compact,
                onPressed: hasValue && onPrimaryTap != null ? onPrimaryTap : null,
                icon: Icon(Icons.open_in_new, color: hasValue ? CyberpunkColors.primaryOrange : Colors.white24),
              ),
              IconButton(
                tooltip: 'Copiar',
                visualDensity: VisualDensity.compact,
                onPressed: hasValue && onSecondaryTap != null ? onSecondaryTap : null,
                icon: Icon(Icons.copy, color: CyberpunkColors.neonBlue),
              ),
            ] else ...[
              IconButton(
                tooltip: 'Copiar',
                visualDensity: VisualDensity.compact,
                onPressed: hasValue && onSecondaryTap != null ? onSecondaryTap : null,
                icon: Icon(Icons.copy, color: CyberpunkColors.neonBlue),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

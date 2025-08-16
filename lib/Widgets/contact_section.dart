// lib/widgets/contact_section.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portifolio/Models/resume_models.dart';
import 'package:portifolio/Theme/ds3_pallet.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  final Profile profile;

 ContactSection({Key? key, required this.profile}) : super(key: key);

  // Cache das configurações dos cartões para evitar recriação
  late final List<_ContactCardConfig> _contactConfigs = [
    _ContactCardConfig(
      icon: Icons.email_outlined,
      title: 'Email',
      value: profile.email,
      onPrimaryTap: () => _openEmail(profile.email),
      onSecondaryTap: () => _copyToClipboard(profile.email, 'Email copiado'),
    ),
    if (_isNotEmpty(profile.linkedin))
      _ContactCardConfig(
        icon: Icons.link,
        title: 'LinkedIn',
        value: profile.linkedin!,
        onPrimaryTap: () => _openLink(profile.linkedin!),
        onSecondaryTap: () => _copyToClipboard(profile.linkedin!, 'Link do LinkedIn copiado'),
        primaryLabel: 'Abrir',
      ),
    if (_isNotEmpty(profile.github))
      _ContactCardConfig(
        icon: Icons.code,
        title: 'GitHub',
        value: profile.github!,
        onPrimaryTap: () => _openLink(profile.github!),
        onSecondaryTap: () => _copyToClipboard(profile.github!, 'Link do GitHub copiado'),
        primaryLabel: 'Abrir',
      ),
    if (_isNotEmpty(profile.location))
      _ContactCardConfig(
        icon: Icons.location_on_outlined,
        title: 'Localização',
        value: profile.location!,
        onSecondaryTap: () => _copyToClipboard(profile.location!, 'Localização copiada'),
        showCopyOnly: true,
      ),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: _contactConfigs
          .map((config) => _ContactCard(config: config))
          .toList(growable: false),
    );
  }

  // Métodos helper inline para melhor performance
  bool _isNotEmpty(String? value) => value != null && value.isNotEmpty;

  Future<void> _openLink(String url) async {
    try {
      final uri = Uri.tryParse(url);
      if (uri == null || !uri.hasScheme) {
        throw 'URL inválida: $url';
      }
      
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Não foi possível abrir o link';
      }
    } catch (e) {
      // Usar rethrow para manter stack trace
      rethrow;
    }
  }

  Future<void> _openEmail(String email) async {
    try {
      final uri = Uri(
        scheme: 'mailto',
        path: email,
        queryParameters: {'subject': 'Contato via portfólio'},
      );
      
      if (!await launchUrl(uri)) {
        throw 'Cliente de e-mail não encontrado';
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _copyToClipboard(String text, String message) async {
    await Clipboard.setData(ClipboardData(text: text));
    // Retorna a mensagem para ser exibida pelo widget pai se necessário
  }
}

// Classe de configuração para evitar passing many parameters
class _ContactCardConfig {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onPrimaryTap;
  final VoidCallback? onSecondaryTap;
  final String primaryLabel;
  final bool showCopyOnly;

  const _ContactCardConfig({
    required this.icon,
    required this.title,
    required this.value,
    this.onPrimaryTap,
    this.onSecondaryTap,
    this.primaryLabel = 'Abrir',
    this.showCopyOnly = false,
  });
}

class _ContactCard extends StatelessWidget {
  final _ContactCardConfig config;

  const _ContactCard({Key? key, required this.config}) : super(key: key);

  // Constantes para evitar recriação
  static const _cardConstraints = BoxConstraints(minWidth: 200, maxWidth: 420);
  static const _iconSize = 44.0;
  static const _spacing = 12.0;
  static const _padding = EdgeInsets.symmetric(horizontal: 14, vertical: 12);
  static const _iconPadding = EdgeInsets.all(10);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: _cardConstraints,
      child: Container(
        decoration: _buildCardDecoration(),
        padding: _padding,
        child: Row(
          children: [
            _buildIconContainer(),
            const SizedBox(width: _spacing),
            _buildContentSection(),
            const SizedBox(width: _spacing),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: CyberpunkColors.charcoalGray,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: CyberpunkColors.mediumGray.withOpacity(0.12),
      ),
      boxShadow: const [
        BoxShadow(
          color: Colors.black45,
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildIconContainer() {
    return Container(
      width: _iconSize,
      height: _iconSize,
      decoration: BoxDecoration(
        color: CyberpunkColors.darkGray,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        config.icon,
        color: CyberpunkColors.screenTeal,
      ),
    );
  }

  Widget _buildContentSection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            config.title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          SelectableText(
            config.value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (config.showCopyOnly) {
      return _buildCopyButton(context);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPrimaryButton(context),
        _buildCopyButton(context),
      ],
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    return IconButton(
      tooltip: config.primaryLabel,
      visualDensity: VisualDensity.compact,
      onPressed: config.onPrimaryTap != null 
          ? () => _handleAction(context, config.onPrimaryTap!)
          : null,
      icon: Icon(
        Icons.open_in_new,
        color: config.onPrimaryTap != null 
            ? CyberpunkColors.primaryOrange 
            : Colors.white24,
      ),
    );
  }

  Widget _buildCopyButton(BuildContext context) {
    return IconButton(
      tooltip: 'Copiar',
      visualDensity: VisualDensity.compact,
      onPressed: config.onSecondaryTap != null
          ? () => _handleCopyAction(context)
          : null,
      icon: Icon(
        Icons.copy,
        color: CyberpunkColors.neonBlue,
      ),
    );
  }

  Future<void> _handleAction(BuildContext context, VoidCallback action) async {
    try {
      action();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    }
  }

  Future<void> _handleCopyAction(BuildContext context) async {
    try {
      config.onSecondaryTap?.call();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${config.title} copiado!'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao copiar: $e')),
        );
      }
    }
  }
}
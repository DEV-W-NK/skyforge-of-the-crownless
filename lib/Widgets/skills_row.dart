// lib/widgets/skills_row.dart

import 'package:flutter/material.dart';
import 'package:portifolio/Theme/ds3_pallet.dart';
import 'package:url_launcher/url_launcher.dart';

/// Widget que exibe uma linha de skills (tecnologias) com animações e links externos.
class SkillsRow extends StatelessWidget {
  final List<String> skills;

  /// [skills] pode ser passado ou usa uma lista padrão.
  SkillsRow({
    Key? key,
    List<String>? skills,
  })  : skills = skills ??
            ['Flutter', 'Dart', 'Java', 'C++', 'Firebase', 'Node.js', 'MQTT', 'ESP32'],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills.map((s) => _SkillPill(skill: s)).toList(),
    );
  }
}

/// Widget individual para cada skill, com animação de hover/press e link externo.
class _SkillPill extends StatefulWidget {
  final String skill;
  const _SkillPill({Key? key, required this.skill}) : super(key: key);

  @override
  State<_SkillPill> createState() => _SkillPillState();
}

class _SkillPillState extends State<_SkillPill> {
  bool _hover = false;
  bool _pressed = false;

  /// Controla estado de hover.
  void _onEnter(bool v) => setState(() => _hover = v);

  /// Controla estado de pressionado.
  void _onPress(bool v) => setState(() => _pressed = v);

  @override
  Widget build(BuildContext context) {
    final double scale = _pressed ? 0.98 : (_hover ? 1.03 : 1.0);
    final icon = _iconFor(widget.skill);

    return MouseRegion(
      onEnter: (_) => _onEnter(true),
      onExit: (_) => _onEnter(false),
      child: GestureDetector(
        onTapDown: (_) => _onPress(true),
        onTapUp: (_) => _onPress(false),
        onTapCancel: () => _onPress(false),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 180),
          transform: Matrix4.identity()..scale(scale, scale),
          curve: Curves.easeOut,
          padding: EdgeInsets.zero,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: CyberpunkColors.darkGray,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _hover
                    ? CyberpunkColors.primaryOrange.withOpacity(0.9)
                    : CyberpunkColors.mediumGray.withOpacity(0.18),
                width: _hover ? 1.6 : 1.0,
              ),
              boxShadow: _hover
                  ? [
                      BoxShadow(
                        color: CyberpunkColors.primaryOrange.withOpacity(0.12),
                        blurRadius: 16,
                        spreadRadius: 1,
                        offset: Offset(0, 6),
                      )
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      )
                    ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _openSkillLink(widget.skill), // abre link externo
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Marcador vertical colorido
                      Container(
                        width: 6,
                        height: 28,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: _accentFor(widget.skill),
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      SizedBox(width: 10),
                      // Ícone da skill (se houver)
                      if (icon != null) ...[
                        Icon(icon, size: 16, color: CyberpunkColors.screenTeal),
                        SizedBox(width: 8),
                      ],
                      // Texto da skill com tooltip
                      Tooltip(
                        message: widget.skill,
                        child: Text(
                          widget.skill,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Retorna ícone nativo para a skill.
  IconData? _iconFor(String s) {
    final n = s.toLowerCase();
    if (n.contains('flutter')) return Icons.flutter_dash;
    if (n.contains('dart')) return Icons.code;
    if (n.contains('java')) return Icons.code;
    if (n.contains('c++')) return Icons.memory;
    if (n.contains('firebase')) return Icons.cloud;
    if (n.contains('node')) return Icons.storage;
    if (n.contains('mqtt')) return Icons.sensors;
    if (n.contains('esp')) return Icons.developer_board;
    return null;
  }

  /// Retorna gradiente de cores para a skill.
  List<Color> _accentFor(String s) {
    final n = s.toLowerCase();
    if (n.contains('flutter') || n.contains('dart')) {
      return [CyberpunkColors.screenTeal, CyberpunkColors.primaryOrange];
    }
    if (n.contains('java') || n.contains('c++')) {
      return [CyberpunkColors.primaryOrange, CyberpunkColors.glowYellow];
    }
    if (n.contains('firebase') || n.contains('node')) {
      return [CyberpunkColors.neonBlue, CyberpunkColors.screenTeal];
    }
    if (n.contains('mqtt') || n.contains('esp')) {
      return [CyberpunkColors.terminalGreen, CyberpunkColors.screenTeal];
    }
    return [CyberpunkColors.primaryOrange, CyberpunkColors.neonBlue];
  }

  /// Abre o link externo de referência da skill.
  void _openSkillLink(String skill) async {
    final url = _skillUrl(skill);
    if (url != null) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  /// Mapeia skill para um link externo de referência.
  String? _skillUrl(String s) {
    final n = s.toLowerCase();
    if (n.contains('flutter')) return 'https://flutter.dev/';
    if (n.contains('dart')) return 'https://dart.dev/';
    if (n.contains('java')) return 'https://www.java.com/';
    if (n.contains('c++')) return 'https://isocpp.org/';
    if (n.contains('firebase')) return 'https://firebase.google.com/';
    if (n.contains('node')) return 'https://nodejs.org/';
    if (n.contains('mqtt')) return 'https://mqtt.org/';
    if (n.contains('esp')) return 'https://www.espressif.com/en/products/socs/esp32';
    return null;
  }
}
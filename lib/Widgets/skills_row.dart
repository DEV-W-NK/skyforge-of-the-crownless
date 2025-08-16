// lib/widgets/skills_row.dart

import 'package:flutter/material.dart';
import 'package:portifolio/Theme/ds3_pallet.dart';
import 'package:url_launcher/url_launcher.dart';

/// Widget que exibe uma linha de skills (tecnologias) com animações otimizadas.
class SkillsRow extends StatelessWidget {
  final List<String> skills;

  /// [skills] pode ser passado ou usa uma lista padrão.
  SkillsRow({
    Key? key,
    List<String>? skills,
  })  : skills = skills ??
            ['Flutter', 'Dart', 'Java','Mobile', 'C++', 'Firebase', 'Node.js', 'MQTT', 'ESP32'],
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

/// Widget individual para cada skill, com animações otimizadas.
class _SkillPill extends StatefulWidget {
  final String skill;
  const _SkillPill({Key? key, required this.skill}) : super(key: key);

  @override
  State<_SkillPill> createState() => _SkillPillState();
}

class _SkillPillState extends State<_SkillPill>
    with SingleTickerProviderStateMixin {
  
  // Controllers para animações otimizadas
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _borderAnimation;
  late Animation<double> _glowAnimation;
  
  bool _isHovered = false;
  
  // Cache dos valores calculados para evitar recálculos
  late final IconData? _cachedIcon;
  late final List<Color> _cachedGradient;
  late final String? _cachedUrl;

  @override
  void initState() {
    super.initState();
    
    // Inicializar controller único para todas as animações
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    // Animações com curvas otimizadas
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02, // Reduzido para ser mais sutil
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic, // Curva mais suave
    ));
    
    _borderAnimation = Tween<double>(
      begin: 1.0,
      end: 1.4,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 0.12,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    // Cache dos valores para evitar recálculos durante animações
    _cachedIcon = _iconFor(widget.skill);
    _cachedGradient = _accentFor(widget.skill);
    _cachedUrl = _skillUrl(widget.skill);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool isHovered) {
    if (_isHovered != isHovered) {
      setState(() {
        _isHovered = isHovered;
      });
      
      if (isHovered) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHoverChanged(true),
      onExit: (_) => _onHoverChanged(false),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: CyberpunkColors.darkGray,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color.lerp(
                    CyberpunkColors.mediumGray.withOpacity(0.18),
                    CyberpunkColors.primaryOrange.withOpacity(0.9),
                    _animationController.value,
                  )!,
                  width: _borderAnimation.value,
                ),
                boxShadow: [
                  // Shadow base sempre presente (mais performático)
                  const BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  ),
                  // Glow shadow animado
                  BoxShadow(
                    color: CyberpunkColors.primaryOrange.withOpacity(_glowAnimation.value),
                    blurRadius: 16 * _animationController.value,
                    spreadRadius: 1 * _animationController.value,
                    offset: Offset(0, 6 * _animationController.value),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _openSkillLink(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Marcador vertical com gradiente cache
                        Container(
                          width: 6,
                          height: 28,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: _cachedGradient,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Ícone (se houver) - cache
                        if (_cachedIcon != null) ...[
                          Icon(_cachedIcon, size: 16, color: CyberpunkColors.screenTeal),
                          const SizedBox(width: 8),
                        ],
                        // Texto com tooltip
                        Text(
                          widget.skill,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Retorna ícone nativo para a skill (cached).
  IconData? _iconFor(String s) {
    final n = s.toLowerCase();
    switch (true) {
      case _ when n.contains('flutter'): return Icons.flutter_dash;
      case _ when n.contains('dart'): return Icons.code;
      case _ when n.contains('java'): return Icons.code;
      case _ when n.contains('c++'): return Icons.memory;
      case _ when n.contains('firebase'): return Icons.cloud;
      case _ when n.contains('node'): return Icons.storage;
      case _ when n.contains('mqtt'): return Icons.sensors;
      case _ when n.contains('esp'): return Icons.developer_board;
      default: return null;
    }
  }

  /// Retorna gradiente de cores para a skill (cached).
  List<Color> _accentFor(String s) {
    final n = s.toLowerCase();
    switch (true) {
      case _ when n.contains('flutter') || n.contains('dart'):
        return [CyberpunkColors.screenTeal, CyberpunkColors.primaryOrange];
      case _ when n.contains('java') || n.contains('c++'):
        return [CyberpunkColors.primaryOrange, CyberpunkColors.glowYellow];
      case _ when n.contains('firebase') || n.contains('node'):
        return [CyberpunkColors.neonBlue, CyberpunkColors.screenTeal];
      case _ when n.contains('mqtt') || n.contains('esp'):
        return [CyberpunkColors.terminalGreen, CyberpunkColors.screenTeal];
      default:
        return [CyberpunkColors.primaryOrange, CyberpunkColors.neonBlue];
    }
  }

  /// Abre o link externo de referência da skill.
  void _openSkillLink() async {
    if (_cachedUrl != null) {
      final uri = Uri.parse(_cachedUrl!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  /// Mapeia skill para um link externo de referência (cached).
  String? _skillUrl(String s) {
    final n = s.toLowerCase();
    switch (true) {
      case _ when n.contains('flutter'): return 'https://flutter.dev/';
      case _ when n.contains('dart'): return 'https://dart.dev/';
      case _ when n.contains('java'): return 'https://www.java.com/';
      case _ when n.contains('c++'): return 'https://isocpp.org/';
      case _ when n.contains('firebase'): return 'https://firebase.google.com/';
      case _ when n.contains('node'): return 'https://nodejs.org/';
      case _ when n.contains('mqtt'): return 'https://mqtt.org/';
      case _ when n.contains('esp'): return 'https://www.espressif.com/en/products/socs/esp32';
      default: return null;
    }
  }
}
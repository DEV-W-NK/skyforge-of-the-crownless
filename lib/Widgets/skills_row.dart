// lib/widgets/skills_row.dart

import 'package:flutter/material.dart';
import 'package:portifolio/Theme/ds3_pallet.dart';
import 'package:url_launcher/url_launcher.dart';

/// Widget que exibe uma linha de skills (tecnologias) com carregamento otimizado.
class SkillsRow extends StatefulWidget {
  final List<String> skills;
  final bool lazy; // Flag para carregamento lazy

  /// [skills] pode ser passado ou usa uma lista padrão.
  /// [lazy] controla se deve usar carregamento preguiçoso (padrão: true)
  const SkillsRow({
    super.key,
    List<String>? skills,
    this.lazy = true,
  })  : skills = skills ??
            const ['Flutter', 'Dart', 'Java','Mobile', 'C++', 'Firebase', 'Node.js', 'MQTT', 'ESP32'];

  @override
  State<SkillsRow> createState() => _SkillsRowState();
}

class _SkillsRowState extends State<SkillsRow> {
  bool _isVisible = false;
  bool _hasBeenBuilt = false;
  
  // Cache estático para evitar recalcular a mesma skill múltiplas vezes
  static final Map<String, _SkillData> _skillCache = {};

  @override
  void initState() {
    super.initState();
    
    // Se não for lazy, renderiza imediatamente
    if (!widget.lazy) {
      _isVisible = true;
      _preloadSkillData();
    } else {
      // Lazy loading com delay micro para evitar janks
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Future.microtask(() {
            if (mounted) {
              setState(() {
                _isVisible = true;
              });
              _preloadSkillData();
            }
          });
        }
      });
    }
  }

  /// Pre-carrega dados das skills em cache para evitar rebuild
  void _preloadSkillData() {
    if (_hasBeenBuilt) return;
    
    for (final skill in widget.skills) {
      if (!_skillCache.containsKey(skill)) {
        _skillCache[skill] = _SkillData(
          skill: skill,
          icon: _iconFor(skill),
          gradient: _accentFor(skill),
          url: _skillUrl(skill),
        );
      }
    }
    _hasBeenBuilt = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) {
      // Placeholder com altura estimada para evitar layout shift
      return SizedBox(
        height: 44, // Altura aproximada de uma linha de skills
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                CyberpunkColors.primaryOrange.withOpacity(0.5),
              ),
            ),
          ),
        ),
      );
    }

    return RepaintBoundary(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: widget.skills.map((skill) {
          // Usa dados do cache
          final skillData = _skillCache[skill]!;
          return _SkillPill(skillData: skillData);
        }).toList(),
      ),
    );
  }

  /// Retorna ícone nativo para a skill.
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

  /// Retorna gradiente de cores para a skill.
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

  /// Mapeia skill para um link externo de referência.
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

/// Classe para armazenar dados pré-calculados da skill
class _SkillData {
  final String skill;
  final IconData? icon;
  final List<Color> gradient;
  final String? url;

  const _SkillData({
    required this.skill,
    required this.icon,
    required this.gradient,
    required this.url,
  });
}

/// Widget individual para cada skill, com animações otimizadas.
class _SkillPill extends StatefulWidget {
  final _SkillData skillData;
  
  const _SkillPill({super.key, required this.skillData});

  @override
  State<_SkillPill> createState() => _SkillPillState();
}

class _SkillPillState extends State<_SkillPill>
    with SingleTickerProviderStateMixin {
  
  // Controllers para animações otimizadas
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _borderAnimation;
  late Animation<double> _glowAnimation;
  
  bool _isHovered = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    
    // Inicializar controller único para todas as animações
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150), // Reduzido para mais responsivo
      vsync: this,
    );
    
    // Animações com curvas otimizadas
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _borderAnimation = ColorTween(
      begin: CyberpunkColors.mediumGray.withOpacity(0.18),
      end: CyberpunkColors.primaryOrange.withOpacity(0.9),
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
  }

  @override
  void dispose() {
    _isDisposed = true;
    _animationController.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool isHovered) {
    if (_isDisposed) return;
    
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
    return RepaintBoundary(
      child: MouseRegion(
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
                    color: _borderAnimation.value ?? Colors.transparent,
                    width: 1.0 + (_animationController.value * 0.4),
                  ),
                  boxShadow: [
                    // Shadow base sempre presente
                    const BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                    // Glow shadow animado - só renderiza se necessário
                    if (_animationController.value > 0) ...[
                      BoxShadow(
                        color: CyberpunkColors.primaryOrange.withOpacity(_glowAnimation.value),
                        blurRadius: 16 * _animationController.value,
                        spreadRadius: 1 * _animationController.value,
                        offset: Offset(0, 6 * _animationController.value),
                      ),
                    ],
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
                          // Marcador vertical com gradiente
                          Container(
                            width: 6,
                            height: 28,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: widget.skillData.gradient,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Ícone (se houver)
                          if (widget.skillData.icon != null) ...[
                            Icon(
                              widget.skillData.icon, 
                              size: 16, 
                              color: CyberpunkColors.screenTeal,
                            ),
                            const SizedBox(width: 8),
                          ],
                          // Texto
                          Text(
                            widget.skillData.skill,
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
      ),
    );
  }

  /// Abre o link externo de referência da skill.
  void _openSkillLink() async {
    if (widget.skillData.url != null) {
      final uri = Uri.parse(widget.skillData.url!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }
}
// lib/widgets/project_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portifolio/Models/resume_models.dart';
import 'package:portifolio/Theme/ds3_pallet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ProjectCard extends StatefulWidget {
  final Project project;
  final double? width;
  final int index; // Índice para delay escalonado

  const ProjectCard({
    super.key,
    required this.project,
    this.width,
    this.index = 0,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _hasAnimated = false;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();

    // Controlador de animação com duração otimizada
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Animações coordenadas
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    // Anima apenas quando o card fica visível pela primeira vez
    if (!_hasAnimated && info.visibleFraction > 0.15) {
      _hasAnimated = true;

      // Delay escalonado baseado no índice
      Future.delayed(Duration(milliseconds: widget.index * 100), () {
        if (mounted) {
          _animationController.forward();
          // Feedback háptico sutil
          HapticFeedback.selectionClick();
        }
      });
    }
  }

  IconData _getProjectIcon() {
    final tech =
        widget.project.tech.isNotEmpty
            ? widget.project.tech.first.toLowerCase()
            : '';
    switch (tech) {
      case 'flutter':
        return Icons.phone_android;
      case '.net maui':
      case 'c#':
        return Icons.phone_android;
      case 'java':
      case 'android':
        return Icons.android;
      case 'web':
        return Icons.web;
      case 'api':
      case 'node.js':
        return Icons.api;
      case 'c++':
      case 'esp32':
      case 'mqtt':
        return Icons.sensors;
      case 'firebase':
        return Icons.cloud;
      default:
        return Icons.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    // Define largura fixa, altura flexível
    final double cardWidth = widget.width ?? (isMobile ? 340 : 320);

    return VisibilityDetector(
      key: Key('project_card_${widget.index}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox(
                  width: cardWidth,
                  child: _buildCard(context, isMobile, cardWidth),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, bool isMobile, double cardWidth) {
    return Container(
      width: cardWidth,
      constraints: BoxConstraints(minHeight: isMobile ? 200 : 180),
      decoration: BoxDecoration(
        color: CyberpunkColors.charcoalGray,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CyberpunkColors.primaryOrange.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: CyberpunkColors.primaryOrange.withValues(alpha: 0.08),
            blurRadius: 12,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black87,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Importante: ajusta ao conteúdo
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(isMobile),
              const SizedBox(height: 16),

              // Tech stack
              if (widget.project.tech.isNotEmpty) ...[
                _buildTechStack(isMobile),
                const SizedBox(height: 16),
              ],

              // Bullets
              if (widget.project.bullets != null &&
                  widget.project.bullets!.isNotEmpty) ...[
                AnimatedSize(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _buildBullets(isMobile),
                  ),
                ),
                const SizedBox(height: 12),
              ],

              // Botão de ação
              _buildActionButton(context, isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isMobile ? 8 : 12),
          decoration: BoxDecoration(
            color: CyberpunkColors.primaryOrange.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: CyberpunkColors.primaryOrange.withValues(alpha: 0.7),
              width: 1.5,
            ),
          ),
          child: Icon(
            _getProjectIcon(),
            color: CyberpunkColors.primaryOrange,
            size: isMobile ? 20 : 24,
          ),
        ),
        SizedBox(width: isMobile ? 12 : 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.project.title,
                style: TextStyle(
                  color: CyberpunkColors.primaryOrange,
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.project.subtitle,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: isMobile ? 12 : 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTechStack(bool isMobile) {
    return Wrap(
      spacing: isMobile ? 6 : 8,
      runSpacing: 4,
      children:
          widget.project.tech.take(isMobile ? 3 : 4).map((tech) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 6 : 8,
                vertical: isMobile ? 3 : 4,
              ),
              decoration: BoxDecoration(
                color: CyberpunkColors.screenTeal.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: CyberpunkColors.screenTeal.withValues(alpha: 0.25),
                ),
              ),
              child: Text(
                tech,
                style: TextStyle(
                  color: CyberpunkColors.screenTeal,
                  fontSize: isMobile ? 10 : 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }).toList(),
    );
  }

  List<Widget> _buildBullets(bool isMobile) {
    final visibleBullets =
        _expanded ? widget.project.bullets! : widget.project.bullets!.take(2);

    return visibleBullets
        .map(
          (bullet) => Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: CyberpunkColors.terminalGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    bullet,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isMobile ? 11 : 12,
                      height: 1.3,
                    ),
                    maxLines: _expanded ? null : 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  Widget _buildActionButton(BuildContext context, bool isMobile) {
    final hasDetails =
        widget.project.bullets != null && widget.project.bullets!.length > 2;
    final links = widget.project.effectiveLinks;

    if (!hasDetails && links.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (hasDetails)
          SizedBox(
            width: links.isEmpty ? double.infinity : 150,
            child: OutlinedButton.icon(
              onPressed: () => setState(() => _expanded = !_expanded),
              icon: Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
                size: 16,
              ),
              label: Text(
                _expanded ? 'MENOS' : 'DETALHES',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  fontSize: isMobile ? 12 : 13,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: CyberpunkColors.primaryOrange,
                side: BorderSide(
                  color: CyberpunkColors.primaryOrange.withValues(alpha: 0.65),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        for (final link in links)
          SizedBox(
            width: links.length > 1 ? 150 : double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openLink(link.url),
              icon: Icon(
                link.label.toLowerCase().contains('google')
                    ? Icons.android_outlined
                    : Icons.launch,
                size: 16,
              ),
              label: Text(
                link.label.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  fontSize: isMobile ? 12 : 13,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: CyberpunkColors.primaryOrange,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('URL inválida')));
      return;
    }
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o link')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao abrir o link: $e')));
    }
  }
}

// lib/widgets/project_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portifolio/Models/resume_models.dart';
import 'package:portifolio/Theme/ds3_pallet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'package:visibility_detector/visibility_detector.dart';

class ProjectCard extends StatefulWidget {
  final Project project;
  final double? width;
  final int index; // Índice para delay escalonado

  const ProjectCard({
    Key? key,
    required this.project,
    this.width,
    this.index = 0,
  }) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    
    // Controlador de animação com duração otimizada
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Animações coordenadas
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
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
    final tech = widget.project.tech.isNotEmpty 
        ? widget.project.tech.first.toLowerCase() 
        : '';
    switch (tech) {
      case 'flutter':
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
      constraints: BoxConstraints(
        minHeight: isMobile ? 200 : 180,
      ),
      decoration: BoxDecoration(
        color: CyberpunkColors.charcoalGray,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CyberpunkColors.primaryOrange.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: CyberpunkColors.primaryOrange.withOpacity(0.08),
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
              
              // Bullets (primeiros 2) - Flexível
              if (widget.project.bullets != null && widget.project.bullets!.isNotEmpty) ...[
                Flexible(
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
            color: CyberpunkColors.primaryOrange.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: CyberpunkColors.primaryOrange.withOpacity(0.7),
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
      children: widget.project.tech.take(isMobile ? 3 : 4).map((tech) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 6 : 8,
            vertical: isMobile ? 3 : 4,
          ),
          decoration: BoxDecoration(
            color: CyberpunkColors.screenTeal.withOpacity(0.12),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: CyberpunkColors.screenTeal.withOpacity(0.25),
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
    return widget.project.bullets!.take(2).map((bullet) => Padding(
      padding: const EdgeInsets.only(bottom: 6.0), // Reduzido de 8.0
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6, // Reduzido de 7
            height: 6, // Reduzido de 7
            decoration: const BoxDecoration(
              color: CyberpunkColors.terminalGreen,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8), // Reduzido de 10
          Expanded(
            child: Text(
              bullet,
              style: TextStyle(
                color: Colors.white70,
                fontSize: isMobile ? 11 : 12, // Reduzido
                height: 1.3, // Reduzido de 1.35
              ),
              maxLines: 2, // Limita a 2 linhas
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    )).toList();
  }

  Widget _buildActionButton(BuildContext context, bool isMobile) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              if (widget.project.url != null && widget.project.url!.isNotEmpty) {
                _openLink(context, widget.project.url!);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('URL não disponível')),
                );
              }
            },
            icon: const Icon(Icons.launch, size: 16),
            label: Text(
              'VER PROJETO',
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

  Future<void> _openLink(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('URL inválida')),
      );
      return;
    }
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o link')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao abrir o link: $e')),
      );
    }
  }
}
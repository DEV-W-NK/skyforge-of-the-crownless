// lib/widgets/project_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portifolio/Models/resume_models.dart';
import 'package:portifolio/Theme/ds3_pallet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

class ProjectCard extends StatefulWidget {
  final Project project;
  final double? width;

  ProjectCard({required this.project, this.width});

  @override
  _ProjectCardState createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _glowController;
  late AnimationController _sparkleController;
  late AnimationController _pulseController;

  late Animation<double> _hoverAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _sparkleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  

  bool _isHovered = false;
  List<SparkleParticle> _sparkles = [];

  @override
  void initState() {
    super.initState();

    // Controladores
    _hoverController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _sparkleController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Animações
    _hoverAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _sparkleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_sparkleController);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: Offset(0, -8),
    ).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );

    _initializeSparkles();
  }

  void _initializeSparkles() {
    final random = math.Random();
    _sparkles = List.generate(15, (index) {
      return SparkleParticle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        speed: 0.5 + random.nextDouble() * 1.5,
        size: 1 + random.nextDouble() * 2,
        opacity: 0.3 + random.nextDouble() * 0.7,
        phase: random.nextDouble() * 2 * math.pi,
      );
    });
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _glowController.dispose();
    _sparkleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });

    if (isHovered) {
      _hoverController.forward();
      HapticFeedback.selectionClick();
    } else {
      _hoverController.reverse();
    }
  }

  void _onCardTap() {
    HapticFeedback.lightImpact();
    if (widget.project.url != null) {
      _openLink(widget.project.url!);
    }
  }

  IconData _getProjectIcon() {
    // Mapear tecnologias para ícones
    final tech =
        widget.project.tech.isNotEmpty
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

    // Sempre "hover" no mobile
    if (isMobile && !_isHovered) {
      _isHovered = true;
      _hoverController.forward();
    }

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: () => _onCardTap(),
        child: AnimatedBuilder(
          animation: Listenable.merge([
            _hoverAnimation,
            _glowAnimation,
            _sparkleAnimation,
            _pulseAnimation,
          ]),
          builder: (context, child) {
            return Transform.translate(
              offset: _slideAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: widget.width,
                  child: Stack(
                    children: [
                      // Card principal
                      _buildMainCard(),

                      // Partículas brilhantes
                      if (_isHovered || isMobile) _buildSparkleLayer(),

                      // Overlay de brilho
                      _buildGlowOverlay(),

                      // Efeito de scan line
                      if ((_isHovered || isMobile)) _buildScanLineEffect(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    return Container(
      decoration: BoxDecoration(
        color: CyberpunkColors.charcoalGray,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              Color.lerp(
                CyberpunkColors.mediumGray,
                CyberpunkColors.primaryOrange,
                _hoverAnimation.value * 0.8,
              )!,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: CyberpunkColors.primaryOrange.withOpacity(
              0.1 + _hoverAnimation.value * 0.4,
            ),
            blurRadius: 20 + _hoverAnimation.value * 10,
            spreadRadius: 2 + _hoverAnimation.value * 3,
          ),
          BoxShadow(
            color: Colors.black87,
            blurRadius: 10,
            offset: Offset(0, 5 + _hoverAnimation.value * 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Background pattern
            _buildBackgroundPattern(),

            // Conteúdo
            Padding(
              padding: EdgeInsets.all(isMobile ? 16 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // força ocupar altura
                children: [
                  // Conteúdo principal
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),
                        SizedBox(height: 16),
                        _buildDescription(),
                        SizedBox(height: 20),
                        _buildTechStack(),
                      ],
                    ),
                  ),
                  // Ações sempre no rodapé
                  _buildActionRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _sparkleAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: CircuitPatternPainter(
              animation: _sparkleAnimation.value,
              intensity: _hoverAnimation.value,
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Row(
      children: [
        // Ícone do projeto - menor no mobile
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Container(
              padding: EdgeInsets.all(isMobile ? 8 : 12),
              decoration: BoxDecoration(
                color: CyberpunkColors.primaryOrange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: CyberpunkColors.primaryOrange.withOpacity(
                    _pulseAnimation.value,
                  ),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: CyberpunkColors.primaryOrange.withOpacity(
                      _pulseAnimation.value * 0.6,
                    ),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                _getProjectIcon(),
                color: CyberpunkColors.primaryOrange,
                size: isMobile ? 20 : 24, // Ícone menor no mobile
              ),
            );
          },
        ),
        SizedBox(width: isMobile ? 12 : 16),

        // Título e status
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedDefaultTextStyle(
                style: TextStyle(
                  color:
                      Color.lerp(
                        CyberpunkColors.primaryOrange,
                        CyberpunkColors.glowYellow,
                        _hoverAnimation.value,
                      )!,
                  fontSize: isMobile ? 16 : 18, // Fonte menor no mobile
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                ),
                duration: Duration(milliseconds: 300),
                child: Text(widget.project.title),
              ),

              SizedBox(height: 4),

              // Status indicator
              Row(
                children: [
                  AnimatedBuilder(
                    animation: _glowAnimation,
                    builder: (context, child) {
                      return Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: CyberpunkColors.terminalGreen,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: CyberpunkColors.terminalGreen.withOpacity(
                                _glowAnimation.value,
                              ),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  SizedBox(width: 8),

                  Text(
                    'ONLINE',
                    style: TextStyle(
                      color: CyberpunkColors.terminalGreen,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

Widget _buildDescription() {
  final screenWidth = MediaQuery.of(context).size.width;
  final isMobile = screenWidth < 600;
  
  return AnimatedDefaultTextStyle(
    style: TextStyle(
      color: Color.lerp(
        Colors.white70,
        Colors.white,
        _hoverAnimation.value * 0.5,
      )!,
      fontSize: isMobile ? 12 : 14, // Fonte menor no mobile
      height: 1.5,
      letterSpacing: 0.3,
    ),
    duration: Duration(milliseconds: 300),
    child: Text(
      widget.project.subtitle,
      maxLines: isMobile ? 2 : 3, // Menos linhas no mobile
      overflow: TextOverflow.ellipsis,
    ),
  );
}

Widget _buildTechStack() {
  final screenWidth = MediaQuery.of(context).size.width;
  final isMobile = screenWidth < 600;
  
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Container(
            width: 4,
            height: isMobile ? 12 : 16,
              decoration: BoxDecoration(
                color: CyberpunkColors.screenTeal,
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: CyberpunkColors.screenTeal.withOpacity(0.6),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
          Text(
            'STACK',
            style: TextStyle(
              color: CyberpunkColors.screenTeal,
              fontSize: isMobile ? 10 : 12, // Fonte menor
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),

      SizedBox(height: 8),

      Wrap(
        spacing: isMobile ? 6 : 8, // Menos espaçamento no mobile
        runSpacing: 4,
        children: widget.project.tech.take(isMobile ? 3 : 4).map((tech) { // Menos tags no mobile
          return AnimatedBuilder(
            animation: _hoverAnimation,
            builder: (context, child) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 6 : 8,
                  vertical: isMobile ? 3 : 4,
                ),
                // ... resto da decoração igual
                child: Text(
                  tech,
                  style: TextStyle(
                    color: CyberpunkColors.screenTeal,
                    fontSize: isMobile ? 9 : 10, // Fonte menor
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    ],
  );
}
  Future<void> _showProjectDetails() async {
    HapticFeedback.selectionClick();

    final project = widget.project;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          backgroundColor: CyberpunkColors.charcoalGray,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Icon(
                          _getProjectIcon(),
                          color: CyberpunkColors.primaryOrange,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            project.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          icon: Icon(Icons.close, color: Colors.white54),
                        ),
                      ],
                    ),

                    SizedBox(height: 12),

                    // Subtitle / descrição
                    Text(
                      project.subtitle,
                      style: TextStyle(color: Colors.white70, height: 1.4),
                    ),

                    SizedBox(height: 16),

                    // Tech stack
                    if (project.tech.isNotEmpty) ...[
                      Text(
                        'Tecnologias',
                        style: TextStyle(
                          color: CyberpunkColors.screenTeal,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.6,
                        ),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children:
                            project.tech.map((t) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: CyberpunkColors.darkGray,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: CyberpunkColors.screenTeal
                                        .withOpacity(0.25),
                                  ),
                                ),
                                child: Text(
                                  t,
                                  style: TextStyle(
                                    color: CyberpunkColors.screenTeal,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      SizedBox(height: 16),
                    ],

                    // Ações
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              if (project.url != null &&
                                  project.url!.isNotEmpty) {
                                _openLink(project.url!);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'URL não disponível para este projeto',
                                    ),
                                  ),
                                );
                              }
                            },
                            icon: Icon(Icons.open_in_new),
                            label: Text('Abrir projeto'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CyberpunkColors.primaryOrange,
                              foregroundColor: Colors.black87,
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final urlToCopy = project.url ?? '';
                            await Clipboard.setData(
                              ClipboardData(text: urlToCopy),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  urlToCopy.isNotEmpty
                                      ? 'Link copiado para a área de transferência'
                                      : 'Texto vazio copiado',
                                ),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.copy,
                            color: CyberpunkColors.neonBlue,
                          ),
                          label: Text(
                            'Copiar link',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: CyberpunkColors.neonBlue),
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

Widget _buildActionRow() {
  final screenWidth = MediaQuery.of(context).size.width;
  final isMobile = screenWidth < 600;
  
  if (isMobile) {
    // Layout em coluna para mobile
    return Column(
      children: [
        // Botão principal - full width
        Container(
          width: double.infinity,
          child: AnimatedBuilder(
            animation: _hoverAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: CyberpunkColors.primaryOrange.withOpacity(
                        _hoverAnimation.value * 0.6,
                      ),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => _openLink(widget.project.url ?? ''),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.lerp(
                      CyberpunkColors.darkGray,
                      CyberpunkColors.primaryOrange,
                      _hoverAnimation.value * 0.8,
                    ),
                    foregroundColor: Color.lerp(
                      CyberpunkColors.primaryOrange,
                      CyberpunkColors.deepBlack,
                      _hoverAnimation.value,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: CyberpunkColors.primaryOrange.withOpacity(
                          0.8 + _hoverAnimation.value * 0.2,
                        ),
                        width: 2,
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.launch, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'VIEW PROJECT',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          fontSize: 12, // Fonte menor no mobile
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 8), // Espaçamento vertical entre botões

        // Botão secundário - full width no mobile
        Container(
          width: double.infinity,
          child: AnimatedBuilder(
            animation: _hoverAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: CyberpunkColors.neonBlue.withOpacity(
                        _hoverAnimation.value * 0.4,
                      ),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Material(
                  color: CyberpunkColors.darkGray,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    onTap: () => _showProjectDetails(),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: CyberpunkColors.neonBlue.withOpacity(
                            0.6 + _hoverAnimation.value * 0.4,
                          ),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: CyberpunkColors.neonBlue,
                            size: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'DETALHES',
                            style: TextStyle(
                              color: CyberpunkColors.neonBlue,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  } else {
    // Layout em linha para desktop (seu código original)
    return Row(
      children: [
        // Botão principal
        Expanded(
          child: AnimatedBuilder(
            animation: _hoverAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: CyberpunkColors.primaryOrange.withOpacity(
                        _hoverAnimation.value * 0.6,
                      ),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () => _openLink(widget.project.url ?? ''),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.lerp(
                      CyberpunkColors.darkGray,
                      CyberpunkColors.primaryOrange,
                      _hoverAnimation.value * 0.8,
                    ),
                    foregroundColor: Color.lerp(
                      CyberpunkColors.primaryOrange,
                      CyberpunkColors.deepBlack,
                      _hoverAnimation.value,
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: CyberpunkColors.primaryOrange.withOpacity(
                          0.8 + _hoverAnimation.value * 0.2,
                        ),
                        width: 2,
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.launch, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'VIEW PROJECT',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(width: 12),

        // Botão secundário (info)
        AnimatedBuilder(
          animation: _hoverAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: CyberpunkColors.neonBlue.withOpacity(
                      _hoverAnimation.value * 0.4,
                    ),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Material(
                color: CyberpunkColors.darkGray,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  onTap: () => _showProjectDetails(),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: CyberpunkColors.neonBlue.withOpacity(
                          0.6 + _hoverAnimation.value * 0.4,
                        ),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: CyberpunkColors.neonBlue,
                      size: 20,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

  Widget _buildSparkleLayer() {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CustomPaint(
          painter: SparklePainter(
            sparkles: _sparkles,
            animation: _sparkleAnimation.value,
          ),
        ),
      ),
    );
  }

  Widget _buildGlowOverlay() {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AnimatedBuilder(
          animation: _hoverAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    CyberpunkColors.primaryOrange.withOpacity(
                      _hoverAnimation.value * 0.1,
                    ),
                    Colors.transparent,
                    CyberpunkColors.neonBlue.withOpacity(
                      _hoverAnimation.value * 0.05,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildScanLineEffect() {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AnimatedBuilder(
          animation: _sparkleAnimation,
          builder: (context, child) {
            return CustomPaint(
              painter: ScanLinePainter(
                progress: _sparkleAnimation.value,
                intensity: _hoverAnimation.value,
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _openLink(String url) async {
    if (url.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('URL vazia')));
      return;
    }

    HapticFeedback.lightImpact();

    final uri = Uri.tryParse(url);
    if (uri == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('URL inválida')));
      return;
    }

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível abrir o link')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao abrir o link: $e')));
    }
  }
}

// Classe para representar partículas brilhantes
class SparkleParticle {
  double x;
  double y;
  final double speed;
  final double size;
  final double opacity;
  final double phase;

  SparkleParticle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
    required this.phase,
  });

  void update() {
    y -= speed * 0.01;
    x += math.sin(phase + y * 10) * 0.001;

    if (y < 0) {
      y = 1.0;
      x = math.Random().nextDouble();
    }
  }
}

class CircuitPatternPainter extends CustomPainter {
  final double animation;
  final double intensity;

  CircuitPatternPainter({required this.animation, required this.intensity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    // Linhas de circuito
    paint.color = CyberpunkColors.screenTeal.withOpacity(
      (0.1 + intensity * 0.2).clamp(0.0, 1.0),
    );

    // Grid pattern
    for (int i = 0; i < 5; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    for (int i = 0; i < 3; i++) {
      final x = size.width * (i / 2);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Pontos de conexão animados
    final rawAlpha =
        (0.3 + math.sin(animation * 2 * math.pi) * 0.3) * intensity;
    final double alpha = rawAlpha.clamp(0.0, 1.0);

    paint.style = PaintingStyle.fill;
    paint.color = CyberpunkColors.primaryOrange.withOpacity(alpha);

    for (int i = 0; i < 6; i++) {
      final x =
          size.width *
          (i / 5) *
          (0.8 + math.sin(animation * math.pi + i) * 0.2);
      final y =
          size.height * 0.2 * (1 + math.cos(animation * math.pi * 2 + i) * 0.5);
      canvas.drawCircle(Offset(x, y), 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// CustomPainter para partículas brilhantes (corrigido)
class SparklePainter extends CustomPainter {
  final List<SparkleParticle> sparkles;
  final double animation;

  SparklePainter({required this.sparkles, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final sparkle in sparkles) {
      sparkle.update();

      // Normaliza o seno para [0,1] e multiplica pela opacidade base da partícula.
      // Assim garantimos que o valor passado para withOpacity está entre 0 e 1.
      final double sinVal = math.sin(animation * 2 * math.pi + sparkle.phase);
      final double normalized = (sinVal + 1.0) / 2.0; // agora entre 0..1
      final double rawAlpha = sparkle.opacity * normalized;
      final double alpha = rawAlpha.clamp(0.0, 1.0);

      paint.color = CyberpunkColors.glowYellow.withOpacity(alpha);

      final dx = sparkle.x * size.width;
      final dy = sparkle.y * size.height;

      // garante um raio mínimo razoável
      final double radius = math.max(0.5, sparkle.size);

      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// CustomPainter para efeito de scan line
class ScanLinePainter extends CustomPainter {
  final double progress;
  final double intensity;

  ScanLinePainter({required this.progress, required this.intensity});

  @override
  void paint(Canvas canvas, Size size) {
    if (intensity < 0.5) return;

    final paint =
        Paint()
          ..style = PaintingStyle.fill
          ..shader = LinearGradient(
            colors: [
              Colors.transparent,
              CyberpunkColors.neonBlue.withOpacity(0.3 * intensity),
              Colors.transparent,
            ],
          ).createShader(Rect.fromLTWH(0, 0, size.width, 4));

    final y = size.height * progress;
    canvas.drawRect(Rect.fromLTWH(0, y - 2, size.width, 4), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
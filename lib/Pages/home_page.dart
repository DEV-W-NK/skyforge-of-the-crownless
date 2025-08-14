// lib/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:portifolio/Models/resume_models.dart';
import 'package:portifolio/Theme/ds3_pallet.dart';
import 'package:portifolio/Widgets/contact_section.dart';
import 'package:portifolio/Widgets/project_card.dart';
import 'package:portifolio/Widgets/skills_row.dart';
import 'package:portifolio/Widgets/timeline.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _parallaxController;
  late AnimationController _fadeController;
  late AnimationController _particleController;
  late AnimationController _glowController;

  late Animation<double> _parallaxAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _glowAnimation;

  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;
  List<Particle> _particles = [];

  @override
  void initState() {
    super.initState();

    // Inicializar controladores de animação
    _parallaxController = AnimationController(
      duration: Duration(seconds: 20),
      vsync: this,
    )..repeat();

    _fadeController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: Duration(seconds: 30),
      vsync: this,
    )..repeat();

    _glowController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    // Configurar animações
    _parallaxAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _parallaxController, curve: Curves.linear),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _particleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_particleController);

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Inicializar partículas
    _initializeParticles();

    // Listener do scroll
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });

    // Iniciar animação de fade
    _fadeController.forward();

    // Vibração sutil ao iniciar
    HapticFeedback.lightImpact();
  }

  void _initializeParticles() {
    final random = math.Random();
    _particles = List.generate(50, (index) {
      return Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        speed: 0.001 + random.nextDouble() * 0.003,
        size: 1 + random.nextDouble() * 3,
        opacity: 0.1 + random.nextDouble() * 0.4,
      );
    });
  }

  @override
  void dispose() {
    _parallaxController.dispose();
    _fadeController.dispose();
    _particleController.dispose();
    _glowController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isWide = mq.size.width > 900;

    return Scaffold(
      body: Stack(
        children: [
          // Background com partículas animadas
          _buildAnimatedBackground(),

          // Conteúdo principal
          SingleChildScrollView(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      _buildParallaxHeader(isWide),
                      SizedBox(height: 48),
                      _buildMainContent(isWide),
                    ],
                  ),
                );
              },
            ),
          ),

          // Overlay com efeito de névoa
          _buildMistOverlay(),

        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: Listenable.merge([_parallaxAnimation, _particleAnimation]),
      builder: (context, child) {
        return Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topRight,
              radius: 1.5,
              colors: [
                CyberpunkColors.burntOrange.withOpacity(0.1),
                CyberpunkColors.deepBlack,
                Colors.black87,
              ],
              stops: [0.0, 0.6, 1.0],
            ),
          ),
          child: CustomPaint(
            painter: ParticlesPainter(
              particles: _particles,
              animation: _particleAnimation.value,
              parallaxOffset: _scrollOffset * 0.5,
            ),
            size: Size.infinite,
          ),
        );
      },
    );
  }

  Widget _buildParallaxHeader(bool isWide) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Stack(
        children: [
          // Background com movimento parallax
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _parallaxAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    math.sin(_parallaxAnimation.value) * 20,
                    math.cos(_parallaxAnimation.value) * 10,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          CyberpunkColors.primaryOrange.withOpacity(0.3),
                          CyberpunkColors.deepOrange.withOpacity(0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Conteúdo do header com animações
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAnimatedTitle(),
                SizedBox(height: 32),
                _buildAnimatedSubtitle(),
                SizedBox(height: 48),
                _buildGlowingButtons(),
              ],
            ),
          ),

          // Efeito de brilho no canto
          Positioned(
            top: 50,
            right: 50,
            child: AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        CyberpunkColors.primaryOrange.withOpacity(
                          _glowAnimation.value * 0.3,
                        ),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedTitle() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1500),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = screenWidth < 600;
        final isTablet = screenWidth >= 600 && screenWidth < 1024;

        // Define o tamanho da fonte baseado no dispositivo
        double fontSize;
        if (isMobile) {
          fontSize = 28; // Muito menor para mobile
        } else if (isTablet) {
          fontSize = 48; // Médio para tablet
        } else {
          fontSize = 64; // Original para desktop
        }

        return Transform.scale(
          scale: value,
          child: Center(
            // Centraliza o texto
            child: FittedBox(
              // Garante que caiba na tela
              fit: BoxFit.scaleDown, // Reduz se necessário
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      CyberpunkColors.primaryOrange,
                      CyberpunkColors.glowYellow,
                      CyberpunkColors.primaryOrange,
                    ],
                    stops: [0.0, 0.5, 1.0],
                  ).createShader(bounds);
                },
                child: Text(
                  profile.fullName,
                  textAlign: TextAlign.center, // Centraliza o texto
                  maxLines: 1, // Força uma linha só
                  overflow: TextOverflow.ellipsis, // Caso seja muito longo
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing:
                        isMobile ? 1.0 : 2.0, // Menos espaçamento no mobile
                    shadows: [
                      Shadow(
                        offset: Offset(0, 0),
                        blurRadius:
                            isMobile ? 15 : 20, // Sombra menor no mobile
                        color: CyberpunkColors.primaryOrange.withOpacity(0.8),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedSubtitle() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 2000),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = screenWidth < 600;
        final isTablet = screenWidth >= 600 && screenWidth < 1024;

        // Define tamanhos responsivos
        double fontSize;
        double horizontalPadding;
        double verticalPadding;

        if (isMobile) {
          fontSize = 16;
          horizontalPadding = 16;
          verticalPadding = 8;
        } else if (isTablet) {
          fontSize = 20;
          horizontalPadding = 20;
          verticalPadding = 10;
        } else {
          fontSize = 24;
          horizontalPadding = 24;
          verticalPadding = 12;
        }

        return Transform.translate(
          offset: Offset(
            0,
            (isMobile ? 30 : 50) * (1 - value),
          ), // Menos movimento no mobile
          child: Opacity(
            opacity: value,
            child: Center(
              // Centraliza o container
              child: FittedBox(
                // Garante que caiba na tela
                fit: BoxFit.scaleDown,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 0, // Margem lateral no mobile
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: CyberpunkColors.primaryOrange.withOpacity(0.5),
                      width: isMobile ? 1.5 : 2, // Borda mais fina no mobile
                    ),
                    borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
                    boxShadow: [
                      BoxShadow(
                        color: CyberpunkColors.primaryOrange.withOpacity(0.3),
                        blurRadius:
                            isMobile ? 10 : 15, // Sombra menor no mobile
                        spreadRadius: isMobile ? 1 : 2,
                      ),
                    ],
                  ),
                  child: Text(
                    profile.title,
                    textAlign: TextAlign.center, // Centraliza o texto
                    maxLines:
                        isMobile
                            ? 2
                            : 1, // Permite 2 linhas no mobile se necessário
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: CyberpunkColors.terminalGreen,
                      letterSpacing:
                          isMobile ? 1.0 : 1.5, // Menos espaçamento no mobile
                      height:
                          isMobile ? 1.3 : 1.0, // Altura da linha para mobile
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlowingButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGlowingButton(
          'GitHub',
          Icons.code,
          () => _openLink(profile.github),
        ),
        SizedBox(width: 24),
        _buildGlowingButton(
          'LinkedIn',
          Icons.link,
          () => _openLink(profile.linkedin),
        ),
      ],
    );
  }

  Widget _buildGlowingButton(
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 2500),
      curve: Curves.bounceOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: MouseRegion(
            onEnter: (_) => HapticFeedback.selectionClick(),
            child: AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: CyberpunkColors.primaryOrange.withOpacity(
                          _glowAnimation.value * 0.6,
                        ),
                        blurRadius: 20,
                        spreadRadius: _glowAnimation.value * 5,
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: onPressed,
                    icon: Icon(icon),
                    label: Text(text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CyberpunkColors.charcoalGray,
                      foregroundColor: CyberpunkColors.primaryOrange,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color: CyberpunkColors.primaryOrange.withOpacity(0.8),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainContent(bool isWide) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 72 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnimatedSection('Sobre mim', _buildAboutSection(), 0),
          SizedBox(height: 64),
          _buildAnimatedSection(
            'Experiência',
            ExperienceTimeline(experiences: experiences),
            200,
          ),
          SizedBox(height: 64),
          _buildAnimatedSection('Projetos', _buildProjectsSection(isWide), 400),
          SizedBox(height: 64),
          _buildAnimatedSection('Skills', SkillsRow(), 600),
          SizedBox(height: 64),
          _buildAnimatedSection(
            'Contato',
            ContactSection(profile: profile),
            800,
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildAnimatedSection(String title, Widget content, double delay) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1000 + delay.toInt()),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 100 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(title),
                SizedBox(height: 24),
                content,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              final screenWidth = MediaQuery.of(context).size.width;
              final isMobile = screenWidth < 600;

              return Container(
                width: isMobile ? 6 : 8, // Barra menor no mobile
                height: isMobile ? 24 : 32, // Altura menor no mobile
                decoration: BoxDecoration(
                  color: CyberpunkColors.primaryOrange,
                  borderRadius: BorderRadius.circular(isMobile ? 3 : 4),
                  boxShadow: [
                    BoxShadow(
                      color: CyberpunkColors.primaryOrange.withOpacity(
                        _glowAnimation.value,
                      ),
                      blurRadius: isMobile ? 8 : 10, // Brilho menor no mobile
                      spreadRadius: isMobile ? 1 : 2,
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width < 600 ? 12 : 16,
          ), // Espaçamento menor no mobile
          Expanded(
            // Adiciona Expanded para evitar overflow
            child: FittedBox(
              // Garante que o texto caiba
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft, // Mantém alinhamento à esquerda
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      CyberpunkColors.primaryOrange,
                      CyberpunkColors.glowYellow,
                    ],
                  ).createShader(bounds);
                },
                child: Builder(
                  builder: (context) {
                    final screenWidth = MediaQuery.of(context).size.width;
                    final isMobile = screenWidth < 600;
                    final isTablet = screenWidth >= 600 && screenWidth < 1024;

                    double fontSize;
                    if (isMobile) {
                      fontSize = 20; // Bem menor para mobile
                    } else if (isTablet) {
                      fontSize = 24; // Médio para tablet
                    } else {
                      fontSize = 28; // Original para desktop
                    }

                    return Text(
                      title,
                      maxLines: 1, // Força uma linha só
                      overflow:
                          TextOverflow.ellipsis, // Adiciona ... se necessário
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing:
                            isMobile ? 0.8 : 1.2, // Menos espaçamento no mobile
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: CyberpunkColors.charcoalGray.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CyberpunkColors.primaryOrange.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: CyberpunkColors.primaryOrange.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Text(
        'Sou desenvolvedor apaixonado por tecnologia, com foco em Flutter, Android (Java) e C++. '
        'Trabalho com soluções mobile, IoT e backend serverless. Busco projetos que misturem design e eficiência.',
        style: TextStyle(
          fontSize: 18,
          color: CyberpunkColors.terminalGreen,
          height: 1.6,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildProjectsSection(bool isWide) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children:
          projects.asMap().entries.map((entry) {
            final index = entry.key;
            final project = entry.value;
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 800 + (index * 200)),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: ProjectCard(
                    project: project,
                    width: isWide ? 320 : double.infinity,
                  ),
                );
              },
            );
          }).toList(),
    );
  }

  Widget _buildMistOverlay() {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _parallaxAnimation,
        builder: (context, child) {
          return Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(
                    0.1 + math.sin(_parallaxAnimation.value) * 0.05,
                  ),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black.withOpacity(0.2),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  void _openLink(String url) async {
    HapticFeedback.lightImpact();
    // Implementar abertura de URL
  }
}

// Classe para representar partículas
class Particle {
  double x;
  double y;
  final double speed;
  final double size;
  final double opacity;

  Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
  });

  void update() {
    y -= speed;
    if (y < 0) {
      y = 1.0;
      x = math.Random().nextDouble();
    }
  }
}

// CustomPainter para partículas
class ParticlesPainter extends CustomPainter {
  final List<Particle> particles;
  final double animation;
  final double parallaxOffset;

  ParticlesPainter({
    required this.particles,
    required this.animation,
    required this.parallaxOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final particle in particles) {
      particle.update();

      paint.color = CyberpunkColors.primaryOrange.withOpacity(particle.opacity);

      final dx =
          particle.x * size.width +
          math.sin(animation * 2 * math.pi + particle.x * 10) * 20;
      final dy = particle.y * size.height - parallaxOffset * 0.5;

      canvas.drawCircle(Offset(dx, dy), particle.size, paint);
    }

    // Desenhar algumas linhas conectoras
    paint.color = CyberpunkColors.primaryOrange.withOpacity(0.1);
    paint.strokeWidth = 1;

    for (int i = 0; i < particles.length - 1; i++) {
      for (int j = i + 1; j < particles.length; j++) {
        final p1 = particles[i];
        final p2 = particles[j];

        final dx1 = p1.x * size.width;
        final dy1 = p1.y * size.height - parallaxOffset * 0.5;
        final dx2 = p2.x * size.width;
        final dy2 = p2.y * size.height - parallaxOffset * 0.5;

        final distance = math.sqrt(
          math.pow(dx2 - dx1, 2) + math.pow(dy2 - dy1, 2),
        );

        if (distance < 100) {
          canvas.drawLine(Offset(dx1, dy1), Offset(dx2, dy2), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

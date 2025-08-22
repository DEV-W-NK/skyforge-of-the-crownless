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
import 'package:portifolio/Widgets/education_section.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:just_audio/just_audio.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Página principal do portfólio/currículo.
/// Exibe header animado, partículas, experiências, projetos, escolaridade, skills e contato.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

/// Estado da HomePage, responsável por animações e controle de rolagem.
class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  // Controladores de animação
  late AnimationController _fadeController;
  late AnimationController _particleController;
  late AnimationController _glowController;

  // Animações
  late Animation<double> _fadeAnimation;
  late Animation<double> _particleAnimation;
  late Animation<double> _glowAnimation;

  // Controle de rolagem
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0.0;

  // Lista de partículas para o fundo animado
  List<Particle> _particles = [];

  // Player de música de fundo
  late final AudioPlayer _audioPlayer;

  // Lista de seções para lazy loading
  final List<_SectionBuilder> _sections = [];

  @override
  void initState() {
    super.initState();

    // Inicializa controladores de animação
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

    // Inicializa animações
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

    // Inicializa partículas do fundo
    _initializeParticles();

    // Atualiza offset do scroll para efeito parallax das partículas
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });

    // Inicia animação de fade-in da página
    _fadeController.forward();

    // Vibração sutil ao abrir a página
    HapticFeedback.lightImpact();

    // Inicializa o player de áudio e tenta tocar ao abrir
    _audioPlayer = AudioPlayer();
    _playBackgroundMusic();

    // Inicializa a lista de seções para lazy loading
    _sections.addAll([
      _SectionBuilder(
        key: const ValueKey('about'),
        builder:
            (context) =>
                _buildAnimatedSection('Sobre mim', _buildAboutSection(), 0),
      ),
      _SectionBuilder(
        key: const ValueKey('exp'),
        builder:
            (context) => _buildAnimatedSection(
              'Experiência',
              ExperienceTimeline(experiences: experiences),
              200,
            ),
      ),
      _SectionBuilder(
        key: const ValueKey('projects'),
        builder:
            (context) => _buildAnimatedSection(
              'Projetos',
              _buildProjectsSection(MediaQuery.of(context).size.width > 900),
              400,
            ),
      ),
      _SectionBuilder(
        key: const ValueKey('education'),
        builder:
            (context) => _buildAnimatedSection(
              'Escolaridade',
              EducationSection(
                educationList: [
                  Education(
                    degree: 'Bacharelado em Engenharia da Computação',
                    institution:
                        'Universidade Virtual do Estado de São Paulo (UNIVESP)',
                    period: '2025 – 2030',
                  ),
                  Education(
                    degree: 'Técnico em Desenvolvimento de Sistemas',
                    institution: 'Etec Professor Basilides de Godoy',
                    period: '2023 – 2024',
                  ),
                  Education(
                    degree: 'Curso de Mecatrônica',
                    institution: 'Alura',
                    period: '2023 – 2024',
                  ),
                ],
              ),
              500,
            ),
      ),
      _SectionBuilder(
        key: const ValueKey('skills'),
        builder:
            (context) => FutureBuilder<Widget>(
              // Delay micro para não bloquear a UI thread
              future: Future.microtask(
                () => _buildAnimatedSection(
                  'Skills',
                  const SkillsRow(lazy: true),
                  600,
                ),
              ),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                }
                // Placeholder durante carregamento
                return SizedBox(
                  height: 100,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        CyberpunkColors.primaryOrange.withOpacity(0.5),
                      ),
                    ),
                  ),
                );
              },
            ),
      ),
      _SectionBuilder(
        key: const ValueKey('contact'),
        builder:
            (context) => _buildAnimatedSection(
              'Contato',
              ContactSection(profile: profile),
              800,
            ),
      ),
    ]);
  }

  /// Inicializa a lista de partículas para o fundo animado.
  void _initializeParticles() {
    final random = math.Random();
    _particles = List.generate(20, (index) {
      // Reduzido de 50 para 20 para melhor desempenho
      return Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        speed: 0.001 + random.nextDouble() * 0.003,
        size: 1 + random.nextDouble() * 3,
        opacity: 0.1 + random.nextDouble() * 0.4,
      );
    });
  }

  Future<void> _playBackgroundMusic() async {
    try {
      await _audioPlayer.setAsset('Assets/TheCrownlessKing.mp3');
      await _audioPlayer.setLoopMode(LoopMode.one);
      await _audioPlayer.setVolume(0.15); // Volume suave (0.0 a 1.0)
      await _audioPlayer.play();
    } catch (e) {
      // Pode falhar no web por autoplay policy, ignore erro silenciosamente
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _particleController.dispose();
    _glowController.dispose();
    _scrollController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final isWide = mq.size.width > 900;

    return Scaffold(
      body: Stack(
        children: [
          // Fundo animado com partículas
          _buildAnimatedBackground(),

          // Conteúdo principal com rolagem
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _buildParallaxHeader(isWide),
                const SizedBox(height: 32), // Espaço entre header e conteúdo
                _buildLazySections(isWide),
                const SizedBox(height: 60), // Espaço no final
              ],
            ),
          ),

          // Overlay de névoa para efeito visual
          _buildMistOverlay(),
        ],
      ),
    );
  }

  // Lazy loading das seções principais com espaçamento otimizado
  Widget _buildLazySections(bool isWide) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isWide ? 72 : 16),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _sections.length,
        separatorBuilder: (context, index) {
          // Espaçamento diferenciado entre seções
          return SizedBox(height: isMobile ? 56 : 72);
        },
        itemBuilder: (context, index) {
          return _LazySection(
            key: _sections[index].key,
            builder: _sections[index].builder,
          );
        },
      ),
    );
  }

  /// Fundo animado com partículas e gradiente radial.
  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _particleAnimation,
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

  /// Header com gradiente, título animado, subtítulo e botões de redes sociais.
  Widget _buildParallaxHeader(bool isWide) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Stack(
        children: [
          // Gradiente de fundo do header
          Positioned.fill(
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
          ),

          // Conteúdo centralizado: nome, título, botões
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildAnimatedTitle(),
                const SizedBox(height: 32),
                _buildAnimatedSubtitle(),
                const SizedBox(height: 48),
                _buildGlowingButtons(),
              ],
            ),
          ),

          // Efeito de brilho circular no canto superior direito
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

  /// Título animado com efeito de escala e gradiente.
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
          fontSize = 28;
        } else if (isTablet) {
          fontSize = 48;
        } else {
          fontSize = 64;
        }

        return Transform.scale(
          scale: value,
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
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
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: isMobile ? 1.0 : 2.0,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 0),
                        blurRadius: isMobile ? 15 : 20,
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

  /// Subtítulo animado com efeito de translação e opacidade.
  Widget _buildAnimatedSubtitle() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 2000),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = screenWidth < 600;
        final isTablet = screenWidth >= 600 && screenWidth < 1024;

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
          offset: Offset(0, (isMobile ? 30 : 50) * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: verticalPadding,
                  ),
                  margin: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: CyberpunkColors.primaryOrange.withOpacity(0.5),
                      width: isMobile ? 1.5 : 2,
                    ),
                    borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
                    boxShadow: [
                      BoxShadow(
                        color: CyberpunkColors.primaryOrange.withOpacity(0.3),
                        blurRadius: isMobile ? 10 : 15,
                        spreadRadius: isMobile ? 1 : 2,
                      ),
                    ],
                  ),
                  child: Text(
                    profile.title,
                    textAlign: TextAlign.center,
                    maxLines: isMobile ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: CyberpunkColors.terminalGreen,
                      letterSpacing: isMobile ? 1.0 : 1.5,
                      height: isMobile ? 1.3 : 1.0,
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

  /// Botões animados para GitHub e LinkedIn.
  Widget _buildGlowingButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildGlowingButton(
          'GitHub',
          Icons.code,
          () => _openLink(profile.github),
        ),
        const SizedBox(width: 24),
        _buildGlowingButton(
          'LinkedIn',
          Icons.link,
          () => _openLink(profile.linkedin),
        ),
      ],
    );
  }

  /// Botão com efeito de brilho animado.
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
                      padding: const EdgeInsets.symmetric(
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

  /// Seção animada com título e conteúdo - espaçamento otimizado.
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
                const SizedBox(height: 20), // Espaço entre título e conteúdo
                content,
              ],
            ),
          ),
        );
      },
    );
  }

  /// Título de seção com barra lateral animada e gradiente.
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
                width: isMobile ? 6 : 8,
                height: isMobile ? 24 : 32,
                decoration: BoxDecoration(
                  color: CyberpunkColors.primaryOrange,
                  borderRadius: BorderRadius.circular(isMobile ? 3 : 4),
                  boxShadow: [
                    BoxShadow(
                      color: CyberpunkColors.primaryOrange.withOpacity(
                        _glowAnimation.value,
                      ),
                      blurRadius: isMobile ? 8 : 10,
                      spreadRadius: isMobile ? 1 : 2,
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(width: MediaQuery.of(context).size.width < 600 ? 12 : 16),
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
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
                      fontSize = 20;
                    } else if (isTablet) {
                      fontSize = 24;
                    } else {
                      fontSize = 28;
                    }

                    return Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: isMobile ? 0.8 : 1.2,
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

  /// Seção "Sobre mim" com descrição.
  Widget _buildAboutSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 24),
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
        'Desenvolvedor apaixonado por tecnologia, especializado em Flutter, Android (Java) e C++. '
        'Atuo no desenvolvimento de soluções mobile, integrações IoT e backends serverless, unindo desempenho e inovação. '
        'Busco criar projetos que aliem design refinado, eficiência e experiências marcantes para o usuário.',
        style: TextStyle(
          fontSize: isMobile ? 16 : 18,
          color: CyberpunkColors.terminalGreen,
          height: 1.6,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// Seção de projetos: grid no desktop/tablet, lista centralizada no mobile.
  Widget _buildProjectsSection(bool isWide) {
    final double cardWidth = isWide ? 320 : 340;

    if (isWide) {
      // Desktop/tablet: grid responsivo com animação individual
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Wrap(
          spacing: 16,
          runSpacing: 20,
          alignment: WrapAlignment.center, // Centraliza os cards
          children:
              projects.asMap().entries.map((entry) {
                final index = entry.key;
                final project = entry.value;

                return SizedBox(
                  width: cardWidth,
                  child: ProjectCard(
                    project: project,
                    width: cardWidth,
                    index: index, // Passa o índice para delay escalonado
                  ),
                );
              }).toList(),
        ),
      );
    } else {
      // Mobile: lista centralizada com animação individual
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: projects.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final project = projects[index];

            return Align(
              alignment: Alignment.center,
              child: ProjectCard(
                project: project,
                width: cardWidth,
                index: index, // Passa o índice para delay escalonado
              ),
            );
          },
        ),
      );
    }
  }

  /// Overlay de névoa animada para efeito visual.
  Widget _buildMistOverlay() {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1 + _glowAnimation.value * 0.05),
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

  /// Abre um link externo (GitHub, LinkedIn, etc).
  void _openLink(String url) async {
    HapticFeedback.lightImpact();
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// Classe para representar partículas do fundo animado.
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

  /// Atualiza a posição da partícula (movimento para cima).
  void update() {
    y -= speed;
    if (y < 0) {
      y = 1.0;
      x = math.Random().nextDouble();
    }
  }
}

/// CustomPainter para desenhar partículas animadas e linhas de conexão.
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

    // Desenha partículas
    for (final particle in particles) {
      particle.update();
      paint.color = CyberpunkColors.primaryOrange.withOpacity(particle.opacity);

      final dx =
          particle.x * size.width +
          math.sin(animation * 2 * math.pi + particle.x * 10) * 20;
      final dy = particle.y * size.height - parallaxOffset * 0.5;

      canvas.drawCircle(Offset(dx, dy), particle.size, paint);
    }

    // Desenha linhas de conexão entre partículas próximas
    paint.color = CyberpunkColors.primaryOrange.withOpacity(0.1);
    paint.strokeWidth = 1;

    for (int i = 0; i < particles.length - 1; i++) {
      int connections = 0;
      for (int j = i + 1; j < particles.length && connections < 2; j++) {
        final p1 = particles[i];
        final p2 = particles[j];

        final dx1 = p1.x * size.width;
        final dy1 = p1.y * size.height - parallaxOffset * 0.5;
        final dx2 = p2.x * size.width;
        final dy2 = p2.y * size.height - parallaxOffset * 0.5;

        final distance = math.sqrt(
          math.pow(dx2 - dx1, 2) + math.pow(dy2 - dy1, 2),
        );

        if (distance < 80) {
          // Reduzido de 100 para 80 para desempenho
          canvas.drawLine(Offset(dx1, dy1), Offset(dx2, dy2), paint);
          connections++;
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AnimatedOnVisible extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offsetY;
  final Curve curve;

  const AnimatedOnVisible({
    required this.child,
    this.duration = const Duration(milliseconds: 700),
    this.offsetY = 60,
    this.curve = Curves.easeOutCubic,
    super.key,
  });

  @override
  State<AnimatedOnVisible> createState() => _AnimatedOnVisibleState();
}

class _AnimatedOnVisibleState extends State<AnimatedOnVisible>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fade = CurvedAnimation(parent: _controller, curve: widget.curve);
    _slide = Tween<Offset>(
      begin: Offset(0, widget.offsetY / 100),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_visible && info.visibleFraction > 0.1) {
      _visible = true;
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.key ?? UniqueKey(),
      onVisibilityChanged: _onVisibilityChanged,
      child: AnimatedBuilder(
        animation: _controller,
        builder:
            (context, child) => Opacity(
              opacity: _fade.value,
              child: Transform.translate(
                offset: Offset(0, _slide.value.dy * 100),
                child: child,
              ),
            ),
        child: widget.child,
      ),
    );
  }
}

// Widget para lazy loading e descarregamento de cada seção
class _LazySection extends StatefulWidget {
  final WidgetBuilder builder;
  const _LazySection({super.key, required this.builder});

  @override
  State<_LazySection> createState() => _LazySectionState();
}

class _LazySectionState extends State<_LazySection> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.key ?? UniqueKey(),
      onVisibilityChanged: (info) {
        // Carrega quando entra, descarrega quando sai do viewport
        final isNowVisible = info.visibleFraction > 0.01;
        if (_visible != isNowVisible) {
          setState(() => _visible = isNowVisible);
        }
      },
      child:
          _visible
              ? widget.builder(context)
              : const SizedBox(height: 180), // Placeholder com altura menor
    );
  }
}

// Helper para construir seções
class _SectionBuilder {
  final Key key;
  final WidgetBuilder builder;
  _SectionBuilder({required this.key, required this.builder});
}

class OptimizedProjectCard extends StatefulWidget {
  final Project project;
  final double? width;
  final int index;

  const OptimizedProjectCard({
    super.key,
    required this.project,
    this.width,
    this.index = 0,
  });

  @override
  State<OptimizedProjectCard> createState() => _OptimizedProjectCardState();
}

class _OptimizedProjectCardState extends State<OptimizedProjectCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.85,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!_hasAnimated && info.visibleFraction > 0.2) {
      _hasAnimated = true;

      // Delay progressivo para cada card
      Future.delayed(Duration(milliseconds: widget.index * 150), () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('optimized_project_${widget.index}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ProjectCard(
                  project: widget.project,
                  width: widget.width,
                  index: widget.index,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

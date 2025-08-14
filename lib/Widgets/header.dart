// lib/widgets/header.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:portifolio/Models/resume_models.dart';
import 'package:portifolio/Theme/ds3_pallet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;

class Header extends StatefulWidget {
  final Profile profile;
  Header({required this.profile});

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _glitchController;
  late AnimationController _emberController;
  late AnimationController _breatheController;

  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _glitchAnimation;
  late Animation<double> _emberAnimation;
  late Animation<double> _breatheAnimation;

  bool _isHovered = false;
  List<EmberParticle> _embers = [];

  @override
  void initState() {
    super.initState();

    // Controladores de animação
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotateController = AnimationController(
      duration: Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _glitchController = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );

    _emberController = AnimationController(
      duration: Duration(seconds: 6),
      vsync: this,
    )..repeat();

    _breatheController = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    // Animações
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _rotateController,
      curve: Curves.linear,
    ));

    _glitchAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glitchController,
      curve: Curves.easeInOut,
    ));

    _emberAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_emberController);

    _breatheAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _breatheController,
      curve: Curves.easeInOut,
    ));

    _initializeEmbers();
  }

  void _initializeEmbers() {
    final random = math.Random();
    _embers = List.generate(30, (index) {
      return EmberParticle(
        x: random.nextDouble(),
        y: 1.0 + random.nextDouble() * 0.5,
        speed: 0.002 + random.nextDouble() * 0.005,
        size: 2 + random.nextDouble() * 4,
        opacity: 0.3 + random.nextDouble() * 0.7,
        sway: random.nextDouble() * 0.02,
      );
    });
  }

  void _triggerGlitch() {
    _glitchController.forward().then((_) {
      _glitchController.reverse();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    _glitchController.dispose();
    _emberController.dispose();
    _breatheController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Stack(
        children: [
          // Background com gradiente animado
          _buildAnimatedBackground(),
          
          // Partículas de fogo/brasas
          _buildEmbersLayer(),
          
          // Conteúdo principal
          _buildMainContent(isWide, screenWidth),
          
          // Overlay de névoa
          _buildMysticalOverlay(),
          
          // Elementos decorativos flutuantes
          _buildFloatingElements(),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: Listenable.merge([_rotateAnimation, _breatheAnimation]),
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(
                math.sin(_rotateAnimation.value) * 0.3,
                -0.2 + math.cos(_rotateAnimation.value * 0.5) * 0.1,
              ),
              radius: 1.5 * _breatheAnimation.value,
              colors: [
                CyberpunkColors.primaryOrange.withOpacity(0.4),
                CyberpunkColors.deepOrange.withOpacity(0.3),
                CyberpunkColors.burntOrange.withOpacity(0.2),
                CyberpunkColors.deepBlack,
              ],
              stops: [0.0, 0.3, 0.6, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmbersLayer() {
    return AnimatedBuilder(
      animation: _emberAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: EmbersPainter(
            embers: _embers,
            animation: _emberAnimation.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildMainContent(bool isWide, double screenWidth) {
    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isWide ? 72 : 24,
          vertical: 40,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isWide) 
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: _buildLeftContent()),
                  SizedBox(width: 60),
                  _buildContactCard(),
                ],
              )
            else
              _buildMobileLayout(),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnimatedTitle(),
        SizedBox(height: 20),
        _buildAnimatedSubtitle(),
        SizedBox(height: 40),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAnimatedTitle(),
        SizedBox(height: 20),
        _buildAnimatedSubtitle(),
        SizedBox(height: 40),
        _buildActionButtons(),
        SizedBox(height: 60),
        _buildContactCard(),
      ],
    );
  }

  Widget _buildAnimatedTitle() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _triggerGlitch,
        child: AnimatedBuilder(
          animation: Listenable.merge([_pulseAnimation, _glitchAnimation, _breatheAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _breatheAnimation.value + (_isHovered ? 0.05 : 0.0),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                child: Stack(
                  children: [
                    // Efeito de glitch
                    if (_glitchAnimation.value > 0)
                      ..._buildGlitchLayers(),
                    
                    // Texto principal
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            CyberpunkColors.primaryOrange,
                            CyberpunkColors.glowYellow,
                            CyberpunkColors.deepOrange,
                            CyberpunkColors.primaryOrange,
                          ],
                          stops: [0.0, 0.3, 0.7, 1.0],
                        ).createShader(bounds);
                      },
                      child: Text(
                        widget.profile.fullName,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width > 900 ? 56 : 36,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 3.0,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 0),
                              blurRadius: 30,
                              color: CyberpunkColors.primaryOrange.withOpacity(0.8),
                            ),
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 5,
                              color: Colors.black87,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Partículas ao redor do texto quando hover
                    if (_isHovered)
                      _buildTextParticles(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildGlitchLayers() {
    return [
      Transform.translate(
        offset: Offset(-2, 0),
        child: Text(
          widget.profile.fullName,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width > 900 ? 56 : 36,
            fontWeight: FontWeight.w900,
            color: CyberpunkColors.neonBlue.withOpacity(_glitchAnimation.value * 0.7),
            letterSpacing: 3.0,
          ),
        ),
      ),
      Transform.translate(
        offset: Offset(2, 0),
        child: Text(
          widget.profile.fullName,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width > 900 ? 56 : 36,
            fontWeight: FontWeight.w900,
            color: CyberpunkColors.errorRed.withOpacity(_glitchAnimation.value * 0.7),
            letterSpacing: 3.0,
          ),
        ),
      ),
    ];
  }

  Widget _buildTextParticles() {
    return Positioned.fill(
      child: CustomPaint(
        painter: TextParticlesPainter(
          animation: _pulseAnimation.value,
        ),
      ),
    );
  }

  Widget _buildAnimatedSubtitle() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: CyberpunkColors.charcoalGray.withOpacity(0.8),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: CyberpunkColors.primaryOrange.withOpacity(0.6),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: CyberpunkColors.primaryOrange.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 3,
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: CyberpunkColors.terminalGreen.withOpacity(_pulseAnimation.value * 0.3),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: DefaultTextStyle(
              style: TextStyle(
                color: CyberpunkColors.terminalGreen,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.2,
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    widget.profile.title,
                    speed: Duration(milliseconds: 80),
                  ),
                  TypewriterAnimatedText(
                    'Flutter • Android • C++ • IoT',
                    speed: Duration(milliseconds: 80),
                  ),
                  TypewriterAnimatedText(
                    'Desenvolvedor Full Stack',
                    speed: Duration(milliseconds: 80),
                  ),
                ],
                repeatForever: true,
                pause: Duration(seconds: 2),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionButtons() {
    return Wrap(
      spacing: 20,
      runSpacing: 16,
      children: [
        _buildEnhancedButton(
          'GitHub',
          Icons.code,
          () => _openLink(widget.profile.github),
          CyberpunkColors.terminalGreen,
        ),
        _buildEnhancedButton(
          'LinkedIn',
          Icons.link,
          () => _openLink(widget.profile.linkedin),
          CyberpunkColors.neonBlue,
        ),
      ],
    );
  }

  Widget _buildEnhancedButton(
    String text, 
    IconData icon, 
    VoidCallback onPressed, 
    Color accentColor
  ) {
    return MouseRegion(
      onEnter: (_) => HapticFeedback.selectionClick(),
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 1.0, end: 1.0),
            duration: Duration(milliseconds: 200),
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: CyberpunkColors.primaryOrange.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      onPressed();
                    },
                    icon: Icon(icon, size: 22),
                    label: Text(
                      text,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CyberpunkColors.charcoalGray,
                      foregroundColor: accentColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color: accentColor.withOpacity(0.8),
                          width: 2,
                        ),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildContactCard() {
    return AnimatedBuilder(
      animation: _breatheAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _breatheAnimation.value,
          child: Container(
            width: 340,
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: CyberpunkColors.charcoalGray.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: CyberpunkColors.primaryOrange.withOpacity(0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: CyberpunkColors.primaryOrange.withOpacity(0.3),
                  blurRadius: 25,
                  spreadRadius: 5,
                ),
                BoxShadow(
                  color: Colors.black87,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: CyberpunkColors.primaryOrange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.contact_mail,
                        color: CyberpunkColors.primaryOrange,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Contato',
                      style: TextStyle(
                        color: CyberpunkColors.primaryOrange,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                _buildContactItem(Icons.email, widget.profile.email),
                SizedBox(height: 12),
                _buildContactItem(Icons.phone, widget.profile.phone),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: _buildEnhancedButton(
                    'Enviar Email',
                    Icons.send,
                    () => _openEmail(widget.profile.email),
                    CyberpunkColors.glowYellow,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: CyberpunkColors.terminalGreen,
          size: 18,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMysticalOverlay() {
    return AnimatedBuilder(
      animation: _rotateAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(0.1 + math.sin(_rotateAnimation.value) * 0.05),
                Colors.transparent,
                Colors.transparent,
                CyberpunkColors.deepBlack.withOpacity(0.3),
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingElements() {
    return AnimatedBuilder(
      animation: _rotateAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            // Elemento flutuante 1
            Positioned(
              top: 100 + math.sin(_rotateAnimation.value * 0.7) * 30,
              right: 100 + math.cos(_rotateAnimation.value * 0.5) * 20,
              child: Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: CyberpunkColors.terminalGreen,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: CyberpunkColors.terminalGreen.withOpacity(0.6),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
            
            // Elemento flutuante 2
            Positioned(
              top: 200 + math.cos(_rotateAnimation.value * 0.9) * 40,
              left: 80 + math.sin(_rotateAnimation.value * 0.6) * 25,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: CyberpunkColors.neonBlue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: CyberpunkColors.neonBlue.withOpacity(0.6),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _openEmail(String to) async {
    final uri = Uri(scheme: 'mailto', path: to);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }
}

// Classe para partículas de brasas
class EmberParticle {
  double x;
  double y;
  final double speed;
  final double size;
  final double opacity;
  final double sway;

  EmberParticle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.opacity,
    required this.sway,
  });

  void update(double time) {
    y -= speed;
    x += math.sin(time * 2 + y * 10) * sway;
    
    if (y < -0.1) {
      y = 1.1;
      x = math.Random().nextDouble();
    }
  }
}

// Painter para brasas
class EmbersPainter extends CustomPainter {
  final List<EmberParticle> embers;
  final double animation;

  EmbersPainter({
    required this.embers,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final ember in embers) {
      ember.update(animation * 10);

      // Gradiente para a brasa
      final gradient = RadialGradient(
        colors: [
          CyberpunkColors.glowYellow.withOpacity(ember.opacity),
          CyberpunkColors.primaryOrange.withOpacity(ember.opacity * 0.8),
          CyberpunkColors.deepOrange.withOpacity(ember.opacity * 0.4),
          Colors.transparent,
        ],
        stops: [0.0, 0.4, 0.8, 1.0],
      );

      final rect = Rect.fromCircle(
        center: Offset(ember.x * size.width, ember.y * size.height),
        radius: ember.size,
      );

      paint.shader = gradient.createShader(rect);

      canvas.drawCircle(
        Offset(ember.x * size.width, ember.y * size.height),
        ember.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Painter para partículas do texto
class TextParticlesPainter extends CustomPainter {
  final double animation;

  TextParticlesPainter({required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final random = math.Random(42); // Seed fixo para consistência

    for (int i = 0; i < 20; i++) {
      final angle = (i / 20) * 2 * math.pi;
      final radius = 50 + math.sin(animation * math.pi + i) * 20;
      
      final dx = size.width * 0.5 + math.cos(angle) * radius;
      final dy = size.height * 0.5 + math.sin(angle) * radius;

      paint.color = CyberpunkColors.primaryOrange.withOpacity(0.6 + math.sin(animation * 2 + i) * 0.3);
      
      canvas.drawCircle(
        Offset(dx, dy),
        2 + math.sin(animation * 3 + i) * 1,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
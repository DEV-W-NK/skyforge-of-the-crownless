import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:portifolio/Models/resume_models.dart';
import 'package:portifolio/Theme/ds3_pallet.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController _ambientController;
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _granithKey = GlobalKey();
  final GlobalKey _systemKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat();
    _scrollController.addListener(() {
      if (!mounted) return;
      setState(() => _scrollOffset = _scrollController.offset);
    });
  }

  @override
  void dispose() {
    _ambientController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewport = MediaQuery.sizeOf(context);
    final isCompact = viewport.width < 760;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _ambientController,
              builder: (context, _) {
                return CustomPaint(
                  painter: _SkyforgeBackgroundPainter(
                    progress: _ambientController.value,
                    scrollOffset: _scrollOffset,
                  ),
                  child: const SizedBox.expand(),
                );
              },
            ),
          ),
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: isCompact ? 86 : 104)),
              SliverToBoxAdapter(
                child: _HeroSection(onOpen: _openLink, isCompact: isCompact),
              ),
              SliverToBoxAdapter(
                child: _PageShell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(
                        key: _granithKey,
                        eyebrow: 'Produto principal',
                        title: 'Granith como vitrine de engenharia',
                        subtitle:
                            'Um ERP web e um app Android de campo conectados por dados, notificações, mapas, offline-first e IA local.',
                      ),
                      const SizedBox(height: 22),
                      _GranithFeatureGrid(onOpen: _openLink),
                      const SizedBox(height: 86),
                      _SectionHeader(
                        key: _systemKey,
                        eyebrow: 'Como eu entrego',
                        title: 'Do problema operacional ao produto em uso',
                        subtitle:
                            'A página agora apresenta o trabalho como uma oferta clara: descoberta, arquitetura, implementação, entrega e evolução.',
                      ),
                      const SizedBox(height: 22),
                      const _DeliverySystem(),
                      const SizedBox(height: 86),
                      const _MetricStrip(),
                      const SizedBox(height: 86),
                      _SectionHeader(
                        key: _projectsKey,
                        eyebrow: 'Portfólio',
                        title: 'Projetos com contexto e impacto',
                        subtitle:
                            'Cards mais densos, com tecnologia, papel no projeto e um resumo do que cada entrega resolveu.',
                      ),
                      const SizedBox(height: 22),
                      _ProjectsShowcase(onOpen: _openLink),
                      const SizedBox(height: 86),
                      const _ExperienceBlock(),
                      const SizedBox(height: 86),
                      const _StackBlock(),
                      const SizedBox(height: 86),
                      _ContactBand(key: _contactKey, onOpen: _openLink),
                      const SizedBox(height: 72),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: _TopNavigation(
                compact: isCompact,
                elevated: _scrollOffset > 40,
                onGranith: () => _scrollTo(_granithKey),
                onSystem: () => _scrollTo(_systemKey),
                onProjects: () => _scrollTo(_projectsKey),
                onContact: () => _scrollTo(_contactKey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _scrollTo(GlobalKey key) async {
    final targetContext = key.currentContext;
    if (targetContext == null) return;
    await Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
      alignment: 0.08,
    );
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _TopNavigation extends StatelessWidget {
  final bool compact;
  final bool elevated;
  final VoidCallback onGranith;
  final VoidCallback onSystem;
  final VoidCallback onProjects;
  final VoidCallback onContact;

  const _TopNavigation({
    required this.compact,
    required this.elevated,
    required this.onGranith,
    required this.onSystem,
    required this.onProjects,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(compact ? 14 : 28, 12, compact ? 14 : 28, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: AnimatedContainer(
            width: double.infinity,
            duration: const Duration(milliseconds: 220),
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 12 : 18,
              vertical: compact ? 10 : 12,
            ),
            decoration: BoxDecoration(
              color: CyberpunkColors.deepBlack.withValues(
                alpha: elevated ? 0.82 : 0.58,
              ),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                    elevated
                        ? CyberpunkColors.primaryOrange.withValues(alpha: 0.34)
                        : Colors.white.withValues(alpha: 0.08),
              ),
              boxShadow: [
                if (elevated)
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.38),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
              ],
            ),
            child: Row(
              children: [
                _BrandMark(compact: compact),
                const Spacer(),
                if (!compact) ...[
                  _NavItem(label: 'Granith', onTap: onGranith),
                  _NavItem(label: 'Sistema', onTap: onSystem),
                  _NavItem(label: 'Projetos', onTap: onProjects),
                  const SizedBox(width: 8),
                ],
                _PrimaryNavButton(
                  label: compact ? 'Contato' : 'Falar comigo',
                  icon: Icons.arrow_outward,
                  onTap: onContact,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  final bool compact;

  const _BrandMark({required this.compact});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'Assets/granith_app_icon.png',
            width: compact ? 36 : 42,
            height: compact ? 36 : 42,
            fit: BoxFit.cover,
          ),
        ),
        if (!compact) ...[
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Skyforge',
                style: TextStyle(
                  color: CyberpunkColors.terminalGreen,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Portfólio Granith',
                style: TextStyle(
                  color: Colors.white54,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _NavItem({required this.label, required this.onTap});

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color:
                _hovered
                    ? CyberpunkColors.primaryOrange.withValues(alpha: 0.12)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  _hovered
                      ? CyberpunkColors.primaryOrange.withValues(alpha: 0.42)
                      : Colors.transparent,
            ),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              color:
                  _hovered
                      ? CyberpunkColors.glowYellow
                      : CyberpunkColors.terminalGreen.withValues(alpha: 0.78),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryNavButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _PrimaryNavButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_PrimaryNavButton> createState() => _PrimaryNavButtonState();
}

class _PrimaryNavButtonState extends State<_PrimaryNavButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 190),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color:
                _hovered
                    ? CyberpunkColors.glowYellow
                    : CyberpunkColors.primaryOrange,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: CyberpunkColors.primaryOrange.withValues(
                  alpha: _hovered ? 0.36 : 0.18,
                ),
                blurRadius: _hovered ? 24 : 12,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  color: CyberpunkColors.deepBlack,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 8),
              Icon(widget.icon, color: CyberpunkColors.deepBlack, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final bool isCompact;
  final void Function(String url) onOpen;

  const _HeroSection({required this.onOpen, required this.isCompact});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 1000;

    return _PageShell(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: isCompact ? 700 : 760),
        child: Column(
          children: [
            if (isWide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 11, child: _HeroCopy(onOpen: onOpen)),
                  const SizedBox(width: 38),
                  const Expanded(flex: 10, child: _ProductPreview()),
                ],
              )
            else ...[
              _HeroCopy(onOpen: onOpen),
              const SizedBox(height: 28),
              const _ProductPreview(),
            ],
            const SizedBox(height: 34),
            const _HeroMarquee(),
          ],
        ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  final void Function(String url) onOpen;

  const _HeroCopy({required this.onOpen});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < 760;
    final titleSize = isCompact ? 42.0 : 74.0;

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Eyebrow(label: 'Flutter Web + Android + Supabase'),
          const SizedBox(height: 22),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Text(
              'Projetos que parecem produto, não apenas repositório.',
              softWrap: true,
              style: TextStyle(
                color: CyberpunkColors.terminalGreen,
                fontSize: titleSize,
                height: 0.98,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 22),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Text(
              professionalSummary,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.68),
                fontSize: isCompact ? 15.5 : 18,
                height: 1.62,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _ActionButton(
                label: 'Ver Granith ERP',
                icon: Icons.dashboard_customize_outlined,
                filled: true,
                onTap: () => onOpen('https://github.com/DEV-W-NK/Granith-ERP'),
              ),
              _ActionButton(
                label: 'Ver Mobile',
                icon: Icons.phone_android_outlined,
                onTap:
                    () => onOpen('https://github.com/DEV-W-NK/Granith-Mobile'),
              ),
              _ActionButton(
                label: 'GitHub',
                icon: Icons.code,
                onTap: () => onOpen(profile.github),
              ),
            ],
          ),
          const SizedBox(height: 34),
          const _HeroStats(),
        ],
      ),
    );
  }
}

class _HeroStats extends StatelessWidget {
  const _HeroStats();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: const [
        _StatTile(value: '2', label: 'apps Granith integrados'),
        _StatTile(value: '100%', label: 'foco em operação real'),
        _StatTile(value: 'PWA', label: 'portfólio web publicado'),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String value;
  final String label;

  const _StatTile({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CyberpunkColors.charcoalGray.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: CyberpunkColors.primaryOrange,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.62),
              fontWeight: FontWeight.w600,
              fontSize: 12.5,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductPreview extends StatefulWidget {
  const _ProductPreview();

  @override
  State<_ProductPreview> createState() => _ProductPreviewState();
}

class _ProductPreviewState extends State<_ProductPreview>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final glow = 0.08 + (_controller.value * 0.08);
        return Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 620),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: CyberpunkColors.primaryOrange.withValues(
                alpha: 0.35 + glow,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: CyberpunkColors.primaryOrange.withValues(alpha: glow),
                blurRadius: 34,
                offset: const Offset(0, 18),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.48),
                blurRadius: 34,
                offset: const Offset(0, 26),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                CyberpunkColors.darkGray.withValues(alpha: 0.95),
                CyberpunkColors.charcoalGray.withValues(alpha: 0.94),
                CyberpunkColors.deepBlack.withValues(alpha: 0.98),
              ],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _PanelLinesPainter(progress: _controller.value),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'Assets/granith_app_icon.png',
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Image.asset(
                              'Assets/granith_logo_wordmark.png',
                              height: 42,
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const _StatusChip(label: 'Online'),
                        ],
                      ),
                      const SizedBox(height: 22),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final compact = constraints.maxWidth < 500;
                          return compact
                              ? const Column(
                                children: [
                                  _DashboardMock(),
                                  SizedBox(height: 14),
                                  _PhoneMock(),
                                ],
                              )
                              : const Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(flex: 7, child: _DashboardMock()),
                                  SizedBox(width: 14),
                                  Expanded(flex: 4, child: _PhoneMock()),
                                ],
                              );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DashboardMock extends StatelessWidget {
  const _DashboardMock();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: CyberpunkColors.deepBlack.withValues(alpha: 0.58),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _TinyIcon(icon: Icons.area_chart_outlined),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'ERP operacional',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.88),
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
              const _StatusChip(label: 'CI/CD'),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(child: _MiniMetric(label: 'Rotas', value: 'GPS')),
              SizedBox(width: 10),
              Expanded(child: _MiniMetric(label: 'Obras', value: 'RLS')),
            ],
          ),
          const SizedBox(height: 14),
          const _ProgressLine(label: 'Compras e requisicoes', percent: 0.84),
          const SizedBox(height: 10),
          const _ProgressLine(label: 'Estoque e financeiro', percent: 0.72),
          const SizedBox(height: 10),
          const _ProgressLine(label: 'Mobile sync', percent: 0.91),
        ],
      ),
    );
  }
}

class _PhoneMock extends StatelessWidget {
  const _PhoneMock();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF06090A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: CyberpunkColors.primaryOrange.withValues(alpha: 0.28),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 5,
            width: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.20),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'Assets/granith_app_icon.png',
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 14),
          const _PhoneRouteLine(title: 'Minha rota hoje', value: '12 km'),
          const _PhoneRouteLine(title: 'Cerca ativa', value: 'OK'),
          const _PhoneRouteLine(title: 'Offline queue', value: '0'),
          const SizedBox(height: 10),
          Container(
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: CyberpunkColors.screenTeal,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Sincronizado',
              style: TextStyle(
                color: CyberpunkColors.deepBlack,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoneRouteLine extends StatelessWidget {
  final String title;
  final String value;

  const _PhoneRouteLine({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.58),
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: CyberpunkColors.primaryOrange,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  final String label;
  final String value;

  const _MiniMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CyberpunkColors.primaryOrange.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: CyberpunkColors.primaryOrange.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.54),
              fontWeight: FontWeight.w700,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: CyberpunkColors.terminalGreen,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  final String label;
  final double percent;

  const _ProgressLine({required this.label, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.62),
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 7,
            backgroundColor: Colors.white.withValues(alpha: 0.08),
            valueColor: const AlwaysStoppedAnimation(
              CyberpunkColors.primaryOrange,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroMarquee extends StatelessWidget {
  const _HeroMarquee();

  @override
  Widget build(BuildContext context) {
    const items = [
      'Flutter Web',
      'Android',
      'Supabase',
      'PostgreSQL',
      'Firebase Cloud Messaging',
      'Google Maps',
      'SQLite',
      'Offline-first',
      'IA local',
      'CI/CD',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: items.map((item) => _TechBadge(label: item)).toList(),
      ),
    );
  }
}

class _GranithFeatureGrid extends StatelessWidget {
  final void Function(String url) onOpen;

  const _GranithFeatureGrid({required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 920;
        final erp = projects[0];
        final mobile = projects[1];

        final cards = [
          _FeatureProjectCard(
            project: erp,
            label: 'ERP Web',
            icon: Icons.desktop_windows_outlined,
            accent: CyberpunkColors.primaryOrange,
            onOpen: onOpen,
          ),
          _FeatureProjectCard(
            project: mobile,
            label: 'Android Field App',
            icon: Icons.phone_android_outlined,
            accent: CyberpunkColors.screenTeal,
            onOpen: onOpen,
          ),
        ];

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 18),
              Expanded(child: cards[1]),
            ],
          );
        }

        return Column(
          children: [cards[0], const SizedBox(height: 16), cards[1]],
        );
      },
    );
  }
}

class _FeatureProjectCard extends StatefulWidget {
  final Project project;
  final String label;
  final IconData icon;
  final Color accent;
  final void Function(String url) onOpen;

  const _FeatureProjectCard({
    required this.project,
    required this.label,
    required this.icon,
    required this.accent,
    required this.onOpen,
  });

  @override
  State<_FeatureProjectCard> createState() => _FeatureProjectCardState();
}

class _FeatureProjectCardState extends State<_FeatureProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.012 : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(22),
          decoration: _cardDecoration(
            border:
                _hovered
                    ? widget.accent.withValues(alpha: 0.72)
                    : widget.accent.withValues(alpha: 0.30),
            glow: widget.accent.withValues(alpha: _hovered ? 0.16 : 0.06),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _IconBox(icon: widget.icon, color: widget.accent),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        color: widget.accent,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  _StatusChip(label: 'Repositório'),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                widget.project.title,
                style: const TextStyle(
                  color: CyberpunkColors.terminalGreen,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  height: 1.08,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.project.subtitle,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.68),
                  fontSize: 15,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    widget.project.tech
                        .map(
                          (tech) =>
                              _TechBadge(label: tech, color: widget.accent),
                        )
                        .toList(),
              ),
              const SizedBox(height: 22),
              ...widget.project.bullets!
                  .take(3)
                  .map(
                    (bullet) => _BulletLine(text: bullet, color: widget.accent),
                  ),
              const SizedBox(height: 18),
              if (widget.project.url != null && widget.project.url!.isNotEmpty)
                _ActionButton(
                  label: 'Abrir repositório',
                  icon: Icons.arrow_outward,
                  filled: true,
                  color: widget.accent,
                  onTap: () => widget.onOpen(widget.project.url!),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeliverySystem extends StatelessWidget {
  const _DeliverySystem();

  @override
  Widget build(BuildContext context) {
    const steps = [
      _ProcessStep(
        title: 'Mapeio o processo',
        body:
            'Transformo regra operacional em fluxo navegavel, com estados claros e telas objetivas.',
        icon: Icons.account_tree_outlined,
      ),
      _ProcessStep(
        title: 'Desenho a base',
        body:
            'Estruturo dados, RLS, migrations, serviços, sync e contratos entre web, mobile e banco.',
        icon: Icons.schema_outlined,
      ),
      _ProcessStep(
        title: 'Entrega no campo',
        body:
            'Levo rotas, geofence, evidências, ponto, notificações e cache offline para o Android.',
        icon: Icons.map_outlined,
      ),
      _ProcessStep(
        title: 'Fecho com dados',
        body:
            'Crio dashboards, relatórios, custos, DRE, compras e visão executiva para decisão.',
        icon: Icons.analytics_outlined,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 960;
        return isWide
            ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < steps.length; i++) ...[
                  Expanded(child: _ProcessCard(step: steps[i], index: i)),
                  if (i < steps.length - 1) const SizedBox(width: 14),
                ],
              ],
            )
            : Column(
              children: [
                for (var i = 0; i < steps.length; i++) ...[
                  _ProcessCard(step: steps[i], index: i),
                  if (i < steps.length - 1) const SizedBox(height: 14),
                ],
              ],
            );
      },
    );
  }
}

class _ProcessStep {
  final String title;
  final String body;
  final IconData icon;

  const _ProcessStep({
    required this.title,
    required this.body,
    required this.icon,
  });
}

class _ProcessCard extends StatefulWidget {
  final _ProcessStep step;
  final int index;

  const _ProcessCard({required this.step, required this.index});

  @override
  State<_ProcessCard> createState() => _ProcessCardState();
}

class _ProcessCardState extends State<_ProcessCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(18),
        decoration: _cardDecoration(
          border:
              _hovered
                  ? CyberpunkColors.primaryOrange.withValues(alpha: 0.56)
                  : Colors.white.withValues(alpha: 0.08),
          glow: CyberpunkColors.primaryOrange.withValues(
            alpha: _hovered ? 0.14 : 0.03,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _IconBox(
                  icon: widget.step.icon,
                  color: CyberpunkColors.primaryOrange,
                ),
                const Spacer(),
                Text(
                  '0${widget.index + 1}',
                  style: TextStyle(
                    color: CyberpunkColors.primaryOrange.withValues(
                      alpha: 0.42,
                    ),
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              widget.step.title,
              style: const TextStyle(
                color: CyberpunkColors.terminalGreen,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.step.body,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.62),
                height: 1.48,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricStrip extends StatelessWidget {
  const _MetricStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: CyberpunkColors.primaryOrange.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: CyberpunkColors.primaryOrange.withValues(alpha: 0.24),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;
          final left = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Eyebrow(label: 'Impacto demonstravel'),
              const SizedBox(height: 12),
              const Text(
                'A vitrine agora mostra engenharia de produto, não uma lista solta de tecnologias.',
                style: TextStyle(
                  color: CyberpunkColors.terminalGreen,
                  fontWeight: FontWeight.w900,
                  fontSize: 28,
                  height: 1.12,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'O foco visual foi trazer a pegada de marketplace: proposta clara, previews, repositórios destacados e cards que vendem o valor do trabalho.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.68),
                  height: 1.55,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
          final right = Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _ValueBox(value: 'ERP', label: 'web completo'),
              _ValueBox(value: 'App', label: 'Android de campo'),
              _ValueBox(value: 'FCM', label: 'notificações'),
              _ValueBox(value: 'Maps', label: 'rotas e geofence'),
            ],
          );

          return isWide
              ? Row(
                children: [
                  Expanded(flex: 7, child: left),
                  const SizedBox(width: 24),
                  Expanded(flex: 5, child: right),
                ],
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [left, const SizedBox(height: 22), right],
              );
        },
      ),
    );
  }
}

class _ValueBox extends StatelessWidget {
  final String value;
  final String label;

  const _ValueBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 145,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CyberpunkColors.deepBlack.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: CyberpunkColors.primaryOrange,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.62),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectsShowcase extends StatelessWidget {
  final void Function(String url) onOpen;

  const _ProjectsShowcase({required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns =
            constraints.maxWidth >= 1150
                ? 3
                : constraints.maxWidth >= 760
                ? 2
                : 1;
        final gap = 14.0;
        final cardWidth =
            (constraints.maxWidth - (gap * (columns - 1))) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children:
              projects
                  .map(
                    (project) => SizedBox(
                      width: cardWidth,
                      child: _CompactProjectCard(
                        project: project,
                        onOpen: onOpen,
                      ),
                    ),
                  )
                  .toList(),
        );
      },
    );
  }
}

class _CompactProjectCard extends StatefulWidget {
  final Project project;
  final void Function(String url) onOpen;

  const _CompactProjectCard({required this.project, required this.onOpen});

  @override
  State<_CompactProjectCard> createState() => _CompactProjectCardState();
}

class _CompactProjectCardState extends State<_CompactProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final hasUrl = widget.project.url != null && widget.project.url!.isNotEmpty;

    return MouseRegion(
      cursor: hasUrl ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: hasUrl ? () => widget.onOpen(widget.project.url!) : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 210),
          constraints: const BoxConstraints(minHeight: 318),
          padding: const EdgeInsets.all(18),
          decoration: _cardDecoration(
            border:
                _hovered
                    ? CyberpunkColors.screenTeal.withValues(alpha: 0.58)
                    : Colors.white.withValues(alpha: 0.08),
            glow: CyberpunkColors.screenTeal.withValues(
              alpha: _hovered ? 0.12 : 0.02,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _IconBox(
                    icon: _iconForProject(widget.project),
                    color: CyberpunkColors.screenTeal,
                  ),
                  const Spacer(),
                  if (hasUrl)
                    Icon(
                      Icons.arrow_outward,
                      color:
                          _hovered
                              ? CyberpunkColors.screenTeal
                              : Colors.white38,
                      size: 20,
                    ),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                widget.project.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: CyberpunkColors.terminalGreen,
                  fontWeight: FontWeight.w900,
                  fontSize: 19,
                  height: 1.16,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                widget.project.subtitle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.62),
                  height: 1.42,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: 7,
                runSpacing: 7,
                children:
                    widget.project.tech
                        .take(4)
                        .map(
                          (tech) => _TechBadge(
                            label: tech,
                            color: CyberpunkColors.screenTeal,
                          ),
                        )
                        .toList(),
              ),
              const SizedBox(height: 15),
              ...?widget.project.bullets
                  ?.take(2)
                  .map(
                    (bullet) => _BulletLine(
                      text: bullet,
                      color: CyberpunkColors.screenTeal,
                      compact: true,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForProject(Project project) {
    final text = '${project.title} ${project.tech.join(' ')}'.toLowerCase();
    if (text.contains('mobile') ||
        text.contains('android') ||
        text.contains('maui')) {
      return Icons.phone_android_outlined;
    }
    if (text.contains('iot') || text.contains('esp') || text.contains('mqtt')) {
      return Icons.sensors_outlined;
    }
    if (text.contains('api') || text.contains('node')) {
      return Icons.api_outlined;
    }
    if (text.contains('erp') || text.contains('sistema')) {
      return Icons.dashboard_customize_outlined;
    }
    return Icons.code;
  }
}

class _ExperienceBlock extends StatelessWidget {
  const _ExperienceBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          eyebrow: 'Experiência',
          title: 'Histórico com foco em produto operacional',
          subtitle:
              'Experiências resumidas por impacto, tecnologia e responsabilidade de entrega.',
        ),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;
            final cards =
                experiences
                    .map(
                      (experience) => _ExperienceCard(experience: experience),
                    )
                    .toList();
            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: cards[0]),
                  const SizedBox(width: 16),
                  Expanded(child: cards[1]),
                ],
              );
            }
            return Column(
              children: [cards[0], const SizedBox(height: 14), cards[1]],
            );
          },
        ),
      ],
    );
  }
}

class _ExperienceCard extends StatefulWidget {
  final Experience experience;

  const _ExperienceCard({required this.experience});

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final bullets =
        _expanded
            ? widget.experience.bullets
            : widget.experience.bullets.take(3).toList();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(
        border:
            _expanded
                ? CyberpunkColors.primaryOrange.withValues(alpha: 0.55)
                : Colors.white.withValues(alpha: 0.08),
        glow: CyberpunkColors.primaryOrange.withValues(
          alpha: _expanded ? 0.12 : 0.03,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _IconBox(
                icon: Icons.work_outline,
                color: CyberpunkColors.primaryOrange,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.experience.company,
                      style: const TextStyle(
                        color: CyberpunkColors.terminalGreen,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.experience.role,
                      style: const TextStyle(
                        color: CyberpunkColors.primaryOrange,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _StatusChip(label: widget.experience.period),
            ],
          ),
          if (widget.experience.subtitle != null) ...[
            const SizedBox(height: 14),
            Text(
              widget.experience.subtitle!,
              style: const TextStyle(
                color: CyberpunkColors.screenTeal,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
          const SizedBox(height: 16),
          AnimatedSize(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOutCubic,
            child: Column(
              children:
                  bullets
                      .map(
                        (bullet) => _BulletLine(
                          text: bullet,
                          color: CyberpunkColors.primaryOrange,
                        ),
                      )
                      .toList(),
            ),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: () => setState(() => _expanded = !_expanded),
            icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            label: Text(_expanded ? 'Ver menos' : 'Ver detalhes'),
            style: TextButton.styleFrom(
              foregroundColor: CyberpunkColors.primaryOrange,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}

class _StackBlock extends StatelessWidget {
  const _StackBlock();

  @override
  Widget build(BuildContext context) {
    final groups = {
      'Mobile e web': [
        'Flutter',
        'Dart',
        'Android SDK',
        '.NET MAUI',
        'C#',
        'Provider',
        'Riverpod',
      ],
      'Dados e backend': [
        'Supabase',
        'PostgreSQL',
        'SQLite',
        'Node.js',
        'REST APIs',
        'Firebase',
        'FCM',
      ],
      'Operação e IA': [
        'Google Maps',
        'Geofence',
        'GitHub Actions',
        'Gemini API',
        'SLM local',
        'MQTT',
        'ESP32',
      ],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(
          eyebrow: 'Stack',
          title: 'Ferramentas que sustentam o Granith',
          subtitle:
              'A stack aparece agrupada por finalidade para o visitante entender onde cada tecnologia entra.',
        ),
        const SizedBox(height: 22),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 920;
            final cards =
                groups.entries
                    .map(
                      (entry) =>
                          _StackGroup(title: entry.key, skills: entry.value),
                    )
                    .toList();

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < cards.length; i++) ...[
                    Expanded(child: cards[i]),
                    if (i < cards.length - 1) const SizedBox(width: 14),
                  ],
                ],
              );
            }
            return Column(
              children: [
                for (var i = 0; i < cards.length; i++) ...[
                  cards[i],
                  if (i < cards.length - 1) const SizedBox(height: 14),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}

class _StackGroup extends StatelessWidget {
  final String title;
  final List<String> skills;

  const _StackGroup({required this.title, required this.skills});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(
        border: Colors.white.withValues(alpha: 0.08),
        glow: CyberpunkColors.screenTeal.withValues(alpha: 0.03),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: CyberpunkColors.terminalGreen,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                skills
                    .map(
                      (skill) => _TechBadge(
                        label: skill,
                        color: CyberpunkColors.screenTeal,
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}

class _ContactBand extends StatelessWidget {
  final void Function(String url) onOpen;

  const _ContactBand({super.key, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: CyberpunkColors.terminalGreen.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: CyberpunkColors.primaryOrange.withValues(alpha: 0.28),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 860;
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Eyebrow(label: 'Contato'),
              const SizedBox(height: 12),
              const Text(
                'Quer ver o projeto funcionando ou conversar sobre produto Flutter?',
                style: TextStyle(
                  color: CyberpunkColors.terminalGreen,
                  fontWeight: FontWeight.w900,
                  fontSize: 30,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${profile.location} | ${profile.availability ?? 'Disponível para novos desafios'}',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.62),
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );
          final actions = Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _ActionButton(
                label: 'Email',
                icon: Icons.mail_outline,
                filled: true,
                onTap: () => onOpen('mailto:${profile.email}'),
              ),
              _ActionButton(
                label: 'LinkedIn',
                icon: Icons.link,
                onTap: () => onOpen(profile.linkedin),
              ),
              _ActionButton(
                label: 'GitHub',
                icon: Icons.code,
                onTap: () => onOpen(profile.github),
              ),
            ],
          );

          return isWide
              ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: copy),
                  const SizedBox(width: 24),
                  actions,
                ],
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [copy, const SizedBox(height: 22), actions],
              );
        },
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String subtitle;

  const _SectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Eyebrow(label: eyebrow),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 840),
          child: Text(
            title,
            style: const TextStyle(
              color: CyberpunkColors.terminalGreen,
              fontWeight: FontWeight.w900,
              fontSize: 36,
              height: 1.08,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.64),
              fontSize: 16,
              height: 1.55,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _PageShell extends StatelessWidget {
  final Widget child;

  const _PageShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: child,
        ),
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.filled = false,
    this.color = CyberpunkColors.primaryOrange,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bg =
        widget.filled
            ? (_hovered ? CyberpunkColors.glowYellow : widget.color)
            : (_hovered
                ? widget.color.withValues(alpha: 0.13)
                : Colors.transparent);
    final fg = widget.filled ? CyberpunkColors.deepBlack : widget.color;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.color.withValues(alpha: widget.filled ? 0 : 0.42),
            ),
            boxShadow: [
              if (widget.filled)
                BoxShadow(
                  color: widget.color.withValues(alpha: _hovered ? 0.28 : 0.14),
                  blurRadius: _hovered ? 24 : 12,
                  offset: const Offset(0, 9),
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 18, color: fg),
              const SizedBox(width: 9),
              Text(
                widget.label,
                style: TextStyle(
                  color: fg,
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Eyebrow extends StatelessWidget {
  final String label;

  const _Eyebrow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: CyberpunkColors.primaryOrange.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: CyberpunkColors.primaryOrange.withValues(alpha: 0.28),
        ),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: CyberpunkColors.primaryOrange,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _TechBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _TechBadge({
    required this.label,
    this.color = CyberpunkColors.primaryOrange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;

  const _StatusChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: CyberpunkColors.screenTeal.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: CyberpunkColors.screenTeal.withValues(alpha: 0.22),
        ),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: CyberpunkColors.screenTeal,
          fontWeight: FontWeight.w900,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _IconBox({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

class _TinyIcon extends StatelessWidget {
  final IconData icon;

  const _TinyIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: CyberpunkColors.primaryOrange.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: CyberpunkColors.primaryOrange, size: 18),
    );
  }
}

class _BulletLine extends StatelessWidget {
  final String text;
  final Color color;
  final bool compact;

  const _BulletLine({
    required this.text,
    required this.color,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: compact ? 8 : 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 7,
            height: 7,
            margin: const EdgeInsets.only(top: 7),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              maxLines: compact ? 3 : null,
              overflow: compact ? TextOverflow.ellipsis : TextOverflow.visible,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.66),
                height: 1.42,
                fontSize: compact ? 12.5 : 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration({required Color border, required Color glow}) {
  return BoxDecoration(
    color: CyberpunkColors.charcoalGray.withValues(alpha: 0.74),
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: border),
    boxShadow: [
      BoxShadow(color: glow, blurRadius: 28, offset: const Offset(0, 16)),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.30),
        blurRadius: 20,
        offset: const Offset(0, 14),
      ),
    ],
  );
}

class _SkyforgeBackgroundPainter extends CustomPainter {
  final double progress;
  final double scrollOffset;

  const _SkyforgeBackgroundPainter({
    required this.progress,
    required this.scrollOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint =
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              CyberpunkColors.deepBlack,
              Color(0xFF0A1212),
              Color(0xFF0D0B08),
            ],
          ).createShader(rect);
    canvas.drawRect(rect, paint);

    final gridPaint =
        Paint()
          ..color = Colors.white.withValues(alpha: 0.028)
          ..strokeWidth = 1;
    const spacing = 64.0;
    final yShift = (scrollOffset * 0.12) % spacing;
    for (double x = -spacing; x < size.width + spacing; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x + 90, size.height), gridPaint);
    }
    for (
      double y = -spacing + yShift;
      y < size.height + spacing;
      y += spacing
    ) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final goldPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2
          ..color = CyberpunkColors.primaryOrange.withValues(alpha: 0.12);
    final tealPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = CyberpunkColors.screenTeal.withValues(alpha: 0.10);

    final wave = math.sin(progress * math.pi * 2);
    final path =
        Path()
          ..moveTo(size.width * 0.62, -40)
          ..lineTo(size.width + 60, size.height * (0.20 + wave * 0.02))
          ..lineTo(size.width * 0.86, size.height * 0.66)
          ..lineTo(size.width * 0.54, size.height * 0.18)
          ..close();
    canvas.drawPath(path, goldPaint);

    final path2 =
        Path()
          ..moveTo(-40, size.height * 0.72)
          ..lineTo(size.width * 0.30, size.height * (0.54 + wave * 0.01))
          ..lineTo(size.width * 0.52, size.height + 80);
    canvas.drawPath(path2, tealPaint);
  }

  @override
  bool shouldRepaint(covariant _SkyforgeBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.scrollOffset != scrollOffset;
  }
}

class _PanelLinesPainter extends CustomPainter {
  final double progress;

  const _PanelLinesPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = CyberpunkColors.primaryOrange.withValues(alpha: 0.12);
    final teal =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = CyberpunkColors.screenTeal.withValues(alpha: 0.10);
    final offset = math.sin(progress * math.pi * 2) * 10;
    canvas.drawLine(
      Offset(size.width * 0.18 + offset, 0),
      Offset(size.width * 0.56, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.82, 0),
      Offset(size.width * 0.48 + offset, size.height),
      teal,
    );
    canvas.drawRect(
      Rect.fromLTWH(10, 10, size.width - 20, size.height - 20),
      paint..color = CyberpunkColors.primaryOrange.withValues(alpha: 0.08),
    );
  }

  @override
  bool shouldRepaint(covariant _PanelLinesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

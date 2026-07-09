import 'package:flutter/material.dart';
import 'package:portifolio/Theme/ds3_pallet.dart';

class GranithLinks {
  static const erp = 'https://github.com/DEV-W-NK/Granith-ERP';
  static const mobile = 'https://github.com/DEV-W-NK/Granith-Mobile';
}

class GranithShowcase extends StatelessWidget {
  final void Function(String url) onOpenLink;

  const GranithShowcase({super.key, required this.onOpenLink});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 880;

        final brand = _BrandBlock(isWide: isWide);
        final repoCards = [
          _RepoCard(
            title: 'Granith ERP Web',
            subtitle:
                'Sistema web em Flutter para obras, compras, estoque, financeiro e portal do cliente.',
            icon: Icons.dashboard_customize_outlined,
            chips: const ['Flutter Web', 'Supabase', 'Firebase'],
            width: isWide ? 280 : double.infinity,
            onTap: () => onOpenLink(GranithLinks.erp),
          ),
          _RepoCard(
            title: 'Granith Mobile',
            subtitle:
                'App Android operacional com rotas, geofence, notificacoes, offline sync e IA local.',
            icon: Icons.phone_android_outlined,
            chips: const ['Android', 'Maps', 'FCM', 'SQLite'],
            width: isWide ? 280 : double.infinity,
            onTap: () => onOpenLink(GranithLinks.mobile),
          ),
        ];
        final repos =
            isWide
                ? Wrap(spacing: 16, runSpacing: 16, children: repoCards)
                : Column(
                  children: [
                    repoCards[0],
                    const SizedBox(height: 14),
                    repoCards[1],
                  ],
                );

        return Container(
          padding: EdgeInsets.all(isWide ? 28 : 20),
          decoration: BoxDecoration(
            color: CyberpunkColors.charcoalGray.withOpacity(0.82),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: CyberpunkColors.primaryOrange.withOpacity(0.36),
            ),
            boxShadow: [
              BoxShadow(
                color: CyberpunkColors.primaryOrange.withOpacity(0.10),
                blurRadius: 26,
                spreadRadius: 2,
              ),
              const BoxShadow(
                color: Colors.black54,
                blurRadius: 22,
                offset: Offset(0, 14),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                CyberpunkColors.darkGray.withOpacity(0.95),
                CyberpunkColors.charcoalGray.withOpacity(0.92),
                CyberpunkColors.deepBlack.withOpacity(0.95),
              ],
            ),
          ),
          child:
              isWide
                  ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: brand),
                      const SizedBox(width: 28),
                      Expanded(flex: 6, child: repos),
                    ],
                  )
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [brand, const SizedBox(height: 22), repos],
                  ),
        );
      },
    );
  }
}

class _BrandBlock extends StatelessWidget {
  final bool isWide;

  const _BrandBlock({required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: isWide ? 56 : 48,
              height: isWide ? 56 : 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: CyberpunkColors.primaryOrange.withOpacity(0.22),
                    blurRadius: 18,
                    spreadRadius: 1,
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset('Assets/granith_app_icon.png'),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Image.asset(
                'Assets/granith_logo_wordmark.png',
                height: isWide ? 54 : 42,
                fit: BoxFit.contain,
                alignment: Alignment.centerLeft,
              ),
            ),
          ],
        ),
        const SizedBox(height: 22),
        Text(
          'Suite operacional propria, conectando ERP web e aplicativo de campo.',
          style: TextStyle(
            color: CyberpunkColors.terminalGreen,
            fontSize: isWide ? 24 : 20,
            fontWeight: FontWeight.w800,
            height: 1.16,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'O portfolio agora destaca o Granith como produto principal: identidade visual, arquitetura, mobile Android, notificacoes, rotas, sincronismo e modulos administrativos.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.68),
            fontSize: isWide ? 15 : 14,
            height: 1.55,
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            _SignalPill(label: 'ERP'),
            _SignalPill(label: 'Mobile'),
            _SignalPill(label: 'Offline-first'),
            _SignalPill(label: 'Push'),
            _SignalPill(label: 'IA local'),
          ],
        ),
      ],
    );
  }
}

class _RepoCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<String> chips;
  final double width;
  final VoidCallback onTap;

  const _RepoCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.chips,
    required this.width,
    required this.onTap,
  });

  @override
  State<_RepoCard> createState() => _RepoCardState();
}

class _RepoCardState extends State<_RepoCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovered ? 1.025 : 1.0,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: widget.width,
            constraints: const BoxConstraints(minHeight: 218),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color:
                  _hovered
                      ? CyberpunkColors.darkGray.withOpacity(0.92)
                      : CyberpunkColors.deepBlack.withOpacity(0.58),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color:
                    _hovered
                        ? CyberpunkColors.primaryOrange
                        : CyberpunkColors.mediumGray.withOpacity(0.45),
                width: _hovered ? 1.6 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: CyberpunkColors.primaryOrange.withOpacity(
                    _hovered ? 0.20 : 0.06,
                  ),
                  blurRadius: _hovered ? 24 : 12,
                  spreadRadius: _hovered ? 2 : 0,
                ),
              ],
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  top: 0,
                  right: _hovered ? 0 : 34,
                  child: AnimatedOpacity(
                    opacity: _hovered ? 1 : 0.25,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      width: 56,
                      height: 2,
                      decoration: BoxDecoration(
                        color: CyberpunkColors.glowYellow,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: [
                          BoxShadow(
                            color: CyberpunkColors.glowYellow.withOpacity(0.55),
                            blurRadius: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: CyberpunkColors.primaryOrange.withOpacity(
                              0.13,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: CyberpunkColors.primaryOrange.withOpacity(
                                0.46,
                              ),
                            ),
                          ),
                          child: Icon(
                            widget.icon,
                            color: CyberpunkColors.primaryOrange,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.open_in_new,
                          color:
                              _hovered
                                  ? CyberpunkColors.primaryOrange
                                  : Colors.white38,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: CyberpunkColors.terminalGreen,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 9),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.66),
                        fontSize: 13.5,
                        height: 1.42,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children:
                          widget.chips
                              .map((chip) => _SignalPill(label: chip))
                              .toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SignalPill extends StatelessWidget {
  final String label;

  const _SignalPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: CyberpunkColors.primaryOrange.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: CyberpunkColors.primaryOrange.withOpacity(0.24),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: CyberpunkColors.primaryOrange,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

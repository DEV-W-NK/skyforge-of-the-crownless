import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:portifolio/Models/resume_models.dart';
import 'package:portifolio/Theme/ds3_pallet.dart';

class ExperienceTimeline extends StatelessWidget {
  final List<Experience> experiences;

  const ExperienceTimeline({super.key, required this.experiences});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: experiences.asMap().entries.map((entry) {
        final idx = entry.key;
        final exp = entry.value;
        final isLast = idx == experiences.length - 1;
        return ExperienceTile(exp: exp, index: idx, isLast: isLast);
      }).toList(),
    );
  }
}

class ExperienceTile extends StatefulWidget {
  final Experience exp;
  final int index;
  final bool isLast;

  const ExperienceTile({
    super.key,
    required this.exp,
    required this.index,
    required this.isLast,
  });

  @override
  State<ExperienceTile> createState() => _ExperienceTileState();
}

class _ExperienceTileState extends State<ExperienceTile>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    final delay = Duration(milliseconds: 80 + widget.index * 90);
    Future.delayed(delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  void _toggleExpanded() {
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 800;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 420),
      opacity: _visible ? 1.0 : 0.0,
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : const Offset(0, 0.06),
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOut,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: isLargeScreen ? 85 : 72,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 6),
                    _buildDot(isLargeScreen),
                    if (!widget.isLast)
                      Container(
                        width: isLargeScreen ? 3 : 2,
                        height: isLargeScreen ? 140 : 120,
                        margin: const EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              CyberpunkColors.mediumGray.withOpacity(0.6),
                              CyberpunkColors.mediumGray.withOpacity(0.15),
                            ],
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 12),
                  ],
                ),
              ),
              Expanded(child: _buildCard(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(bool isLargeScreen) {
    final dotSize = isLargeScreen ? 16.0 : 14.0;
    final innerDotSize = isLargeScreen ? 7.0 : 6.0;

    return Container(
      width: dotSize,
      height: dotSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            CyberpunkColors.primaryOrange,
            CyberpunkColors.glowYellow.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: CyberpunkColors.primaryOrange.withOpacity(0.32),
            blurRadius: 12,
            spreadRadius: 1,
          ),
          const BoxShadow(
            color: Colors.black54,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.06), width: 1),
      ),
      child: Center(
        child: Container(
          width: innerDotSize,
          height: innerDotSize,
          decoration: const BoxDecoration(
            color: CyberpunkColors.deepBlack,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 800;
    final isTablet = screenSize.width > 600 && screenSize.width <= 1200;

    final titleFontSize = isLargeScreen ? 18.0 : (isTablet ? 16.0 : 15.0);
    final roleFontSize = isLargeScreen ? 16.0 : (isTablet ? 15.0 : 14.0);
    final periodFontSize = isLargeScreen ? 14.0 : (isTablet ? 13.0 : 12.0);
    final bulletFontSize = isLargeScreen ? 15.0 : (isTablet ? 14.0 : 13.0);
    final maxBulletsHeight = math.min(
      isLargeScreen ? 450.0 : 350.0,
      screenSize.height * (isLargeScreen ? 0.5 : 0.45),
    );

    return GestureDetector(
      onTap: _toggleExpanded,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: CyberpunkColors.charcoalGray,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _expanded
                ? CyberpunkColors.primaryOrange.withOpacity(0.9)
                : CyberpunkColors.mediumGray.withOpacity(0.4),
            width: _expanded ? 2.2 : 1.0,
          ),
          boxShadow: [
            const BoxShadow(
              color: Colors.black87,
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
            if (_expanded)
              BoxShadow(
                color: CyberpunkColors.primaryOrange.withOpacity(0.06),
                blurRadius: 18,
                spreadRadius: 2,
              ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.exp.company,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: titleFontSize,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.exp.role,
                        style: TextStyle(
                          color: CyberpunkColors.primaryOrange,
                          fontWeight: FontWeight.w600,
                          fontSize: roleFontSize,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.exp.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.exp.subtitle!,
                          style: TextStyle(
                            color: CyberpunkColors.screenTeal,
                            fontSize: periodFontSize,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.exp.period,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: periodFontSize,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _buildExpandIcon(isLargeScreen),
                  ],
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: _expanded
                  ? Container(
                      constraints: BoxConstraints(maxHeight: maxBulletsHeight),
                      margin: const EdgeInsets.only(top: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: widget.exp.bullets.map((b) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 6),
                                    width: isLargeScreen ? 10 : 8,
                                    height: isLargeScreen ? 10 : 8,
                                    decoration: const BoxDecoration(
                                      color: CyberpunkColors.terminalGreen,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: isLargeScreen ? 12 : 10),
                                  Expanded(
                                    child: Text(
                                      b,
                                      style: TextStyle(
                                        color: Colors.white70,
                                        height: 1.35,
                                        fontSize: bulletFontSize,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandIcon(bool isLargeScreen) {
    return AnimatedRotation(
      turns: _expanded ? 0.5 : 0.0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Icon(
        Icons.expand_more,
        color: Colors.white70,
        size: isLargeScreen ? 26.0 : 22.0,
      ),
    );
  }
}

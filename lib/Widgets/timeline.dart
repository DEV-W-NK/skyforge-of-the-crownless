// lib/widgets/timeline.dart
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:portifolio/Models/resume_models.dart';
import 'package:portifolio/Theme/ds3_pallet.dart';

class ExperienceTimeline extends StatelessWidget {
  final List<Experience> experiences;

  ExperienceTimeline({required this.experiences});

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          experiences.asMap().entries.map((entry) {
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
    Key? key,
    required this.exp,
    required this.index,
    required this.isLast,
  }) : super(key: key);

  @override
  _ExperienceTileState createState() => _ExperienceTileState();
}

class _ExperienceTileState extends State<ExperienceTile>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    // Staggered entrance: cada tile espera um pouco baseado no index
    final delay = Duration(milliseconds: 80 + widget.index * 90);
    Future.delayed(delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  void _toggleExpanded() {
    setState(() => _expanded = !_expanded);
    // Haptic feedback leve quando expandir/colapsar
    // Importar: import 'package:flutter/services.dart'; se quiser haptics
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 420),
      opacity: _visible ? 1.0 : 0.0,
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: _visible ? Offset(0, 0) : Offset(0, 0.06),
        duration: Duration(milliseconds: 420),
        curve: Curves.easeOut,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // coluna da timeline (dot + linha) - FIXED: removed IntrinsicHeight
              SizedBox(
                width: 72,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // ADDED: prevent expansion
                  children: [
                    SizedBox(height: 6),
                    _buildDot(),
                    if (!widget.isLast)
                      Container(
                        width: 2,
                        height:
                            120, // FIXED: explicit height instead of Flexible
                        margin: EdgeInsets.only(top: 8),
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
                      SizedBox(height: 12),
                  ],
                ),
              ),

              // conteúdo principal
              Expanded(child: _buildCard(context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 14,
      height: 14,
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
          BoxShadow(color: Colors.black54, blurRadius: 6, offset: Offset(0, 2)),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.06), width: 1),
      ),
      child: Center(
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: CyberpunkColors.deepBlack,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    // limite máximo para a área de bullets quando expandido
    final double maxBulletsHeight = math.min(
      220.0,
      MediaQuery.of(context).size.height * 0.32,
    );

    return GestureDetector(
      onTap: _toggleExpanded,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 360),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: CyberpunkColors.charcoalGray,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                _expanded
                    ? CyberpunkColors.primaryOrange.withOpacity(0.9)
                    : CyberpunkColors.mediumGray.withOpacity(0.4),
            width: _expanded ? 2.2 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
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
        padding: EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min, // IMPORTANT: prevent expansion
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // header (empresa + período + chevron) - FIXED structure
            Row(
              children: [
                Expanded(
                  // FIXED: use Expanded instead of Flexible
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min, // ADDED
                    children: [
                      Text(
                        widget.exp.company,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        maxLines: 2, // ADDED: prevent overflow
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6),
                      Text(
                        widget.exp.role,
                        style: TextStyle(
                          color: CyberpunkColors.primaryOrange,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2, // ADDED: prevent overflow
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8), // ADDED: spacing
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min, // ADDED
                  children: [
                    Text(
                      widget.exp.period,
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    SizedBox(height: 6),
                    _buildExpandIcon(),
                  ],
                ),
              ],
            ),

            // bullets animados (expansível) - FIXED AnimatedSize usage
            AnimatedSize(
              duration: Duration(milliseconds: 280),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child:
                  _expanded
                      ? Container(
                        constraints: BoxConstraints(
                          maxHeight: maxBulletsHeight,
                        ),
                        margin: EdgeInsets.only(top: 10), // MOVED margin here
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min, // ADDED
                            children:
                                widget.exp.bullets.map((b) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6.0,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 6),
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color:
                                                CyberpunkColors.terminalGreen,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            b,
                                            style: TextStyle(
                                              color: Colors.white70,
                                              height: 1.35,
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
                      : SizedBox.shrink(), // SIMPLIFIED: removed unnecessary ConstrainedBox
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandIcon() {
    return AnimatedRotation(
      turns: _expanded ? 0.5 : 0.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Icon(Icons.expand_more, color: Colors.white70, size: 22),
    );
  }
}
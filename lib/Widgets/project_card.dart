// lib/widgets/project_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portifolio/Models/resume_models.dart';
import 'package:portifolio/Theme/ds3_pallet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math' as math;
import 'package:visibility_detector/visibility_detector.dart';

class ProjectCard extends StatelessWidget {
  final Project project;
  final double? width;

  ProjectCard({required this.project, this.width});

  IconData _getProjectIcon() {
    final tech =
        project.tech.isNotEmpty ? project.tech.first.toLowerCase() : '';
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

    // Define tamanhos fixos para os cards
    final double cardWidth = width ?? (isMobile ? 340 : 320);
    final double cardHeight = isMobile ? 220 : 210;

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Container(
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
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
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
                            project.title,
                            style: TextStyle(
                              color: CyberpunkColors.primaryOrange,
                              fontSize: isMobile ? 16 : 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            project.subtitle,
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
                ),
                SizedBox(height: 16),
                // Tech stack
                if (project.tech.isNotEmpty)
                  Wrap(
                    spacing: isMobile ? 6 : 8,
                    runSpacing: 4,
                    children: project.tech.take(isMobile ? 3 : 4).map((tech) {
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
                  ),
                SizedBox(height: 16),
                // Bullets (primeiros 2)
                if (project.bullets != null && project.bullets!.isNotEmpty)
                  ...project.bullets!.take(2).map((b) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 6),
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                color: CyberpunkColors.terminalGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                b,
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: isMobile ? 12 : 13,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                // Botão de ação
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (project.url != null && project.url!.isNotEmpty) {
                            _openLink(context, project.url!);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('URL não disponível')),
                            );
                          }
                        },
                        icon: Icon(Icons.launch, size: 16),
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
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
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
  }

  Future<void> _openLink(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('URL inválida')),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao abrir o link: $e')),
      );
    }
  }
}
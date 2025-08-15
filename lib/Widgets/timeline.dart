import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:portifolio/Models/resume_models.dart';
import 'package:portifolio/Theme/ds3_pallet.dart';

class ExperienceTimeline extends StatelessWidget {
  final List<Experience> experiences = [
    Experience(
      company: "Enebras Engenharia",
      role: "Desenvolvedor FullStack (PJ)",
      period: "Março 2025 – Atual",
      bullets: [
        // Desenvolvimento Mobile e Integração
        "Implementação de sistema de geolocalização avançado com Google Maps API, incluindo geofencing automático e rastreamento de presença em tempo real",
        "Desenvolvimento de aplicações Flutter multiplataforma com interface responsiva e componentes customizados para diferentes tamanhos de tela",
        "Criação de sistema de cache offline inteligente usando SQLite local para garantir funcionamento sem conectividade, com sincronização automática quando online",
        "Otimização de performance mobile implementando WorkManager para tarefas em background e gerenciamento eficiente de bateria",
        
        // Backend e APIs
        "Desenvolvimento de APIs RESTful robustas em Node.js com Express.js para integração entre sistemas mobile e web",
        "Implementação de Firebase Cloud Functions para processamento serverless de dados e automação de workflows",
        "Criação de sistema de autenticação seguro usando Firebase Auth com OAuth e controle de permissões por níveis de usuário",
        "Desenvolvimento de endpoints especializados para importação e processamento de dados de folha de pagamento em formato CSV",
        
        // IoT e Sistemas de Monitoramento
        "Arquitetura e implementação de comunicação MQTT para conectar dispositivos ESP32 com sistema central de monitoramento",
        "Desenvolvimento de firmware em C++ para microcontroladores ESP32, incluindo algoritmos de calibração de sensores ambientais",
        "Criação de sistema de monitoramento 24/7 com alta disponibilidade, incluindo alertas automáticos e dashboard em tempo real",
        "Implementação de protocolos de comunicação serial e integração IoT com processamento de dados de sensores DHT22 e PMS5003",
        
        // Automação e Relatórios
        "Desenvolvimento de sistema automatizado de cálculo de custos com distribuição proporcional e geração de relatórios financeiros detalhados",
        "Criação de dashboards interativos com visualizações gráficas usando bibliotecas de chart em Flutter",
        "Implementação de geração automática de PDFs com templates customizados e dados dinâmicos",
        "Automação de processos manuais que reduziram tempo de trabalho de horas para minutos através de algoritmos eficientes",
      ],
    ),
    Experience(
      company: "Enebras Engenharia",
      role: "Desenvolvedor de Sistemas - Junior",
      period: "Agosto 2024 – Março 2025",
      bullets: [
        // Desenvolvimento de Interfaces e UX
        "Criação de interfaces Flutter modernas com componentes reutilizáveis e design system consistente",
        "Implementação de mapas interativos com Google Maps API, incluindo marcadores personalizados e controles de navegação",
        "Desenvolvimento de gráficos interativos para visualização de dados em tempo real com animações suaves",
        "Design e implementação de sistema de navegação intuitivo com feedback visual e animações de transição",
        
        // Integração e Comunicação de Dados
        "Implementação de comunicação MQTT bidirecional para controle remoto de dispositivos IoT com confirmação de entrega",
        "Desenvolvimento de sistema de sincronização offline com estratégias de conflito e merge inteligente de dados",
        "Criação de sistema de notificações push integrado com Firebase Cloud Messaging para alertas em tempo real",
        "Implementação de WebSockets para comunicação em tempo real entre aplicativo mobile e servidor",
        
        // Performance e Otimização
        "Otimização avançada de bateria implementando algoritmos inteligentes de gerenciamento de energia em dispositivos mobile",
        "Desenvolvimento de estratégias de cache multinível (memória, disco, rede) para melhor performance",
        "Implementação de lazy loading e paginação para listas grandes com milhares de registros",
        "Criação de sistema de compressão de dados para otimizar tráfego de rede em conexões lentas",
        
        // Backend e Processamento
        "Desenvolvimento de Firebase Cloud Functions para processamento assíncrono de dados com retry automático",
        "Implementação de sistema de backup automático com versionamento e recuperação point-in-time",
        "Criação de jobs programados para limpeza de dados, agregações e manutenção automática do sistema",
        "Desenvolvimento de middleware customizado para validação de dados e tratamento de erros",
        
        // Qualidade e Manutenibilidade
        "Implementação de testes unitários e de integração com cobertura superior a 80% do código",
        "Criação de documentação técnica detalhada incluindo diagramas de arquitetura e guias de API",
        "Estabelecimento de code review e padrões de desenvolvimento para manter qualidade do código",
        "Implementação de logging estruturado e monitoramento de performance para debugging eficiente",
        
        // Destaque da promoção
        "Promoção para regime PJ devido ao excelente desempenho e entregas consistentes de alta qualidade",
      ],
    ),
  ];

  ExperienceTimeline({required List<Experience> experiences});

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
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 800;
    
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
                width: isLargeScreen ? 85 : 72,
                child: Column(
                  mainAxisSize: MainAxisSize.min, // ADDED: prevent expansion
                  children: [
                    SizedBox(height: 6),
                    _buildDot(),
                    if (!widget.isLast)
                      Container(
                        width: isLargeScreen ? 3 : 2,
                        height: isLargeScreen ? 140 : 120,
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
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 800;
    
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
          BoxShadow(color: Colors.black54, blurRadius: 6, offset: Offset(0, 2)),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.06), width: 1),
      ),
      child: Center(
        child: Container(
          width: innerDotSize,
          height: innerDotSize,
          decoration: BoxDecoration(
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
    
    // Tamanhos de fonte responsivos
    final titleFontSize = isLargeScreen ? 18.0 : (isTablet ? 16.0 : 15.0);
    final roleFontSize = isLargeScreen ? 16.0 : (isTablet ? 15.0 : 14.0);
    final periodFontSize = isLargeScreen ? 14.0 : (isTablet ? 13.0 : 12.0);
    final bulletFontSize = isLargeScreen ? 15.0 : (isTablet ? 14.0 : 13.0);
    
    // limite máximo para a área de bullets quando expandido
    final double maxBulletsHeight = math.min(
      isLargeScreen ? 450.0 : 350.0,
      screenSize.height * (isLargeScreen ? 0.5 : 0.45),
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
            color: _expanded
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
                          fontSize: titleFontSize,
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
                          fontSize: roleFontSize,
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
                      style: TextStyle(
                        color: Colors.white70, 
                        fontSize: periodFontSize,
                      ),
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
              child: _expanded
                  ? Container(
                      constraints: BoxConstraints(
                        maxHeight: maxBulletsHeight,
                      ),
                      margin: EdgeInsets.only(top: 10), // MOVED margin here
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min, // ADDED
                          children: widget.exp.bullets.map((b) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6.0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 6),
                                    width: isLargeScreen ? 10 : 8,
                                    height: isLargeScreen ? 10 : 8,
                                    decoration: BoxDecoration(
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
                  : SizedBox.shrink(), // SIMPLIFIED: removed unnecessary ConstrainedBox
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandIcon() {
    final screenSize = MediaQuery.of(context).size;
    final isLargeScreen = screenSize.width > 800;
    final iconSize = isLargeScreen ? 26.0 : 22.0;
    
    return AnimatedRotation(
      turns: _expanded ? 0.5 : 0.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Icon(Icons.expand_more, color: Colors.white70, size: iconSize),
    );
  }
}
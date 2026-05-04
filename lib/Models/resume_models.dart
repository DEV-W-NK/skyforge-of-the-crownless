// lib/models/resume_models.dart

class Profile {
  final String fullName;
  final String title;
  final String location;
  final String email;
  final String phone;
  final String linkedin;
  final String github;
  final String? languages;
  final String? availability;

  Profile({
    required this.fullName,
    required this.title,
    required this.location,
    required this.email,
    required this.phone,
    required this.linkedin,
    required this.github,
    this.languages,
    this.availability,
  });
}

class Experience {
  final String company;
  final String role;
  final String period;
  final String? subtitle;
  final List<String> bullets;

  Experience({
    required this.company,
    required this.role,
    required this.period,
    this.subtitle,
    required this.bullets,
  });
}

class Project {
  final String title;
  final String subtitle;
  final List<String> tech;
  final String? url;
  final List<String>? bullets;

  Project({
    required this.title,
    required this.subtitle,
    required this.tech,
    this.url,
    this.bullets,
  });
}

final profile = Profile(
  fullName: 'Guilherme Leonardo de Barros',
  title: 'Engenheiro de Software | Mobile Multiplataforma | Full Stack',
  location: 'São Paulo, SP - Brasil',
  email: 'guileobarros@gmail.com',
  phone: '+55 (11) 91346-7227',
  linkedin: 'https://linkedin.com/in/devw-nk',
  github: 'https://github.com/DEV-W-NK',
  languages: 'Português (Nativo), Inglês (Avançado B2)',
  availability: 'PJ ou CLT - remoto, presencial ou híbrido',
);

const professionalSummary =
    'Engenheiro de Software e Desenvolvedor Mobile Multiplataforma focado na construção de aplicações escaláveis, integração full stack e arquitetura modular. Especialista em Flutter, .NET MAUI, Clean Architecture, MVVM, modelagem relacional e NoSQL com PostgreSQL, SQL Server, MySQL, SQLiteupabase e Firebase. Experiência na criação de ERPs comerciais, sistemas de alta performance, APIs RESTful e soluções com IA aplicada para análise operacional, predição estatística e recuperação de receita.';

const coreSkills = [
  'Dart',
  'Flutter',
  'C#',
  '.NET MAUI',
  'Java',
  'Android SDK',
  'C++',
  'TypeScript',
  'JavaScript',
  'SQL',
  'Python',
  'Clean Architecture',
  'MVVM',
  'MobX',
  'Provider',
  'Riverpod',
  'Bloc',
  'Supabase',
  'PostgreSQL',
  'Firebase',
  'MySQL',
  'SQL Server',
  'SQLite',
  'Node.js',
  'REST APIs',
  'GitHub Actions',
  'Google Cloud',
  'MQTT',
  'Gemini API',
  'SkiaSharp',
  'Firebase Cloud Messaging',
];

final experiences = [
  Experience(
    company: 'Interação',
    role: 'Desenvolvedor Mobile',
    period: 'Set 2025 - Atual',
    subtitle: 'Intera Expo, Intera Hub, Expo API e Hub API',
    bullets: [
      'Co-desenvolvimento dos aplicativos InteraExpo e EasyExpo em .NET MAUI/C#, estruturados com MVVM, injeção de dependência, navegação modular e camada de serviços desacoplada.',
      'Implementação de persistência offline-first com SQLite, SecureStorage e Preferences para sessão, notificações, perfil, formulários, captura de leads e continuidade operacional em conectividade instável.',
      'Desenvolvimento do fluxo de leitura de QR Code com parsing estruturado, obfuscação e decodificação local, questionário dinâmico persistido, fila de sincronização de pendências e exportação analítica em Excel.',
      'Implementação de restore de sessão, login biométrico, controle de logout intencional, sincronização de token FCM e tratamento robusto de falhas de API e ciclo de vida Android.',
      'Otimização de uploads com compressão e correção de orientação EXIF via SkiaSharp, paginação incremental no feed, cache defensivo de imagens, upload multipart e moderação de conteúdo.',
      'Desenvolvimento de serviço antifraude geográfica com geofence poligonal, detecção de mock GPS e validação de consistência entre GPS e IP no aplicativo do visitante.',
    ],
  ),
  Experience(
    company: 'Enebras Engenharia',
    role: 'Engenheiro de Software (Reporte direto ao CEO)',
    period: 'Ago 2024 - Ago 2025',
    subtitle: 'ERP interno, automação operacional, APIs e IoT',
    bullets: [
      'Arquitetura e criação do Sistema Integrado Enebras, estancando perdas anuais estimadas em R\$ 2 milhões em folha e R\$ 4 milhões em extravio de materiais.',
      'Redução do ciclo de fechamento financeiro de 190 horas para 40 minutos mensais por meio de automação de cruzamento de dados e integração com APIs RESTful legadas.',
      'Liderança da engenharia de sistema IoT de monitoramento ambiental apadrinhado pelo Hospital Israelita Albert Einstein, com arquitetura otimizada para custo de nuvem de R\$ 0,06 por equipamento/mês.',
      'Desenvolvimento de interfaces Flutter, dashboards operacionais, relatórios automatizados, rotinas de integração e backend para suporte a processos críticos de negócio.',
    ],
  ),
];

final projects = [
  Project(
    title: 'Granith ERP',
    subtitle: 'Gestão empresarial comercial',
    tech: ['Flutter', 'Supabase', 'Provider', 'PostgreSQL'],
    url: '',
    bullets: [
      'ERP comercial em Flutter para gestão de obras, projetos, orçamentos, compras, estoque, financeiro, RH, fornecedores, equipes e diário de obra.',
      'Arquitetura modular com Provider, ChangeNotifier, ViewModels, controllers e camada de serviços para reduzir acoplamento e facilitar evolução.',
      'Fluxos integrados entre requisição de materiais, compras, movimentação de estoque, lançamentos financeiros e atualização de custos por projeto.',
      'Migração da persistência de Firebase/Firestore para Supabase/PostgreSQL para ganhar modelagem relacional, consistência e escalabilidade.',
      'Produto próprio com roadmap ativo para aplicativo do colaborador, portal do cliente e expansão incremental de módulos comerciais.',
    ],
  ),
  Project(
    title: 'HardPoint',
    subtitle: 'E-commerce, analytics e IA operacional',
    tech: ['Flutter', 'Firebase Auth', 'Supabase', 'Gemini API'],
    url: '',
    bullets: [
      'Aplicação Flutter full stack com 9 módulos funcionais em Clean Architecture por feature, separando presentation, domain e data.',
      'Integração híbrida entre Firebase Auth, Google Sign-In e Supabase/PostgreSQL com sincronização de identidade e dados em tempo real no painel administrativo.',
      'Dashboard executivo com KPIs de receita, despesas, lucro líquido, ticket médio, satisfação do cliente, estoque crítico e produtos mais vendidos.',
      'Uso da Google Gemini API com grounding em schema, KPIs e snapshots do banco para gerar insights estratégicos e responder perguntas operacionais.',
      'Modelo de predição de receita com regressão linear sobre histórico semanal de vendas, classificação de tendência e apoio à tomada de decisão.',
    ],
  ),
  Project(
    title: 'InteraExpo, EasyExpo e ExpoRevestir',
    subtitle: 'Ecossistema mobile para eventos',
    tech: ['.NET MAUI', 'C#', 'SQLite', 'SkiaSharp'],
    url: '',
    bullets: [
      'Coautoria de apps nativos para jornadas de expositor e visitante com MVVM, injeção de dependência e persistência local offline-first.',
      'Captura de leads via QR Code com parsing estruturado, descriptografia local e fila de sincronização resiliente para operação sem internet.',
      'Serviço antifraude geográfica com geofence poligonal, detecção de mock GPS e validação combinada de GPS e IP.',
      'Uploads de mídia otimizados com compressão, correção de orientação EXIF via SkiaSharp, cache defensivo de imagens e paginação incremental.',
    ],
  ),
  Project(
    title: 'RedeSocialExpositor',
    subtitle: 'Feed social, mídia e moderação',
    tech: ['.NET MAUI', 'C#', 'SkiaSharp', 'REST APIs'],
    url: '',
    bullets: [
      'Experiência social nativa para expositores com feed paginado, upload multipart, cache defensivo de imagens e moderação de conteúdo.',
      'Pipeline de mídia com compressão, correção de orientação EXIF e tratamento de falhas para reduzir erros de publicação em dispositivos Android.',
      'Integração com camada de serviços desacoplada e APIs RESTful para manter o feed responsivo e resiliente em cenários de conexão instável.',
    ],
  ),
  Project(
    title: 'EasyExpoAPI',
    subtitle: 'Serviços e sincronização para eventos',
    tech: ['C#', 'REST APIs', 'SQLite', 'FCM'],
    url: '',
    bullets: [
      'Integração de serviços para autenticação, sessão, notificações, perfil, captura de leads, formulários e sincronização de pendências.',
      'Tratamento robusto de falhas de API, restore de sessão, controle de logout intencional e sincronização de tokens Firebase Cloud Messaging.',
      'Suporte a exportação analítica em Excel e consistência operacional entre banco local SQLite e serviços remotos.',
    ],
  ),
  Project(
    title: 'Sistema Integrado Enebras',
    subtitle: 'Sistema de Auditoria Interno, automação financeira e controle operacional',
    tech: ['Flutter', 'Node.js', 'REST APIs', 'Firebase'],
    url: '',
    bullets: [
      'Sistema integrado para controle financeiro, folha, materiais e relatórios operacionais, criado para atacar perdas relevantes de receita.',
      'Automação do fechamento financeiro mensal, reduzindo um ciclo manual de 190 horas para 40 minutos com cruzamento de dados e integrações legadas.',
      'Dashboards e relatórios para acompanhamento executivo, análise de custos e rastreabilidade de processos críticos.',
    ],
  ),
  Project(
    title: 'Sistema IoT Vaccs',
    subtitle: 'Monitoramento ambiental institucional',
    tech: ['C++', 'ESP32', 'MQTT', 'Node.js'],
    url: '',
    bullets: [
      'Firmware Edge Computing com lógica de self-healing, buffers locais e preservação de integridade em períodos offline.',
      'Gateway em Node.js para ingestão, gerenciamento de conexões MQTT em larga escala e integração com camada de monitoramento.',
      'Arquitetura de baixo custo operacional para telemetria ambiental contínua em equipamentos distribuídos.',
    ],
  ),
];

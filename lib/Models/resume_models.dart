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
  location: 'Sao Paulo, SP - Brasil',
  email: 'guileobarros@gmail.com',
  phone: '+55 (11) 91346-7227',
  linkedin: 'https://linkedin.com/in/devw-nk',
  github: 'https://github.com/DEV-W-NK',
  languages: 'Portugues (Nativo), Ingles (Avancado B2)',
  availability: 'PJ ou CLT - remoto, presencial ou hibrido',
);

const professionalSummary =
    'Engenheiro de Software e Desenvolvedor Mobile Multiplataforma focado em produtos operacionais reais. Hoje o principal destaque e o Granith: um ERP web em Flutter integrado a um app Android de campo, com Supabase/PostgreSQL, Firebase Cloud Messaging, Google Maps, sincronismo offline, rotas, geofence, portal do cliente e IA local para apoio operacional. Tambem atuo com .NET MAUI, Clean Architecture, MVVM, APIs RESTful, automacao financeira, IoT e sistemas de alta confiabilidade.';

const coreSkills = [
  'Dart',
  'Flutter',
  'Flutter Web',
  'Android SDK',
  'C#',
  '.NET MAUI',
  'Java',
  'C++',
  'TypeScript',
  'JavaScript',
  'SQL',
  'Python',
  'Clean Architecture',
  'MVVM',
  'Provider',
  'Riverpod',
  'Bloc',
  'Supabase',
  'PostgreSQL',
  'Firebase',
  'Firebase Cloud Messaging',
  'Google Maps',
  'SQLite',
  'Node.js',
  'REST APIs',
  'GitHub Actions',
  'Google Cloud',
  'MQTT',
  'Gemini API',
  'SLM local',
  'SkiaSharp',
];

final experiences = [
  Experience(
    company: 'Interacao',
    role: 'Desenvolvedor Mobile',
    period: 'Set 2025 - Atual',
    subtitle: 'Intera Expo, Intera Hub, Expo API e Hub API',
    bullets: [
      'Co-desenvolvimento dos aplicativos InteraExpo e EasyExpo em .NET MAUI/C#, estruturados com MVVM, injecao de dependencia, navegacao modular e camada de servicos desacoplada.',
      'Implementacao de persistencia offline-first com SQLite, SecureStorage e Preferences para sessao, notificacoes, perfil, formularios, captura de leads e continuidade operacional em conectividade instavel.',
      'Desenvolvimento do fluxo de leitura de QR Code com parsing estruturado, decodificacao local, questionario dinamico persistido, fila de sincronizacao de pendencias e exportacao analitica em Excel.',
      'Implementacao de restore de sessao, login biometrico, controle de logout intencional, sincronizacao de token FCM e tratamento robusto de falhas de API e ciclo de vida Android.',
      'Otimizacao de uploads com compressao e correcao de orientacao EXIF via SkiaSharp, paginacao incremental no feed, cache defensivo de imagens, upload multipart e moderacao de conteudo.',
      'Desenvolvimento de servico antifraude geografica com geofence poligonal, deteccao de mock GPS e validacao de consistencia entre GPS e IP no aplicativo do visitante.',
    ],
  ),
  Experience(
    company: 'Enebras Engenharia',
    role: 'Engenheiro de Software (Reporte direto ao CEO)',
    period: 'Ago 2024 - Ago 2025',
    subtitle: 'ERP interno, automacao operacional, APIs e IoT',
    bullets: [
      'Arquitetura e criacao do Sistema Integrado Enebras, estancando perdas anuais estimadas em R\$ 2 milhoes em folha e R\$ 4 milhoes em extravio de materiais.',
      'Reducao do ciclo de fechamento financeiro de 190 horas para 40 minutos mensais por meio de automacao de cruzamento de dados e integracao com APIs RESTful legadas.',
      'Lideranca da engenharia de sistema IoT de monitoramento ambiental apadrinhado pelo Hospital Israelita Albert Einstein, com arquitetura otimizada para custo de nuvem de R\$ 0,06 por equipamento/mes.',
      'Desenvolvimento de interfaces Flutter, dashboards operacionais, relatorios automatizados, rotinas de integracao e backend para suporte a processos criticos de negocio.',
    ],
  ),
];

final projects = [
  Project(
    title: 'Granith ERP Web',
    subtitle: 'ERP em Flutter Web para gestao operacional e financeira',
    tech: ['Flutter Web', 'Supabase', 'Provider', 'PostgreSQL'],
    url: 'https://github.com/DEV-W-NK/Granith-ERP',
    bullets: [
      'ERP comercial em Flutter para obras, projetos, orcamentos, compras, estoque, financeiro, RH, fornecedores, equipes, diario de obra e portal do cliente.',
      'Arquitetura modular com Provider, ChangeNotifier, ViewModels, controllers e camada de servicos para reduzir acoplamento e facilitar evolucao.',
      'Fluxos integrados entre requisicao de materiais, compras, movimentacao de estoque, lancamentos financeiros, medicoes, custos por projeto e notificacoes.',
      'Migracao de persistencia para Supabase/PostgreSQL, com migrations, RLS, edge functions, CI/CD, Firebase Hosting e integracao com FCM.',
      'Identidade visual propria em grafite e dourado, com dashboard web, permissoes, usuarios internos e experiencia focada em uso operacional real.',
    ],
  ),
  Project(
    title: 'Granith Mobile',
    subtitle: 'App Android de campo conectado ao Granith ERP',
    tech: ['Flutter', 'Android', 'Google Maps', 'SQLite'],
    url: 'https://github.com/DEV-W-NK/Granith-Mobile',
    bullets: [
      'Aplicativo Android para funcionarios de campo, motoristas e equipes vinculadas a obras, com rotas, geofence, ponto, checklist, ocorrencias e notificacoes.',
      'Sincronismo offline-first com SQLite local e Supabase, incluindo rotas, checkpoints, evidencias, fotos, assinatura, KM real e atualizacoes vindas do ERP.',
      'Integracao com Firebase Cloud Messaging para notificacoes em primeiro e segundo plano, armazenamento local das mensagens e background sync.',
      'Navegacao de rotas com Google Maps, controle de GPS, cerca geografica e preparo para operacao de motorista no app em vez do ERP.',
      'IA local com flutter_gemma para assistente de campo, diario de obra, ocorrencias e resumo de rota sem depender sempre de rede.',
    ],
  ),
  Project(
    title: 'HardPoint',
    subtitle: 'E-commerce, analytics e IA operacional',
    tech: ['Flutter', 'Firebase Auth', 'Supabase', 'Gemini API'],
    url: '',
    bullets: [
      'Aplicacao Flutter full stack com 9 modulos funcionais em Clean Architecture por feature, separando presentation, domain e data.',
      'Integracao hibrida entre Firebase Auth, Google Sign-In e Supabase/PostgreSQL com sincronizacao de identidade e dados em tempo real no painel administrativo.',
      'Dashboard executivo com KPIs de receita, despesas, lucro liquido, ticket medio, satisfacao do cliente, estoque critico e produtos mais vendidos.',
      'Uso da Google Gemini API com grounding em schema, KPIs e snapshots do banco para gerar insights estrategicos e responder perguntas operacionais.',
      'Modelo de predicao de receita com regressao linear sobre historico semanal de vendas, classificacao de tendencia e apoio a tomada de decisao.',
    ],
  ),
  Project(
    title: 'InteraExpo, EasyExpo e ExpoRevestir',
    subtitle: 'Ecossistema mobile para eventos',
    tech: ['.NET MAUI', 'C#', 'SQLite', 'SkiaSharp'],
    url: '',
    bullets: [
      'Coautoria de apps nativos para jornadas de expositor e visitante com MVVM, injecao de dependencia e persistencia local offline-first.',
      'Captura de leads via QR Code com parsing estruturado, descriptografia local e fila de sincronizacao resiliente para operacao sem internet.',
      'Servico antifraude geografica com geofence poligonal, deteccao de mock GPS e validacao combinada de GPS e IP.',
      'Uploads de midia otimizados com compressao, correcao de orientacao EXIF via SkiaSharp, cache defensivo de imagens e paginacao incremental.',
    ],
  ),
  Project(
    title: 'RedeSocialExpositor',
    subtitle: 'Feed social, midia e moderacao',
    tech: ['.NET MAUI', 'C#', 'SkiaSharp', 'REST APIs'],
    url: '',
    bullets: [
      'Experiencia social nativa para expositores com feed paginado, upload multipart, cache defensivo de imagens e moderacao de conteudo.',
      'Pipeline de midia com compressao, correcao de orientacao EXIF e tratamento de falhas para reduzir erros de publicacao em dispositivos Android.',
      'Integracao com camada de servicos desacoplada e APIs RESTful para manter o feed responsivo e resiliente em cenarios de conexao instavel.',
    ],
  ),
  Project(
    title: 'EasyExpoAPI',
    subtitle: 'Servicos e sincronizacao para eventos',
    tech: ['C#', 'REST APIs', 'SQLite', 'FCM'],
    url: '',
    bullets: [
      'Integracao de servicos para autenticacao, sessao, notificacoes, perfil, captura de leads, formularios e sincronizacao de pendencias.',
      'Tratamento robusto de falhas de API, restore de sessao, controle de logout intencional e sincronizacao de tokens Firebase Cloud Messaging.',
      'Suporte a exportacao analitica em Excel e consistencia operacional entre banco local SQLite e servicos remotos.',
    ],
  ),
  Project(
    title: 'Sistema Integrado Enebras',
    subtitle: 'Auditoria interna, automacao financeira e controle operacional',
    tech: ['Flutter', 'Node.js', 'REST APIs', 'Firebase'],
    url: '',
    bullets: [
      'Sistema integrado para controle financeiro, folha, materiais e relatorios operacionais, criado para atacar perdas relevantes de receita.',
      'Automacao do fechamento financeiro mensal, reduzindo um ciclo manual de 190 horas para 40 minutos com cruzamento de dados e integracoes legadas.',
      'Dashboards e relatorios para acompanhamento executivo, analise de custos e rastreabilidade de processos criticos.',
    ],
  ),
  Project(
    title: 'Sistema IoT Vaccs',
    subtitle: 'Monitoramento ambiental institucional',
    tech: ['C++', 'ESP32', 'MQTT', 'Node.js'],
    url: '',
    bullets: [
      'Firmware Edge Computing com logica de self-healing, buffers locais e preservacao de integridade em periodos offline.',
      'Gateway em Node.js para ingestao, gerenciamento de conexoes MQTT em larga escala e integracao com camada de monitoramento.',
      'Arquitetura de baixo custo operacional para telemetria ambiental continua em equipamentos distribuidos.',
    ],
  ),
];

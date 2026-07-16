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
    'Engenheiro de Software e Desenvolvedor Mobile Multiplataforma focado em produtos operacionais reais. Hoje o principal destaque é o Granith: um ERP web em Flutter integrado a um app Android de campo, com Supabase/PostgreSQL, Firebase Cloud Messaging, Google Maps, sincronismo offline, rotas, geofence, portal do cliente e IA local para apoio operacional. Também atuo com .NET MAUI, Clean Architecture, MVVM, APIs RESTful, automação financeira, IoT e sistemas de alta confiabilidade.';

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
      'Co-desenvolvimento dos aplicativos InteraExpo, rede social do expositor, e Intera Hub, rede social do visitante, em .NET MAUI/C#, com MVVM, SQLite local, APIs ASP.NET Core e camada de serviços desacoplada.',
      'Implementação de persistência offline-first com SQLite, SecureStorage e Preferences para sessão, notificações, perfil, formulários, captura de leads e continuidade operacional em conectividade instável.',
      'Desenvolvimento do fluxo de leitura de QR Code com parsing estruturado, decodificação local, questionário dinâmico persistido, fila de sincronização de pendências e exportação analítica em Excel.',
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
    title: 'Granith ERP Web',
    subtitle: 'ERP em Flutter Web para gestão operacional e financeira',
    tech: ['Flutter Web', 'Supabase', 'Provider', 'PostgreSQL'],
    url: 'https://github.com/DEV-W-NK/Granith-ERP',
    bullets: [
      'ERP comercial em Flutter para obras, projetos, orçamentos, compras, estoque, financeiro, RH, fornecedores, equipes, diário de obra e portal do cliente.',
      'Arquitetura modular com Provider, ChangeNotifier, ViewModels, controllers e camada de serviços para reduzir acoplamento e facilitar evolução.',
      'Fluxos integrados entre requisição de materiais, compras, movimentação de estoque, lançamentos financeiros, medições, custos por projeto e notificações.',
      'Migração de persistência para Supabase/PostgreSQL, com migrations, RLS, edge functions, CI/CD, Firebase Hosting e integração com FCM.',
      'Identidade visual própria em grafite e dourado, com dashboard web, permissões, usuários internos e experiência focada em uso operacional real.',
    ],
  ),
  Project(
    title: 'Granith Mobile',
    subtitle: 'App Android de campo conectado ao Granith ERP',
    tech: ['Flutter', 'Android', 'Google Maps', 'SQLite'],
    url: 'https://github.com/DEV-W-NK/Granith-Mobile',
    bullets: [
      'Aplicativo Android para funcionários de campo, motoristas e equipes vinculadas a obras, com rotas, geofence, ponto, checklist, ocorrências e notificações.',
      'Sincronismo offline-first com SQLite local e Supabase, incluindo rotas, checkpoints, evidências, fotos, assinatura, KM real e atualizações vindas do ERP.',
      'Integração com Firebase Cloud Messaging para notificações em primeiro e segundo plano, armazenamento local das mensagens e background sync.',
      'Navegação de rotas com Google Maps, controle de GPS, cerca geográfica e preparo para operação de motorista no app em vez do ERP.',
      'IA local com flutter_gemma para assistente de campo, diário de obra, ocorrências e resumo de rota sem depender sempre de rede.',
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
      'Modelo de predição de receita com regressão linear sobre histórico semanal de vendas, classificação de tendência e apoio a tomada de decisão.',
    ],
  ),
  Project(
    title: 'InteraExpo e Intera Hub',
    subtitle: 'Plataforma mobile para eventos corporativos',
    tech: ['.NET MAUI', 'ASP.NET Core', 'SQL Server', 'SQLite'],
    url: '',
    bullets: [
      'Evolução de uma plataforma mobile para eventos, feiras e exposições, composta pelo InteraExpo para expositores e pelo Intera Hub para visitantes.',
      'Arquitetura mobile em .NET MAUI/C# com MVVM, injeção de dependência, persistência local com SQLite e integração com APIs ASP.NET Core.',
      'Fluxos para feed social, networking, reuniões, expositores, notificações push, LGPD, autenticação com token e experiência offline em campo.',
      'Base preparada para múltiplos idiomas, tema claro/escuro e operação em eventos com conectividade instável.',
    ],
  ),
  Project(
    title: 'InteraExpo - Rede Social Expositor',
    subtitle: 'Leads, agenda e operação offline',
    tech: ['.NET MAUI', 'C#', 'SQLite', 'REST APIs'],
    url: '',
    bullets: [
      'Aplicativo do expositor com coleta de leads via QR Code e código de barras, parsing estruturado, controle de chave de acesso e rastreabilidade por usuário e dispositivo.',
      'Funcionamento offline-first com persistência local, fila de sincronização automática, controle de status dos leads e continuidade operacional sem internet.',
      'Qualificação de leads com formulários personalizados, gestão de horários disponíveis e indisponíveis para reuniões e relatórios analíticos.',
      'Integração com APIs para sincronização de leads, agenda, reuniões e exportações operacionais.',
    ],
  ),
  Project(
    title: 'Intera Hub - Rede Social Visitante',
    subtitle: 'Networking, feed e mapa indoor offline',
    tech: ['.NET MAUI', 'FCM', 'SkiaSharp', 'OpenCV'],
    url: '',
    bullets: [
      'Aplicativo do visitante com programação do evento, feed social, posts com mídia, comentários, curtidas, denúncias, favoritos e busca de expositores.',
      'Solicitação e acompanhamento de reuniões com expositores, notificações push via Firebase e controle de sessão com token e refresh token.',
      'Mapa interativo offline com stands, pontos de interesse e rotas internas calculadas a partir de grafo de navegação.',
      'Pipeline de mapa indoor com extração de dados a partir de PDF/imagem usando Python, OpenCV e OCR para reduzir processamento no celular.',
    ],
  ),
  Project(
    title: 'APIs e Internacionalização para Eventos',
    subtitle: 'Back-end, LGPD, notificações e tradução',
    tech: ['ASP.NET Core', 'C#', 'SQL Server', 'Firebase'],
    url: '',
    bullets: [
      'APIs em ASP.NET Core para autenticação JWT, refresh token, usuários, eventos, feed, mídia, reuniões, notificações, mapa, leads, LGPD e módulos por evento.',
      'Estrutura de internacionalização com suporte a português, inglês e espanhol, combinando RESX no app, preferência persistida por usuário e endpoints de conteúdo traduzido.',
      'Motor local em Python para geração automática de traduções de textos institucionais armazenados no banco, com tratamento de encoding, BOM e caracteres especiais.',
      'Integração com Firebase Cloud Messaging para notificações segmentadas e base preparada para comunicação por idioma do usuário.',
    ],
  ),
  Project(
    title: 'Sistema Integrado Enebras',
    subtitle: 'Auditoria interna, automação financeira e controle operacional',
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

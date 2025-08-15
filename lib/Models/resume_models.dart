// lib/models/resume_models.dart

class Profile {
  final String fullName;
  final String title;
  final String location;
  final String email;
  final String phone;
  final String linkedin;
  final String github;
  final String? languages; // opcional
  final String? availability; // opcional

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
  title: 'Desenvolvedor FullStack - Android & Web',
  location: 'São Paulo, SP – Brasil',
  email: 'guileobarros@gmail.com',
  phone: '+55 (11) 91346-7227',
  linkedin: 'https://linkedin.com/in/devw-nk',
  github: 'https://github.com/DEV-W-NK',
  languages: 'Português (Nativo), Inglês (Avançado)',
  availability: 'PJ ou CLT - Remoto, Presencial ou Híbrido',
);

final experiences = [
  Experience(
    company: 'Enebras Engenharia',
    role: 'Desenvolvedor FullStack (PJ)',
    period: 'Março 2025 – Atual',
    subtitle: 'Apps mobile, APIs e IoT',
    bullets: [
      'Desenvolvimento de aplicações mobile com Flutter integradas ao Google Maps',
      'Criação de APIs Node.js para integração entre diferentes sistemas',
      'Implementação de sistema IoT com comunicação MQTT e monitoramento de sensores',
      'Desenvolvimento de funcionalidades para controle de custos e relatórios automatizados',
      'Participação no planejamento técnico e arquitetura de soluções',
    ],
  ),
  Experience(
    company: 'Enebras Engenharia',
    role: 'Desenvolvedor de Sistemas - Junior',
    period: 'Ago 2024 – Mar 2025',
    subtitle: 'Interfaces, gráficos e cloud functions',
    bullets: [
      'Desenvolvimento de interfaces Flutter com Google Maps, gráficos interativos e geração de PDFs',
      'Implementação de Firebase Cloud Functions para processamento de dados',
      'Integração MQTT para comunicação com dispositivos IoT',
      'Criação de sistema de monitoramento com otimização de bateria',
      'Desenvolvimento backend com Firebase e estratégias de cache',
      'Promoção para PJ devido ao bom desempenho e entregas consistentes',
    ],
  ),
];

final projects = [
  Project(
    title: 'Sistema de Controle de Acesso Mobile',
    subtitle: 'Java Android, Firebase, GPS',
    tech: ['Java', 'Firebase', 'Geofencing'],
    bullets: [
      'Controle de presença com geolocalização e geofencing',
      'Sincronização offline com cache local',
      'Serviços em background para funcionamento contínuo',
      'Otimização de bateria e gerenciamento inteligente de recursos',
      'Interface intuitiva com feedback em tempo real',
    ],
  ),
  Project(
    title: 'Plataforma de Gestão e Relatórios',
    subtitle: 'Flutter, Firebase, Node.js',
    tech: ['Flutter', 'Firestore', 'Node.js'],
    bullets: [
      'Controle de horas e geração de relatórios financeiros',
      'Interface responsiva para visualização de dados',
      'Cálculo automatizado de custos e rateios',
      'Integração com dados de folha de pagamento',
      'Dashboard com visualizações gráficas',
    ],
  ),
  Project(
    title: 'Sistema IoT de Monitoramento Ambiental',
    subtitle: 'ESP32, C++, MQTT, Firebase',
    tech: ['C++', 'ESP32', 'MQTT', 'Firebase'],
    bullets: [
      'Monitoramento de qualidade do ar em tempo real',
      'Uso de sensores DHT22 e PMS5003',
      'Firebase Functions para processamento de dados',
      'Interface web para visualização ao vivo',
      'Otimização de energia para funcionamento 24/7',
    ],
  ),
  Project(
    title: 'Assistente Inteligente de Gestão de Projetos',
    subtitle: 'Flutter, Gemini AI, Firebase, Google Calendar API',
    tech: ['Flutter', 'Gemini AI', 'Firebase', 'Google Calendar API'],
    bullets: [
      'Chatbot integrado para gestão automatizada de projetos',
      'Análise inteligente de complexidade e recursos necessários',
      'Sincronização automática com Google Calendar',
      'Criação e reagendamento de tarefas inteligentes',
      'Notificações personalizadas e lembretes contextuais',
    ],
  ),
];
// lib/models/resume_models.dart
class Profile {
  final String fullName;
  final String title;
  final String location;
  final String email;
  final String phone;
  final String linkedin;
  final String github;
  Profile({
    required this.fullName,
    required this.title,
    required this.location,
    required this.email,
    required this.phone,
    required this.linkedin,
    required this.github,
  });
}

class Experience {
  final String company;
  final String role;
  final String period;
  final String? subtitle; // novo campo (opcional)
  final List<String> bullets;

  Experience({
    required this.company,
    required this.role,
    required this.period,
    this.subtitle, // opcional
    required this.bullets,
  });
}

class Project {
  final String title;
  final String subtitle;
  final List<String> tech;
  final String? url;
  Project({required this.title, required this.subtitle, required this.tech, this.url});
}

final profile = Profile(
  fullName: 'Guilherme Leonardo de Barros',
  title: 'Desenvolvedor FullStack - Android & Web',
  location: 'São Paulo, SP – Brasil',
  email: 'guilherme.leonardo.barros@gmail.com',
  phone: '+55 (11) 91346-7227',
  linkedin: 'https://linkedin.com/in/devw-nk',
  github: 'https://github.com/DEV-W-NK',
);

final experiences = [
  Experience(
    company: 'Enebras Engenharia',
    role: 'Desenvolvedor FullStack (PJ)',
    period: 'Março 2025 – Atual',
    subtitle: 'Apps mobile e integração IoT', // opcional
    bullets: [
      'Desenvolvimento de aplicações mobile com Flutter integradas ao Google Maps',
      'APIs Node.js para integração entre sistemas',
      'Sistema IoT com MQTT e monitoramento de sensores'
    ],
  ),
  Experience(
    company: 'Enebras Engenharia',
    role: 'Desenvolvedor de Sistemas - Junior',
    period: 'Ago 2024 – Mar 2025',
    subtitle: 'Interfaces, gráficos e cloud functions',
    bullets: [
      'Interfaces Flutter com Google Maps, gráficos e geração de PDFs',
      'Firebase Cloud Functions e integração MQTT'
    ],
  ),
  // adicione mais se quiser...
];

final projects = [
  Project(
    title: 'Sistema de Controle de Acesso Mobile',
    subtitle: 'Java Android, Firebase, GPS',
    tech: ['Java', 'Firebase', 'Geofencing'],
  ),
  Project(
    title: 'Plataforma de Gestão e Relatórios',
    subtitle: 'Flutter, Firebase, Node.js',
    tech: ['Flutter', 'Firestore', 'Node.js'],
  ),
  Project(
    title: 'Sistema IoT de Monitoramento',
    subtitle: 'ESP32, C++, MQTT',
    tech: ['C++', 'ESP32', 'MQTT'],
  ),
  // Projeto pessoal etc...
];

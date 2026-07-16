# Skyforge of the Crownless

<p align="center">
  <strong>Portfólio Flutter Web de Guilherme Leonardo de Barros</strong><br />
  Engenharia de software, mobile multiplataforma, sistemas operacionais reais e produtos com identidade própria.
</p>

<p align="center">
  <a href="https://skyforge-of-the-crownless.web.app/">
    <img alt="Portfolio" src="https://img.shields.io/badge/Portfolio-online-E3B84A?style=for-the-badge&labelColor=080B0D" />
  </a>
  <a href="https://github.com/DEV-W-NK">
    <img alt="GitHub" src="https://img.shields.io/badge/GitHub-DEV--W--NK-111827?style=for-the-badge&logo=github" />
  </a>
  <a href="https://linkedin.com/in/devw-nk">
    <img alt="LinkedIn" src="https://img.shields.io/badge/LinkedIn-devw--nk-0A66C2?style=for-the-badge&logo=linkedin" />
  </a>
</p>

---

## Sobre o Projeto

**Skyforge of the Crownless** é o meu portfólio público, criado em Flutter Web para apresentar trajetória, projetos e capacidade de entrega em produtos reais.

O site foi reformulado para ter a mesma presença visual do ecossistema **Granith**: grafite, dourado metálico, contraste forte, animações sutis, cards densos e uma narrativa mais pessoal. A proposta não é ser apenas uma vitrine estética, mas mostrar como eu penso produto, arquitetura, operação, mobile, dados e integração ponta a ponta.

---

## Destaques

- Identidade visual própria inspirada no Granith, com linguagem grafite e dourado.
- Seção de história pessoal, explicando a origem da jornada na programação.
- Galeria com fotos pessoais para dar mais presença humana ao portfólio.
- Cards de projetos com contexto técnico, impacto e links externos.
- Destaque para **Granith ERP Web** e **Granith Mobile** como produto principal.
- Links oficiais de **InteraExpo** e **Intera Hub** na App Store e Google Play.
- Deploy automatizado no Firebase Hosting via GitHub Actions.

---

## Projetos em Evidência

### Granith ERP Web

ERP em Flutter Web para gestão operacional e financeira de obras, compras, estoque, equipes, portal do cliente, permissões, financeiro, DRE, notificações e integração com Supabase/PostgreSQL.

[Repositório](https://github.com/DEV-W-NK/Granith-ERP)

### Granith Mobile

Aplicativo Android de campo conectado ao Granith ERP, com rotas, geofence, ponto, checklist, evidências, notificações, sincronismo offline-first, Google Maps e IA local com `flutter_gemma`.

[Repositório](https://github.com/DEV-W-NK/Granith-Mobile)

### InteraExpo

Rede social do expositor para eventos corporativos, com leads via QR Code, operação offline, agenda, sincronização e relatórios.

[App Store](https://apps.apple.com/us/app/intera-expo/id6759558431) · [Google Play](https://play.google.com/store/apps/details?id=br.com.interacao.interaexpo&pcampaignid=web_share)

### Intera Hub

Rede social do visitante para eventos, com feed, networking, reuniões, favoritos, notificações e mapa indoor offline.

[App Store](https://apps.apple.com/us/app/intera-hub/id6757712811) · [Google Play](https://play.google.com/store/apps/details?id=br.com.interacao.interahub&hl=pt_BR)

---

## Stack

| Camada | Tecnologias |
| --- | --- |
| Frontend | Flutter Web, Dart |
| UI | Google Fonts, animações Flutter, componentes responsivos |
| Hosting | Firebase Hosting |
| CI/CD | GitHub Actions, Firebase Hosting Deploy |
| Integrações | URL Launcher, Firebase Core |
| Assets | Fotos pessoais, branding Granith, áudio ambiente |

---

## Estrutura

```text
lib/
  Models/        Dados do perfil, experiências, skills e projetos
  Pages/         Página principal e composição visual do portfólio
  Theme/         Paleta visual grafite/dourado
  Widgets/       Componentes reutilizáveis
Assets/          Imagens, logos e áudio
web/             Manifest, ícones e metadados web
.github/         Workflows de preview e deploy no Firebase Hosting
```

---

## Como Rodar Localmente

Pré-requisitos:

- Flutter stable instalado
- Dart compatível com o SDK do projeto
- Chrome ou Edge para testar a versão web

```bash
flutter pub get
flutter run -d chrome
```

Build de produção:

```bash
flutter build web --release
```

---

## Deploy

O projeto possui dois workflows:

- `Deploy to Firebase Hosting on PR`: gera preview em pull requests.
- `Deploy to Firebase Hosting on merge`: publica em produção quando há push na `main`.

O deploy usa o secret:

```text
FIREBASE_SERVICE_ACCOUNT_SKYFORGE_OF_THE_CROWNLESS
```

Esse valor não deve ser versionado. Ele precisa existir apenas nos **GitHub Actions Secrets** do repositório.

---

## Status

O portfólio está em fase de evolução contínua. A base atual já apresenta:

- narrativa pessoal;
- experiência profissional;
- stack técnica;
- projetos publicados;
- links de lojas;
- deploy automatizado;
- identidade visual alinhada ao Granith.

---

## Autor

**Guilherme Leonardo de Barros**<br />
Engenheiro de Software | Mobile Multiplataforma | Full Stack

- Portfolio: [skyforge-of-the-crownless.web.app](https://skyforge-of-the-crownless.web.app/)
- GitHub: [DEV-W-NK](https://github.com/DEV-W-NK)
- LinkedIn: [devw-nk](https://linkedin.com/in/devw-nk)

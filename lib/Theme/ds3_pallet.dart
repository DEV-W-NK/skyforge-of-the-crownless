import 'package:flutter/material.dart';

class CyberpunkColors {
  // Granith visual language: graphite surfaces, metallic gold and cold accents.
  static const Color primaryOrange = Color(0xFFE3B84A);
  static const Color deepOrange = Color(0xFFB8872D);
  static const Color burntOrange = Color(0xFF6F5221);

  static const Color deepBlack = Color(0xFF080B0D);
  static const Color charcoalGray = Color(0xFF12181B);
  static const Color darkGray = Color(0xFF1D272B);
  static const Color mediumGray = Color(0xFF36444A);

  static const Color screenTeal = Color(0xFF38D6C6);
  static const Color codeGreen = Color(0xFFB9C8C7);
  static const Color terminalGreen = Color(0xFFEDE1CC);

  static const Color neonBlue = Color(0xFF62B8FF);
  static const Color glowYellow = Color(0xFFFFD66B);
  static const Color errorRed = Color(0xFFD32F2F);

  static const LinearGradient skyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFE3B84A),
      Color(0xFF6F5221),
      Color(0xFF12181B),
      Color(0xFF080B0D),
    ],
  );

  static const LinearGradient screenGlow = LinearGradient(
    begin: Alignment.center,
    end: Alignment.bottomRight,
    colors: [Color(0xFF38D6C6), Color(0xFF1D272B), Color(0xFF080B0D)],
  );
}

class CyberpunkTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: createMaterialColor(CyberpunkColors.primaryOrange),
      primaryColor: CyberpunkColors.primaryOrange,
      scaffoldBackgroundColor: CyberpunkColors.deepBlack,
      cardColor: CyberpunkColors.charcoalGray,
      dividerColor: CyberpunkColors.darkGray,
      appBarTheme: AppBarTheme(
        backgroundColor: CyberpunkColors.charcoalGray,
        foregroundColor: CyberpunkColors.primaryOrange,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CyberpunkColors.primaryOrange,
          foregroundColor: CyberpunkColors.deepBlack,
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: CyberpunkColors.primaryOrange,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: CyberpunkColors.primaryOrange,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: CyberpunkColors.terminalGreen),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
      colorScheme: ColorScheme.dark(
        primary: CyberpunkColors.primaryOrange,
        secondary: CyberpunkColors.screenTeal,
        surface: CyberpunkColors.charcoalGray,
        error: CyberpunkColors.errorRed,
        onPrimary: CyberpunkColors.deepBlack,
        onSecondary: CyberpunkColors.deepBlack,
        onSurface: Colors.white70,
        onError: Colors.white,
      ),
    );
  }

  static MaterialColor createMaterialColor(Color color) {
    final strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red;
    final int g = color.green;
    final int b = color.blue;

    for (var i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (final strength in strengths) {
      final ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }

    return MaterialColor(color.value, swatch);
  }
}

class ColorPaletteDemo extends StatelessWidget {
  const ColorPaletteDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Granith Color Palette')),
      body: Container(
        decoration: const BoxDecoration(gradient: CyberpunkColors.skyGradient),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildColorCard('Granith Gold', CyberpunkColors.primaryOrange),
            _buildColorCard('Deep Gold', CyberpunkColors.deepOrange),
            _buildColorCard('Bronze Shadow', CyberpunkColors.burntOrange),
            _buildColorCard('Deep Black', CyberpunkColors.deepBlack),
            _buildColorCard('Charcoal Gray', CyberpunkColors.charcoalGray),
            _buildColorCard('Signal Teal', CyberpunkColors.screenTeal),
            _buildColorCard('Warm Text', CyberpunkColors.terminalGreen),
            _buildColorCard('System Blue', CyberpunkColors.neonBlue),
            _buildColorCard('Glow Yellow', CyberpunkColors.glowYellow),
            const SizedBox(height: 20),
            Card(
              child: Container(
                decoration: BoxDecoration(
                  gradient: CyberpunkColors.screenGlow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Granith System',
                        style: TextStyle(
                          color: CyberpunkColors.primaryOrange,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '> flutter run\n> Building app...\n> Hot reload enabled',
                        style: TextStyle(
                          color: CyberpunkColors.terminalGreen,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorCard(String name, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white24),
          ),
        ),
        title: Text(name),
        subtitle: Text(color.value.toRadixString(16).toUpperCase()),
      ),
    );
  }
}

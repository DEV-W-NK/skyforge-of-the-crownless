import 'package:flutter/material.dart';

class CyberpunkColors {
  // Cores principais baseadas em DS3
  static const Color primaryOrange = Color(0xFFFF6B35);      // Laranja vibrante do céu
  static const Color deepOrange = Color(0xFFE55100);         // Laranja mais profundo
  static const Color burntOrange = Color(0xFFBF360C);        // Laranja queimado das sombras
  
  // Tons escuros e neutros
  static const Color deepBlack = Color(0xFF0D0D0D);          // Preto profundo das sombras
  static const Color charcoalGray = Color(0xFF1A1A1A);       // Cinza carvão dos dispositivos
  static const Color darkGray = Color(0xFF2D2D2D);           // Cinza escuro
  static const Color mediumGray = Color(0xFF424242);         // Cinza médio
  
  // Tons de tela/código
  static const Color screenTeal = Color(0xFF00695C);         // Verde-azulado das telas
  static const Color codeGreen = Color(0xFF2E7D32);          // Verde do código
  static const Color terminalGreen = Color(0xFF4CAF50);      // Verde terminal
  
  // Tons de destaque
  static const Color neonBlue = Color(0xFF00E5FF);           // Azul neon para destaques
  static const Color glowYellow = Color(0xFFFFD600);         // Amarelo brilho
  static const Color errorRed = Color(0xFFD32F2F);           // Vermelho para erros
  
  // Gradientes
  static const LinearGradient skyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFF6B35),
      Color(0xFFE55100),
      Color(0xFFBF360C),
      Color(0xFF1A1A1A),
    ],
  );
  
  static const LinearGradient screenGlow = LinearGradient(
    begin: Alignment.center,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF00695C),
      Color(0xFF2E7D32),
      Color(0xFF1A1A1A),
    ],
  );
}

// Theme personalizado usando as cores
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
        bodyLarge: TextStyle(
          color: CyberpunkColors.terminalGreen,
        ),
        bodyMedium: TextStyle(
          color: Colors.white70,
        ),
      ),
      
      colorScheme: ColorScheme.dark(
        primary: CyberpunkColors.primaryOrange,
        secondary: CyberpunkColors.screenTeal,
        surface: CyberpunkColors.charcoalGray,
        error: CyberpunkColors.errorRed,
        onPrimary: CyberpunkColors.deepBlack,
        onSecondary: Colors.white,
        onSurface: Colors.white70,
        onError: Colors.white,
      ),
    );
  }
  
  // Função auxiliar para criar MaterialColor
  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
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

// Exemplo de uso das cores
class ColorPaletteDemo extends StatelessWidget {
  const ColorPaletteDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cyberpunk Color Palette'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: CyberpunkColors.skyGradient,
        ),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildColorCard('Primary Orange', CyberpunkColors.primaryOrange),
            _buildColorCard('Deep Orange', CyberpunkColors.deepOrange),
            _buildColorCard('Burnt Orange', CyberpunkColors.burntOrange),
            _buildColorCard('Deep Black', CyberpunkColors.deepBlack),
            _buildColorCard('Charcoal Gray', CyberpunkColors.charcoalGray),
            _buildColorCard('Screen Teal', CyberpunkColors.screenTeal),
            _buildColorCard('Terminal Green', CyberpunkColors.terminalGreen),
            _buildColorCard('Neon Blue', CyberpunkColors.neonBlue),
            _buildColorCard('Glow Yellow', CyberpunkColors.glowYellow),
            
            SizedBox(height: 20),
            
            // Exemplo de card com as cores
            Card(
              child: Container(
                decoration: BoxDecoration(
                  gradient: CyberpunkColors.screenGlow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Terminal Output',
                        style: TextStyle(
                          color: CyberpunkColors.terminalGreen,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '> flutter run\n> Building app...\n> Hot reload enabled',
                        style: TextStyle(
                          color: Colors.white70,
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
      margin: EdgeInsets.symmetric(vertical: 4),
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
import 'package:flutter/material.dart';

class JourneyStartScreen extends StatelessWidget {
  final String language;
  final String flag;
  final String greeting;

  const JourneyStartScreen({
    super.key,
    required this.language,
    required this.flag,
    required this.greeting,
  });

  @override
  Widget build(BuildContext context) {
    final destination = switch (language) {
      'Türkçe' => 'Türkei',
      'Ελληνικά' => 'Griechenland',
      _ => 'der englischsprachigen Welt',
    };

    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF07070A),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Deine Reise'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF471027), Color(0xFF171219)],
                  ),
                  border: Border.all(color: const Color(0x66FF2E9A)),
                ),
                child: Column(
                  children: [
                    Text(flag, style: const TextStyle(fontSize: 52)),
                    const SizedBox(height: 12),
                    Text(greeting, style: const TextStyle(color: Color(0xFFFF4FA8), fontSize: 20, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Text(
                      'Deine Reise durch $destination beginnt.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 25, height: 1.12, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Wir begleiten dich Schritt für Schritt – vom ersten Wort bis zu echten Gesprächen.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFFD0CAD3), height: 1.45),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Dein Fortschritt', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                  Text('0 %', style: TextStyle(color: Color(0xFFFF2E9A), fontWeight: FontWeight.w900)),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: const LinearProgressIndicator(
                  value: 0,
                  minHeight: 10,
                  backgroundColor: Color(0xFF25222A),
                  valueColor: AlwaysStoppedAnimation(Color(0xFFFF2E9A)),
                ),
              ),
              const SizedBox(height: 26),
              const Text('KAPITEL 1', style: TextStyle(color: Color(0xFFFF78BC), fontSize: 13, fontWeight: FontWeight.w900)),
              const SizedBox(height: 6),
              const Text('Ankommen & erste Worte', style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              const Text(
                'Begrüßen, vorstellen, hören, nachsprechen und deine ersten eigenen Sätze bilden.',
                style: TextStyle(color: Color(0xFFB9B3BD), height: 1.45),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFF2E9A),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(58),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kapitel 1 wird als nächstes mit der Lern-Runtime verbunden.'), behavior: SnackBarBehavior.floating),
                  );
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Kapitel 1 starten', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
              ),
              const SizedBox(height: 26),
              const Row(
                children: [
                  Expanded(child: _JourneyTile(icon: Icons.menu_book_rounded, title: 'Sprachbuch', subtitle: 'Deine Wörter & Sätze')),
                  SizedBox(width: 10),
                  Expanded(child: _JourneyTile(icon: Icons.badge_outlined, title: 'Reisepass', subtitle: 'Niveaus & Zertifikate')),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Expanded(child: _JourneyTile(icon: Icons.quiz_outlined, title: 'Übungen', subtitle: 'Quiz & Wiederholen')),
                  SizedBox(width: 10),
                  Expanded(child: _JourneyTile(icon: Icons.graphic_eq_rounded, title: 'Aussprache', subtitle: 'Hören & sprechen')),
                ],
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: const Color(0xFF17161B),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF2D2932)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded, color: Color(0xFFFF2E9A)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Keine Vorkenntnisse nötig. Wir beginnen gemeinsam bei null.',
                        style: TextStyle(color: Colors.white, height: 1.35, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JourneyTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _JourneyTile({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF17161B),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF2D2932)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFFFF2E9A), size: 26),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Color(0xFF9C96A1), fontSize: 11.5, height: 1.3)),
          ],
        ),
      );
}

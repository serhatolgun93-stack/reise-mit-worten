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
    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Deine Reise'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(flag, textAlign: TextAlign.center, style: const TextStyle(fontSize: 66)),
              const SizedBox(height: 18),
              Text(
                greeting,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFFF2E9A),
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Deine Reise in $language beginnt.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 31,
                  height: 1.1,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Wir begleiten dich Schritt für Schritt – vom ersten Wort bis zu echten Gesprächen.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFC8C3CC), fontSize: 16, height: 1.45),
              ),
              const Spacer(),
              const Row(
                children: [
                  Expanded(child: _JourneyTile(icon: Icons.menu_book_rounded, label: 'Kapitel 1', value: 'Ankommen')),
                  SizedBox(width: 12),
                  Expanded(child: _JourneyTile(icon: Icons.route_rounded, label: 'Niveau', value: 'Start · A1')),
                ],
              ),
              const SizedBox(height: 14),
              const _InfoCard(),
              const SizedBox(height: 20),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFFF2E9A),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Kapitel 1 wird als Nächstes freigeschaltet.'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.flight_takeoff_rounded),
                label: const Text('Erstes Kapitel starten', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
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
  final String label;
  final String value;
  const _JourneyTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF17161C),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF34313A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFFFF2E9A)),
            const SizedBox(height: 12),
            Text(label, style: const TextStyle(color: Color(0xFF918B97), fontSize: 12)),
            const SizedBox(height: 3),
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          ],
        ),
      );
}

class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF361225), Color(0xFF17141B)]),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0x66FF2E9A)),
        ),
        child: const Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0x33FF2E9A),
              child: Icon(Icons.auto_awesome_rounded, color: Color(0xFFFF2E9A)),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Text(
                'Keine Vorkenntnisse nötig. Wir beginnen gemeinsam bei null.',
                style: TextStyle(color: Colors.white, height: 1.35, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
}

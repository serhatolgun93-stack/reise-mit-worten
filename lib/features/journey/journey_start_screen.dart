import 'package:flutter/material.dart';

import 'maria_asset_v2.dart';

class JourneyStartScreen extends StatelessWidget {
  final String language;
  final String flag;
  final String greeting;
  final String backgroundAsset;

  const JourneyStartScreen({
    super.key,
    required this.language,
    required this.flag,
    required this.greeting,
    required this.backgroundAsset,
  });

  String get questionGreeting => switch (language) {
        'Türkçe' => 'Tanışalım',
        'Ελληνικά' => 'Ας γνωριστούμε',
        _ => "Let's get to know you",
      };

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            backgroundAsset,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, __, ___) => const ColoredBox(color: Color(0xFF07070A)),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x55000000), Color(0x22000000), Color(0xB8000000)],
                stops: [0.0, 0.45, 1.0],
              ),
            ),
          ),
          Positioned(
            right: -20,
            bottom: 82,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.diagonal3Values(-1, 1, 1),
              child: SizedBox(
                width: screen.width * 0.50,
                height: screen.height * 0.50,
                child: FittedBox(
                  fit: BoxFit.contain,
                  alignment: Alignment.bottomRight,
                  child: Image.memory(
                    mariaWelcomePngBytes,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 34),
                      ),
                      const Text('2 / 8', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    width: screen.width * 0.72,
                    margin: EdgeInsets.only(right: screen.width * 0.18),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xDD17161B),
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(color: const Color(0x44FFFFFF)),
                      boxShadow: const [BoxShadow(color: Color(0x77000000), blurRadius: 26, offset: Offset(0, 12))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(questionGreeting, style: const TextStyle(color: Color(0xFFFF5BAE), fontSize: 18, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 12),
                        const Text('Wie darf ich dich nennen?', style: TextStyle(color: Colors.white, fontSize: 32, height: 1.08, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 12),
                        const Text('Dein Name macht deine Reise persönlicher. Ich werde dich während des Lernens damit ansprechen.', style: TextStyle(color: Color(0xFFE8E1E8), fontSize: 15, height: 1.45)),
                        const SizedBox(height: 22),
                        TextField(
                          textCapitalization: TextCapitalization.words,
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                          decoration: InputDecoration(
                            hintText: 'Dein Vorname',
                            hintStyle: const TextStyle(color: Color(0xFFAAA3AC)),
                            prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFFFF2E9A)),
                            filled: true,
                            fillColor: const Color(0xE61E1C22),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Color(0xFF514A56))),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Color(0xFFFF2E9A), width: 2)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(color: const Color(0xC91E1C22), borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFF3C3740))),
                          child: Row(children: [
                            Text(flag, style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 12),
                            Expanded(child: Text('Du lernst $language – Schritt für Schritt und in deinem Tempo.', style: const TextStyle(color: Colors.white, height: 1.4, fontWeight: FontWeight.w600))),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 62,
                    child: FilledButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Schritt 3 folgt als Nächstes.'), behavior: SnackBarBehavior.floating));
                      },
                      style: FilledButton.styleFrom(backgroundColor: const Color(0xFFFF2E9A), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(31))),
                      child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('Weiter', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                        SizedBox(width: 12),
                        Icon(Icons.arrow_forward_rounded, size: 28),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

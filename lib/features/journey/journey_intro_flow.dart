import 'package:flutter/material.dart';

import 'journey_start_screen.dart';
import 'maria_asset_v2.dart';

class JourneyIntroFlow extends StatelessWidget {
  final String language;
  final String flag;
  final String greeting;
  final String backgroundAsset;

  const JourneyIntroFlow({
    super.key,
    required this.language,
    required this.flag,
    required this.greeting,
    required this.backgroundAsset,
  });

  String get learningGreeting {
    switch (language) {
      case 'Türkçe':
        return 'Merhaba!';
      case 'Ελληνικά':
        return 'Γεια σου!';
      default:
        return 'Hello!';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: const Color(0xFF050508),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            backgroundAsset,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
            errorBuilder: (_, __, ___) => const ColoredBox(color: Color(0xFF050508)),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x22000000), Color(0x18000000), Color(0xB8000000)],
                stops: [0.0, 0.48, 1.0],
              ),
            ),
          ),
          Positioned(
            left: -14,
            bottom: 96,
            child: SizedBox(
              width: screen.width * 0.55,
              height: screen.height * 0.57,
              child: FittedBox(
                fit: BoxFit.contain,
                alignment: Alignment.bottomLeft,
                child: Image.memory(
                  mariaWelcomePngBytes,
                  filterQuality: FilterQuality.high,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 34),
                      ),
                      const Text('1 / 8', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: screen.width * 0.64,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
                      decoration: BoxDecoration(
                        color: const Color(0xE817161A),
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: const Color(0x44FFFFFF)),
                        boxShadow: const [BoxShadow(color: Color(0x77000000), blurRadius: 28, offset: Offset(0, 12))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(children: [
                            const Icon(Icons.favorite_rounded, color: Color(0xFFFF2E9A), size: 21),
                            const SizedBox(width: 8),
                            Flexible(child: Text(learningGreeting, style: const TextStyle(color: Color(0xFFFF5BAE), fontSize: 17, fontWeight: FontWeight.w800))),
                          ]),
                          const SizedBox(height: 14),
                          const Text('Maria begrüßt dich', style: TextStyle(color: Colors.white, fontSize: 29, height: 1.08, fontWeight: FontWeight.w900)),
                          const SizedBox(height: 14),
                          const Divider(color: Color(0xCCFF2E9A), thickness: 1.2),
                          const SizedBox(height: 14),
                          const Text('Schön, dass du da bist. Bevor wir gemeinsam auf Reisen gehen, möchte ich dich ein wenig kennenlernen.', style: TextStyle(color: Color(0xFFF2EDF2), fontSize: 15, height: 1.45, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 16),
                          Text('$flag $language', style: const TextStyle(color: Color(0xFFFF5BAE), fontSize: 18, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 62,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (_) => JourneyStartScreen(
                              language: language,
                              flag: flag,
                              greeting: greeting,
                              backgroundAsset: backgroundAsset,
                            ),
                          ),
                        );
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

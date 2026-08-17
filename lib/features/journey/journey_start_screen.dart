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

  String get questionGreeting => switch (language) {
        'Türkçe' => 'Tanışalım',
        'Ελληνικά' => 'Ας γνωριστούμε',
        _ => "Let's get to know you",
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07070A),
      body: SafeArea(
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
              Text(questionGreeting, style: const TextStyle(color: Color(0xFFFF5BAE), fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              const Text(
                'Wie darf ich dich nennen?',
                style: TextStyle(color: Colors.white, fontSize: 34, height: 1.08, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              const Text(
                'Dein Name macht deine Reise persönlicher. Ich werde dich während des Lernens damit ansprechen.',
                style: TextStyle(color: Color(0xFFCFC9D2), fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 30),
              TextField(
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                decoration: InputDecoration(
                  hintText: 'Dein Vorname',
                  hintStyle: const TextStyle(color: Color(0xFF8F8992)),
                  prefixIcon: const Icon(Icons.person_outline_rounded, color: Color(0xFFFF2E9A)),
                  filled: true,
                  fillColor: const Color(0xFF17161B),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: const BorderSide(color: Color(0xFF3B3640)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: const BorderSide(color: Color(0xFFFF2E9A), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF17161B),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF2D2932)),
                ),
                child: Row(
                  children: [
                    Text(flag, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Du lernst $language – Schritt für Schritt und in deinem Tempo.',
                        style: const TextStyle(color: Colors.white, height: 1.4, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 62,
                child: FilledButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Schritt 3 folgt als Nächstes.'), behavior: SnackBarBehavior.floating),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF2E9A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(31)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Weiter', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                      SizedBox(width: 12),
                      Icon(Icons.arrow_forward_rounded, size: 28),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

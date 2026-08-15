import 'package:flutter/material.dart';

import 'journey_start_screen.dart';

class JourneyIntroFlow extends StatefulWidget {
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

  @override
  State<JourneyIntroFlow> createState() => _JourneyIntroFlowState();
}

class _JourneyIntroFlowState extends State<JourneyIntroFlow> {
  final _nameController = TextEditingController();
  int _step = 0;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String get _name {
    final value = _nameController.text.trim();
    return value.isEmpty ? 'Reisender' : value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09080B),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            widget.backgroundAsset,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x44000000),
                  Color(0x77000000),
                  Color(0xE60A090C),
                ],
                stops: [0.0, 0.54, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (_step == 0) {
                            Navigator.of(context).pop();
                          } else {
                            setState(() => _step--);
                          }
                        },
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: Colors.white,
                      ),
                      const Spacer(),
                      Text(
                        '${_step + 1} / 3',
                        style: const TextStyle(
                          color: Color(0xFFD7D1D9),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: _buildStep(),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: FilledButton(
                      onPressed: _next,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFF2E9A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        _step == 2 ? 'Weiter zur Reise' : 'Weiter',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
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

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _GlassCard(
          key: const ValueKey('welcome'),
          child: Column(
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF6BB6), Color(0xFFFF2E9A)],
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 42,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Maria begrüßt dich',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Schön, dass du da bist. Bevor wir gemeinsam auf Reisen gehen, möchte ich dich ein wenig kennenlernen.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFE4DEE6),
                  fontSize: 16,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '${widget.flag} ${widget.language}',
                style: const TextStyle(
                  color: Color(0xFFFF75BD),
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      case 1:
        return _GlassCard(
          key: const ValueKey('name'),
          child: Column(
            children: [
              const Text(
                'Wie dürfen wir dich nennen?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Nur dein Vorname genügt.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFD5CFD8), fontSize: 15),
              ),
              const SizedBox(height: 22),
              TextField(
                controller: _nameController,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                style: const TextStyle(color: Color(0xFF171217), fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'Vorname',
                  filled: true,
                  fillColor: const Color(0xFFF7F2F5),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _next(),
              ),
            ],
          ),
        );
      default:
        return _GlassCard(
          key: const ValueKey('personal'),
          child: Column(
            children: [
              const Icon(
                Icons.favorite_rounded,
                color: Color(0xFFFF2E9A),
                size: 42,
              ),
              const SizedBox(height: 14),
              Text(
                'Schön, dich kennenzulernen, $_name!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Ich freue mich, dich auf deiner Reise in ${widget.language} begleiten zu dürfen. Wir gehen Schritt für Schritt – in deinem Tempo.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFFE4DEE6),
                  fontSize: 16,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.greeting,
                style: const TextStyle(
                  color: Color(0xFFFF75BD),
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        );
    }
  }

  void _next() {
    if (_step == 1 && _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte gib deinen Vornamen ein.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (_step < 2) {
      setState(() => _step++);
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => JourneyStartScreen(
          language: widget.language,
          flag: widget.flag,
          greeting: widget.greeting,
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;

  const _GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
      decoration: BoxDecoration(
        color: const Color(0xDD171218),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0x55FFFFFF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x55000000),
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

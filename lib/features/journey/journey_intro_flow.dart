import 'package:flutter/material.dart';

import 'journey_start_screen.dart';

class JourneyIntroFlow extends StatefulWidget {
  final String language;
  final String flag;
  final String greeting;
  final String backgroundAsset;

  const JourneyIntroFlow({super.key, required this.language, required this.flag, required this.greeting, required this.backgroundAsset});

  @override
  State<JourneyIntroFlow> createState() => _JourneyIntroFlowState();
}

class _JourneyIntroFlowState extends State<JourneyIntroFlow> {
  final _nameController = TextEditingController();
  int _step = 0;
  final Set<String> _goals = {'Reisen & die Welt entdecken'};

  static const _goalOptions = <String>[
    'Reisen & die Welt entdecken',
    'Beruf & Karriere',
    'Schule & Studium',
    'Familie & Freunde',
    'Neue Kulturen entdecken',
    'Aus Freude lernen',
    'Im Ausland leben',
    'Selbstbewusster sprechen',
    'Prüfung oder Zertifikat',
    'Eigener Grund',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String get _name => _nameController.text.trim().isEmpty ? 'Reisender' : _nameController.text.trim();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09080B),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(widget.backgroundAsset, fit: BoxFit.cover, alignment: Alignment.center),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x33000000), Color(0x66000000), Color(0xEE0A090C)],
                stops: [0, .5, 1],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 22),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(onPressed: _back, icon: const Icon(Icons.arrow_back_rounded), color: Colors.white),
                      const Spacer(),
                      Text('${_step + 1} / 8', style: const TextStyle(color: Color(0xFFE4DEE6), fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const Spacer(),
                  Flexible(
                    child: SingleChildScrollView(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _buildStep(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: FilledButton(
                      onPressed: _next,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFF2E9A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      child: Text(
                        _step == 7 ? 'Meine Reise beginnen' : 'Weiter',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
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
        return _card('welcome', Column(children: [
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFF75BD), width: 3),
              image: DecorationImage(image: AssetImage(widget.backgroundAsset), fit: BoxFit.cover, alignment: const Alignment(.25, 0)),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Maria begrüßt dich', textAlign: TextAlign.center, style: _title),
          const SizedBox(height: 12),
          const Text('Schön, dass du da bist. Bevor wir gemeinsam auf Reisen gehen, möchte ich dich ein wenig kennenlernen.', textAlign: TextAlign.center, style: _body),
          const SizedBox(height: 14),
          Text('${widget.flag} ${widget.language}', style: _accent),
        ]));
      case 1:
        return _card('name', Column(children: [
          const Text('Wie dürfen wir dich nennen?', textAlign: TextAlign.center, style: _title),
          const SizedBox(height: 8),
          const Text('Nur dein Vorname genügt.', textAlign: TextAlign.center, style: _body),
          const SizedBox(height: 20),
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
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
            onSubmitted: (_) => _next(),
          ),
        ]));
      case 2:
        return _card('hello', Column(children: [
          const Icon(Icons.favorite_rounded, color: Color(0xFFFF2E9A), size: 42),
          const SizedBox(height: 14),
          Text('Schön, dich kennenzulernen, $_name!', textAlign: TextAlign.center, style: _title),
          const SizedBox(height: 12),
          Text('Ich freue mich, dich auf deiner Reise in ${widget.language} begleiten zu dürfen. Wir gehen Schritt für Schritt – in deinem Tempo.', textAlign: TextAlign.center, style: _body),
          const SizedBox(height: 14),
          Text(widget.greeting, style: _accent),
        ]));
      case 3:
        return _card('goals', Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Was motiviert dich?', style: _title),
          const SizedBox(height: 6),
          const Text('Was möchtest du mit deiner neuen Sprache erreichen? Du kannst mehrere Ziele auswählen.', style: _body),
          const SizedBox(height: 16),
          ..._goalOptions.map((goal) => CheckboxListTile(
                value: _goals.contains(goal),
                dense: true,
                contentPadding: EdgeInsets.zero,
                activeColor: const Color(0xFFFF2E9A),
                checkColor: Colors.white,
                title: Text(goal, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                onChanged: (value) => setState(() => value == true ? _goals.add(goal) : _goals.remove(goal)),
              )),
        ]));
      case 4:
        return _card('understood', Column(children: [
          const Icon(Icons.auto_awesome_rounded, color: Color(0xFFFF75BD), size: 50),
          const SizedBox(height: 16),
          Text('Danke, $_name!', textAlign: TextAlign.center, style: _title),
          const SizedBox(height: 12),
          const Text('Jetzt verstehe ich besser, was dir wichtig ist. Gemeinsam gestalten wir eine Reise, die zu deinen Zielen passt. Und wenn sich deine Ziele später ändern – kein Problem. Deine Reise wächst mit dir.', textAlign: TextAlign.center, style: _body),
          if (_goals.isNotEmpty) ...[
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: _goals.take(4).map((goal) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0x33FF2E9A),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0x66FF75BD)),
                    ),
                    child: Text(goal, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                  )).toList(),
            ),
          ],
        ]));
      case 5:
        return _card('journal', Column(children: [
          const Icon(Icons.menu_book_rounded, color: Color(0xFFFF75BD), size: 54),
          const SizedBox(height: 16),
          const Text('Dies ist dein persönliches Reisetagebuch.', textAlign: TextAlign.center, style: _title),
          const SizedBox(height: 12),
          Text('Hier halten wir gemeinsam deine schönsten Momente, Fortschritte und Erinnerungen fest. Deine Reise in ${widget.language} wächst mit dir.', textAlign: TextAlign.center, style: _body),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0x22FF75BD),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0x55FF75BD)),
            ),
            child: Text(
              'Erster Eintrag\n\nHeute beginnt die Reise von $_name mit einem kleinen Schritt – und einem neuen Wort. ${widget.greeting}!',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, height: 1.5, fontSize: 15),
            ),
          ),
        ]));
      case 6:
        return _card('ready', Column(children: [
          const Icon(Icons.favorite_rounded, color: Color(0xFFFF2E9A), size: 48),
          const SizedBox(height: 16),
          Text('Bist du bereit, $_name?', textAlign: TextAlign.center, style: _title),
          const SizedBox(height: 12),
          const Text('Du musst heute nicht alles können. Du musst nur bereit sein, den ersten Schritt zu gehen. Den Rest entdecken wir gemeinsam.', textAlign: TextAlign.center, style: _body),
          const SizedBox(height: 20),
          Text('${widget.flag} ${widget.greeting}', style: _accent),
        ]));
      default:
        return _card('journey-begins', Column(children: [
          const Icon(Icons.flight_takeoff_rounded, color: Color(0xFFFF2E9A), size: 58),
          const SizedBox(height: 16),
          const Text('Deine Reise beginnt.', textAlign: TextAlign.center, style: _title),
          const SizedBox(height: 12),
          Text('Ein neuer Ort. Neue Wörter. Neue Begegnungen. Und Maria begleitet dich auf deinem Weg in ${widget.language}.', textAlign: TextAlign.center, style: _body),
          const SizedBox(height: 18),
          Text('${widget.flag} ${widget.greeting}, $_name!', style: _accent, textAlign: TextAlign.center),
          const SizedBox(height: 18),
          const Text('Jede Reise beginnt mit einem Wort.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
        ]));
    }
  }

  Widget _card(String keyName, Widget child) => Container(
        key: ValueKey(keyName),
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
        decoration: BoxDecoration(
          color: const Color(0xE6171218),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0x55FFFFFF)),
          boxShadow: const [BoxShadow(color: Color(0x55000000), blurRadius: 28, offset: Offset(0, 12))],
        ),
        child: child,
      );

  void _back() {
    FocusScope.of(context).unfocus();
    if (_step == 0) {
      Navigator.of(context).pop();
    } else {
      setState(() => _step--);
    }
  }

  void _next() {
    FocusScope.of(context).unfocus();
    if (_step == 1 && _nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bitte gib deinen Vornamen ein.'), behavior: SnackBarBehavior.floating));
      return;
    }
    if (_step == 3 && _goals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Wähle bitte mindestens ein Ziel aus.'), behavior: SnackBarBehavior.floating));
      return;
    }
    if (_step < 7) {
      setState(() => _step++);
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => JourneyStartScreen(language: widget.language, flag: widget.flag, greeting: widget.greeting),
      ),
    );
  }

  static const _title = TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w900, height: 1.12);
  static const _body = TextStyle(color: Color(0xFFE4DEE6), fontSize: 16, height: 1.45);
  static const _accent = TextStyle(color: Color(0xFFFF75BD), fontWeight: FontWeight.w900, fontSize: 18);
}

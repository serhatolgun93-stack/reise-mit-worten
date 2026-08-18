import 'package:flutter/material.dart';

class JourneyIntroFlow extends StatefulWidget {
  final String language;
  final String flag;
  final String greeting;
  final String backgroundAsset;
  final String guideKey;
  final String guideName;

  const JourneyIntroFlow({super.key, required this.language, required this.flag, required this.greeting, required this.backgroundAsset, required this.guideKey, required this.guideName});

  @override
  State<JourneyIntroFlow> createState() => _JourneyIntroFlowState();
}

class _JourneyIntroFlowState extends State<JourneyIntroFlow> {
  int _step = 1;
  String? _selectedLevel;
  final _nameController = TextEditingController();
  bool get _isLeon => widget.guideKey == 'leon';

  String get learningGreeting => widget.language == 'Türkçe' ? 'Merhaba!' : widget.language == 'Ελληνικά' ? 'Γεια σου!' : 'Hello!';
  String get _activeBackground {
    if (_step != 3) return widget.backgroundAsset;
    if (widget.language == 'Türkçe') return 'assets/backgrounds/onboarding_3_turkish.png';
    if (widget.language == 'Ελληνικά') return 'assets/backgrounds/onboarding_3_greek.png';
    return 'assets/backgrounds/onboarding_3_english.png';
  }
  String get _guideAsset {
    if (_step == 2) return _isLeon ? 'assets/characters/leon_confident.png' : 'assets/characters/maria_confident.png';
    if (_step == 3) return _isLeon ? 'assets/characters/leon_relaxed.png' : 'assets/characters/maria_thinking.png';
    return _isLeon ? 'assets/characters/leon_invite.png' : 'assets/characters/maria_welcome.png';
  }

  @override
  void dispose() { _nameController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    final landscape = screen.width > screen.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF050508),
      body: Stack(fit: StackFit.expand, children: [
        Positioned.fill(child: ClipRect(child: Image.asset(_activeBackground, key: ValueKey('${_activeBackground}_$landscape'), width: screen.width, height: screen.height, fit: BoxFit.cover, alignment: Alignment.center, filterQuality: FilterQuality.high, errorBuilder: (_,__,___)=>const ColoredBox(color: Color(0xFF050508))))),
        const Positioned.fill(child: DecoratedBox(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,colors:[Color(0x10000000),Color(0x05000000),Color(0xA8000000)],stops:[0,.55,1])))),
        _guideLayer(screen, landscape),
        SafeArea(child: Padding(padding: EdgeInsets.fromLTRB(landscape?24:18, landscape?8:12, landscape?24:18, landscape?10:18), child: _buildStep(screen, landscape))),
      ]),
    );
  }

  Widget _buildStep(Size s,bool l)=>_step==1?(l?_stepOneLandscape(s):_stepOnePortrait(s)):_step==2?(l?_stepTwoLandscape(s):_stepTwoPortrait(s)):(l?_stepThreeLandscape(s):_stepThreePortrait(s));

  Widget _guideLayer(Size s,bool l) {
    final right=_step==2;
    return Positioned(
      left:right?null:(l?-12:-28),
      right:right?(l?-8:-32):null,
      bottom:l?-10:(_step==3?105:120),
      child:IgnorePointer(
        child:SizedBox(
          width:l ? s.width * (_step == 3 ? 0.27 : 0.32) : s.width * (_step == 3 ? 0.43 : 0.62),
          height:l ? s.height * 0.88 : s.height * (_step == 3 ? 0.43 : 0.58),
          child:Image.asset(_guideAsset,fit:BoxFit.contain,alignment:right?Alignment.bottomRight:Alignment.bottomLeft,errorBuilder:(_,__,___)=>const SizedBox.shrink()),
        ),
      ),
    );
  }

  Widget _stepOnePortrait(Size s)=>Column(children:[_header('1 / 8',()=>Navigator.of(context).pop()),const Spacer(),Align(alignment:Alignment.centerRight,child:_welcomeCard(s.width*.68,false)),const SizedBox(height:16),_pinkButton('Weiter',()=>setState(()=>_step=2))]);
  Widget _stepOneLandscape(Size s)=>Column(children:[_header('1 / 8',()=>Navigator.of(context).pop()),const Spacer(),Align(alignment:Alignment.centerRight,child:_welcomeCard(s.width*.56,true)),const SizedBox(height:8),Align(alignment:Alignment.centerRight,child:SizedBox(width:s.width*.48,child:_pinkButton('Weiter',()=>setState(()=>_step=2),height:48)))]);

  Widget _welcomeCard(double width,bool compact)=>Container(width:width,padding:EdgeInsets.all(compact?16:18),decoration:_cardDecoration(),child:Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisSize:MainAxisSize.min,children:[Row(children:[const Icon(Icons.favorite_rounded,color:Color(0xFFFF2E9A),size:21),const SizedBox(width:8),Text(learningGreeting,style:TextStyle(color:const Color(0xFFFF5BAE),fontSize:compact?15:17,fontWeight:FontWeight.w800))]),SizedBox(height:compact?6:10),Text('${widget.guideName} begrüßt dich',style:TextStyle(color:Colors.white,fontSize:compact?24:28,fontWeight:FontWeight.w900)),SizedBox(height:compact?6:10),const Divider(color:Color(0xCCFF2E9A)),SizedBox(height:compact?6:10),Text('Schön, dass du da bist. Bevor wir gemeinsam auf Reisen gehen, möchte ich dich ein wenig kennenlernen.',style:TextStyle(color:const Color(0xFFF2EDF2),fontSize:compact?12.5:14.5,height:1.35)),SizedBox(height:compact?8:12),Text('${widget.flag} ${widget.language}',style:TextStyle(color:const Color(0xFFFF5BAE),fontSize:compact?16:18,fontWeight:FontWeight.w900))]));

  Widget _stepTwoPortrait(Size s)=>Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[_header('2 / 8',()=>setState(()=>_step=1)),const Spacer(),Align(alignment:Alignment.centerLeft,child:_nameCard(s.width*.66,false)),const SizedBox(height:16),_continueNameButton()]);
  Widget _stepTwoLandscape(Size s)=>Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[_header('2 / 8',()=>setState(()=>_step=1)),const Spacer(),Align(alignment:Alignment.centerLeft,child:_nameCard(s.width*.62,true)),const SizedBox(height:8),Align(alignment:Alignment.centerLeft,child:SizedBox(width:s.width*.47,child:_continueNameButton(height:48)))]);

  Widget _nameCard(double width,bool compact)=>Container(width:width,padding:EdgeInsets.all(compact?14:18),decoration:_cardDecoration(),child:Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisSize:MainAxisSize.min,children:[Text('LERNEN WIR UNS KENNEN',style:TextStyle(color:const Color(0xFFFF5BAE),fontSize:compact?13:14.5,fontWeight:FontWeight.w900)),const SizedBox(height:7),Text('Wie darf ich dich nennen?',style:TextStyle(color:Colors.white,fontSize:compact?23:27,fontWeight:FontWeight.w900)),const SizedBox(height:7),Text('Dein Name macht deine Reise persönlicher. ${widget.guideName} wird dich während des Lernens damit ansprechen.',style:TextStyle(color:const Color(0xFFF2EDF2),fontSize:compact?12:13.5,height:1.3)),SizedBox(height:compact?9:13),TextField(controller:_nameController,onChanged:(_)=>setState((){}),style:const TextStyle(color:Colors.white,fontWeight:FontWeight.w700),decoration:InputDecoration(hintText:'Dein Vorname',hintStyle:const TextStyle(color:Color(0xFFAAA3AC)),prefixIcon:const Icon(Icons.person_outline_rounded,color:Color(0xFFFF2E9A)),filled:true,fillColor:const Color(0xE61E1C22),contentPadding:EdgeInsets.symmetric(vertical:compact?10:14),border:OutlineInputBorder(borderRadius:BorderRadius.circular(18)))),SizedBox(height:compact?8:11),Container(width:double.infinity,padding:EdgeInsets.all(compact?9:11),decoration:BoxDecoration(color:const Color(0xC91E1C22),borderRadius:BorderRadius.circular(17),border:Border.all(color:const Color(0xFF3C3740))),child:Row(children:[Text(widget.flag,style:const TextStyle(fontSize:22)),const SizedBox(width:9),Expanded(child:Text('Du lernst ${widget.language} – Schritt für Schritt und in deinem Tempo.',style:TextStyle(color:Colors.white,fontSize:compact?11.5:12.5,fontWeight:FontWeight.w600)))]) )]));

  Widget _stepThreePortrait(Size s)=>Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[_header('3 / 8',()=>setState(()=>_step=2)),const Spacer(),Align(alignment:Alignment.centerRight,child:_levelCard(s.width*.72,false,true)),const SizedBox(height:12),_continueLevelButton(height:58)]);
  Widget _stepThreeLandscape(Size s)=>Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[_header('3 / 8',()=>setState(()=>_step=2)),const Spacer(),Align(alignment:Alignment.centerRight,child:_levelCard(s.width*.57,true,true)),const SizedBox(height:7),Align(alignment:Alignment.centerRight,child:SizedBox(width:s.width*.42,child:_continueLevelButton(height:46)))]);

  Widget _levelCard(double width,bool compact,bool grid)=>Container(width:width,padding:EdgeInsets.all(compact?12:14),decoration:_cardDecoration(),child:Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisSize:MainAxisSize.min,children:[Text('DEIN STARTPUNKT',style:TextStyle(color:const Color(0xFFFF5BAE),fontSize:compact?11:12.5,fontWeight:FontWeight.w900)),SizedBox(height:compact?3:5),Text('Wo stehst du gerade?',style:TextStyle(color:Colors.white,fontSize:compact?19:22,fontWeight:FontWeight.w900)),SizedBox(height:compact?3:5),Text('${widget.guideName} passt deine ersten Schritte an dein aktuelles Niveau an.',style:TextStyle(color:const Color(0xFFF2EDF2),fontSize:compact?10.5:11.5,height:1.2)),SizedBox(height:compact?7:9),Row(crossAxisAlignment:CrossAxisAlignment.start,children:[Expanded(child:_levelOption('new',Icons.auto_awesome_rounded,'Ich starte ganz neu','Keine oder fast keine Vorkenntnisse',compact)),const SizedBox(width:7),Expanded(child:_levelOption('words',Icons.chat_bubble_outline_rounded,'Ich kenne ein paar Wörter','Begrüßungen und einzelne Begriffe',compact))]),const SizedBox(height:7),Row(crossAxisAlignment:CrossAxisAlignment.start,children:[Expanded(child:_levelOption('sentences',Icons.record_voice_over_rounded,'Ich kann einfache Sätze','Kurze Alltagssituationen klappen schon',compact)),const SizedBox(width:7),Expanded(child:_levelOption('restart',Icons.refresh_rounded,'Ich möchte wieder einsteigen','Früher gelernt – jetzt auffrischen',compact))]) ]));

  Widget _levelOption(String value,IconData icon,String title,String subtitle,bool compact){final selected=_selectedLevel==value;return Material(color:Colors.transparent,child:InkWell(onTap:()=>setState(()=>_selectedLevel=value),borderRadius:BorderRadius.circular(14),child:AnimatedContainer(duration:const Duration(milliseconds:180),constraints:BoxConstraints(minHeight:compact?64:78),padding:EdgeInsets.symmetric(horizontal:compact?7:9,vertical:compact?6:8),decoration:BoxDecoration(color:selected?const Color(0x3DFF2E9A):const Color(0xC91E1C22),borderRadius:BorderRadius.circular(14),border:Border.all(color:selected?const Color(0xFFFF2E9A):const Color(0xFF3C3740),width:selected?1.7:1)),child:Row(children:[Icon(icon,color:const Color(0xFFFF2E9A),size:compact?18:20),const SizedBox(width:7),Expanded(child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[Text(title,maxLines:2,style:TextStyle(color:Colors.white,fontSize:compact?10.5:11.5,height:1.1,fontWeight:FontWeight.w800)),const SizedBox(height:2),Text(subtitle,maxLines:2,overflow:TextOverflow.ellipsis,style:TextStyle(color:const Color(0xFFD7D0D7),fontSize:compact?8.5:9.5,height:1.1))])),if(selected) const Icon(Icons.check_circle_rounded,color:Color(0xFFFF2E9A),size:17)])))) ;}

  Widget _continueNameButton({double height=62})=>_pinkButton('Weiter',_nameController.text.trim().isEmpty?null:(){FocusScope.of(context).unfocus();setState(()=>_step=3);},height:height);
  Widget _continueLevelButton({double height=62})=>_pinkButton('Weiter',_selectedLevel==null?null:(){ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Danke, ${_nameController.text.trim()}! Dein Startpunkt ist gespeichert. Schritt 4 folgt als Nächstes.')));},height:height);
  Widget _header(String step,VoidCallback back)=>Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[IconButton(onPressed:back,icon:const Icon(Icons.arrow_back_rounded,color:Colors.white,size:34)),Text(step,style:const TextStyle(color:Colors.white,fontSize:18,fontWeight:FontWeight.w800))]);
  BoxDecoration _cardDecoration()=>BoxDecoration(color:const Color(0xE817161A),borderRadius:BorderRadius.circular(26),border:Border.all(color:const Color(0x44FFFFFF)),boxShadow:const[BoxShadow(color:Color(0x77000000),blurRadius:28,offset:Offset(0,12))]);
  Widget _pinkButton(String label,VoidCallback? onPressed,{double height=62})=>SizedBox(width:double.infinity,height:height,child:FilledButton(onPressed:onPressed,style:FilledButton.styleFrom(backgroundColor:const Color(0xFFFF2E9A),disabledBackgroundColor:const Color(0x88FF2E9A),foregroundColor:Colors.white,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(height/2))),child:Row(mainAxisAlignment:MainAxisAlignment.center,children:[Text(label,style:TextStyle(fontSize:height<55?18:20,fontWeight:FontWeight.w900)),const SizedBox(width:12),Icon(Icons.arrow_forward_rounded,size:height<55?24:28)])));
}

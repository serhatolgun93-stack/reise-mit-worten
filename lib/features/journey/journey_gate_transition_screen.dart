import 'dart:async';

import 'package:flutter/material.dart';

import 'journey_dashboard_screen.dart';

class JourneyGateTransitionScreen extends StatefulWidget {
  final String name;
  final String language;
  final String flag;
  final String guideName;
  final String guideKey;
  final String backgroundAsset;

  const JourneyGateTransitionScreen({super.key,required this.name,required this.language,required this.flag,required this.guideName,required this.guideKey,required this.backgroundAsset});
  @override State<JourneyGateTransitionScreen> createState()=>_JourneyGateTransitionScreenState();
}

class _JourneyGateTransitionScreenState extends State<JourneyGateTransitionScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _open;
  Timer? _finishTimer;
  String get _destinationAsset {if(widget.language=='Türkçe')return 'assets/backgrounds/gate_turkish.jpg';if(widget.language=='Ελληνικά')return 'assets/backgrounds/gate_greek.jpg';return 'assets/backgrounds/gate_english.jpg';}

  @override void initState(){super.initState();_controller=AnimationController(vsync:this,duration:const Duration(milliseconds:3400));_open=CurvedAnimation(parent:_controller,curve:Curves.easeInOutCubic);Future<void>.delayed(const Duration(milliseconds:800),(){if(mounted)_controller.forward();});_finishTimer=Timer(const Duration(milliseconds:4800),_finish);}
  @override void dispose(){_finishTimer?.cancel();_controller.dispose();super.dispose();}
  void _finish(){if(!mounted)return;Navigator.of(context).pushReplacement(PageRouteBuilder<void>(transitionDuration:const Duration(milliseconds:650),pageBuilder:(_,animation,__)=>FadeTransition(opacity:animation,child:JourneyDashboardScreen(name:widget.name,language:widget.language,flag:widget.flag,guideName:widget.guideName,guideKey:widget.guideKey,backgroundAsset:widget.backgroundAsset))));}

  @override Widget build(BuildContext context){final size=MediaQuery.sizeOf(context),landscape=size.width>size.height;return Scaffold(backgroundColor:const Color(0xFF07070A),body:Stack(fit:StackFit.expand,children:[Image.asset(_destinationAsset,fit:BoxFit.cover,alignment:Alignment.center,filterQuality:FilterQuality.high,errorBuilder:(_,__,___)=>Image.asset(widget.backgroundAsset,fit:BoxFit.cover,alignment:Alignment.center)),AnimatedBuilder(animation:_open,builder:(_,__)=>_GateScene(openAmount:_open.value,destinationAsset:_destinationAsset)),SafeArea(child:Padding(padding:EdgeInsets.fromLTRB(landscape?24:18,landscape?10:16,landscape?24:18,landscape?12:20),child:Column(children:[Row(children:[const Icon(Icons.travel_explore_rounded,color:Colors.white,size:28),const SizedBox(width:8),const Expanded(child:Text('Reise mit Worten',style:TextStyle(color:Colors.white,fontSize:19,fontWeight:FontWeight.w900))),Text('${widget.flag} ${widget.language}',style:const TextStyle(color:Colors.white,fontSize:14,fontWeight:FontWeight.w800))]),const Spacer(),AnimatedOpacity(opacity:_open.value>.92?0:1,duration:const Duration(milliseconds:300),child:Container(constraints:BoxConstraints(maxWidth:landscape?560:520),padding:EdgeInsets.symmetric(horizontal:landscape?24:20,vertical:landscape?9:12),decoration:BoxDecoration(color:const Color(0xB8141318),borderRadius:BorderRadius.circular(30),border:Border.all(color:const Color(0x55FFFFFF))),child:Text(_open.value>.42?'Deine Reise beginnt, ${widget.name}.':'Das Tor zu deiner neuen Sprache öffnet sich …',textAlign:TextAlign.center,style:TextStyle(color:Colors.white,fontSize:landscape?14.5:16.5,fontWeight:FontWeight.w800))))])))]));}
}

class _GateScene extends StatelessWidget {
  final double openAmount;
  final String destinationAsset;
  const _GateScene({required this.openAmount,required this.destinationAsset});

  @override Widget build(BuildContext context){final size=MediaQuery.sizeOf(context);final landscape=size.width>size.height;final p=Curves.easeInOutCubic.transform(openAmount);final gateOpacity=(1-((p-.88)/.12).clamp(0.0,1.0));final slitOpacity=((p-.02)/.10).clamp(0.0,1.0)*(1-((p-.16)/.14).clamp(0.0,1.0));return Opacity(opacity:gateOpacity,child:Stack(fit:StackFit.expand,children:[Image.asset('assets/journey_gate.png',fit:BoxFit.cover,alignment:Alignment.center,filterQuality:FilterQuality.high),ClipPath(clipper:_OpeningClipper(progress:p,landscape:landscape),child:Image.asset(destinationAsset,fit:BoxFit.cover,alignment:Alignment.center,filterQuality:FilterQuality.high)),if(slitOpacity>0)Center(child:FractionallySizedBox(widthFactor:.004,heightFactor:landscape?.56:.49,child:Opacity(opacity:slitOpacity,child:const DecoratedBox(decoration:BoxDecoration(color:Color(0xFFFFE6AE),boxShadow:[BoxShadow(color:Color(0xAAFFD36A),blurRadius:12,spreadRadius:3)])))))]));}
}

class _OpeningClipper extends CustomClipper<Path>{final double progress;final bool landscape;const _OpeningClipper({required this.progress,required this.landscape});@override Path getClip(Size size){final center=size.width/2;final top=size.height*(landscape?.315:.325);final bottom=size.height*(landscape?.885:.865);final maxHalf=size.width*(landscape?.29:.36);final half=(2+maxHalf*progress);return Path()..addRect(Rect.fromLTRB(center-half,top,center+half,bottom));}@override bool shouldReclip(covariant _OpeningClipper old)=>old.progress!=progress||old.landscape!=landscape;}

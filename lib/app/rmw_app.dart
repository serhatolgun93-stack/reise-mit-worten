import 'package:flutter/material.dart';
import '../features/home/home_screen.dart';
import '../features/recovery/recovery_screen.dart';
import 'bootstrap/bootstrap_result.dart';
import 'environment/app_environment.dart';
class RmwApp extends StatelessWidget { final BootstrapResult bootstrapResult; const RmwApp({super.key,required this.bootstrapResult}); @override Widget build(BuildContext context)=>MaterialApp(title:'Reise mit Worten',debugShowCheckedModeBanner:false,home:switch(bootstrapResult){BootstrapSuccess(:final environment,:final localProfileId)=>HomeScreen(showBuildLabel:environment.environment!=AppEnvironment.production,localProfileId:localProfileId.value),BootstrapFailure(:final errorCode)=>RecoveryScreen(errorCode:errorCode)}); }

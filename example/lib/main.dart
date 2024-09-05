import 'package:flutter/material.dart';
import 'package:audio_chat/audio_chat.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  List<String> audios = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Audio Chat"),),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: audios.length,
                itemBuilder: (context,index){
                return AudioBubble(filepath: audios[index]);
              },),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                        decoration: const ShapeDecoration(
                          shape: StadiumBorder(side: BorderSide(color: Colors.grey,width: 0.8)),
                          color: Colors.white,
                        ),
                      child: const TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.emoji_emotions),
                          border: InputBorder.none,
                          hintText: 'Message'
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  RecordButton(onAudioRecorded: (path){
                if(path != null) {
                  audios.add(path);
                  setState(() {
                    
                  });
                }
              },),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}

// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:iwill/feature.dart';
import 'package:iwill/openai_service.dart';
import 'package:iwill/pallete.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
// import 'package:text_to_speech/text_to_speech.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final speechToText=SpeechToText();
  FlutterTts flutterTts = FlutterTts();
  String lastWords='';
  String? generatedContent;
  String? generatedImageUrl;
  final OpenAIService openAIService=OpenAIService();
  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {

    });
  }
  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {
    });
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  Future<void> onSpeechResult(SpeechRecognitionResult result) async {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Allen'),
        leading: Icon(Icons.menu),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //virtual assistance image
            Stack(
              children: [
                Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    margin: EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: Pallete.assistantCircleColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: 123,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: AssetImage('assets/images/virtualAssistant.png')),
                    ),
                  ),
                )
              ],
            ),


            //chat bubble
            Visibility(
              visible: generatedImageUrl==null,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    generatedContent==null ? 'Good Morning, what can I do for you 🖤?' : generatedContent!,
                    style: TextStyle(
                      color: Pallete.mainFontColor,
                      fontSize: 20,
                      fontFamily: 'Cera Pro',
                    ),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                margin: EdgeInsets.symmetric(horizontal: 40).copyWith(
                  top: 30,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Pallete.borderColor,
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )
                ),
              ),
            ),
            if(generatedImageUrl!=null)
            Padding(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                  child: Image.network(generatedImageUrl!),
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            Visibility(
              visible: generatedContent==null && generatedImageUrl==null,
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 10,left: 22),
                alignment: Alignment.centerLeft,
                child: Text('Here are a few feature',
                style: TextStyle(
                  fontFamily: 'Cera Pro',
                  color: Pallete.mainFontColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                ),
              ),
            ),
            Visibility(
              visible: generatedContent==null && generatedImageUrl==null,
              child: Column(
                children: [
                  FeatureBox(
                    color: Pallete.firstSuggestionBoxColor,
                    headerText: 'Chat GPT',
                    descText: 'A smarter way to stay organized and informed with ChatGPT ',
                  ),
                  FeatureBox(
                      color: Pallete.secondSuggestionBoxColor,
                      headerText: 'Dall-E',
                      descText: 'Get inspired and stay creative with your perosnal assistant powered by Dall-E',
                  ),
                  FeatureBox(
                    color: Pallete.thirdSuggestionBoxColor,
                    headerText: 'Smart Voice Assistant',
                    descText: 'Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.firstSuggestionBoxColor,
        onPressed: () async {
          if(await speechToText.hasPermission && speechToText.isNotListening)
            {
              await startListening();
            }
          else if(speechToText.isListening){
            final speech = await openAIService.isArtPromptAPI(lastWords);
            if(speech.contains('https')){
              generatedImageUrl=speech;

              generatedContent=null;
              setState(() {

              });
            }
            else{
                generatedImageUrl=null;
                generatedContent=speech;
                setState(() {

                });
                await systemSpeak(speech);
              }



            await stopListening();
            print(lastWords);
          }
          else{
            initSpeechToText();
          }
        },
        child: Icon(speechToText.isListening?Icons.stop:Icons.mic),
      ),
    );
  }
}
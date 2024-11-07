// speech_translation_helper.dart
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';

class SpeechTranslationHelper {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final GoogleTranslator translator = GoogleTranslator();

  bool _isListening = false;
  String _spokenText = '';

  Future<void> startListening(Function(String) onResult) async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        _isListening = true;
        _speech.listen(onResult: (result) {
          onResult(result.recognizedWords);
        });
      }
    }
  }

  void stopListening() {
    _isListening = false;
    _speech.stop();
  }

  Future<String> translateText(
      String text, String fromLang, String toLang) async {
    if (text.isNotEmpty) {
      final translation =
          await translator.translate(text, from: fromLang, to: toLang);
      return translation.text;
    }
    return '';
  }
}

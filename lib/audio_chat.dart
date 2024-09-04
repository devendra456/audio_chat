import 'audio_chat_platform_interface.dart';

export 'src/widgets/audio_bubble.dart';
export 'src/widgets/record_button.dart';

class AudioChat {
  Future<String?> getPlatformVersion() {
    return AudioChatPlatform.instance.getPlatformVersion();
  }
}

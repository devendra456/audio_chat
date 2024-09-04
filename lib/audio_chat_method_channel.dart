import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'audio_chat_platform_interface.dart';

/// An implementation of [AudioChatPlatform] that uses method channels.
class MethodChannelAudioChat extends AudioChatPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('audio_chat');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}

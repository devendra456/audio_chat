import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'audio_chat_method_channel.dart';

abstract class AudioChatPlatform extends PlatformInterface {
  /// Constructs a AudioChatPlatform.
  AudioChatPlatform() : super(token: _token);

  static final Object _token = Object();

  static AudioChatPlatform _instance = MethodChannelAudioChat();

  /// The default instance of [AudioChatPlatform] to use.
  ///
  /// Defaults to [MethodChannelAudioChat].
  static AudioChatPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AudioChatPlatform] when
  /// they register themselves.
  static set instance(AudioChatPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}

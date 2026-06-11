import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../models/mock_data.dart';

class CommunityProvider extends ChangeNotifier {
  final List<CommunityModel> _communities = List.from(MockData.communities);
  final Map<String, List<MessageModel>> _messages = {};

  List<CommunityModel> get allCommunities => _communities;
  List<CommunityModel> get joinedCommunities =>
      _communities.where((c) => c.isJoined).toList();

  List<MessageModel> getMessages(String communityId) {
    _messages[communityId] ??= MockData.getMessages(communityId);
    return _messages[communityId]!;
  }

  void toggleJoin(String communityId) {
    final idx = _communities.indexWhere((c) => c.id == communityId);
    if (idx != -1) {
      _communities[idx].isJoined = !_communities[idx].isJoined;
      notifyListeners();
    }
  }

  void sendMessage(String communityId, String content, UserModel sender) {
    _messages[communityId] ??= MockData.getMessages(communityId);
    _messages[communityId]!.add(MessageModel(
      id: 'm_${DateTime.now().millisecondsSinceEpoch}',
      senderId: sender.id,
      senderName: sender.fullName,
      senderInitials: sender.initials,
      content: content,
      timestamp: DateTime.now(),
      isMe: true,
    ));
    final idx = _communities.indexWhere((c) => c.id == communityId);
    if (idx != -1) _communities[idx].lastMessage = content;
    notifyListeners();
  }
}

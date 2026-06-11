import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/community_provider.dart';
import '../../providers/profile_provider.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';

class ChatRoomScreen extends StatefulWidget {
  final CommunityModel community;
  const ChatRoomScreen({super.key, required this.community});
  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _msgCtrl = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() { _msgCtrl.dispose(); _scroll.dispose(); super.dispose(); }

  void _send() {
    if (_msgCtrl.text.trim().isEmpty) return;
    final user = context.read<ProfileProvider>().user!;
    context.read<CommunityProvider>().sendMessage(widget.community.id, _msgCtrl.text.trim(), user);
    _msgCtrl.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) _scroll.animateTo(_scroll.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  String _fmt(DateTime t) => '${t.hour.toString().padLeft(2,'0')}:${t.minute.toString().padLeft(2,'0')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18), onPressed: () => Navigator.pop(context)),
        title: Row(children: [
          CircleAvatar(radius: 16,
            backgroundColor: Color(int.parse(widget.community.avatarColor.replaceFirst('#', 'FF'), radix: 16)),
            child: Text(widget.community.name[0], style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(widget.community.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            Text('${widget.community.memberCount} members', style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
          ])),
        ]),
      ),
      body: Column(children: [
        Expanded(child: Consumer<CommunityProvider>(builder: (_, cp, __) {
          final messages = cp.getMessages(widget.community.id);
          return ListView.builder(
            controller: _scroll, padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (_, i) {
              final msg = messages[i];
              final showAvatar = i == 0 || messages[i - 1].senderId != msg.senderId;
              return _Bubble(message: msg, showAvatar: showAvatar, time: _fmt(msg.timestamp));
            },
          );
        })),
        Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
          decoration: const BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(color: AppColors.divider, width: 0.5))),
          child: Row(children: [
            Expanded(child: TextField(
              controller: _msgCtrl,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Message ${widget.community.name}...',
                hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                filled: true, fillColor: AppColors.surfaceLight,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
              ),
              onSubmitted: (_) => _send(),
            )),
            const SizedBox(width: 8),
            GestureDetector(onTap: _send, child: Container(
              width: 40, height: 40,
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: const Icon(Icons.send, color: Colors.white, size: 18),
            )),
          ]),
        ),
      ]),
    );
  }
}

class _Bubble extends StatelessWidget {
  final MessageModel message; final bool showAvatar; final String time;
  const _Bubble({required this.message, required this.showAvatar, required this.time});

  @override
  Widget build(BuildContext context) {
    if (message.isMe) {
      return Padding(padding: const EdgeInsets.only(bottom: 6),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: const BoxDecoration(color: AppColors.primary,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(4), bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))),
              child: Text(message.content, style: const TextStyle(color: Colors.white, fontSize: 14))),
            const SizedBox(height: 2),
            Text(time, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
          ]),
        ]));
    }
    return Padding(padding: const EdgeInsets.only(bottom: 6),
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        showAvatar
            ? CircleAvatar(radius: 14, backgroundColor: AppColors.surfaceLight,
                child: Text(message.senderInitials, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold)))
            : const SizedBox(width: 28),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (showAvatar) Padding(padding: const EdgeInsets.only(bottom: 3),
              child: Text(message.senderName, style: const TextStyle(color: AppColors.textMuted, fontSize: 11))),
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(color: AppColors.surface,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(16), bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))),
            child: Text(message.content, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14))),
          const SizedBox(height: 2),
          Text(time, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
        ]),
      ]));
  }
}

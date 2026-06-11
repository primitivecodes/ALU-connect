import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/feed_provider.dart';
import '../../providers/profile_provider.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});
  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _seatsCtrl = TextEditingController();
  EventCategory _category = EventCategory.events;
  bool _isLoading = false;

  @override
  void dispose() { _titleCtrl.dispose(); _descCtrl.dispose(); _locationCtrl.dispose(); _seatsCtrl.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (_titleCtrl.text.isEmpty || _descCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in title and description.'), backgroundColor: AppColors.error));
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    final user = context.read<ProfileProvider>().user!;
    context.read<FeedProvider>().addEvent(EventModel(
      id: 'e_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleCtrl.text.trim(), organiser: user.fullName,
      description: _descCtrl.text.trim(), date: 'Jul 2026', time: '10:00 AM',
      location: _locationCtrl.text.isEmpty ? 'ALU Campus' : _locationCtrl.text.trim(),
      category: _category, tag: _category.categoryLabel,
      totalSeats: int.tryParse(_seatsCtrl.text) ?? 50,
    ));
    setState(() => _isLoading = false);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Post published!'), backgroundColor: AppColors.success));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Create Opportunity'),
        leading: IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context)),
        actions: [TextButton(onPressed: _submit, child: const Text('Publish', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)))],
      ),
      body: SingleChildScrollView(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Category', style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        SizedBox(height: 40, child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: EventCategory.values.where((c) => c != EventCategory.all).length,
          itemBuilder: (_, i) {
            final cats = EventCategory.values.where((c) => c != EventCategory.all).toList();
            return CategoryChip(label: cats[i].categoryLabel, selected: _category == cats[i], onTap: () => setState(() => _category = cats[i]));
          },
        )),
        const SizedBox(height: 20),
        _Field(label: 'Title', hint: 'e.g. Annual Leadership Summit', controller: _titleCtrl),
        const SizedBox(height: 16),
        _Field(label: 'Description', hint: 'Tell students what this is about...', controller: _descCtrl, maxLines: 4),
        const SizedBox(height: 16),
        _Field(label: 'Location', hint: 'e.g. ALU Kigali Campus, Room 204', controller: _locationCtrl),
        const SizedBox(height: 16),
        _Field(label: 'Available Seats', hint: '50', controller: _seatsCtrl, keyboard: TextInputType.number),
        const SizedBox(height: 32),
        PrimaryButton(label: 'Publish Opportunity', onPressed: _submit, isLoading: _isLoading),
      ])),
    );
  }
}

class _Field extends StatelessWidget {
  final String label, hint; final TextEditingController controller;
  final int maxLines; final TextInputType keyboard;
  const _Field({required this.label, required this.hint, required this.controller, this.maxLines = 1, this.keyboard = TextInputType.text});
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
      const SizedBox(height: 6),
      TextField(controller: controller, maxLines: maxLines, keyboardType: keyboard,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
        decoration: InputDecoration(hintText: hint)),
    ]);
  }
}

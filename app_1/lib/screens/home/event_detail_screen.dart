import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/feed_provider.dart';
import '../../providers/profile_provider.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class EventDetailScreen extends StatelessWidget {
  final EventModel event;
  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 200, pinned: true, backgroundColor: AppColors.background,
          leading: IconButton(
            icon: Container(padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.white)),
            onPressed: () => Navigator.pop(context)),
          flexibleSpace: FlexibleSpaceBar(background: Container(
            decoration: const BoxDecoration(gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF922B21), Color(0xFF1A252F)])),
            child: Center(child: Icon(Icons.event, color: Colors.white.withOpacity(0.3), size: 64)),
          )),
        ),
        SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          TagBadge(label: event.tag),
          const SizedBox(height: 12),
          Text(event.title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('by ${event.organiser}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          const SizedBox(height: 20),
          _InfoRow(icon: Icons.calendar_today_outlined, label: event.date),
          const SizedBox(height: 10),
          _InfoRow(icon: Icons.access_time_outlined, label: event.time),
          const SizedBox(height: 10),
          _InfoRow(icon: Icons.location_on_outlined, label: event.location),
          const SizedBox(height: 10),
          _InfoRow(icon: Icons.people_outline, label: '${event.registeredCount} registered · ${event.seatsLeft} seats left'),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Capacity', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
            Text('${event.registeredCount}/${event.totalSeats}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 6),
          ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(
            value: event.registeredCount / event.totalSeats,
            backgroundColor: AppColors.surfaceLight,
            valueColor: AlwaysStoppedAnimation(event.seatsLeft < 10 ? AppColors.warning : AppColors.primary),
            minHeight: 6,
          )),
          const SizedBox(height: 24),
          const Text('About this event', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(event.description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, height: 1.6)),
          const SizedBox(height: 32),
          Consumer2<ProfileProvider, FeedProvider>(builder: (_, profile, feed, __) {
            final rsvped = profile.user?.rsvpedEventIds.contains(event.id) ?? false;
            if (event.isFull && !rsvped) {
              return Container(width: double.infinity, height: 50,
                decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(10)),
                child: const Center(child: Text('Event Full', style: TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.w600))));
            }
            return PrimaryButton(
              label: rsvped ? '✓ Registered — Cancel RSVP' : 'RSVP — Register Now',
              onPressed: () {
                if (rsvped) { profile.toggleRsvp(event.id); feed.cancelRsvp(event.id); }
                else { profile.toggleRsvp(event.id); feed.rsvpEvent(event.id); }
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(rsvped ? 'RSVP cancelled' : 'You\'re registered for ${event.title}!'),
                  backgroundColor: rsvped ? AppColors.textMuted : AppColors.success,
                  duration: const Duration(seconds: 2),
                ));
              },
            );
          }),
          const SizedBox(height: 24),
        ]))),
      ]),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon; final String label;
  const _InfoRow({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, color: AppColors.primary, size: 16),
      const SizedBox(width: 8),
      Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
    ]);
  }
}

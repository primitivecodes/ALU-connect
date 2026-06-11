import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../models/mock_data.dart';

class FeedProvider extends ChangeNotifier {
  final List<EventModel> _events = List.from(MockData.events);
  EventCategory _selectedCategory = EventCategory.all;
  bool _isLoading = false;

  List<EventModel> get allEvents => _events;
  EventCategory get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  List<EventModel> get filteredEvents {
    if (_selectedCategory == EventCategory.all) return _events;
    return _events.where((e) => e.category == _selectedCategory).toList();
  }

  EventModel? get featuredEvent =>
      _events.firstWhere((e) => e.isFeatured, orElse: () => _events.first);

  void setCategory(EventCategory cat) {
    _selectedCategory = cat;
    notifyListeners();
  }

  void rsvpEvent(String eventId) {
    final idx = _events.indexWhere((e) => e.id == eventId);
    if (idx != -1 && !_events[idx].isFull) {
      _events[idx].registeredCount++;
      notifyListeners();
    }
  }

  void cancelRsvp(String eventId) {
    final idx = _events.indexWhere((e) => e.id == eventId);
    if (idx != -1 && _events[idx].registeredCount > 0) {
      _events[idx].registeredCount--;
      notifyListeners();
    }
  }

  void addEvent(EventModel event) {
    _events.insert(0, event);
    notifyListeners();
  }

  Future<void> refresh() async {
    _isLoading = true; notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _isLoading = false; notifyListeners();
  }
}

import 'models.dart';

class MockData {
  static final List<EventModel> events = [
    EventModel(
      id: 'e1', title: 'Master Class Internship',
      organiser: 'ALU Career Services',
      description: 'Join the exclusive Masterclass internship programme — designed to give ALU students the practical career skills needed to thrive in todays workplace.',
      date: 'Jun 24, 2026', time: '10:00 AM', location: 'ALU Kigali Campus',
      category: EventCategory.internships, tag: 'Internship',
      totalSeats: 50, registeredCount: 32, imageColor: '#C0392B', isFeatured: true,
    ),
    EventModel(
      id: 'e2', title: 'Global Leadership Workshop',
      organiser: 'Leadership Club',
      description: 'A full-day immersive leadership workshop covering conflict resolution, strategic thinking, and public speaking.',
      date: 'Jun 24, 2026', time: '09:00 AM', location: 'Room 204, ALU',
      category: EventCategory.workshops, tag: 'Workshop',
      totalSeats: 40, registeredCount: 15, imageColor: '#2C3E50',
    ),
    EventModel(
      id: 'e3', title: 'Pan-African Tech Summit',
      organiser: 'Tech & Innovation Hub',
      description: 'Connect with tech leaders across Africa. Panels, demos, and networking across 2 days.',
      date: 'Jun 25, 2026', time: '08:00 AM', location: 'Convention Centre, Kigali',
      category: EventCategory.events, tag: 'Technology',
      totalSeats: 200, registeredCount: 143, imageColor: '#1A252F',
    ),
    EventModel(
      id: 'e4', title: 'ALU Hackathon 2026 — Build For Africa',
      organiser: 'ALU Innovation Club',
      description: 'A 48-hour hackathon to build solutions for African challenges. Form a team and compete for prizes up to \$5,000.',
      date: 'Jul 2, 2026', time: '06:00 PM', location: 'ALU Campus + Online',
      category: EventCategory.hackathons, tag: 'Hackathon',
      totalSeats: 120, registeredCount: 88, imageColor: '#922B21',
    ),
    EventModel(
      id: 'e5', title: 'Social Impact Hackathon',
      organiser: 'Social Impact Team',
      description: 'Build tech solutions that address social challenges facing communities across Rwanda and East Africa.',
      date: 'Jul 10, 2026', time: '09:00 AM', location: 'ALU Kigali',
      category: EventCategory.hackathons, tag: 'Hackathon',
      totalSeats: 80, registeredCount: 34, imageColor: '#1E8449',
    ),
    EventModel(
      id: 'e6', title: 'Mastercard Foundation Internship',
      organiser: 'Mastercard Foundation',
      description: 'Apply now — Mastercard Foundation is offering paid internships to ALU students across multiple tracks.',
      date: 'Jul 15, 2026', time: '12:00 PM', location: 'Remote / Kigali',
      category: EventCategory.internships, tag: 'Internship',
      totalSeats: 30, registeredCount: 29, imageColor: '#1A5276',
    ),
    EventModel(
      id: 'e7', title: 'African Arts Collective',
      organiser: 'Arts Club',
      description: 'Showcasing emerging student artists. An evening of music, visual art, spoken word, and community.',
      date: 'Jun 28, 2026', time: '05:00 PM', location: 'ALU Courtyard',
      category: EventCategory.events, tag: 'Community',
      totalSeats: 150, registeredCount: 72, imageColor: '#6C3483',
    ),
    EventModel(
      id: 'e8', title: 'ALU Climate Action Summit',
      organiser: 'Climate Action Club',
      description: 'A day-long summit on climate policy, green entrepreneurship, and environmental activism.',
      date: 'Jul 5, 2026', time: '09:00 AM', location: 'ALU Campus',
      category: EventCategory.leadership, tag: 'Leadership',
      totalSeats: 60, registeredCount: 41, imageColor: '#117A65',
    ),
  ];

  static final List<CommunityModel> communities = [
    CommunityModel(id: 'c1', name: 'ALU Debate Society', description: 'Weekly debates on African politics, business and society. All levels welcome.', category: 'Leadership', memberCount: 124, isJoined: true, lastMessage: 'Meeting this Friday at 4PM!', lastMessageTime: '2h ago', unreadCount: 3, avatarColor: '#C0392B'),
    CommunityModel(id: 'c2', name: 'Entrepreneurship Club', description: 'Build, pitch, and grow your startup with fellow ALU entrepreneurs.', category: 'Entrepreneurship', memberCount: 89, lastMessage: 'Pitch night is next Tuesday 🚀', lastMessageTime: '5h ago', avatarColor: '#E67E22'),
    CommunityModel(id: 'c3', name: 'UTG Study Group', description: 'Collaborative studying, past papers, and peer tutoring for all modules.', category: 'Academic', memberCount: 56, isJoined: true, lastMessage: 'Thanks for the notes today!', lastMessageTime: '1d ago', avatarColor: '#2980B9'),
    CommunityModel(id: 'c4', name: 'Women in Leadership', description: 'Empowering women at ALU through mentorship, networking, and leadership programmes.', category: 'Leadership', memberCount: 203, lastMessage: 'New mentorship applications open!', lastMessageTime: '3h ago', avatarColor: '#8E44AD'),
    CommunityModel(id: 'c5', name: 'Tech & Innovation Hub', description: 'Builders, coders, designers — if you make things, you belong here.', category: 'Technology', memberCount: 178, isJoined: true, lastMessage: 'Hackathon team sign-ups are live!', lastMessageTime: '30m ago', unreadCount: 7, avatarColor: '#1ABC9C'),
    CommunityModel(id: 'c6', name: 'ALU Climate Action', description: 'Student-led climate activism, green projects, and environmental policy discussions.', category: 'Social Impact', memberCount: 67, lastMessage: 'Summit prep — who is presenting?', lastMessageTime: '6h ago', avatarColor: '#27AE60'),
    CommunityModel(id: 'c7', name: 'African Arts Collective', description: 'A creative space for ALU artists, musicians, writers, and performers.', category: 'Arts', memberCount: 91, lastMessage: 'Gallery submissions close Sunday', lastMessageTime: '1d ago', avatarColor: '#D35400'),
  ];

  static List<MessageModel> getMessages(String communityId) => [
    MessageModel(id: 'm1', senderId: 'u2', senderName: 'Amara Diallo', senderInitials: 'AD', content: 'Hey everyone! Who is joining the hackathon this weekend?', timestamp: DateTime.now().subtract(const Duration(hours: 2)), isMe: false),
    MessageModel(id: 'm2', senderId: 'u1', senderName: 'You', senderInitials: 'KU', content: 'I am in! Already registered with my team.', timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)), isMe: true),
    MessageModel(id: 'm3', senderId: 'u3', senderName: 'Kofi Mensah', senderInitials: 'KM', content: 'Same! We are building a fintech solution. Looking for a designer if anyone is interested.', timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)), isMe: false),
    MessageModel(id: 'm4', senderId: 'u4', senderName: 'Fatima Nour', senderInitials: 'FN', content: 'I can help with design! Send me the details.', timestamp: DateTime.now().subtract(const Duration(hours: 1)), isMe: false),
    MessageModel(id: 'm5', senderId: 'u2', senderName: 'Amara Diallo', senderInitials: 'AD', content: 'Meeting this Friday at 4PM in Room 204 to prep. Everyone come!', timestamp: DateTime.now().subtract(const Duration(minutes: 30)), isMe: false),
    MessageModel(id: 'm6', senderId: 'u1', senderName: 'You', senderInitials: 'KU', content: 'Will be there 👍', timestamp: DateTime.now().subtract(const Duration(minutes: 10)), isMe: true),
  ];

  static final List<IdeaModel> ideas = [
    IdeaModel(id: 'i1', title: 'AgriConnect Rwanda', description: 'A mobile platform connecting smallholder farmers directly to urban buyers, cutting out middlemen and increasing farmer income by 40%.', authorName: 'Uwimana Jean', authorInitials: 'UJ', skills: ['Flutter', 'Backend', 'Agri'], backerCount: 12, stage: 'MVP', domain: 'AgriTech'),
    IdeaModel(id: 'i2', title: 'MentalSpace Africa', description: 'Anonymous peer-support and professional therapy matching for African university students dealing with academic pressure.', authorName: 'Amara Diallo', authorInitials: 'AD', skills: ['UI/UX', 'React', 'Psychology'], backerCount: 24, isBacked: true, stage: 'Idea', domain: 'HealthTech'),
    IdeaModel(id: 'i3', title: 'EduBridge AI', description: 'AI-powered tutoring that adapts to each student learning style, available in Kinyarwanda, French, and English.', authorName: 'Kofi Mensah', authorInitials: 'KM', skills: ['AI/ML', 'EdTech', 'NLP'], backerCount: 31, stage: 'Prototype', domain: 'EdTech'),
    IdeaModel(id: 'i4', title: 'GreenLogistics', description: 'Carbon-neutral last-mile delivery network using electric motorcycles and optimized routing for East African cities.', authorName: 'Fatima Nour', authorInitials: 'FN', skills: ['Logistics', 'Mobile', 'Sustainability'], backerCount: 8, stage: 'Research', domain: 'CleanTech'),
    IdeaModel(id: 'i5', title: 'PayLocal', description: 'Cross-border micro-payment infrastructure for informal traders in East Africa — no smartphone required.', authorName: 'Chioma Obi', authorInitials: 'CO', skills: ['FinTech', 'USSD', 'Backend'], backerCount: 19, stage: 'MVP', domain: 'FinTech'),
  ];
}

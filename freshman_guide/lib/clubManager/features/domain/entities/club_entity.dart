class Club {
  String name;
  String clubManager;
  List<String> members;
  String description;
  List<String>? passedEvents;
  List<String> scheduledEvents;
  String chat;
  String photoUrl;

  
  Club({
    required this.name,
    required this.clubManager,
    required this.members,
    required this.description,
    required this.passedEvents,
    required this.scheduledEvents,
    required this.chat,
    required this.photoUrl,
  });


  factory Club.fromMap(Map<String, dynamic> data) => Club(
        name: data['name'] as String? ?? 'Unnamed Club',
        clubManager: data['ClubManager'] as String? ?? 'Unknown Manager',
        members: (data['memebers'] as List<dynamic>? ?? [])
            .map((item) => item?.toString() ?? '')
            .toList(),
        description: data['description'] as String? ?? 'No description',
        passedEvents: (data['passedEvents'] as List<dynamic>? ?? [])
            .map((item) => item?.toString() ?? '')
            .toList(),
        scheduledEvents: (data['ScheduledEvents'] as List<dynamic>? ?? [])
            .map((item) => item?.toString() ?? '')
            .toList(),
        chat: data['chat'] as String? ?? '',
        photoUrl: data['photoUrl'] as String? ?? '',
      );

 
  Map<String, dynamic> toMap() => {
        'name': name,
        'ClubManager': clubManager,
        'memebers': members,
        'description': description,
        'passedEvents': passedEvents,
        'ScheduledEvents': scheduledEvents,
        'chat': chat,
        'photoUrl': photoUrl,
      };
}

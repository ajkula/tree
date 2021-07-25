class ScheduleTracker {
  String name;
  int lastDone;
  int deadLine;
  int startKm;

  ScheduleTracker(this.name, this.lastDone, this.deadLine, this.startKm);

  ScheduleTracker.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        lastDone = json['lastDone'],
        deadLine = json['deadLine'],
        startKm = json['startKm'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'lastDone': lastDone,
        'deadLine': deadLine,
        'startKm': startKm,
      };
}

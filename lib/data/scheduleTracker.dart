class ScheduleTracker {
  String name;
  int lastDone;
  int deadLine;
  int kmCount;
  int baseKm;

  ScheduleTracker(
      this.name, this.lastDone, this.deadLine, this.baseKm, this.kmCount);

  ScheduleTracker.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        lastDone = json['lastDone'],
        deadLine = json['deadLine'],
        kmCount = json['kmCount'],
        baseKm = json['baseKm'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'lastDone': lastDone,
        'deadLine': deadLine,
        'kmCount': kmCount,
        'baseKm': baseKm,
      };
}

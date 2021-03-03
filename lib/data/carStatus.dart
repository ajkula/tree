import 'package:tree/data/scheduleTracker.dart';

class CarStatus {
  int baseKm;
  int actualKm;
  int kmDiff;
  String carName;
  List<ScheduleTracker> scheduleTrackerList;

  CarStatus(this.carName, this.baseKm, this.scheduleTrackerList);

  void setBaseKm(int bk) {
    actualKm = bk;
    scheduleTrackerList.forEach((element) {
      element.baseKm = bk;
    });
  }

  CarStatus.fromJson(Map<String, dynamic> json)
      : carName = json['carName'],
        baseKm = json['baseKm'],
        actualKm = json['actualKm'],
        kmDiff = json['kmDiff'],
        scheduleTrackerList =
            List<ScheduleTracker>.from(json['scheduleTrackerList']);

  Map<String, dynamic> toJson() => {
        'carName': carName,
        'baseKm': baseKm,
        'actualKm': actualKm,
        'kmDiff': kmDiff,
        'scheduleTrackerList': encondeToJson(scheduleTrackerList),
      };

  static List encondeToJson(List<ScheduleTracker> list) {
    List jsonList = List();
    list.map((item) => jsonList.add(item.toJson())).toList();
    return jsonList;
  }

  // static List<ScheduleTracker> decodeJson(List list) {
  //   return list.map((item) => ScheduleTracker.fromJson(item));
  // }
}

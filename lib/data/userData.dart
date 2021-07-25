import 'package:tree/data/carStatus.dart';
import 'package:tree/data/scheduleTracker.dart';

var now = DateTime.now().millisecondsSinceEpoch;
var today = new DateTime.now();
var twoYearsFromToday =
    today.add(new Duration(days: 365 * 2)).millisecondsSinceEpoch;

List<ScheduleTracker> baseMaintenanceNamesList() {
  return [
    new ScheduleTracker("Contrôle technique", now, twoYearsFromToday, 0),
    new ScheduleTracker("Révision", now, twoYearsFromToday, 0),
    new ScheduleTracker("Courroie", now, twoYearsFromToday, 0),
    new ScheduleTracker("Vidange", now, twoYearsFromToday, 0),
    new ScheduleTracker("Freins", now, twoYearsFromToday, 0),
    new ScheduleTracker("Filtres huile", now, twoYearsFromToday, 0),
    new ScheduleTracker("Filtre carburant", now, twoYearsFromToday, 0),
    new ScheduleTracker("Filtre habitacle", now, twoYearsFromToday, 0),
    new ScheduleTracker("Pneus", now, twoYearsFromToday, 0),
  ];
}

class User {
  String id = r'car&care';
  List<String> carNames = [];
  Map cars = new Map<String, CarStatus>();
  String _selectedCar;
  // Map<String, CarStatus> cars;

  User();

  void addCar(car, distance) {
    if (carNames == null) {
      carNames = [];
    }
    carNames.add(car);
    cars[car] = new CarStatus(car, 1, baseMaintenanceNamesList());
    cars[car].setBaseKm(distance);
    print("this.carNames " + carNames.toString());
    print(cars[car].toJson());
  }

  void makeBaseKm(int distance) {}

  void removeCar(value) {
    carNames.remove(value);
    cars.remove(value);
  }

  String getSelectedCar() {
    return _selectedCar;
  }

  void selectCar(String car) {
    _selectedCar = car;
  }

  Map<String, dynamic> _mapToJSON(Map<String, CarStatus> carsMap) {
    Map<String, dynamic> json = {};
    carsMap.forEach((key, value) {
      json[key] = value.toJson();
    });
    return json;
  }

  User.fromJson(Map<String, dynamic> json)
      : carNames = json['carNames'] != null
            ? List<String>.from(json['carNames'])
            : null,
        cars = json['cars'] != null
            ? Map<String, CarStatus>.from(json['cars'])
            : null,
        _selectedCar = json['_selectedCar'],
        id = json['id'];

  Map<String, dynamic> toJson() => {
        'carNames': carNames,
        'cars': _mapToJSON(cars),
        'id': id,
        '_selectedCar': _selectedCar,
      };
}

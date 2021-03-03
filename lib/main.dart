import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tree/components/components.dart';
import 'package:tree/data/carStatus.dart';
import 'package:tree/data/scheduleTracker.dart';
import 'package:tree/data/userData.dart';
import 'package:tree/data/dataStorage.dart';

const appTitle = "Tree";
var boldGrey = TextStyle(
    color: Colors.grey[800], fontWeight: FontWeight.bold, fontSize: 40);
DataStorage data = DataStorage();

void main() async {
  User user = User();

  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Reducer(user),
      child: App(),
    ),
  );
}

// User getStoredUser() {
//   print(data.getUser());
//   print(User.fromJson(data.getUser()));
//   return data.getUser() ? User.fromJson(data.getUser()) : User();
// }

class Reducer with ChangeNotifier {
  //  getUser()
  // User user = getStoredUser();
  User user;

  Reducer(this.user);

  void addCar(car, distance) {
    user.addCar(car, distance);
    user.cars[car].actualKm = distance;
    print("user.toJson() " + (user.toJson()).toString());
    data.saveUser(user);
    notifyListeners();
  }

  void removeCar(value) {
    user.removeCar(value);
    notifyListeners();
  }

  CarStatus getCurrentCarObject() {
    return user.cars[user.getSelectedCar()];
  }

  String getCarName() {
    // print(new User.fromJson(data.getUser()));
    return user.getSelectedCar();
  }

  seletCar(BuildContext context, car) {
    user.selectCar(car);
    notifyListeners();
  }

  double fillKmBar(ScheduleTracker schedule) {
    CarStatus car = user.cars[user.getSelectedCar()];
    print(car.actualKm);
    schedule.kmCount = schedule.baseKm - car.actualKm;
    return schedule.kmCount / 20000;
  }

  double fillTimerBar(ScheduleTracker schedule) {
    // CarStatus car = user.cars[user.getSelectedCar()];
    var maxTime = schedule.deadLine - schedule.lastDone;
    print("schedule.deadLine " + schedule.deadLine.toString());
    print("schedule.lastDone " + schedule.lastDone.toString());
    print("maxTime " + maxTime.toString());
    var now = schedule.deadLine - DateTime.now().millisecondsSinceEpoch;
    print("now " + now.toString());
    var spent = maxTime - now;
    print("spent " + spent.toString());
    print("% " + (spent / maxTime).toString());
    return spent / maxTime;
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: ThemeData(
        primarySwatch: (Colors.orange),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'Open Sans',
              bodyColor: Colors.black54,
              fontSizeFactor: 1.6,
              // displayColor: Colors.blueGrey[800],
            ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/newCarForm': (context) =>
            pageHelper(context, appTitle, NewCarState()),
        // '/settings': (context) => Settings()
      },
    );
  }
}

Function alignCenter = (String text) => Center(child: Text(text));

class MainPage extends StatelessWidget {
  _getMaintenancesList(BuildContext context) {
    if (Provider.of<Reducer>(context).getCarName() != null) {
      return Provider.of<Reducer>(context)
          .user
          .cars[Provider.of<Reducer>(context).getCarName()]
          .scheduleTrackerList;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.menu),
        //   tooltip: 'Menu',
        //   onPressed: () {},
        // ),
        actions: <Widget>[
          button(
            tooltip: "This car's settings",
            onPressed: () {},
          ),
        ],
        title: Text(Provider.of<Reducer>(context).getCarName() ?? appTitle),
        centerTitle: true,
      ),
      body: mainCarList(context, _getMaintenancesList(context)),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: UserAccountsDrawerHeader(
                accountEmail: alignCenter(""),
                accountName: alignCenterBold(
                  "Your cars",
                  // boldGrey,
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage("images/header.png"),
                ),
                // decoration: BoxDecoration(
                //   // borderRadius: BorderRadius.circular(5),
                //   border: Border.all(
                //     color: Colors.black,
                //     width: 8,
                //   ),
                //   color: Colors.amber,
                //   shape: BoxShape.rectangle,
                //   image: DecorationImage(
                //       image: AssetImage("images/header.png"),
                //       fit: BoxFit.contain),
                // ),
              ),
            ),
            Expanded(
              flex: 2,
              child: ListView(
                padding: EdgeInsets.zero,
                children: ListTile.divideTiles(
                  context: context,
                  tiles: <Widget>[
                    ListTile(
                      tileColor: Colors.brown[300],
                      title: Center(
                        child: Text(
                          'Tap here',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Open Sans',
                            fontSize: 24,
                          ),
                        ),
                      ),
                      subtitle: Center(child: Text('to add a Car')),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/newCarForm');
                      },
                    ),
                    ...drawerTilesFromCarNames(
                      Provider.of<Reducer>(context).user.carNames,
                      onTap: (car) {
                        // print("CAR TAPPED: " + car);
                        Provider.of<Reducer>(context, listen: false)
                            .seletCar(context, car);
                        Navigator.pop(context);
                        // Navigator.pushNamed(context, '/newCarForm');
                      },
                    ),
                  ],
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// *************************************************************

class NewCarState extends StatelessWidget with ChangeNotifier {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<NewCarState>.
  final _formKey = GlobalKey<FormState>();
  var strCar;
  var intDistance = 0;

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                decoration:
                    InputDecoration(labelText: r"Enter your car's name"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  if (Provider.of<Reducer>(context, listen: false)
                      .user
                      .carNames
                      .contains(value)) {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('$value already exists')));
                    return 'Car already exists';
                  }
                  strCar = value;
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                decoration: InputDecoration(labelText: r"Km to the counter"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the value';
                  }

                  if (int.tryParse(value) == null) {
                    return 'Please enter a number';
                  }

                  intDistance = int.parse(value);
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (_formKey.currentState.validate()) {
                    // If the form is valid, display a Snackbar.

                    Provider.of<Reducer>(context, listen: false)
                        .addCar(strCar, intDistance);
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('New car created!')));
                  }
                },
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget mainCarList(BuildContext context, List elements) {
  String selectedCar = Provider.of<Reducer>(context).getCarName();
  CarStatus currentCar = Provider.of<Reducer>(context).getCurrentCarObject();

  if (selectedCar == null) {
    return alignCenterBold("Create a Car to start");
  }
  // print(elements[0].toJson()); // ************************
  var makeListTile = (item) {
    // print(Provider.of<Reducer>(context).fillTimerBar(item));
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
          border: new Border(
            right: new BorderSide(width: 1.0, color: Colors.white),
          ),
        ),
        child: Icon(makeListIcons(item.name), color: Colors.brown[400]),
      ),
      title: Center(
        child: Text(
          item.name,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
      subtitle: Column(
        children: <Widget>[
          Text(
            "Last time: " +
                DateFormat('yyyy-MM-dd')
                    .format(DateTime.fromMillisecondsSinceEpoch(item.lastDone))
                    .toString(),
            style: TextStyle(fontSize: 18),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child:
                progressBar(Provider.of<Reducer>(context).fillTimerBar(item)),
          ),
          Text(
            "Km since: " + (item.baseKm).toString(),
            style: TextStyle(fontSize: 18),
          ),
          //  ICI LES PROGRESS BARS ET LA DATE...
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: progressBar(
                Provider.of<Reducer>(context).fillKmBar(item) ?? 0.01),
          ),
        ],
      ),
      trailing:
          Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
    );
  };

  var makeCard = (item) {
    return Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.amber),
        child: makeListTile(item),
      ),
    );
  };

  return ListView.builder(
    padding: EdgeInsets.zero,
    itemCount: elements.length,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) {
      return makeCard(elements[index]);
    },
  );
}

IconData makeListIcons(String name) {
  switch (name) {
    case "Contrôle technique":
      return Icons.car_repair;
    case "Révision":
      return Icons.alarm;
    case "Courroie":
      return Icons.miscellaneous_services_outlined;
    case "Vidange":
      return Icons.opacity_outlined;
    case "Freins":
      return Icons.motion_photos_pause_outlined;
    case "Filtres huile":
      return Icons.filter_alt_outlined;
    case "Filtre carburant":
      return Icons.filter_alt;
    case "Filtre habitacle":
      return Icons.airline_seat_recline_extra;
    case "Pneus":
      return Icons.fiber_smart_record_outlined;
    default:
      return Icons.construction_outlined;
  }
}

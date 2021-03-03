import 'package:flutter/material.dart';

Function alignCenterBold = (String text, [TextStyle style]) => Center(
    child: Text(text,
        style: style ??
            TextStyle(
              color: Colors.blueGrey[800],
              fontWeight: FontWeight.w900,
              fontFamily: 'Open Sans',
              fontSize: 24,
            )));

Widget listRepeater(List members) {
  return ListView.builder(
    padding: const EdgeInsets.all(16.0),
    itemCount: members.length,
    itemBuilder: (BuildContext context, int pos) {
      return ListTile(
        title: alignCenterBold("Element: &{pos}"),
      );
    },
  );
}

Widget progressBar(double value) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 2.0),
    child: LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
      value: value,
    ),
  );
}

button(
    {icon = Icons.settings,
    String tooltip = 'Setting Icon',
    Function onPressed}) {
  return IconButton(
    icon: Icon(icon),
    tooltip: tooltip,
    onPressed: onPressed,
  );
}

floatingButton(BuildContext context, callback, {tooltip = "Add"}) {
  FloatingActionButton(
    onPressed: callback,
    // () {
    //   var counter = context.read<reducer>();
    //   counter.increment();
    // },
    tooltip: tooltip,
    child: Icon(Icons.add),
  );
}

Widget pageHelper(BuildContext context, String appTitle, Widget body) {
  return Scaffold(
    appBar: AppBar(
      title: Text(appTitle),
      centerTitle: true,
    ),
    body: body,
  );
}

List<Widget> drawerTilesFromCarNames(List list,
    {Function onTap, Function onLongPress}) {
  return list
      .map((item) => ListTile(
            title: alignCenterBold(item),
            subtitle: alignTileText('Long press to edit'),
            onTap: () {
              if (onTap != null) onTap(item);
              // Navigator.pop(context);
              // Navigator.pushNamed(context, '/settings');
            },
            onLongPress: () {
              if (onLongPress != null) onLongPress(item);
            },
          ))
      .toList();
}

Function alignTileText = (String text) => Center(child: Text(text));

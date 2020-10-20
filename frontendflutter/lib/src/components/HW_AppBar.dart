import 'package:flutter/material.dart';

// System.Obsolete() for now, unless there is a better way of generically having one appbar
// that can be returned and used for all pages/scaffolds
class HWAppBar extends StatelessWidget {
  @override
  final Size preferredSize;

  final String title;

  HWAppBar({
    this.title,
    Key key,
  })  : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.chevron_left),
        onPressed: () => Navigator.pop(context),
        color: Colors.black,
      ),
    );
  }
}

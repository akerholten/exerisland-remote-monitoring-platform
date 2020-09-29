import 'package:flutter/material.dart';

class PlusButton extends StatelessWidget {
  @required
  final VoidCallback onPressed;

  PlusButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: 36,
        width: 36,
        child: FlatButton(
          onPressed: onPressed,
          child: Container(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 16,
            ),
          ),
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}

class TrashcanButton extends StatelessWidget {
  @required
  final VoidCallback onPressed;

  TrashcanButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: 36,
        width: 36,
        child: FlatButton(
          onPressed: onPressed,
          child: Container(
            child: Icon(
              Icons.delete,
              color: Colors.grey,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}

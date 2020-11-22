import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final Key key;
  final String title;
  final String date;
  final String imgUrl;
  final Function onDismiss;
  final Function onTap;
  CustomListTile(
      {this.title, this.imgUrl, this.date = "", this.onDismiss, this.onTap})
      : this.key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: onDismiss,
      key: GlobalKey(),
      background: Container(
        margin: EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4.0),
        color: Colors.black,
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          onTap: onTap,
          highlightColor: Colors.black,
          splashColor: Theme.of(context).accentColor,
          child: ListTile(
            title: Text(title),
            subtitle: Text(date),
            leading: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border:
                    Border.all(color: Theme.of(context).accentColor, width: 3),
              ),
              child: ClipOval(
                child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/image_placeholder.jpg',
                    image: imgUrl),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

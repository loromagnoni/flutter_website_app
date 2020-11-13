import 'package:flutter/material.dart';
import 'package:flutter_website_app/widgets/page_to_display.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({
    Key key,
    @required Function onItemTap,
    @required PageToDisplay selectedPage,
  })  : _onTapFunction = onItemTap,
        _selectedPage = selectedPage,
        super(key: key);

  final Function _onTapFunction;
  final PageToDisplay _selectedPage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      color: Colors.black,
      child: ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                child: Text('Contents',
                    style: Theme.of(context).textTheme.headline1),
                decoration: BoxDecoration(color: Colors.black)),
            _DrawerItem(
                page: ProjectPage(),
                selectedPage: _selectedPage,
                onTapFunction: _onTapFunction),
            _DrawerItem(
              page: BooksPage(),
              selectedPage: _selectedPage,
              onTapFunction: _onTapFunction,
            )
          ]),
    );
  }
}

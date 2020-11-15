import 'package:flutter/material.dart';
import 'package:flutter_website_app/screens/management/page_to_display.dart';
import 'package:flutter_website_app/screens/management/projects_page.dart';

import '../screens/management/books_page.dart';
import 'drawer_item.dart';

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
            DrawerItem(
                page: ProjectPage(),
                selectedPage: _selectedPage,
                onTapFunction: _onTapFunction),
            DrawerItem(
              page: BooksPage(),
              selectedPage: _selectedPage,
              onTapFunction: _onTapFunction,
            )
          ]),
    );
  }
}

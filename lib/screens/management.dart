import 'package:flutter/material.dart';
import 'package:flutter_website_app/widgets/books_list.dart';
import 'package:flutter_website_app/widgets/page_to_display.dart';
import 'package:flutter_website_app/widgets/projects_list.dart';

class ManagementScreen extends StatefulWidget {
  static const String routeName = '/management';
  @override
  _ManagementScreenState createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  PageToDisplay _page = ProjectPage();

  void _setPage(PageToDisplay p) {
    setState(() => _page = p);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Website Manager"),
          ),
          drawer: _Drawer(selectedPage: _page, onItemTap: _setPage),
          body: AnimatedSwitcher(
              duration: Duration(milliseconds: 500), child: _page.widget)),
    );
  }
}

class _Drawer extends StatelessWidget {
  _Drawer({
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

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    Key key,
    @required Function onTapFunction,
    @required PageToDisplay selectedPage,
    @required PageToDisplay page,
  })  : _onTapFunction = onTapFunction,
        _selectedPage = selectedPage,
        _page = page,
        super(key: key);

  final Function _onTapFunction;
  final PageToDisplay _page;
  final PageToDisplay _selectedPage;

  bool get _isSelected => _selectedPage == _page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        color: Colors.grey[900],
        elevation: _isSelected ? 5 : 0,
        shadowColor: Theme.of(context).accentColor,
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          splashColor: Theme.of(context).accentColor,
          onTap: () => _onTapFunction(_page),
          child: AnimatedContainer(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: _isSelected
                    ? Theme.of(context).accentColor.withOpacity(0.7)
                    : Colors.white.withAlpha(0)),
            duration: Duration(milliseconds: 300),
            child: ListTile(
              title: Text(_page.stringValue),
            ),
          ),
        ),
      ),
    );
  }
}

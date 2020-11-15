import 'package:flutter/material.dart';
import 'package:flutter_website_app/screens/management/page_to_display.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem({
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

  bool get _isSelected => _selectedPage.stringValue == _page.stringValue;

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

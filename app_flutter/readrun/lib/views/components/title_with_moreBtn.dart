import 'package:flutter/material.dart';
import 'package:readrun/model/constants.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:wiredash/wiredash.dart';

class TitleWithMoreBtn extends StatefulWidget {
  const TitleWithMoreBtn({
    Key key,
    this.title,
    this.press,
  }) : super(key: key);
  final String title;
  final Function press;

  @override
  _TitleWithMoreBtnState createState() => _TitleWithMoreBtnState();
}

class _TitleWithMoreBtnState extends State<TitleWithMoreBtn> {

  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 1,
    minLaunches: 4,
    remindDays: 3,
    remindLaunches: 5,
    googlePlayIdentifier: 'fr.skyost.example',
    appStoreIdentifier: '1491556149',
  );

  @override
  void initState() {
    rateMyApp.init().then((_) {
      if (rateMyApp.shouldOpenDialog) {
      rateMyApp.showRateDialog(
        context,
        title: 'Rate this app', // The dialog title.
        message: 'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.', // The dialog message.
        rateButton: 'RATE', // The dialog "rate" button text.
        noButton: 'NO THANKS', // The dialog "no" button text.
        laterButton: 'MAYBE LATER', // The dialog "later" button text.
        listener: (button) { // The button click listener (useful if you want to cancel the click event).
          switch(button) {
            case RateMyAppDialogButton.rate:
              print('Clicked on "Rate".');
              break;
            case RateMyAppDialogButton.later:
              print('Clicked on "Later".');
              break;
            case RateMyAppDialogButton.no:
              print('Clicked on "No".');
              Navigator.pop(context);
              Wiredash.of(context).show();
              break;
          }

          return true; // Return false if you want to cancel the click event.
        },
        ignoreIOS: false, // Set to false if you want to show the Apple's native app rating dialog on iOS.
        dialogStyle: DialogStyle(
          dialogShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
          titleAlign: TextAlign.center,
          titleStyle: Theme.of(context).textTheme.headline2,
          messageStyle: Theme.of(context).textTheme.bodyText2,
          messageAlign: TextAlign.left,
          
        ), // Custom dialog styles.
        onDismissed: () => rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
        // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
        // actionsBuilder: (context) => [], // This one allows you to use your own buttons.
      );

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        children: <Widget>[
          TitleWithCustomUnderline(text: widget.title),
          Spacer(),
        ],
      ),
    );
  }
}

class TitleWithCustomUnderline extends StatelessWidget {
  const TitleWithCustomUnderline({
    Key key,
    this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: EdgeInsets.only(bottom: 4),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: kDefaultPadding / 4),
            child: Text(
              text,
              style: TextStyle(fontSize: 20,fontFamily: 'KievitOT'),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.only(right: kDefaultPadding / 4),
              height: 7,
              color: kPrimaryColor.withOpacity(0.2),
            ),
          )
        ],
      ),
    );
  }
}
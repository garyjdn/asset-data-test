import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ActionAlignment { VERTICAL, HORIZONTAL }

class CustomDialog extends StatefulWidget {
  final String? title;
  final Widget content;
  final CrossAxisAlignment? titleAlign;
  final PrimaryDialogButton? primaryButton;
  final SecondaryDialogButton? secondaryButton;
  final ActionAlignment actionAlignment;
  final void Function()? closeButton;
  final bool closeIcon;
  final bool disableBottomPadding;

  CustomDialog({
    this.title,
    required this.content,
    this.titleAlign = CrossAxisAlignment.center,
    this.primaryButton,
    this.secondaryButton,
    this.closeButton,
    this.actionAlignment = ActionAlignment.HORIZONTAL,
    this.closeIcon = true,
    this.disableBottomPadding = false,
  });

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 24.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      contentPadding: EdgeInsets.fromLTRB(25.0, 0, 25.0, 25.0),
      titlePadding: EdgeInsets.all(10.0),
      title: widget.closeIcon
          ? Align(
              alignment: Alignment.topRight,
              child: widget.closeButton == null
                  ? GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.close,
                        size: 22.0,
                      ),
                    )
                  : GestureDetector(
                      onTap: widget.closeButton!,
                      child: Icon(
                        Icons.close,
                        size: 22.0,
                      ),
                    ),
            )
          : null,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: widget.titleAlign ?? CrossAxisAlignment.center,
        children: <Widget>[
          if (widget.title != null && widget.title!.isNotEmpty)
            Container(
                child: Text(
                  widget.title!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Capriola',
                  ),
                  textAlign: TextAlign.center,
                ),
                margin: EdgeInsets.only(bottom: 30.0)),
          widget.content,
          if (!widget.disableBottomPadding) SizedBox(height: 30),
          if ((widget.primaryButton != null ||
                  widget.secondaryButton != null) &&
              widget.actionAlignment == ActionAlignment.HORIZONTAL)
            Row(
              children: <Widget>[
                if (widget.secondaryButton != null)
                  Flexible(
                    child: widget.secondaryButton!,
                  ),
                if (widget.primaryButton != null &&
                    widget.secondaryButton != null)
                  SizedBox(width: 10),
                if (widget.primaryButton != null)
                  Flexible(child: widget.primaryButton!),
              ],
            ),
          if ((widget.primaryButton != null ||
                  widget.secondaryButton != null) &&
              widget.actionAlignment == ActionAlignment.VERTICAL)
            Column(
              children: <Widget>[
                if (widget.primaryButton != null) widget.primaryButton!,
                if (widget.primaryButton != null &&
                    widget.secondaryButton != null)
                  SizedBox(height: 12),
                if (widget.secondaryButton != null) widget.secondaryButton!
              ],
            ),
          Container(width: 1000, height: 1, color: Colors.transparent)
        ],
      ),
    );
  }
}

class PrimaryDialogButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final TextStyle textStyle;
  final void Function() onPressed;

  PrimaryDialogButton({
    // @required this.context,
    this.text = 'Ok',
    this.isLoading = false,
    textStyle,
    required this.onPressed,
  })  : assert(text.isNotEmpty),
        this.textStyle = textStyle ??
            TextStyle(
                fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? () {} : onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: Theme.of(context).primaryColor),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 21,
                  height: 21,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(text, style: textStyle),
        ),
      ),
    );
  }
}

class SecondaryDialogButton extends StatelessWidget {
  final BuildContext context;
  final String text;
  final TextStyle textStyle;
  final void Function() onPressed;

  SecondaryDialogButton({
    required this.context,
    this.text = 'Cancel',
    textStyle,
    required this.onPressed,
  })  : assert(text.isNotEmpty),
        this.textStyle = textStyle ??
            TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: Theme.of(context).primaryColor,
            );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4.0),
          border: Border.all(color: Theme.of(context).primaryColor),
        ),
        child: Center(
          child: Text(text, style: textStyle),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ExtendedCustomListTitle extends StatelessWidget {
  final bool? moveTopRightWidgetToLeft;
  final IconData? icon;
  final String? text;

  const ExtendedCustomListTitle({
    this.moveTopRightWidgetToLeft = false,
    this.text,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8.0),
      child: Row(
        mainAxisAlignment: moveTopRightWidgetToLeft!
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: moveTopRightWidgetToLeft!
                    ? Colors.transparent
                    : Colors.grey
                        .withOpacity(0.6), 
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 6, vertical: 3.0), 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon ?? Icons.remove_red_eye_outlined,
                    size: 14,
                    color: Colors.white,
                  ),
                  Text(' $text',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
          ),
          !moveTopRightWidgetToLeft!
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.grey
                        .withOpacity(0.6), 
                  ),
                  padding:
                      const EdgeInsets.all(3.0), 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: const Icon(
                          Icons.favorite_border_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                        onTap: () {
                        },
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

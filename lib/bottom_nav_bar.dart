import 'package:flutter/material.dart';
import 'package:we_work/application/home/home_bloc.dart';
import 'package:we_work/core/config/image_constants.dart';
import 'package:we_work/core/services/service_locator.dart';
import 'package:we_work/presentation/home/widgets/generate_icon.dart';

class BottomBar extends StatelessWidget {
  BottomBar({super.key, required this.onBottomItemTapped});
  final Function(int) onBottomItemTapped;
  final HomePageBloc homePageBloc = serviceLocator<HomePageBloc>();
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: iconGenerate(ImageConstants.roundLogo,
              homePageBloc.indexOfSelectedBottomNav == 0, Icons.search),
          label: 'We Movies',
        ),
        BottomNavigationBarItem(
          icon: iconGenerate(null, homePageBloc.indexOfSelectedBottomNav == 1,
              Icons.map_outlined),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: iconGenerate(null, homePageBloc.indexOfSelectedBottomNav == 2,
              Icons.calendar_month_outlined),
          label: 'Upcoming',
        ),
      ],
      currentIndex: homePageBloc.indexOfSelectedBottomNav,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      onTap: onBottomItemTapped,
      backgroundColor: Colors.white,
      selectedFontSize: 12,
    );
  }
}

import 'package:cma_management/Menu/DataFragment.dart';
import 'package:cma_management/Menu/accountFragment.dart';
import 'package:cma_management/Menu/dashboardFragment.dart';
import 'package:cma_management/Menu/notificationFragment.dart';
import 'package:cma_management/component/barChart.dart';
import 'package:cma_management/component/btm_nav_item.dart';
import 'package:cma_management/Menu/component/header.dart';
import 'package:cma_management/component/historyTable.dart';
import 'package:cma_management/component/infoCard.dart';
import 'package:cma_management/component/paymentDetailList.dart';
import 'package:cma_management/model/menu.dart';
import 'package:cma_management/styles/colors.dart';
import 'package:cma_management/styles/styles.dart';
import 'package:cma_management/styles/themes.dart';
import 'package:cma_management/utils/rive_utils.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'config/responsive.dart';
import 'config/size_config.dart';

class mainMenu extends StatefulWidget {
  const mainMenu({Key? key}) : super(key: key);

  @override
  _mainMenuState createState() => _mainMenuState();
}

class _mainMenuState extends State<mainMenu>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  int selectedIndex = 0;
  Menu selectedBottonNav = bottomNavItems.first;

  AnimationController? _animationController;
  Animation<double>? scalAnimation;
  Animation<double>? animation;

  late SMIBool isMenuOpenInput;

  void updateSelectedBtmNav(Menu menu) {
    if (selectedBottonNav != menu) {
      _animationController?.reverse().then<dynamic>((data) {
        if (!mounted) {
          return;
        }
        setState(() {
          selectedIndex = menu.index;
          selectedBottonNav = menu;
          tabBody = loadMenu(selectedIndex)!;
        });
      });
    }
  }

  Widget tabBody = Container(
    color: CMATheme.background,
  );

  Widget? loadMenu(int index) {
    switch (index) {
      case 0:
        return new DashboardFragment(animationController: _animationController);
      case 1:
        return new DataFragment(animationController: _animationController);
      case 2:
        return new NotificationFragment(
            animationController: _animationController);
      case 3:
        return new AccountFragment();
    }
  }

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..addListener(
        () {
          setState(() {});
        },
      );
    tabBody = DashboardFragment(animationController: _animationController);
    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
        parent: _animationController!, curve: Curves.fastOutSlowIn));
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController!, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      extendBody: true,
      body: tabBody,
      floatingActionButton: Transform.translate(
        offset: Offset(20, 10),
        child: SafeArea(
          child: Container(
            padding:
                const EdgeInsets.only(left: 12, top: 12, right: 12, bottom: 12),
            margin: const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor2.withOpacity(0.6),
              borderRadius: const BorderRadius.all(Radius.circular(26)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.backgroundColor2.withOpacity(0.5),
                  offset: const Offset(0, 5),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ...List.generate(
                  bottomNavItems.length,
                  (index) {
                    Menu navBar = bottomNavItems[index];
                    return BtmNavItem(
                      navBar: navBar,
                      press: () {
                        RiveUtils.chnageSMIBoolState(navBar.rive.status!);
                        updateSelectedBtmNav(navBar);
                      },
                      riveOnInit: (artboard) {
                        navBar.rive.status = RiveUtils.getRiveInput(artboard,
                            stateMachineName: navBar.rive.stateMachineName);
                      },
                      selectedNav: selectedBottonNav,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

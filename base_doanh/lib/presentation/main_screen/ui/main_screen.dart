import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:base_doanh/config/base/root_screen.dart';
import 'package:base_doanh/generated/l10n.dart';
import 'package:base_doanh/presentation/main_screen/cubit/main_cubit.dart';
import 'package:base_doanh/widgets/bottom_tab.dart';

const int tabBookTicketIndex = 0;
const int tabTransshipmentIndex = 1;
const int tabGiveTicketIndex = 2;

class MainScreen extends RootScreen {
  const MainScreen({
    Key? key,
    this.index,
    this.checkExist,
  }) : super(key: key);
  final int? index;
  final bool? checkExist;

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends RootScreenScreen<MainScreen> {

  final List<Widget> _pages = [
    const SizedBox(),
    const SizedBox(),
    const SizedBox(),
  ];

  final MainCubit _cubit = MainCubit();

  late int pageIndex;

  int lastDuration = 2;
  @override
  void initState() {
    super.initState();
    pageIndex = widget.index ?? tabBookTicketIndex;
    _cubit.indexSink.add(pageIndex);
    _cubit.indexStream.listen((tabIndex) {
      if (_pages[tabIndex] is! SizedBox) {
        return;
      }
      if (tabIndex == tabBookTicketIndex) {
        _pages[tabIndex] = const SizedBox();
      } else if (tabIndex == tabTransshipmentIndex) {
        _pages[tabIndex] = const SizedBox();
      } else {
        _pages[tabIndex] = const SizedBox();
      }
      setState(() {});
    });
  }



  @override
  Widget build(BuildContext context) {
    DateTime? lastQuitTime;
    return WillPopScope(
      onWillPop: () async {
        if (lastQuitTime == null ||
            DateTime.now().difference(lastQuitTime!).inSeconds > 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 1),
              content: Text(
                S.current.out_app,
              ),
            ),
          );
          lastQuitTime = DateTime.now();
          return Future.value(false);
        } else {
          if (Platform.isAndroid) {
            await SystemNavigator.pop();
          } else if (Platform.isIOS) {
            exit(0);
          }
          return Future.value(true);
        }
      },
      child: Scaffold(
        bottomNavigationBar: CustomBottomHomeAppbar(
          mainCubit: _cubit,
          onTap: (tabIndex) {
            final currentTab = _cubit.currentIndex;
            if(tabIndex == currentTab) {
              return;
            }
            if (_pages[tabIndex] is! SizedBox) {
              return;
            }
            if (tabIndex == tabBookTicketIndex) {
              _pages[tabIndex] = const SizedBox();
            } else if (tabIndex == tabTransshipmentIndex) {
              _pages[tabIndex] = const SizedBox();
            } else {
              _pages[tabIndex] = const SizedBox();
            }
            setState(() {});
          },
        ),
        body:  StreamBuilder<int>(
          stream: _cubit.indexStream,
          builder: (context, snapshot) {
            final index = snapshot.data ?? tabBookTicketIndex;
            return IndexedStack(
              index: index,
              children: _pages,
            );
          },
        ),
      ),
    );
  }
}

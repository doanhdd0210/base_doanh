import 'package:hapycar/utils/constants/api_constants.dart';
import 'package:hapycar/utils/constants/image_asset.dart';
import 'package:hapycar/utils/style_utils.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rxdart/rxdart.dart';

import '../../config/themes/app_theme.dart';

class ViewLoadMoreBase extends StatefulWidget {
  const ViewLoadMoreBase({
    Key? key,
    required this.functionInit,
    required this.itemWidget,
    required this.controller,
    this.isInit = false,
    this.isGrid = false,
    this.notFoundData,
    this.child,
    this.isCustom,
    this.expandedHeight,
    this.isChildShowHasData = false,
  }) : super(key: key);
  final Future<dynamic> Function(int page, bool isInit) functionInit;
  final Function(int index, dynamic data) itemWidget;
  final LoadMoreController controller;
  final bool isInit;
  final bool isGrid;
  final bool? isCustom;
  final Widget? notFoundData;
  final Widget? child;
  final double? expandedHeight;
  final bool isChildShowHasData;

  @override
  State<ViewLoadMoreBase> createState() => _ViewLoadMoreBaseState();
}

class _ViewLoadMoreBaseState extends State<ViewLoadMoreBase>
    with AutomaticKeepAliveClientMixin {
  late final LoadMoreController _controller;

  @override
  void initState() {
    _controller = widget.controller;
    _controller.functionInit = widget.functionInit;
    super.initState();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (widget.isInit) _controller.loadData(_controller.page);
        _controller.handelLoadMore();
      });
    }
  }

  double? _getHeight() {
    final _h =
        (widget.expandedHeight ?? 164) - MediaQuery.of(context).padding.top;
    if (_h < 56) {
      return 56;
    } else {
      return _h;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.child != null && widget.isChildShowHasData == false) {
      return RefreshIndicator(
        onRefresh: () async {
          if (_controller.isRefresh) {
            _controller.page = ApiConstants.PAGE_BEGIN;
            _controller.isLoadMore = false;
            await _controller.loadData(_controller.page);
          }
        },
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _controller.controller,
          slivers: <Widget>[
            // SliverApps
            SliverAppBar(
              automaticallyImplyLeading: false,
              snap: true,
              floating: true,
              expandedHeight: _getHeight(),
              flexibleSpace: Container(
                height: _getHeight(),
                alignment: _getHeight() == 56
                    ? Alignment.center
                    : Alignment.bottomCenter,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: boxShadowBase,
                ),
                child: widget.child,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return StreamBuilder<List<dynamic>?>(
                      stream: _controller.streamList,
                      builder: (context, snapshot) {
                        final list = snapshot.data;
                        if (list?.isNotEmpty ?? false) {
                          return Column(
                            children: [
                              _childL(
                                list,
                                isController: false,
                                physics: NeverScrollableScrollPhysics(),
                                isWarp: true,
                              ),
                              _load(),
                            ],
                          );
                        } else if (list == null) {
                          return SizedBox.shrink();
                        } else {
                          return SingleChildScrollView(
                              child: Center(
                            child: widget.notFoundData ?? notFound(),
                          ));
                        }
                      });
                },
                childCount: 1,
              ),
            ),
          ],
        ),
      );
    } else if (widget.isCustom == true) {
      return StreamBuilder<List<dynamic>?>(
          stream: _controller.streamList,
          builder: (context, snapshot) {
            final list = snapshot.data;
            if (list?.isNotEmpty ?? false) {
              return Column(
                children: [
                  _childL(
                    list,
                    isWarp: true,
                    physics: NeverScrollableScrollPhysics(),
                    isController: false,
                    child: widget.isChildShowHasData ? widget.child : null,
                  ),
                  _load(),
                ],
              );
            } else if (list == null) {
              return SizedBox.shrink();
            } else {
              return SingleChildScrollView(
                  child: Center(
                child: widget.notFoundData ?? notFound(),
              ));
            }
          });
    } else {
      return StreamBuilder<List<dynamic>?>(
          stream: _controller.streamList,
          builder: (context, snapshot) {
            final list = snapshot.data;
            if (list?.isNotEmpty ?? false) {
              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        if (_controller.isRefresh) {
                          _controller.page = ApiConstants.PAGE_BEGIN;
                          _controller.isLoadMore = false;
                          await _controller.loadData(_controller.page);
                        }
                      },
                      child: _childL(
                        list,
                      ),
                    ),
                  ),
                  _load(),
                ],
              );
            } else if (list == null) {
              return SizedBox.shrink();
            } else {
              return SingleChildScrollView(
                  child: Center(
                child: widget.notFoundData ?? notFound(),
              ));
            }
          });
    }
  }

  _load() => StreamBuilder<bool>(
      stream: _controller.showLoad,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          _controller.controller.animateTo(
            _controller.controller.position.maxScrollExtent + 32,
            duration: Duration(milliseconds: 1000),
            curve: Curves.easeOut,
          );
          return Container(
            margin: EdgeInsets.only(
              bottom: 16,
            ),
            child: LoadingAnimationWidget.fourRotatingDots(
              size: 24,
              color: AppTheme.getInstance().colorOrange(),
            ),
          );
        }
        return SizedBox.shrink();
      });

  @override
  bool get wantKeepAlive => true;

  _childL(
    list, {
    bool isController = true,
    ScrollPhysics? physics,
    bool isWarp = false,
    Widget? child,
  }) =>
      child != null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (list?.length > 0) child,
                _childLChild(
                  list,
                  isController: isController,
                  physics: physics,
                  isWarp: isWarp,
                ),
              ],
            )
          : _childLChild(
              list,
              isController: isController,
              physics: physics,
              isWarp: isWarp,
            );

  _childLChild(
    list, {
    bool isController = true,
    ScrollPhysics? physics,
    bool isWarp = false,
  }) =>
      widget.isGrid
          ? GridView.builder(
              shrinkWrap: isWarp,
              physics: physics ?? AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 16,
                top: 16,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 157 / 251,
              ),
              controller: isController ? _controller.controller : null,
              itemCount: list?.length,
              itemBuilder: (context, index) =>
                  widget.itemWidget(index, list?[index]),
            )
          : ListView.builder(
              shrinkWrap: isWarp,
              physics: physics ?? AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
              ),
              controller: isController ? _controller.controller : null,
              itemCount: list?.length,
              itemBuilder: (context, index) =>
                  widget.itemWidget(index, list?[index]),
            );
}

class LoadMoreController<T> {
  final BehaviorSubject<List<dynamic>?> streamList = BehaviorSubject();
  BehaviorSubject<bool> showLoad = BehaviorSubject.seeded(false);
  final ScrollController controller = ScrollController();
  bool isLoadMore = false;
  bool isRefresh = true;
  int page = ApiConstants.PAGE_BEGIN;
  Future<dynamic> Function(int page, bool isInit)? functionInit;

  reloadData() {
    isRefresh = true;
    page = ApiConstants.PAGE_BEGIN;
    loadData(page);
  }

  initData(List<dynamic> list) {
    streamList.add(list);
  }

  handelLoadMore() {
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset &&
          isLoadMore) {
        page = page + 1;
        loadData(page);
      }
    });
  }

  dispose() {
    streamList.add(null);
    isLoadMore = true;
    page = ApiConstants.PAGE_BEGIN;
    functionInit = null;
    showLoad.add(false);
  }

  Future<void> loadData(int page, {bool isInit = true}) async {
    if (functionInit != null) {
      if (page != ApiConstants.PAGE_BEGIN) {
        showLoad.add(true);
      }
      final result = await functionInit!(page, isInit);
      showLoad.add(false);
      if (result != null) {
        isLoadMore = result.length == ApiConstants.DEFAULT_PAGE_SIZE;
      } else {
        isLoadMore = false;
      }
      if (result.runtimeType == String) {
        //todo
      } else {
        if (page == ApiConstants.PAGE_BEGIN) {
          streamList.add(result);
        } else {
          streamList.add([...streamList.value ?? [], ...result]);
        }
      }
    }
  }
}

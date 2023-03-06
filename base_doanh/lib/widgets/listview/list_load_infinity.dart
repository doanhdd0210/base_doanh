import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:base_doanh/config/themes/app_theme.dart';
import 'package:base_doanh/data/exception/app_exception.dart';
import 'package:base_doanh/generated/l10n.dart';
import 'package:base_doanh/utils/constants/api_constants.dart';

class ListLoadInfinity<T> extends StatefulWidget {
  const ListLoadInfinity({
    Key? key,
    required this.callData,
    this.pageSize = ApiConstants.DEFAULT_PAGE_SIZE,
    required this.itemBuilder,
    this.noDataWidget,
    this.errorWidget,
    this.controller,
    this.aboveWidget,
    this.belowWidget,
    this.isGetAll = false,
    this.reloadData,
  }) : super(key: key);
  final Future<List<T>> Function(int pageIndex, int pageSize, int offset)
      callData;
  final Widget Function(T item, int index) itemBuilder;
  final Future<void> Function()? reloadData;
  final List<Widget>? aboveWidget;
  final List<Widget>? belowWidget;
  final Widget? noDataWidget;
  final Widget Function(Function() retry, dynamic error)? errorWidget;
  final int pageSize;
  final LoadMoreController<T>? controller;
  final bool isGetAll;

  @override
  _ListLoadInfinityState<T> createState() => _ListLoadInfinityState<T>();
}

class _ListLoadInfinityState<T> extends State<ListLoadInfinity<T>> {
  late final LoadMoreController<T> controller;

  @override
  void initState() {
    controller = widget.controller ?? LoadMoreController<T>();
    controller.callData = widget.callData;
    controller.pageSize = widget.pageSize;
    controller.reloadCallback = widget.reloadData;
    controller.isGetAll = widget.isGetAll;
    controller.loadData();
    controller.createListenScroll();
    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.reloadData();
      },
      child: StreamBuilder<List<T>>(
        stream: controller.listData,
        builder: (context, snapshot) {
          final data = snapshot.data ?? [];
          return CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: controller.scrollController,
            slivers: [
              ...widget.aboveWidget?.map((e) => e) ?? [],
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _KeepAlive(
                      child: widget.itemBuilder(
                        controller.listData.value[index],
                        index,
                      ),
                    );
                  },
                  childCount: data.length,
                ),
              ),
              SliverToBoxAdapter(
                child: StreamBuilder<bool>(
                  stream: controller.isLoading,
                  builder: (_, loadingValue) {
                    final isLoad = loadingValue.data ?? false;
                    if (isLoad) {
                      return Padding(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.getInstance().primaryColor(),
                          ),
                        ),
                      );
                    }
                    return StreamBuilder(
                      stream: controller.error,
                      builder: (_, snapshot) {
                        final error = snapshot.data;
                        if (error != null) {
                          if (widget.errorWidget != null) {
                            return widget.errorWidget!(
                              controller.onRetry,
                              error,
                            );
                          } else {
                            // return ErrorViewWidget(
                            //   message: error is AppException
                            //       ? error.message
                            //       : S.current.something_went_wrong,
                            //   onRetry: () {
                            //     controller.onRetry();
                            //   },
                            // );
                          }
                        }
                        if (data.isEmpty) {
                          return widget.noDataWidget ?? const SizedBox(); //todo handle widget
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    );
                  },
                ),
              ),
              ...widget.belowWidget?.map((e) => e) ?? [] ,
            ],
          );
        },
      ),
    );
  }
}

class LoadMoreController<T> {
  final ScrollController scrollController = ScrollController();
  final BehaviorSubject<List<T>> listData = BehaviorSubject.seeded([]);
  final BehaviorSubject<bool> canLoadMore = BehaviorSubject.seeded(true);
  final BehaviorSubject<bool> isLoading = BehaviorSubject.seeded(false);
  final BehaviorSubject<dynamic> error = BehaviorSubject();

  Future<List<T>> Function(int pageIndex, int pageSize, int offset)? callData;
  Future<void> Function()? reloadCallback;
  int pageSize = ApiConstants.DEFAULT_PAGE_SIZE;
  int _pageIndex = ApiConstants.PAGE_BEGIN;
  bool isGetAll = false;

  void deleteItem(T item) {
    final newData = listData.valueOrNull ?? [];
    newData.remove(item);
    listData.sink.add(newData);
  }

  void addItem(T item, int index) {
    final newData = listData.valueOrNull ?? [];
    newData.insert(index, item);
    listData.sink.add(newData);
  }

  Future<void> reloadData() async {
    _pageIndex = ApiConstants.PAGE_BEGIN;
    final listCall = [loadData(isNew: true)];
    if (reloadCallback != null) {
      listCall.add(reloadCallback!.call());
    }
    await Future.wait(listCall);
  }

  void createListenScroll() {
    scrollController.addListener(() {
      if (!isLoading.value && canLoadMore.value) {
        if (scrollController.position.pixels >=
            (scrollController.position.maxScrollExtent - 200)) {
          loadData();
        }
      }
    });
  }

  Future<void> loadData({bool isNew = false}) async {
    isLoading.sink.add(!isNew);
    try {
      final result = await callData?.call(
            _pageIndex,
            pageSize,
            isNew ? 0 : (listData.valueOrNull ?? []).length,
          ) ??
          [];
      checkCanLoad(result);
      listData.sink.add(isNew ? result : [...listData.value..addAll(result)]);
      _pageIndex++;
      error.sink.add(null);
    } catch (e) {
      error.sink.add(e);
      canLoadMore.sink.add(false);
      if (isNew) {
        listData.sink.add([]);
      }
    } finally {
      isLoading.sink.add(false);
    }
  }

  void onRetry() {
    error.sink.add(null);
    canLoadMore.sink.add(true);
    loadData();
  }

  void checkCanLoad(List<T> data) {
    return canLoadMore.sink.add(data.length >= pageSize && !isGetAll);
  }

  void dispose() {
    scrollController.dispose();
    listData.close();
    canLoadMore.close();
    isLoading.close();
  }
}

class _KeepAlive extends StatefulWidget {
  final Widget child;

  const _KeepAlive({Key? key, required this.child}) : super(key: key);

  @override
  State<_KeepAlive> createState() => _KeepAliveState();
}

class _KeepAliveState extends State<_KeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}

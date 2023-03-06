import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:base_doanh/config/base/base_cubit.dart';
import 'package:base_doanh/config/base/base_state.dart';
import 'package:base_doanh/data/exception/app_exception.dart';
import 'package:base_doanh/generated/l10n.dart';
import 'package:base_doanh/utils/app_utils.dart';
import 'package:base_doanh/utils/constants/api_constants.dart';
import 'package:base_doanh/utils/constants/app_constants.dart';
import 'package:base_doanh/widgets/dialog/loading_loadmore.dart';
import 'package:base_doanh/widgets/views/state_stream_layout.dart';

class ListViewLoadMore extends StatelessWidget {
  final BaseCubit<dynamic> cubit;
  final Function() callApi;
  final Function() callApiMore;
  final Widget Function(dynamic) viewItem;

  const ListViewLoadMore(
      this.cubit, this.callApi, this.callApiMore, this.viewItem,
      {Key? key})
      : super(key: key);

  Future<void> refreshPosts() async {
    if (!cubit.loadMoreLoading) {
      cubit.showLoading();
      cubit.loadMorePage = 1;
      cubit.loadMoreRefresh = true;
      cubit.loadMoreLoading = true;
      await callApi();
    }
  }

  Future<void> loadMorePosts() async {
    if (!cubit.loadMoreLoading) {
      cubit.loadMorePage += 1;
      cubit.loadMoreRefresh = false;
      cubit.loadMoreLoading = true;
      await callApiMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _isLoading = false;
    refreshPosts();
    return BlocConsumer(
      bloc: cubit,
      listener: (ctx, state) {
        // Loading
        if (state is Loading && cubit.loadMoreRefresh) {
          if (!_isLoading) {
            _isLoading = true;
            showLoading(ctx, close: (value) {
              _isLoading = false;
            });
          }
        }
        if (_isLoading && state is! Loading) {
          hideLoading(ctx);
        }
        //Get Blog List Completed
        if (state is CompletedLoadMore) {
          if (state.completeType == CompleteType.SUCCESS) {
            if (cubit.loadMoreRefresh) {
              cubit.loadMoreList.clear();
              if ((state.posts ?? []).isEmpty) {
                cubit.showEmpty();
              } else {
                cubit.showContent();
              }
            }
          } else {
            cubit.loadMoreList.clear();
            cubit.showError();
          }
          cubit.loadMoreList.addAll(state.posts ?? []);
          cubit.canLoadMore =
              cubit.loadMoreList.length >= ApiConstants.DEFAULT_PAGE_SIZE;
          cubit.loadMoreLoading = false;
        }
      },
      builder: (BuildContext context, Object? state) {
        return StateStreamLayout(
          retry: () {
            refreshPosts();
          },
          error: AppException('', S.current.something_went_wrong),
          textEmpty: '',
          stream: cubit.stateStream,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (cubit.canLoadMore &&
                  scrollInfo.metrics.pixels ==
                      scrollInfo.metrics.maxScrollExtent) {
                loadMorePosts();
              }
              return true;
            },
            child: RefreshIndicator(
              onRefresh: refreshPosts,
              child: ListView.builder(
                itemCount: cubit.loadMoreItemCount,
                itemBuilder: (ctx, index) {
                  if (index < cubit.loadMoreList.length) {
                    return viewItem(cubit.loadMoreList[index]);
                  } else {
                    return LoadingItem();
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

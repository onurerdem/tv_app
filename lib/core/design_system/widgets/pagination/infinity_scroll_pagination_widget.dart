import 'package:flutter/material.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/widgets/indicators/empty_list_indicator_widget.dart';
import 'package:tv_app/core/design_system/widgets/indicators/loading_indicator_widget.dart';

class UIInfinityScrollPagination<T> extends StatefulWidget {
  const UIInfinityScrollPagination({
    required this.itemsLenght,
    required this.itemBuilder,
    required this.onFetchMore,
    required this.hasNextPage,
    this.topPadding = 20,
    this.horizontalPadding = 20,
    this.itemGap = 12,
    this.requestFocus = true,
    this.itemsHeader,
    this.topExtraSpace = 0,
    this.bottomExtraSpace = 0,
    this.primaryColor = AppColors.primary,
    this.emptyText,
    super.key,
  });

  final int itemsLenght;
  final Widget Function(
    BuildContext context,
    int index,
  ) itemBuilder;
  final bool hasNextPage;
  final Future Function() onFetchMore;
  final double horizontalPadding;
  final double topPadding;
  final double itemGap;
  final double topExtraSpace;
  final double bottomExtraSpace;
  final Color primaryColor;
  final String? emptyText;
  final Widget? itemsHeader;
  final bool requestFocus;

  @override
  State<UIInfinityScrollPagination<T>> createState() =>
      _UIInfinityScrollPaginationState<T>();
}

class _UIInfinityScrollPaginationState<T>
    extends State<UIInfinityScrollPagination<T>> {
  late ScrollController _scrollController;
  bool _isFetchingNextPage = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildContent(),
      ],
    );
  }

  Widget _buildContent() {
    if (widget.itemsLenght > 0) {
      return Expanded(
        child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
                  height: widget.itemGap,
                ),
            padding: EdgeInsets.only(
              top: widget.horizontalPadding + widget.topExtraSpace,
              bottom: widget.horizontalPadding + widget.bottomExtraSpace,
              left: widget.topPadding,
              right: widget.topPadding,
            ),
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.itemsLenght,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  if (index == 0 && widget.itemsHeader != null) ...[
                    widget.itemsHeader!,
                  ],
                  widget.itemBuilder(context, index),
                  if (index == widget.itemsLenght - 1 &&
                      _isFetchingNextPage) ...[
                    _buildFetchMoreLoadingIndicator(),
                  ],
                ],
              );
            }),
      );
    } else {
      return Expanded(
        child: UIEmptyListIndicator(
          iconColor: widget.primaryColor,
          text: widget.emptyText,
        ),
      );
    }
  }

  Widget _buildFetchMoreLoadingIndicator() {
    return UILoadingIndicator(
      color: widget.primaryColor,
    );
  }

  Future<void> _scrollListener() async {
    if (_scrollController.position.extentAfter < 100 &&
        !_isFetchingNextPage &&
        widget.hasNextPage) {
      setState(() => _isFetchingNextPage = true);
      await widget.onFetchMore();
      setState(() => _isFetchingNextPage = false);
    }
  }
}
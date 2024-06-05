import 'dart:async';

import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/widgets/buttons/core_button_widget.dart';

class UISearchField extends StatefulWidget {
  const UISearchField({
    required this.onSearchChanged,
    this.placeHolder,
    this.onClearButtonTapped,
    this.requestFocus = true,
    this.bgColor = Colors.white,
    super.key,
  });

  final Function(String) onSearchChanged;
  final VoidCallback? onClearButtonTapped;
  final String? placeHolder;
  final Color bgColor;
  final bool requestFocus;

  @override
  State<UISearchField> createState() => _UISearchFieldState();
}

class _UISearchFieldState extends State<UISearchField> {
  final TextEditingController searchController = TextEditingController();
  StreamSubscription<String>? searchSubcription;
  final Debouncer<String> debouncer = Debouncer<String>(
    const Duration(milliseconds: 500),
    initialValue: '',
  );

  @override
  void initState() {
    searchController.addListener(() => debouncer.value = searchController.text);
    searchSubcription = debouncer.values.listen(
      (String search) => widget.onSearchChanged(search),
    );
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await searchSubcription?.cancel();
    searchController.dispose();
  }

  bool hasFocus = false;
  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: Focus(
        onFocusChange: (bool focus) {
          setState(() {
            hasFocus = focus;
          });
        },
        child: TextFormField(
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.white,
          ),
          controller: searchController,
          maxLength: 100,
          onChanged: (String text) {
            setState(() {});
          },
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            labelStyle: const TextStyle(
              fontSize: 18,
              color: Color.fromRGBO(97, 202, 255, .8),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              borderSide: BorderSide(
                width: 1.5,
                color: AppColors.dark1,
              ),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              borderSide: BorderSide(
                width: 1.5,
                color: Colors.red,
              ),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            prefixIconConstraints: const BoxConstraints(maxHeight: 26),
            suffixIconConstraints: const BoxConstraints(maxHeight: 26),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(
                left: 12,
                right: 12,
              ),
              child: Icon(
                Icons.search,
                color: Colors.grey.shade300,
                size: 24,
              ),
            ),
            suffixIcon: searchController.text.isEmpty
                ? null
                : UICoreButton(
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() => searchController.clear());
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
            counter: const Offstage(),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            filled: true,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(
                width: 1.5,
                color: AppColors.border,
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(
                width: 1.5,
                color: AppColors.border,
              ),
            ),
            fillColor: (hasFocus || searchController.text.isNotEmpty)
                ? AppColors.black
                : AppColors.dark2,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 16,
            ),
            hintText: widget.placeHolder ?? 'Search',
          ),
        ),
      ),
    );
  }
}
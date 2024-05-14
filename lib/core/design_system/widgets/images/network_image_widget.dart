import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UINetworkImage extends StatelessWidget {
  const UINetworkImage({
    required this.url,
    this.fit = BoxFit.cover,
    this.height,
    this.width,
    super.key,
  });

  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.network(url, fit: fit, width: width, height: height,
        loadingBuilder: (
      BuildContext context,
      Widget child,
      ImageChunkEvent? loadingProgress,
    ) {
      if (loadingProgress == null) {
        return child;
      }
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade500,
        highlightColor: Colors.grey.shade200,
        child: Container(
          color: Colors.white,
        ),
      );
    });
  }
}
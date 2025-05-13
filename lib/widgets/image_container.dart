import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImageContainer extends StatelessWidget {
  final String imgPath;
  final Widget? child;
  final Function()? onTap;
  final double? width;
  final double? height;
  final bool? hasOverlay;
  const ImageContainer(
      {super.key,
      this.child,
      required this.imgPath,
      this.onTap,
      this.width = double.infinity,
      this.height = 100,
      this.hasOverlay = true});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(10),
      ),
      child: Material(
        child: InkWell(
          onTap: onTap,
          child: Stack(
            fit: StackFit.passthrough,
            clipBehavior: Clip.none,
            children: [
              SizedBox(
                width: width,
                height: height,
                child: CachedNetworkImage(
                  fadeInCurve: Curves.ease,
                  imageUrl: imgPath,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => _imageErrorWidget(),
                  errorWidget: (context, url, error) => _imageErrorWidget(),
                ),
              ),
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: hasOverlay!
                      ? Colors.black.withValues(alpha: 0.5)
                      : Colors.transparent,
                ),
                child: Center(
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageErrorWidget() {
    return SvgPicture.asset(
      'assets/images/placeholder.svg',
      fit: BoxFit.cover,
    );
  }
}

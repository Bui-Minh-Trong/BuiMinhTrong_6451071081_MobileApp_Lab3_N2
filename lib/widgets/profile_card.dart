import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Card bọc ngoài các mục thông tin, tách ra cho gọn màn hình chính
class ProfileCard extends StatelessWidget {
  final String title;
  final String svgIconPath;
  final Widget? headerAction;
  final Widget? contentWidget;

  const ProfileCard({
    super.key,
    required this.title,
    required this.svgIconPath,
    this.headerAction,
    this.contentWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.02 * 255).round()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                svgIconPath,
                width: 24,
                height: 24,
                placeholderBuilder: (context) => Container(
                  width: 24,
                  height: 24,
                  color: Colors.grey[200],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF130160),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              ?headerAction,
            ],
          ),
          if (contentWidget != null) ...[
            const SizedBox(height: 12),
            contentWidget!,
          ],
        ],
      ),
    );
  }
}

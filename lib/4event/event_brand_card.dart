import 'package:flutter/material.dart';
import 'address.dart';

class EventBrandCard extends StatelessWidget {
  final String brand;
  final bool selected;
  final VoidCallback? onTap;

  const EventBrandCard({
    super.key,
    required this.brand,
    this.selected = false,
    this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        width: 105,
        height: 48,
        decoration: BoxDecoration(
          color: selected
              ? AppColors.navy
              : Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: selected
                ? AppColors.navy
                : AppColors.border,
            width: 1,
          ),
          boxShadow: selected
              ? [
            BoxShadow(
              color: AppColors.navy.withOpacity(0.12),
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.025),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 27,
              height: 27,
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withOpacity(0.10)
                    : AppColors.navy.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.directions_car_outlined,
                size: 16,
                color: selected
                    ? AppColors.goldLight
                    : AppColors.navy,
              ),
            ),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                brand,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : AppColors.textDark,
                  fontSize: 14,
                  fontWeight: selected
                      ? FontWeight.w700
                      : FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
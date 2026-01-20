import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/primary_button.dart';

class BookingPriceFooter extends StatelessWidget {
  final int totalPrice;
  final VoidCallback onProceed;

  const BookingPriceFooter({
    super.key,
    required this.totalPrice,
    required this.onProceed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.black.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Total Price',
                style: TextStyle(fontSize: 12, color: AppColors.greyLabel),
              ),
              Text(
                '\$ $totalPrice',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: PrimaryButton(
            text: 'Proceed to pay',
            onPressed: onProceed,
            height: 60,
          ),
        ),
      ],
    );
  }
}

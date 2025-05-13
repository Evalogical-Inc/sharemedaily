import 'package:flutter/material.dart';
import 'package:quotify/config/constants/colors.dart';
import 'package:quotify/config/constants/spacing.dart';
import 'package:quotify/widgets/circle_button.dart';

class ReminderCard extends StatelessWidget {
  final int index;
  const ReminderCard({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.defaultGrey,
        ),
      ),
      child: Column(
        children: [
          _cardTopSection(context, index),
          const Divider(
            color: AppColors.defaultGrey,
          ),
          AppSpacing.height10,
          _cardCenterSection(context),
          AppSpacing.height10,
          const Divider(
            color: AppColors.defaultGrey,
          ),
          AppSpacing.height10,
          _cardBottomSection()
        ],
      ),
    );
  }

  Widget _cardTopSection(BuildContext context, int index) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Icon(Icons.access_alarms),
            AppSpacing.width5,
            Text(
              'Reminder ${index + 1}',
              style:
                  textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            )
          ],
        ),
        Row(
          children: [
            const Icon(
              Icons.access_time_rounded,
              color: AppColors.defaultPink,
            ),
            AppSpacing.width5,
            Text(
              '05:00pm',
              style: textTheme.bodySmall?.copyWith(color: Colors.red),
            ),
            PopupMenuButton(
              padding: const EdgeInsets.all(0),
              itemBuilder: (context) {
                return [
                  const PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        AppSpacing.width5,
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.delete),
                        AppSpacing.width5,
                        Text('Delete'),
                      ],
                    ),
                  ),
                ];
              },
            )
          ],
        ),
      ],
    );
  }

  Row _cardCenterSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          children: [
            Text(
              'Selected date',
              style: TextStyle(color: AppColors.defaultGrey),
            ),
            AppSpacing.height10,
            Row(
              children: [
                CircleButton(
                  backgroundColor: AppColors.defaultPink,
                  diameter: 28,
                  child: Text(
                    'M',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                AppSpacing.width5,
                CircleButton(
                  backgroundColor: AppColors.defaultPink,
                  diameter: 28,
                  child: Text(
                    'T',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                AppSpacing.width5,
                CircleButton(
                  backgroundColor: AppColors.defaultPink,
                  diameter: 28,
                  child: Text(
                    'We',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            )
          ],
        ),
        Column(
          children: [
            const Text(
              'Selected month',
              style: TextStyle(color: AppColors.defaultGrey),
            ),
            AppSpacing.height10,
            Text(
              'Jan 2023',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            )
          ],
        ),
      ],
    );
  }

  Widget _cardBottomSection() {
    return Column(
      children: [
        const Row(
          children: [
            Text(
              'Selected categories',
              style: TextStyle(color: AppColors.defaultGrey),
            )
          ],
        ),
        AppSpacing.height10,
        SizedBox(
          height: 35,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            // primary: false,
            // shrinkWrap: true,
            itemCount: 6,
            itemBuilder: (context, index) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Center(
                  child: Text(
                    'Motivation',
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => AppSpacing.width5,
          ),
        )
      ],
    );
  }
}

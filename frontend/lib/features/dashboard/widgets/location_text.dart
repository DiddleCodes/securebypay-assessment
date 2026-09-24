import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';

/// City and country with a flag. Only a Nigerian flag asset exists, matching the seeded routes.
class LocationText extends StatelessWidget {
  const LocationText({super.key, required this.city, required this.country});

  final String city;
  final String country;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (country == 'Nigeria') ...[
          Image.asset('assets/images/flag_ng.png', width: 18, height: 18, semanticLabel: 'Nigeria'),
          const SizedBox(width: AppSpacing.sm),
        ],
        Flexible(
          child: Text(
            '$city, $country',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.locationValue,
          ),
        ),
      ],
    );
  }
}

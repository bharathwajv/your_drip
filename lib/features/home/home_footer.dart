import 'package:flutter/material.dart';
import 'package:ui_core/components/Extension.dart';

class SpiceItUpCard extends StatelessWidget {
  const SpiceItUpCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16.scalablePixel),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spice',
              style: context.textTheme
                  .modifiedTextTheme(
                    context.textTheme.headlineLarge,
                    context.colorScheme.primary,
                  )
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'it up!',
              style: context.textTheme
                  .modifiedTextTheme(
                    context.textTheme.headlineLarge,
                    context.colorScheme.primary,
                  )
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.scalablePixel),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Crafted with ',
                  style: context.textTheme.modifiedTextTheme(
                    context.textTheme.bodyMedium,
                    context.colorScheme.onSurface,
                  ),
                ),
                Icon(
                  Icons.favorite,
                  color: context.colorScheme.secondary,
                  size: 16.scalablePixel,
                ),
                Text(
                  ' by bharath, chennai.',
                  style: context.textTheme.modifiedTextTheme(
                    context.textTheme.bodyMedium,
                    context.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 30.scalablePixel),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/constants/colors.dart';
import 'package:quotify/config/constants/spacing.dart';
import 'package:quotify/provider/category_provider.dart';
import 'package:quotify/provider/quote_listing_provider.dart';
import 'package:quotify/provider/theme_provider.dart';
import 'package:quotify/screens/quotes/quote_listing_screen.dart';
import 'package:quotify/widgets/custom_page_route.dart';
import 'package:quotify/widgets/image_container.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTeme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Provider.of<ThemeProvier>(context, listen: false).isDarkMode
                ? Colors.white
                : Colors.black,
          ),
        ),
        title: Text(
          'Categories',
          style: textTeme.titleLarge,
        ),
      ),
      body: Consumer<CategoryProvider>(builder: (context, dataClass, _) {
        return ListView.separated(
          padding: const EdgeInsets.only(left: 18, right: 18, bottom: 18),
          itemCount: dataClass.categoryResponse.result.length,
          itemBuilder: (context, index) {
            return ImageContainer(
              onTap: () {
                Provider.of<QuoteListingProvider>(context, listen: false)
                    .initializeData();
                var categoryName =
                    dataClass.categoryResponse.result[index].category;
                Navigator.push(
                  context,
                  CustomPageRoute(
                    child: QuoteListingScreen(
                      itemIndex: index,
                    ),
                    settings: RouteSettings(
                      arguments: QuoteListingScreenArguments(
                          categoryName: categoryName),
                    ),
                  ),
                );
              },
              height: 120,
              imgPath: dataClass.categoryResponse.result[index].categoryImage,
              child: Text(
                dataClass.categoryResponse.result[index].category,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.white,
                    ),
              ),
            );
          },
          separatorBuilder: (context, index) => AppSpacing.height10,
        );
      }),
    );
  }
}

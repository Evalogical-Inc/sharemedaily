import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/constants/colors.dart';
import 'package:quotify/provider/category_provider.dart';
import 'package:quotify/provider/theme_provider.dart';
import 'package:quotify/screens/feature/feature_screen.dart';
import 'package:quotify/widgets/app_bottom_sheet.dart';
import 'package:quotify/widgets/image_container.dart';

class FavoriteScreen extends StatefulWidget {
  final bool enableBackBtn;
  const FavoriteScreen({super.key, this.enableBackBtn = false});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: widget.enableBackBtn
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Provider.of<ThemeProvier>(context, listen: false)
                          .isDarkMode
                      ? Colors.white
                      : Colors.black,
                ),
              )
            : null,
        title: Text(
          'Favorite',
          style: textTheme.titleLarge,
        ),
        actions: [
          IconButton(
            onPressed: () {
              AppBottomSheet.showBottomSheet(
                context: context,
                body: Container(),
              );
            },
            icon: Icon(
              Icons.filter_list,
              size: 28,
              color:
                  Provider.of<ThemeProvier>(context, listen: false).isDarkMode
                      ? Colors.white
                      : Colors.black,
            ),
          )
        ],
      ),
      body: Consumer<CategoryProvider>(
        builder: (context, dataClass, _) {
          return GridView.builder(
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.all(18),
            itemCount: dataClass.categoryResponse.result.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              mainAxisSpacing: 18,
              crossAxisSpacing: 18,
            ),
            itemBuilder: (context, index) {
              return Hero(
                tag: 'feature$index',
                child: ImageContainer(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      'feature',
                      arguments: FeatureScreenArguments(
                          imagePath: dataClass
                              .categoryResponse.result[index].categoryImage,
                          imageAuthor: 'author',
                          tagName: 'index',
                          quote:
                              'Leadership is not about being the best. It is about making everyone else better.',
                          categoryId: 1),
                    );
                  },
                  imgPath:
                      dataClass.categoryResponse.result[index].categoryImage,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Leadership is not about being the best. It is about making everyone else better.',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.white,
                            fontSize: 14,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

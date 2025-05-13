import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotify/config/constants/colors.dart';
import 'package:quotify/config/constants/globals/globals.dart';
import 'package:quotify/provider/search_provider.dart';
import 'package:quotify/provider/theme_provider.dart';
import 'package:quotify/screens/search/widgets/search_resilt_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  SearchProvider searchProvider =
      Provider.of<SearchProvider>(scaffoldKey.currentContext!, listen: false);


      @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Provider.of<ThemeProvier>(context, listen: false).isDarkMode
                ? Colors.white
                : Colors.black,
          ),
        ),
        title: Text(
          'Search Categories',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body:
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: 
          Stack(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 60),
                child: 
                SearchResult(),
              ),
              SizedBox(
                height: 60,
                child: TextFormField(
                  style: const TextStyle(color: AppColors.purple),
                  controller: searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(18),
                    filled: true,
                    fillColor: AppColors.lightGrey,
                    hintText: 'Search categories',
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.defaultGrey,
                        ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: const Icon(
                      Icons.search,
                      color: AppColors.defaultGrey,
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      if (value.length >= 3) {
                        searchProvider.pageNumber = 1;
                        searchProvider.searchQuery = value;
                        searchProvider.searchResponse = [];
                        searchProvider.newCategoryItem = [];
                        searchProvider.searchCategory();
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

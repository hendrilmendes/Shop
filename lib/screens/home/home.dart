import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/products_provider.dart';
import 'package:shop/provider/category_provider.dart';
import 'package:shop/widgets/items/product_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isLoading = true;
  var _searchQuery = '';
  var _selectedCategory = 'Todos';
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<ProductProvider>(context, listen: false)
          .fetchProducts();
      // ignore: use_build_context_synchronously
      await Provider.of<CategoryProvider>(context, listen: false)
          .fetchCategories();
      setState(() {
        _categories =
            Provider.of<CategoryProvider>(context, listen: false).categories;
        if (!_categories.contains(_selectedCategory)) {
          _selectedCategory = 'Todos';
        }
      });
    } catch (error) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appName),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120.0),
          child: Column(
            children: [
              Card(
                clipBehavior: Clip.hardEdge,
                color: Theme.of(context).listTileTheme.tileColor,
                margin: const EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.searchFor,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _categories
                      .map((category) => Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ChoiceChip(
                              label: Text(category),
                              selected: _selectedCategory == category,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.grey[200],
                              selectedColor: Colors.blue,
                              labelStyle: TextStyle(
                                color: _selectedCategory == category
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              onSelected: (isSelected) {
                                setState(() {
                                  _selectedCategory = category;
                                });
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Consumer<ProductProvider>(
              builder: (ctx, productsData, _) {
                final products = productsData.products
                    .where((prod) => prod.title
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()))
                    .where((prod) =>
                        _selectedCategory == 'Todos' ||
                        prod.category == _selectedCategory)
                    .toList();

                if (products.isEmpty) {
                  return Center(
                    child: Text(
                      AppLocalizations.of(context)!.noProduct,
                      style: const TextStyle(fontSize: 18),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: products.length,
                  itemBuilder: (ctx, i) => ProductItem(
                    id: products[i].id,
                    title: products[i].title,
                    imageUrls: products[i].imageUrls,
                    price: products[i].price,
                    isOutOfStock: products[i].isOutOfStock,
                    discount: products[i].discount,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 3,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                );
              },
            ),
    );
  }
}

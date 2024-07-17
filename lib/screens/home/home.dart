import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/products_provider.dart';
import 'package:shop/widgets/bottom_navigation.dart';
import 'package:shop/widgets/product_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isLoading = false;
  var _searchQuery = '';
  var _selectedCategory = 'Todos';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  Future<void> fetchProducts() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<ProductProvider>(context, listen: false)
          .fetchProducts();
    } catch (error) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (_selectedIndex) {
      case 0:
        // Navegar para a tela inicial
        Navigator.of(context).pushReplacementNamed('/');
        break;
      case 1:
        // Navegar para a tela de pedidos
        Navigator.pushNamed(context, '/order');
        break;
      case 2:
         // Navegar para a tela de pedidos
        break;
      case 3:
        // Navegar para a tela de configurações
        // Implemente a navegação para a tela de configurações
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopTem'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(108.0),
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Pesquisar...',
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  children:
                      ['Todos', 'Camisetas', 'Calças', 'Acessórios', 'Calçados','Perfumes']
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

                return GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: products.length,
                  itemBuilder: (ctx, i) => ProductItem(
                    id: products[i].id,
                    title: products[i].title,
                    imageUrl: products[i].imageUrl,
                    price: products[i].price,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                );
              },
            ),
      bottomNavigationBar: BottomNavigationContainer(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

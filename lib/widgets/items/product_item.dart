import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final List<String> imageUrls;
  final double price;
  final bool isOutOfStock; // Parâmetro para indicar se o produto está esgotado
  final double? discount; // Parâmetro opcional para indicar o desconto

  const ProductItem({
    required this.id,
    required this.title,
    required this.imageUrls,
    required this.price,
    required this.isOutOfStock,
    required this.discount, // Adicionando o parâmetro de desconto opcional
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Criar um formatador de número com vírgula como separador decimal
    final formatter = NumberFormat('#,##0.00', 'pt_BR');
    final formattedPrice = formatter.format(price);

    // Calcular o preço com desconto, se houver
    final discountedPrice =
        discount != null ? price * (1 - (discount! / 100)) : price;
    final formattedDiscountedPrice = formatter.format(discountedPrice);

    return GestureDetector(
      onLongPressStart: (_) {
        Feedback.forLongPress(context);
      },
      onTap: () {
        Navigator.of(context).pushNamed(
          '/product-detail',
          arguments: id,
        );
      },
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Stack(
          children: <Widget>[
            // Imagem do produto com ajuste de proporção
            AspectRatio(
              aspectRatio:
                  3 / 2, // Ajusta para proporção 3:2 (pode ser alterado)
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: imageUrls.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrls.first,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      )
                    : const Placeholder(),
              ),
            ),
            // Selo de esgotado
            if (isOutOfStock)
              Positioned(
                top: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topRight: Radius.circular(15),
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: Colors.red,
                    child: Text(
                      AppLocalizations.of(context)!.outOfStock,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            // Selo de desconto
            if (discount != null && discount! > 0)
              Positioned(
                top: 0,
                left: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topLeft: Radius.circular(15),
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: Colors.green,
                    child: Text(
                      '${discount!.toStringAsFixed(0)}% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            // Informações do produto com espaçamento e cor ajustada
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Mostrar preço original riscado, se houver desconto
                        if (discount != null && discount! > 0)
                          Text(
                            'R\$ $formattedPrice',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        // Mostrar preço com desconto, se houver
                        if (discount != null && discount! > 0)
                          Text(
                            'R\$ $formattedDiscountedPrice',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          )
                        // Caso não haja desconto, mostrar o preço original
                        else
                          Text(
                            'R\$ $formattedPrice',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

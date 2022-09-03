import 'package:flutter/material.dart';
import 'package:kartforyou/screens/product_details/components/body.dart';
import 'package:kartforyou/screens/product_details/components/fab.dart';
import 'package:kartforyou/screens/product_details/provider_models/ProductActions.dart';
import 'package:provider/provider.dart';
import '';



class ProductDetailScreen extends StatelessWidget{
  final String productId;

  const ProductDetailScreen({
    Key? key, required this.productId,
}) : super(key: key);
  @override

  Widget build(BuildContext context){
    return ChangeNotifierProvider(
      create: (context) => ProductActions(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6F9),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        body: Body(
          productId:productId, ProductId: '',
        ),
        floatingActionButton: AddToCartFAB(productId:productId),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      )
    );
  }
}
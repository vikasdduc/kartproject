import 'package:flutter/material.dart';
import 'package:kartforyou/constants.dart';
import 'package:kartforyou/models/Product.dart';
import 'package:kartforyou/screens/product_details/components/product_review_section.dart';
import 'package:kartforyou/services/database/product_database_helper.dart';
import 'package:kartforyou/size_config.dart';
import 'package:logger/logger.dart';

class Body  extends StatelessWidget{
  final String ProductId;
  const Body({
    Key? key,
    required this.ProductId, required String productId,
}):super(key: key);
  @override
  Widget build(BuildContext context){
    return SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(screenPadding)
            ),
            child: FutureBuilder<Product>(
              future: ProductDatabaseHelper().getProductWithID(ProductId),
              builder: (context, snapshot){
                if (snapshot.hasData){
                  final product = snapshot.data;
                  return Column(
                    children: [
                     // ProductImages(product:product),
                      SizedBox(height: getProportionateScreenHeight(20)),
                    //  ProductActionsSection(product:product),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      ProductReviewSection(product: product!),
                      SizedBox(height: getProportionateScreenHeight(100)),
                    ],
                  );
                } else if (snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError){
                  final error = snapshot.error.toString();
                  Logger().e(error);
                }
                return const Center(
                child: Icon(
                Icons.error,
                color: kTextColor,
                size: 60,
                ),
                );
              },
            ),
          ),
        ),
    );
  }
}
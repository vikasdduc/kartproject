import 'dart:js';

import 'package:flutter/material.dart';
import 'package:kartforyou/components/nothingtoshow_container.dart';
import 'package:kartforyou/components/product_card.dart';
import 'package:kartforyou/constants.dart';
import 'package:kartforyou/screens/product_details/product_details_screen.dart';
import 'package:kartforyou/size_config.dart';

class Body extends StatelessWidget{
  final String searchQuery;
  final String searchIn;
  final List<String> searchResultProductsId;

  const Body({
    Key? key,
    required this.searchIn,
    required this.searchResultProductsId,
    required this.searchQuery,
}): super(key: key);
  @override
  Widget build(BuildContext context){
    return SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(screenPadding)),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: getProportionateScreenHeight(10)),
                  Text(
                    "search Result",
                    style: headingStyle,
                  ),
                  Text.rich(
                      TextSpan(
                        text: "$searchQuery",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                        children:  [
                          const TextSpan(
                            text: "in",
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                          TextSpan(
                            text: "$searchIn",
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.75,
                    child: buildProductGrid(),
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),

                ],
              ),
            ),
          ),
        ),
    );
  }

  Widget buildProductGrid(){
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 16,
      ),
      decoration: BoxDecoration(

        color: Color(0xFFF5F6F9),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Builder(
        builder: (context){
          if (searchResultProductsId.length>0){
            return GridView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: searchResultProductsId.length,
                itemBuilder: (context, index){
                  return ProductCard(
                      productId: searchResultProductsId[index],
                      press: (){
                        Navigator.push(context,
                            MaterialPageRoute(
                                builder:(context)=>
                            ProductDetailScreen(productId:
                            searchResultProductsId[index],
                            ),
                            ),
                        );
                       },
                      );
                    },
                );
          }

          return const Center(
            child: NothingToShowContainer(
              iconPath: "assets/icons/search_no_found.svg",
              secondaryMessage: "Found 0 Products",
              primaryMessage: "Try another search keyword",
            ),
          );
        },
      )
    );
  }

}
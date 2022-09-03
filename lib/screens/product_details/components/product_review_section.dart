import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kartforyou/components/top_rounded_container.dart';
import 'package:kartforyou/constants.dart';
import 'package:kartforyou/models/Product.dart';
import 'package:kartforyou/models/Review.dart';
import 'package:kartforyou/screens/product_details/components/review_box.dart';
import 'package:kartforyou/services/database/product_database_helper.dart';
import 'package:kartforyou/size_config.dart';
import 'package:logger/logger.dart';




class ProductReviewSection extends StatelessWidget{
  const ProductReviewSection({
    Key?key,
    required this.product,
}): super(key: key);

  final Product product;

  get error => null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
    height:getProportionateScreenHeight(320),
    child: Stack(
      children: [
        TopRoundedContainer(
            child: Column(
              children: [
                const Text(
                  "Product Reviews",
                  style: TextStyle(
                    fontSize: 21,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                Expanded(
                    child: StreamBuilder<List<Review>>(
                      stream: ProductDatabaseHelper()
                      .getAllReviewsStreamForProductId(product.id),
                      builder: (context, snapshot){
                        if (snapshot.hasData){
                          final reviewList = snapshot.data;
                          if(reviewList?.length == 0){
                            return Center(
                              child: Column(
                                children: [
                                  SvgPicture.asset("assets/icons/review.svg",
                                  color: kTextColor,
                                  width: 40,),
                                  const SizedBox(height: 8),
                                  const Text(""
                                      "No reviews yet",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: reviewList?.length,
                              itemBuilder: (context, index){
                                return ReviewBox(
                                    review: reviewList![index],
                                );
                              },
                              );
                        } else if (snapshot.connectionState ==
                        ConnectionState.waiting){
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.error != null){
                          Logger().w(error.toString());
                        }
                        return const Center(
                          child: Icon(
                            Icons.error,
                            color: kTextColor,
                            size: 50,
                          ),
                        );
                      },

                    ),
                ),
              ],
            ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: buildProductRatingWidget(product.rating),
        ),
      ],
    ),
    );
  }

  Widget buildProductRatingWidget(num rating) {
    return Container(
      width: getProportionateScreenWidth(80),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(
                "$rating",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: getProportionateScreenWidth(16),
                ),
              ),
          ),
          const SizedBox(width: 5),
          const Icon(
            Icons.star,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
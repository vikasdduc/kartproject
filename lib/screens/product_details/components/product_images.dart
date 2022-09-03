import 'package:flutter/material.dart';
import 'package:kartforyou/constants.dart';
import 'package:kartforyou/models/Product.dart';
import 'package:kartforyou/screens/product_details/provider_models/ProductImageSwiper.dart';
import 'package:kartforyou/size_config.dart';
import 'package:provider/provider.dart';
import 'package:swipedetector/swipedetector.dart';

class ProductImages extends StatelessWidget{
  const ProductImages({
    Key? key,
    required this.product,
}):super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context){

    return ChangeNotifierProvider(
        create: (context) => ProductImageSwiper(),
    child: Consumer<ProductImageSwiper>(
      builder: (context,productImagesSwiper,child){
        return Column(
          children: [
            SwipeDetector(
              onSwipeLeft:(){
                productImagesSwiper.currentImageIndex++;
                productImagesSwiper.currentImageIndex %=
                    product.images.length;
              },
              onSwipeRight: () {
                productImagesSwiper.currentImageIndex--;
                productImagesSwiper.currentImageIndex +=
                    product.images.length;
                productImagesSwiper.currentImageIndex %=
                    product.images.length;
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                child: SizedBox(
                  height: SizeConfig.screenHeight!  * 0.35,
                  width: SizeConfig.screenWidth! * 0.75,
                  child: Image.network(
                    product.images[productImagesSwiper.currentImageIndex],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(
                    product.images.length, (index) =>
                buildSmallPreview(productImagesSwiper,index: index),
                ),
              ],
            ),
          ],
        );
      },
    ),
    );
  }
  Widget buildSmallPreview(ProductImageSwiper productImageSwiper,
  {required int index}) {
    return GestureDetector(
      onTap: (){
        productImageSwiper.currentImageIndex = index;
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(8)),
        padding: EdgeInsets.all(getProportionateScreenHeight(8)),
        height: getProportionateScreenHeight(48),
        width: getProportionateScreenWidth(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: productImageSwiper.currentImageIndex == index
                ? kPrimaryColor
                :Colors.transparent),
          ),
        child: Image.network(product.images[index]),
        ),
      );
  }
}
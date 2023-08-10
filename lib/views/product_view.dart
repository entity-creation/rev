import 'package:flutter/material.dart';
import 'package:rev/constants/field_constants.dart';
import 'package:rev/constants/routes.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';

class ProductView extends StatelessWidget {
  final String productName;
  final String productPictureUrl;
  final double ratings;
  final String comments;
  final String storeName;
  final String storeLocation;
  final String userName;
  const ProductView({
    required this.productName,
    required this.productPictureUrl,
    required this.ratings,
    required this.comments,
    required this.storeName,
    required this.storeLocation,
    required this.userName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          reviewExpandRoute,
          arguments: {
            "Product Name": productName,
            "Picture": productPictureUrl,
            "Ratings": ratings,
            "Comments": comments,
            "Store name": storeName,
            "Store location": storeLocation,
            "Username": userName,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: Row(
          children: [
            Column(
              children: [
                (productPictureUrl != "")
                    ? Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        height: 100,
                        width: 170,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            productPictureUrl,
                            fit: BoxFit.cover,
                          ),
                        ))
                    : Image.asset(""),
                const SizedBox(
                  height: 10,
                ),
                Text(productName),
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SmoothStarRating(
                  allowHalfRating: true,
                  starCount: 5,
                  rating: ratings,
                  size: 15,
                  color: Colors.amber,
                  borderColor: Colors.black26,
                  spacing: 0,
                ),
                SizedBox(
                  width: 120,
                  child: Text(
                    comments,
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Text(
                    storeName,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Text(
                    storeLocation,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Text(
                    "Posted by $userName",
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

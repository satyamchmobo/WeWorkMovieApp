import 'package:flutter/material.dart';
import 'package:we_work/core/config/image_constants.dart';

class LocationDetailsWidget extends StatelessWidget {
  const LocationDetailsWidget(
      {super.key, required this.mainAddress, required this.secondaryAddress});

  final String? mainAddress;

  final String? secondaryAddress;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 10.0, right: 2),
                                    child: Icon(
                                      Icons.location_on_outlined,
                                      size: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          120,
                                      child: Text(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        mainAddress!,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 120,
                                  child: Text(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    secondaryAddress!,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  )),
                            ],
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage(ImageConstants.roundLogo),
                                      fit: BoxFit.contain),
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

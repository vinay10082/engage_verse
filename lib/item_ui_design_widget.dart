import 'package:engage_verse/item_details_screen.dart';
import 'package:flutter/material.dart';

import 'items_modal.dart';

class ItemUIDesignWidget extends StatefulWidget 
{
  Items? itemsInfo;
  BuildContext? context;

  ItemUIDesignWidget(
    {
      this.itemsInfo,
      this.context
    }
    );

  @override
  State<ItemUIDesignWidget> createState() => _ItemUIDesignWidgetState();
}

class _ItemUIDesignWidgetState extends State<ItemUIDesignWidget> {
  @override
  Widget build(BuildContext context) 
  {
    return InkWell(
      onTap: () 
      {
        //send use to the item detail screen
        Navigator.push(context, MaterialPageRoute(builder: (c) => ItemDetailsScreen(
          clickedItemInfo: widget.itemsInfo,
        )));
      },
      splashColor: Colors.deepPurple,
      child: Padding(padding: const EdgeInsets.all(6.0),
      child: SizedBox(
        height: 140,
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: 
          [
            //image
            Image.network(
              widget.itemsInfo!.itemImage.toString(),
              width: 140,
              height: 140,
            ),

            const SizedBox(width: 4.0,),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: 
                [
                  const SizedBox(height: 15,),

                  //item name
                  Expanded(
                    child: Text(
                      widget.itemsInfo!.itemName.toString(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    )
                  ),

                  const SizedBox(height: 5.0,),

                  //seller Name
                  //item name
                  Expanded(
                    child: Text(
                      widget.itemsInfo!.sellerName.toString(),
                      style: const TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 13,
                      ),
                    )
                  ),

                  const SizedBox(height: 20.0,),

                  //show discount badge - 50% OFF badge
                  //price original
                  //new price
                  Row(
                    children: [

                      //50% off badge
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.deepPurple,
                        ),
                        alignment: Alignment.topLeft,
                        width: 40,
                        height: 44,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Text(
                                "50%",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal
                                ),
                              ),

                              Text(
                                "OFF",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal
                                ),
                              ),


                            ],
                            )
                          ),
                      ),
                    
                      const SizedBox(
                        width: 10,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //original price
                          Row(
                            children: [
                              const Text(
                            "Original Price: ₹",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          Text(
                            (double.parse(widget.itemsInfo!.itemPrice!) + double.parse(widget.itemsInfo!.itemPrice!)).toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          )
                            ],
                          ),

                          //new discounted price
                          Row(
                            children: [
                              const Text(
                            "New Price: ₹",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.deepPurple,
                            ),
                          ),
                          Text(
                            widget.itemsInfo!.itemPrice.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.deepPurple,
                            ),
                          )
                            ],
                          ),
                        
                          
                        ],
                      )
                    ],
                  ),
                
                  const SizedBox(height: 8.0,),

                  const Divider(
                    color: Colors.white70,
                    height: 4,
                  ),
                ]
              ),
            )
          ],
          )
        ),
      ),
    );
  }
}
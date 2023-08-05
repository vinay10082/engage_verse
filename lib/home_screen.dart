import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engage_verse/item_ui_design_widget.dart';
import 'package:engage_verse/items_modal.dart';
import 'package:engage_verse/items_upload_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Engage Verse",
          style: TextStyle(
            fontSize: 18,
            letterSpacing: 2,
            fontWeight: FontWeight.bold
          ),
          ),
        actions: [
          IconButton(
            onPressed: ()
            {
              //You are trying to use contextless navigation without
              // Get.to(const ItemsUploadScreen());
              Navigator.push(context, MaterialPageRoute(builder: (c) => const ItemsUploadScreen()));
            }, 
            icon: const Icon(
              Icons.add_box_rounded,
              color: Colors.white,
            )
            )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
        .collection("items")
        .orderBy("publishedDate", descending: true)
        .snapshots(),
      builder: (context, AsyncSnapshot dataSnapshot) 
      {
        if(dataSnapshot.hasData)
        {
          return ListView.builder(
            itemCount: dataSnapshot.data!.docs.length,
            itemBuilder: (context, index)
            {
              Items eachItemInfo = Items.fromJson(
                dataSnapshot.data!.docs[index].data() as Map<String, dynamic>
              );

              return ItemUIDesignWidget(
                itemsInfo: eachItemInfo,
                context: context,
                );
            },
          );
        }
        else
        {
          return const Column(
            children: [
              Center(
                child: Text(
                  "Data is not Available.",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          );
        }
      },
      ),
    );
  }
}
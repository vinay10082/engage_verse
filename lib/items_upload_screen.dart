import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engage_verse/api_consumer.dart';
import 'package:engage_verse/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

class ItemsUploadScreen extends StatefulWidget {
  const ItemsUploadScreen({super.key});

  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreenState();
}

class _ItemsUploadScreenState extends State<ItemsUploadScreen> {

  Uint8List? imageFileUint8List;
  
  bool isUploading = false;

  String imgDownloadUrl = "";

  TextEditingController sellerNameTextEditingController = TextEditingController();
  TextEditingController sellerPhoneTextEditingController = TextEditingController();
  TextEditingController itemNameTextEditingController = TextEditingController();
  TextEditingController itemDescriptionTextEditingController = TextEditingController();
  TextEditingController itemPriceTextEditingController = TextEditingController();

  //upload form screen
  Widget uploadFormScreen()
  {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Upload New Item",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () 
          {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () 
            {
              //validate upload form fields
              if(isUploading != true)
              {
              validateUploadFormAndUploadItemInfo();
              }
            }, 
            icon: const Icon(
              Icons.cloud_upload,
              color: Colors.white,
            )
          )
        ],
      ),
      body: ListView(
        children: [
          isUploading == true?
          const LinearProgressIndicator(color: Colors.deepPurple,)
          : Container(),

          //image
          SizedBox(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: imageFileUint8List != null ?
              Image.memory(
                imageFileUint8List!
              )
              : const Icon(
                Icons.image_not_supported,
                color: Colors.grey,
                size: 100,
              )
            ),
          ),

          const Divider(
            color: Colors.white,
            thickness: 2,
          ),

          //seller name
          ListTile(
            leading: const Icon(
              Icons.person_pin_rounded,
              color: Colors.white,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.grey),
                controller: sellerNameTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Seller Name",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.white,
            thickness: 2,
          ),

          //seller phone
          ListTile(
            leading: const Icon(
              Icons.phone_iphone_rounded,
              color: Colors.white,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.grey),
                controller: sellerPhoneTextEditingController,
                decoration: const InputDecoration(
                  hintText: "+91 xxxxxxxxxx",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.white,
            thickness: 2,
          ),

          //Item Name
          ListTile(
            leading: const Icon(
              Icons.title,
              color: Colors.white,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.grey),
                controller: itemNameTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Item Name",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.white,
            thickness: 2,
          ),

          //Item Description
          ListTile(
            leading: const Icon(
              Icons.description,
              color: Colors.white,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.grey),
                controller: itemDescriptionTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Item Description",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.white,
            thickness: 2,
          ),

          //Item Price
          ListTile(
            leading: const Icon(
              Icons.price_change,
              color: Colors.white,
            ),
            title: SizedBox(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.grey),
                controller: itemPriceTextEditingController,
                decoration: const InputDecoration(
                  hintText: "Item Price",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Divider(
            color: Colors.white,
            thickness: 2,
          ),
        
        ],
      ),
    );
  }

  //validate upload form and upload item info
  validateUploadFormAndUploadItemInfo() async
  {
    if(imageFileUint8List != null)
    {
      if
      (
        sellerNameTextEditingController.text.isNotEmpty &&
        sellerPhoneTextEditingController.text.isNotEmpty &&
        itemNameTextEditingController.text.isNotEmpty &&
        itemDescriptionTextEditingController.text.isNotEmpty &&
        itemPriceTextEditingController.text.isNotEmpty
      )
      {
        setState(() {
          isUploading = true;
        });

        //1.upload image to firebase cloud storage
        String imageUID = DateTime.now().millisecondsSinceEpoch.toString();

        fStorage.Reference firebaseStorageRef = fStorage.FirebaseStorage.instance.ref()
        .child("Items Images")
        .child(imageUID);

        fStorage.UploadTask uploadTaskImageFile = firebaseStorageRef.putData(imageFileUint8List!);

        fStorage.TaskSnapshot uploadImageTaskSnapshot = await uploadTaskImageFile.whenComplete(() {});

        await uploadImageTaskSnapshot.ref.getDownloadURL().then((imageDownloadUrl) => 
        {
          imgDownloadUrl = imageDownloadUrl
        }
        );

        //2.item info to firestore database
        FirebaseFirestore.instance.collection("items").doc(imageUID).set(
          {
            "itemID": imageUID,
            "itemImage": imgDownloadUrl,
            "itemName": itemNameTextEditingController.text,
            "itemDescription": itemDescriptionTextEditingController.text,
            "itemPrice": itemPriceTextEditingController.text,
            "sellerName": sellerNameTextEditingController.text,
            "sellerPhone": sellerPhoneTextEditingController.text,
            "publishedDate": DateTime.now(),
            "status": "available",
          }
        );
      
        Fluttertoast.showToast(msg: "New item uploaded Successfully");

        setState(() {
          isUploading = false;
          imageFileUint8List = null;
        });

        Navigator.push(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      }
      else
      {
        Fluttertoast.showToast(msg: "All fields are mandatory");
      }
    }
    else
    {
      Fluttertoast.showToast(msg: "Please select image file");
    }
  }

  //default screen
  Widget defaultScreen()
  {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Upload New Item",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.add_photo_alternate,
              color: Colors.white,
              size: 200,
            ),

            ElevatedButton(
              onPressed: () 
              {
                showDialogBox();
              }, 
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text(
                "Add New Item",
                style: TextStyle(
                  color: Colors.white70
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
  
  //showDialogBox
  showDialogBox()
  {
    return showDialog(
      context: context,
      builder: (e)
      {
        return SimpleDialog(
          backgroundColor: Colors.deepPurple,
          title: const Text(
            "Item Image",
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            SimpleDialogOption(
              onPressed: ()
              {
                captureImageWithPhoneCamera();
              },
              child: const Text(
                "Capture image with Camera",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            
            SimpleDialogOption(
              onPressed: ()
              {
                chooseImageFromPhoneGallery();
              },
              child: const Text(
                "Choose Image from Gallery",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          
            SimpleDialogOption(
              onPressed: ()
              {
                Navigator.pop(context);
              },
              child: const Text(
                "Cancle",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          
          ],
        );
      }
    );
  }

  //capture Image With Camera Function
  captureImageWithPhoneCamera() async
  {
    Navigator.pop(context);

    try 
    {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);

      if(pickedImage != null)
      {
        String imagePath = pickedImage.path;
        // imageFileUint8List = await pickedImage.readAsBytes();

      //remove background from image
      //make the image transparent
      imageFileUint8List = await ApiClient().removeImageBgApi(imagePath);

      setState(() {
        imageFileUint8List;
      });

      }
    } 
    catch (errMsg) 
    {
      print(errMsg.toString());

      setState(() {
        imageFileUint8List = null;
      });
    }
  }

  //Choose Image From Gallery Function
  chooseImageFromPhoneGallery() async
  {
    Navigator.pop(context);
    
    try 
    {
      final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

      if(pickedImage != null)
      {
        String imagePath = pickedImage.path;
        // imageFileUint8List = await pickedImage.readAsBytes();

      //remove background from image
      //make the image transparent
      imageFileUint8List = await ApiClient().removeImageBgApi(imagePath);

      setState(() {
        imageFileUint8List;
      });
      }
    } 
    catch (errMsg) 
    {
      print(errMsg.toString());

      setState(() {
        imageFileUint8List = null;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return imageFileUint8List == null ?
    defaultScreen()
    : uploadFormScreen();
  }
}
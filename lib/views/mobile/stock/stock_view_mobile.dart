import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grocery_pos/controller/productController.dart';
import 'package:provider/provider.dart';

import '../../../models/product.dart';
import '../modify_product/modify_product.dart';

class StockViewMobile extends StatefulWidget {
  StockViewMobile({super.key});

  @override
  State<StockViewMobile> createState() => _StockViewMobileState();
}

class _StockViewMobileState extends State<StockViewMobile> {
  List<Product> _products = [];

  var pNameController = TextEditingController();
  var pSellingPriceController = TextEditingController();
  var pBuyingPriceController = TextEditingController();
  var pQuantityController = TextEditingController();
  var pDescController = TextEditingController();
  var pBrandController = TextEditingController();
  var pSupplierController = TextEditingController();
  var pImgUrlController = TextEditingController();

  var pQController = TextEditingController();
  var pSController = TextEditingController();

  bool _isLoaded = true;
  bool _isInit = true;
  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoaded = false;
      });
      await Provider.of<ProductController>(context).fetchAndSetProducts();
      setState(() {
        _isLoaded = true;
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    _products = Provider.of<ProductController>(context).getProducts();
    return Expanded(
      flex: 11,
      child: Container(
        padding: EdgeInsets.all(7),
        color: Color.fromARGB(255, 234, 234, 254),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 5),
              width: double.infinity,
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PRODUCTS STOCK",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  Text(
                    "Manage product stock",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            Divider(thickness: 2),
            Expanded(
              child: _isLoaded
                  ? ListView.builder(
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        return stockProductCardMobile(
                            _products[index],
                            context,
                            Provider.of<ProductController>(context,
                                listen: false));
                      },
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (ctx) => ModifyProduct(
                              title: "Add New Product",
                            )));
              },
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.green,
                ),
                child: Center(
                    child: Text(
                  "Add new product to store",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget stockProductCardMobile(
      Product product, BuildContext context, ProductController controller) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(25.0))),
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  padding: EdgeInsets.all(18),
                  height: 250,
                  child: Column(
                    children: [
                      Text("Buy Now :)"),
                      SizedBox(height: 10),
                      TextField(
                        controller: pQController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          label: Text("Enter Quantity"),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: pSController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          label: Text("Supplier Name"),
                        ),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                          onPressed: () {
                            controller.addMoreQtyP(
                                int.parse(pQController.text), product);
                            pQController.text = "";
                            Navigator.pop(context);
                          },
                          child: Text("Proceed")),
                    ],
                  ),
                ),
              );
            });
    
      },
      child: Container(
        height: 130,
        padding: EdgeInsets.all(5),
        child: Card(
            elevation: 5,
            child: Row(
              children: [
                Container(
                  width: 120,
                  child:
                      Image.file(File(product.pImgUrl!), fit: BoxFit.contain),
                ),
                Container(
                  padding:
                      EdgeInsets.only(left: 3, top: 8, right: 3, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.pName!.length > 21
                            ? "${product.pName!.substring(0, 20)}..."
                            : product.pName!,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(product.pDesc!),
                      Spacer(),
                      Text(
                        "Buying Price: ${product.pBuyingPrice!.toString()} TK",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Selling Price: ${product.pSalePrice!.toString()} Tk",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Quantity: ${product.pQuantity!.toString()} Pcs",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}

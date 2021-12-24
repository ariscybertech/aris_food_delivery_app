import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_order_app/src/helpers/order.dart';
import 'package:food_order_app/src/helpers/style.dart';
import 'package:food_order_app/src/models/cart_item.dart';
import 'package:food_order_app/src/providers/app.dart';
import 'package:food_order_app/src/providers/user.dart';
import 'package:food_order_app/src/widgets/custom_text.dart';
import 'package:food_order_app/src/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _key = GlobalKey<ScaffoldState>();
  OrderServices _orderServices = OrderServices();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final app = Provider.of<AppProvider>(context);

    return SafeArea(
      child: Scaffold(
          key: _key,
          appBar: AppBar(
            iconTheme: IconThemeData(color: black),
            backgroundColor: white,
            elevation: 0.0,
            title: CustomText(
              text: "Shopping Cart",
            ),
            leading: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          backgroundColor: white,
          body: app.isLoading
              ? Loading()
              : ListView.builder(
                  itemCount: user.userModel.cart.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: 120,
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.red[100],
                                  offset: Offset(3, 7),
                                  blurRadius: 30)
                            ]),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                topLeft: Radius.circular(20),
                              ),
                              child: Image.network(
                                user.userModel.cart[index].image,
                                height: 120,
                                width: 120,
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: user.userModel.cart[index] .name +
                                              "\n",
                                          style: TextStyle(
                                              color: black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: "Rs" +
                                              user.userModel
                                                  .cart[index].price
                                                  .toString() +
                                              "\n\n",
                                          style: TextStyle(
                                              color: black,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w300)),
                                      TextSpan(
                                          text: "Quantity:",
                                          style: TextStyle(
                                              color: grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400)),
                                      TextSpan(
                                          text: user
                                              .userModel.cart[index].quantity
                                              .toString(),
                                          style: TextStyle(
                                              color: primary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400)),
                                    ]),
                                  ),
                                  SizedBox(
                                    width: 100,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: primary,
                                    ),
                                    onPressed: () async {
                                      app.changeLoading();
                                      bool value = await user.removeFromCart(
                                          cartItem: user.userModel.cart[index]);
                                      if (value) {
                                        user.reloadUserModel();
                                        _key.currentState.showSnackBar(SnackBar(
                                          content: Text("Removed from cart"),
                                        ));
                                        app.changeLoading();
                                        return;
                                      } else {
                                        print(("ITEM WAS NOT REMOVED"));
                                        app.changeLoading();
                                      }
                                    },
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
          bottomNavigationBar: Container(
            height: 70,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "Total:",
                          style: TextStyle(
                              color: black,
                              fontSize: 22,
                              fontWeight: FontWeight.w300)),
                      TextSpan(
                          text: "Rs.${user.userModel.totalCartPrice}",
                          style: TextStyle(
                              color: black,
                              fontSize: 22,
                              fontWeight: FontWeight.normal)),
                    ]),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(20)),
                    child: FlatButton(
                      onPressed: () {
                        if (user.userModel.totalCartPrice == 0) {
                          return showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  //this right here
                                  child: Container(
                                    height: 150,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Your cart is empty",
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            width: 320.0,
                                            child: RaisedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Shop more",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              color: red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                //this right here
                                child: Container(
                                  height: 150,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "You will be charged Rs.${user.userModel.totalCartPrice} upon delivery",
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(
                                          width: 320.0,
                                          child: RaisedButton(
                                            onPressed: () async {

                                              var uuid = Uuid();
                                              String id = uuid.v4();
                                              _orderServices.createOrder(
                                                  userId: user.user.uid,
                                                  id: id,
                                                  description:
                                                      "Some random description",
                                                  status: "Processing",
                                                  totalPrice: user
                                                      .userModel.totalCartPrice,
                                                  cart: user.userModel.cart);
                                              for (CartItemModel cartItem in user.userModel.cart) {
                                                bool value = await user.removeFromCart(cartItem: cartItem);
                                                if (value) {
                                                  user.reloadUserModel();
                                                  _key.currentState
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Removed from cart"),
                                                  ));
                                                  return;
                                                } else {
                                                  print(
                                                      ("ITEM WAS NOT REMOVED"));
                                                }
                                              }
                                              _key.currentState
                                                  .showSnackBar(SnackBar(
                                                content: Text("Order created"),
                                              ));
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Accept",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            color: const Color(0xFF1BC0C5),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 320.0,
                                          child: RaisedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Shop More",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            color: red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                      child: CustomText(
                        text: "Check out",
                        color: white,
                        weight: FontWeight.normal,
                        size: 22,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}

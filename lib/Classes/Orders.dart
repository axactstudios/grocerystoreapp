class Order {
  String key,
      customerAddress,
      customerName,
      customerPhone,
      customerUid,
      customerZip,
      deliveryDate,
      orderAmount,
      orderDate,
      orderTime,
      shippingDate,
      status;
  bool isCompleted;
  List<String> itemsName;
  List<int> itemsQty;

  Order(
      {this.isCompleted,
      this.orderAmount,
      this.orderDate,
      this.key,
      this.itemsQty,
      this.orderTime,
      this.deliveryDate,
      this.status,
      this.itemsName,
      this.customerAddress,
      this.customerName,
      this.customerPhone,
      this.customerUid,
      this.customerZip,
      this.shippingDate});
}

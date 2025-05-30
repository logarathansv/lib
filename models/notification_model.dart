class FlashProductList {
  final String name;
  final String units;
  final String bpid;
  final int quantity;
  final String price;
  bool checked;

  FlashProductList({
    required this.name,
    required this.units,
    required this.bpid,
    required this.quantity,
    required this.price,
    this.checked = false,
  });
}

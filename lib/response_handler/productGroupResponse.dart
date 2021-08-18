import '../../model/product.dart';

class ProductGroup {
  List<SizeGroup> sizeGroup;
  List<ColorGroup> colorGroup;

  ProductGroup({this.colorGroup, this.sizeGroup});

  factory ProductGroup.fromJson(Map<String, dynamic> json) => ProductGroup(
      sizeGroup: json["sizeGroup"] != null
          ? List<SizeGroup>.from(
              json["sizeGroup"].map((x) => SizeGroup.fromJson(x)))
          : [SizeGroup()],
      colorGroup: json["colorGroup"] != null
          ? List<ColorGroup>.from(
              json["colorGroup"].map((x) => ColorGroup.fromJson(x)))
          : [ColorGroup()]);
}

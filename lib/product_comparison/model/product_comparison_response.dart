class ProductComparisonResponse {
  List<Products>? products;
  bool? includeShortDescriptionInCompareProducts;
  bool? includeFullDescriptionInCompareProducts;
  int? id;

  ProductComparisonResponse({
    this.products,
    this.includeShortDescriptionInCompareProducts,
    this.includeFullDescriptionInCompareProducts,
    this.id,
  });

  ProductComparisonResponse.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
    includeShortDescriptionInCompareProducts =
        json['include_short_description_in_compare_products'];
    includeFullDescriptionInCompareProducts = json['include_full_description_in_compare_products'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    data['include_short_description_in_compare_products'] =
        this.includeShortDescriptionInCompareProducts;
    data['include_full_description_in_compare_products'] =
        this.includeFullDescriptionInCompareProducts;

    return data;
  }
}

class Products {
  String? name;
  String? shortDescription;
  String? fullDescription;
  String? seName;
  String? sku;
  String? productType;
  bool? markAsNew;
  ProductPrice? productPrice;
  DefaultPictureModel? defaultPictureModel;
  ProductSpecificationModel? productSpecificationModel;
  ReviewOverviewModel? reviewOverviewModel;
  int? id;

  Products({
    this.name,
    this.shortDescription,
    this.fullDescription,
    this.seName,
    this.sku,
    this.productType,
    this.markAsNew,
    this.productPrice,
    this.defaultPictureModel,
    this.productSpecificationModel,
    this.reviewOverviewModel,
    this.id,
  });

  Products.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    shortDescription = json['short_description'];
    fullDescription = json['full_description'];
    seName = json['se_name'];
    sku = json['sku'];
    productType = json['product_type'];
    markAsNew = json['mark_as_new'];
    productPrice =
        json['product_price'] != null ? new ProductPrice.fromJson(json['product_price']) : null;
    defaultPictureModel = json['default_picture_model'] != null
        ? new DefaultPictureModel.fromJson(json['default_picture_model'])
        : null;
    productSpecificationModel = json['product_specification_model'] != null
        ? new ProductSpecificationModel.fromJson(json['product_specification_model'])
        : null;
    reviewOverviewModel = json['review_overview_model'] != null
        ? new ReviewOverviewModel.fromJson(json['review_overview_model'])
        : null;
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['short_description'] = this.shortDescription;
    data['full_description'] = this.fullDescription;
    data['se_name'] = this.seName;
    data['sku'] = this.sku;
    data['product_type'] = this.productType;
    data['mark_as_new'] = this.markAsNew;
    if (this.productPrice != null) {
      data['product_price'] = this.productPrice!.toJson();
    }
    if (this.defaultPictureModel != null) {
      data['default_picture_model'] = this.defaultPictureModel!.toJson();
    }
    if (this.productSpecificationModel != null) {
      data['product_specification_model'] = this.productSpecificationModel!.toJson();
    }
    if (this.reviewOverviewModel != null) {
      data['review_overview_model'] = this.reviewOverviewModel!.toJson();
    }
    data['id'] = this.id;

    return data;
  }
}

class ProductPrice {
  Null? oldPrice;
  String? price;

  // int? priceValue;
  Null? basePricePAngV;
  bool? disableBuyButton;
  bool? disableWishlistButton;
  bool? disableAddToCompareListButton;
  bool? availableForPreOrder;
  Null? preOrderAvailabilityStartDateTimeUtc;
  bool? isRental;
  bool? forceRedirectionAfterAddingToCart;
  bool? displayTaxShippingInfo;

  ProductPrice(
      {this.oldPrice,
      this.price,
      this.basePricePAngV,
      this.disableBuyButton,
      this.disableWishlistButton,
      this.disableAddToCompareListButton,
      this.availableForPreOrder,
      this.preOrderAvailabilityStartDateTimeUtc,
      this.isRental,
      this.forceRedirectionAfterAddingToCart,
      this.displayTaxShippingInfo});

  ProductPrice.fromJson(Map<String, dynamic> json) {
    oldPrice = json['old_price'];
    price = json['price'];
    // priceValue = json['price_value'];
    basePricePAngV = json['base_price_p_ang_v'];
    disableBuyButton = json['disable_buy_button'];
    disableWishlistButton = json['disable_wishlist_button'];
    disableAddToCompareListButton = json['disable_add_to_compare_list_button'];
    availableForPreOrder = json['available_for_pre_order'];
    preOrderAvailabilityStartDateTimeUtc = json['pre_order_availability_start_date_time_utc'];
    isRental = json['is_rental'];
    forceRedirectionAfterAddingToCart = json['force_redirection_after_adding_to_cart'];
    displayTaxShippingInfo = json['display_tax_shipping_info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['old_price'] = this.oldPrice;
    data['price'] = this.price;
    // data['price_value'] = this.priceValue;
    data['base_price_p_ang_v'] = this.basePricePAngV;
    data['disable_buy_button'] = this.disableBuyButton;
    data['disable_wishlist_button'] = this.disableWishlistButton;
    data['disable_add_to_compare_list_button'] = this.disableAddToCompareListButton;
    data['available_for_pre_order'] = this.availableForPreOrder;
    data['pre_order_availability_start_date_time_utc'] = this.preOrderAvailabilityStartDateTimeUtc;
    data['is_rental'] = this.isRental;
    data['force_redirection_after_adding_to_cart'] = this.forceRedirectionAfterAddingToCart;
    data['display_tax_shipping_info'] = this.displayTaxShippingInfo;

    return data;
  }
}

Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  return data;
}

class DefaultPictureModel {
  String? imageUrl;
  Null? thumbImageUrl;
  String? fullSizeImageUrl;
  String? title;
  String? alternateText;

  DefaultPictureModel(
      {this.imageUrl, this.thumbImageUrl, this.fullSizeImageUrl, this.title, this.alternateText});

  DefaultPictureModel.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
    thumbImageUrl = json['thumb_image_url'];
    fullSizeImageUrl = json['full_size_image_url'];
    title = json['title'];
    alternateText = json['alternate_text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_url'] = this.imageUrl;
    data['thumb_image_url'] = this.thumbImageUrl;
    data['full_size_image_url'] = this.fullSizeImageUrl;
    data['title'] = this.title;
    data['alternate_text'] = this.alternateText;
    return data;
  }
}

class ProductSpecificationModel {
  List<Groups>? groups;

  ProductSpecificationModel({
    this.groups,
  });

  ProductSpecificationModel.fromJson(Map<String, dynamic> json) {
    if (json['groups'] != null) {
      groups = <Groups>[];
      json['groups'].forEach((v) {
        groups!.add(new Groups.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.groups != null) {
      data['groups'] = this.groups!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Groups {
  String? name;
  List<Attributes>? attributes;
  int? id;

  Groups({
    this.name,
    this.attributes,
    this.id,
  });

  Groups.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['attributes'] != null) {
      attributes = <Attributes>[];
      json['attributes'].forEach((v) {
        attributes!.add(new Attributes.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    return data;
  }
}

class Attributes {
  String? name;
  List<Values>? values;
  int? id;

  Attributes({
    this.name,
    this.values,
    this.id,
  });

  Attributes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['values'] != null) {
      values = <Values>[];
      json['values'].forEach((v) {
        values!.add(new Values.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}

class Values {
  String? valueRaw;
  String? colorSquaresRgb;

  Values({this.valueRaw, this.colorSquaresRgb});

  Values.fromJson(Map<String, dynamic> json) {
    valueRaw = json['value_raw'];
    colorSquaresRgb = json['color_squares_rgb'];
  }
}

class ReviewOverviewModel {
  int? productId;
  int? ratingSum;
  int? totalReviews;
  bool? allowCustomerReviews;
  bool? canAddNewReview;

  ReviewOverviewModel({
    this.productId,
    this.ratingSum,
    this.totalReviews,
    this.allowCustomerReviews,
    this.canAddNewReview,
  });

  ReviewOverviewModel.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    ratingSum = json['rating_sum'];
    totalReviews = json['total_reviews'];
    allowCustomerReviews = json['allow_customer_reviews'];
    canAddNewReview = json['can_add_new_review'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['rating_sum'] = this.ratingSum;
    data['total_reviews'] = this.totalReviews;
    data['allow_customer_reviews'] = this.allowCustomerReviews;
    data['can_add_new_review'] = this.canAddNewReview;
    return data;
  }
}

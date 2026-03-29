enum AuthStates {
  Loading,
  Initial,
  Authenticated,
  Unauthenticated,
  Error,
}

enum PersonRole {
  buyer,
  seller,
}

enum PersonStatus {
  accepted,
  rejected,
  waiting
}

enum OrderStatus {
  complete,
  incomplete,
  cancelled
}

enum ProductStatus {
  packing,
  packed,
  shipped,
  arrived,
  received
}


enum ProductScreenStatus {
  initial,
  loading,
  loaded,
  error,
  empty,
  adding,
  added,
  updating,
  updated,
  deleting,
  deleted,
  searching,
  filtering,
}

enum ProductCategory{
  electronics,
  food,
  dairy,
  homeAccessories,
  kitchenAccessories,
  utensils,
}
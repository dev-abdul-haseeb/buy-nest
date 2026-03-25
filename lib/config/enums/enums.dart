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
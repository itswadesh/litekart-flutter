class QueryMutation {

  // Live Commerce

  channels(){
    return """query channels(
  \$page: Int
  \$skip: Int
  \$limit: Int
  \$search: String
  \$sort: String
  \$user:ID
  \$q: String
) {
  channels(
    page: \$page
    skip: \$skip
    search: \$search
    limit: \$limit
    sort: \$sort
    user: \$user
    q: \$q
  ) {
    count
    page
    pageSize
    data {
      id
      scheduleDateTime
      title
      img
      imgCdn
      requestId
      cid
      ctime
      pushUrl
      httpPullUrl
      hlsPullUrl
      rtmpPullUrl
      name
      code
      msg
      product {
        id
        name
        img
        slug
        price
        mrp
      }
      products {
        id
        name
        img
        slug
        price
        mrp
      }
      user {
        id
        firstName
        lastName
        email
        phone
      }
      users {
        id
        firstName
        lastName
        email
        phone
      }
    }
  }
}""";
  }




  // Store

  store(){
    return """
   query storeOne(\$id: ID, \$slug: String, \$domain: String) {
  storeOne(id: \$id, slug: \$slug, domain: \$domain) {
    id
    active
    adminNotifications {
      lowStockNotification
      newOrderPlaced
    }
    address
    alert
    analyticsTrackingId
    banners
    city
    closed
    closedMessage
    country
    currency
    currencyCode
    currencyDecimals
    currencySymbol
    customerOrderNotifications {
      downloadEGoods
      giftCardPurchased
      orderConfirmation
      orderIsReadyForPickup
      orderShipped
      orderStatusChanged
    }
    description
    metaDescription
    dimentionUnit
    domain
    email
    facebook
    facebookPixelId
    facebookUrl
    favicon
    firstName
    freeShippingOn
    gdpr
    gdprCookieConsent
    google
    googleAdsTag
    homeMeta1
    homeMeta2
    homeMeta3
    homeMeta4
    img
    images
    bankAccountNo
    bankAccountHolderName
    bankIfscCode
    instagram
    instagramUrl
    isHideNilStock
    isMegamenu
    isOpen
    isSearch
    keywords
    lastName
    lat
    legalName
    linkedin
    lng
    locality
    logo
    logoDark
    logoMobile
    logoMobileDark
    minimumOrderValue
    minOrderValue
    name
    openGraphImage
    pageSize
    phone
    pinterestTag
    pinterestUrl
    qrCode
    review {
      enabled
      moderate
    }
    searchbarText
    shipping {
      charge
      deliveryDays
      enabled
      free
      method
      provider
    }
    shippingCharge
    shopAddress
    shopPhone
    slug
    snapChatPixel
    state
    storeId
    timeZone
    timing
    title
    twitter
    twitterUrl
    websiteEmail
    websiteLegalName
    websiteName
    weightUnit
    youtubeUrl
    zip
    createdAt
    updatedAt
    user {
      firstName
      lastName
      email
      phone
    }
  }
}
    """;

  }


  // Settings

  settings(){
    return """query settings {
  settings {
    id
    websiteName
    websiteLegalName
    liveCommerce
    multilingual
    closed
    closedMessage
    minimumOrderValue
    title
    alert
    keywords
    description
    tax {
      cgst
      sgst
      igst
    }
    demo
    RAZORPAY_KEY_ID
    GOOGLE_CLIENT_ID
    stripePublishableKey
    brainTreePublicKey
    enableStripe
    enableRazorpay
    currencyCode
    currencySymbol
    currencyDecimals
    openGraphImage
    shipping {
      deliveryDays
      charge
      free
      method
      enabled
      provider
    }
    userRoles
    websiteEmail
    shopPhone
    shopAddress
    country
    logo
    logoMobile
    logoDark
    logoMobileDark
    favicon
    CDN_URL
    S3_URL
    searchbarText
    pageSize
    returnReasons
    orderStatuses {
      status
      title
      body
      icon
      public
      index
    }
    paymentStatuses
    paymentMethods {
      active
      name
      value
      img
      color
      position
      text
    }
    otpLogin
    sms {
      AUTO_VERIFICATION_ID
      enabled
      provider
    }
    email {
      enabled
      from
      cc
      bcc
      printers
    }
    storage {
      enabled
      provider
    }
    review {
      enabled
      moderate
    }
    product {
      moderate
    }
    customerOrderNotifications {
      orderConfirmation
      orderStatusChanged
      orderShipped
      orderIsReadyForPickup
      downloadEGoods
      giftCardPurchased
    }
    adminNotifications {
      newOrderPlaced
      lowStockNotification
    }
    ADMIN_PANEL_LINK
    DOCS_LINK
    storageProvider
    googleMapsApi
    facebook
    twitter
    google
    instagram
    linkedin
    enableTax
    locationExpiry
    WWW_URL
    referralBonus
    joiningBonus
    isMultiVendor
    isMultiStore
    isMegamenu
    isSaas
    isSearch
  }
}""";
  }


  login() {
    return """
    mutation login(\$email: String!, \$password: String!) {
  login(email: \$email, password: \$password) {
    id
    email
    firstName
    lastName
    city
    phone
    avatar
    role
    verified
    active
    provider
    createdAt
    updatedAt
  }
}""";
  }

  register() {
    return """
    mutation register(
  \$email: String!
  \$password: String!
  \$passwordConfirmation: String!
  \$firstName: String
  \$lastName: String
  \$referrer: String
) {
  register(
    email: \$email
    password: \$password
    passwordConfirmation: \$passwordConfirmation
    firstName: \$firstName
    lastName: \$lastName
    referrer: \$referrer
  ) {
    id
    email
    firstName
    lastName
    city
    phone
    role
    verified
    active
    avatar
    provider
    createdAt
    updatedAt
  }
}""";
  }

  getOtp() {
    return """
mutation getOtp(\$phone: String!) {
getOtp(phone: \$phone){
    otp
    timer
  }
}""";
  }

  signOut() {
    return """mutation signOut {
  signOut
}""";
  }

  me() {
    return """query me {
  me {
    id
    firstName
    lastName
    email
    phone
    gender
    role
    verified
    active
    provider
    active
    avatar
    avatarCdn
    address {
      address
      town
      city
      state
      zip
    }
    info {
      public
      store
      storePhotos
    }
  }
}""";
  }

  verifyOtp() {
    return """ mutation verifyOtp(\$phone: String!, \$otp: String!) {
   verifyOtp(phone: \$phone, otp: \$otp) {
    id
    firstName
    lastName
    email
    phone
    role
    verified
    active
    avatar
    sid
   }
  }""";
  }

  categories() {
    return """query categories(
  \$page: Int
  \$search: String
  \$limit: Int
  \$sort: String
  \$megamenu: Boolean
  \$featured: Boolean
  \$active: Boolean
  \$shopbycategory: Boolean
  \$store: ID
) {
  categories(
    page: \$page
    search: \$search
    limit: \$limit
    sort: \$sort
    megamenu: \$megamenu
    featured: \$featured
    active: \$active
    shopbycategory: \$shopbycategory
    store: \$store
  ) {
    count
    page
    pageSize
    data {
      id
      name
      namePath
      # parent
      slug
      img
      imgCdn
      level
      metaTitle
      metaDescription
      metaKeywords
      position
      megamenu
      active
      featured
      shopbycategory
      createdAt
      updatedAt
    }
  }
}""";
  }

  trending() {
    return """query trending(\$type: String, \$store: ID) {
  trending(type: \$type, store: \$store) {
    id
    sku
    barcode
    description
    productMasterId
    slug
    name
    type
    price
    mrp
    stock
    tax
    img
    imgCdn
    images
    time
    active
    popularity
    position
    trending
    featured
    hot
    new
    sale
    recommended
    title
    metaDescription
    keywords
    ratings
    reviews
    itemId
    warranty
    discount
    ageMin
    ageMax
    ageUnit
    cgst
    sgst
    igst
    category
    variants
    vendor
  }
}""";
  }

  products() {
    return """
  query products(
  \$page: Int
  \$skip: Int
  \$limit: Int
  \$search: String
  \$sort: String
  \$vendor: String
  \$category: String
  \$active: Boolean
  \$featured: Boolean
  \$new: Boolean
  \$hot: Boolean
  \$sale: Boolean
  \$store: ID
  ) {
  products(
  page: \$page
  skip: \$skip
  limit: \$limit
  search: \$search
  sort: \$sort
  vendor: \$vendor
  category: \$category
  active: \$active
  featured: \$featured
  new: \$new
  hot: \$hot
  sale: \$sale
  store: \$store
  ) {
  data {
  id
  slug
  name
  type
  price
  mrp
  stock
  img
  images
  time
  active
  popularity
  position
  variants {
  id
  options {
  name
  }
  stock
  weight
  barcode
  sku
  mrp
  price
  images
  trackInventory
  active
  sort
  }
  trending
  featured
  hot
  new
  sale
  recommended
  title
  metaDescription
  keywords
  ratings
  reviews
  brand {
      id
      name
    }
  category {
  name
  }
  vendor {
  id
  firstName
  lastName
  phone
  email
  address {
  address
  }
  info {
  store
  storePhotos
  }
  }
  }
  count
  pageSize
  noOfPage
  page
  }
  }
""";
  }

  product() {
    return """query Product(\$id: ID!) {
  product(id: \$id) {
    id
    slug
    name
    description
    variants {
      id
      options {
        name
        val
      }
      stock
      weight
      barcode
      sku
      mrp
      price
      images
      trackInventory
      active
      sort
    }
    channels {
      id
      title
      img
      scheduleDateTime
      user {
        firstName
        lastName
      }
    }
    brand {
      id
      name
    }
    color {
      id
      name
    }
    size {
      id
      name
    }
    category {
      id
      name
    }
    categories {
      id
      name
    }
    keyFeatures
    features {
      id
      name
      value
    }
    specifications {
      id
      name
      value
    }
    productDetails {
      id
      name
      value
    }
     sizeGroup {
      _id
      slug
      size {
        name
      }
    }
    colorGroup {
      _id
      slug
      color {
        name
        color_code
      }
    }
    type
    price
    mrp
    stock
    img
    imgCdn
    images
    imagesCdn
    time
    active
    popularity
    position
    sku
    hsn
    group
    barcode
    trending
    featured
    hot
    new
    sale
    recommended
    title
    metaDescription
    keywords
    countryOfOrigin
    link
    warranty
    vendor {
      id
      firstName
      lastName
      phone
      email
      address {
        address
      }
      info {
        store
        storePhotos
      }
    }
  }
}""";
  }

  addToCart() {
    return """mutation addToCart(
  \$qty: Int!
  \$pid: ID!
  \$vid: ID
  \$options: String
  \$vendor: ID
  \$replace: Boolean
) {
  addToCart(
    qty: \$qty
    pid: \$pid
    vid: \$vid
    options: \$options
    vendor: \$vendor
    replace: \$replace
  ) {
    items {
      pid
      tax
      barcode
      vendor {
        _id
        firstName
        lastName
        phone
      }
      brand {
        name
      }
      name
      slug
      qty
      price
      shippingCharge
      tax
      img
      imgCdn
      options
    }
    qty
    subtotal
    discount {
      code
      value
      text
      amount
    }
    shipping {
      charge
    }
    total
    tax
  }
}""";
  }

  cart() {
    return """query cart(\$store: ID) {
  cart(store: \$store) {
    id
    items {
      pid
      barcode
      tax
      vendor {
        id
        store
        firstName
        lastName
        phone
      }
      brand {
        id
        name
      }
      name
      slug
      qty
      price
      shippingCharge
      img
      imgCdn
      options
      tracking
    }
    qty
    subtotal
    discount {
      code
      value
      text
      amount
    }
    shipping {
      charge
    }
    total
    tax
  }
}""";
  }

  deleteCart() {
    return """mutation deleteCart(\$id: ID!) {
  deleteCart(id: \$id)
}""";
  }

  listDeals() {
    return """query listDeals(\$page: Int, \$search: String, \$limit: Int, \$sort: String) {
  listDeals(page: \$page, search: \$search, limit: \$limit, sort: \$sort) {
    count
    page
    pageSize
    data {
      id
      name
      startTime
      endTime
      startTimeISO
      endTimeISO
      onGoing
      products {
        id
        name
        price
        slug
        img
        images
      }
      dealStatus
      active
    }
  }
}""";
  }

  banners() {
    return """query banners(
  \$page: Int
  \$search: String
  \$limit: Int
  \$sort: String
  \$type: String
  \$pageId: String
  \$groupId: String
  \$groupTitle: String
  \$active: Boolean
  \$isMobile: Boolean
  \$store: ID
) {
  banners(
    page: \$page
    search: \$search
    limit: \$limit
    sort: \$sort
    type: \$type
    pageId: \$pageId
    groupId: \$groupId
    groupTitle: \$groupTitle
    active: \$active
    isMobile: \$isMobile
    store: \$store
  ) {
    count
    page
    pageSize
    data {
      id
      link
      heading
      img
      imgCdn
      type
      pageId
      groupId
      groupTitle
      active
      createdAt
      updatedAt
    }
  }
}""";
  }

  groupByBanner() {
    return """query groupByBanner(\$type: String, \$pageId: String, \$groupTitle: String, \$store: ID) {
  groupByBanner(type: \$type, pageId: \$pageId, groupTitle: \$groupTitle, store: \$store) {
    _id {    
      title
    }
    data {
      link
      heading
      img
      imgCdn
      sort
      type
      pageId
      active
      groupId
      groupTitle
      createdAt
      updatedAt
    }
  }
}
 """;
  }

  saveAddress() {
    return """mutation saveAddress(
    \$id:String!
  \$email: String
  \$firstName: String
  \$lastName: String
  \$address: String
  \$town: String
  \$city: String
  \$country: String
  \$state: String
  \$zip: Int
  \$phone: String
  \$store: ID
) {
  saveAddress(
  id: \$id
    email: \$email
    firstName: \$firstName
    lastName: \$lastName
    address: \$address
    town: \$town
    city: \$city
    country: \$country
    state: \$state
    zip: \$zip
    phone: \$phone
    store: \$store
  ) {
    id
    firstName
    lastName
    address
    town
    city
    country
    state
    zip
    phone
    active
    createdAt
    updatedAt
  }
}""";
  }

  myAddresses() {
    return """query {
  myAddresses {
    count
    page
    pageSize
    data {
      id
      type
      firstName
      lastName
      type
      address
      email
      town
      district
      city
      country
      state
      zip
      phone
      user
    }
  }
} """;
  }

  deleteAddress() {
    return """mutation deleteAddress(\$id: ID!) {
  deleteAddress(id: \$id)
}""";
  }

  checkOut() {
    return """mutation checkout(\$address: ID!, \$paymentMethod: String) {
  checkout(address: \$address, paymentMethod: \$paymentMethod) {
    id
    orderNo
    otp
    amount {
      qty
      subtotal
      discount
      shipping
      total
    }
    paymentOrderId
    delivery {
      otp
    }
    items {
      status
      pid
      name
      slug
      img
      qty
      price
      vendor {
        store
      }
      options
      brandName
    }
    address {
      email
      firstName
      lastName
      address
      town
      city
      country
      state
      zip
      phone
    }
    createdAt
    updatedAt
  }
}""";
  }

//   pendingOrders() {
//     return """query pendingOrders(
//   \$page: Int
//   \$skip: Int
//   \$limit: Int
//   \$search: String
//   \$sort: String
//   \$q: String
// ) {
//   pendingOrders(
//     page: \$page
//     q: \$q
//     skip: \$skip
//     limit: \$limit
//     search: \$search
//     sort: \$sort
//   ) {
//     data {
//       id
//       orderNo
//       otp
//       amount {
//         qty
//         subtotal
//         total
//         shipping
//         discount
//       }
//       delivery {
//         otp
//         finish {
//           lat
//           lng
//         }
//       }
//       items {
//         name
//         slug
//         img
//         rate
//         qty
//         status
//       }
//       user {
//         phone
//         firstName
//         lastName
//       }
//       address {
//         firstName
//         lastName
//         address
//         town
//         city
//         zip
//         coords {
//           lat
//           lng
//         }
//       }
//       createdAt
//       updatedAt
//     }
//   }
// }""";
//   }


  order(){
    return """
    query order(\$id: ID!) {
  order(id: \$id) {
     id
    orderNo
    otp
    amount {
      qty
      subtotal
      discount
      shipping
      total
    }
    paymentOrderId
    delivery {
      otp
    }
    items {
      status
      pid
      name
      slug
      img
      imgCdn
      qty
      price
      vendor {
        store
      }
      options
      brandName
    }
    address {
      email
      firstName
      lastName
      address
      town
      city
      country
      state
      zip
      phone
    }
    createdAt
    updatedAt
  }
}""";
  }

  myOrders() {
    return """query myOrders(
  \$page: Int
  \$skip: Int
  \$limit: Int
  \$search: String
  \$sort: String
  \$status: String
  \$store: ID
) {
  myOrders(
    page: \$page
    skip: \$skip
    limit: \$limit
    search: \$search
    sort: \$sort
    status: \$status
    store: \$store
  ) {
    count
    pageSize
    page
    data {
      id
      orderNo
      otp
      createdAt
      updatedAt
      codPaid
      paymentMode
      paymentStatus
      paymentCurrency
      paymentReferenceId
      paymentOrderId
      paymentReceipt
      invoiceId
      paymentGateway
      codPaid
      amountPaid
      amountDue
      paymentStatus
      paymentMsg
      paymentTime
      paid
      amount {
        qty
        subtotal
        tax
        discount
        total
        shipping
      }
      userFirstName
      userLastName
      userPhone
      address {
        firstName
        lastName
        town
        city
        state
        zip
        address
        lat
        lng
        email
        phone
      }
      items {
        id
        pid
        posInvoiceNo
        itemOrderNo
        name
        barcode
        img
        imgCdn
        slug
        price
        qty
        shippingCharge
        tax
        time
        options
        brandName
        brandImg
        orderStatus {
          id
          event
          tracking_id
          courier_name
        }
        vendor {
          firstName
          lastName
          phone
          address {
            address
          }
          store
        }
        status
      }
      orderItems {
        id
        pid
        posInvoiceNo
        itemOrderNo
        name
        barcode
        img
        imgCdn
        slug
        price
        qty
        shippingCharge
        tax
        time
        options
        brandName
        brandImg
        orderStatus {
          id
          event
          tracking_id
          courier_name
        }
        vendor {
          firstName
          lastName
          phone
          address {
            address
          }
          store
        }
        status
      }
    }
  }
}""";
  }

  returnItem(){
    return """mutation returnOrReplace(
  \$orderId: ID!
  \$pId: String!
  \$reason: String!
  \$requestType: String!
  \$qty: Int
) {
  returnOrReplace(
    orderId: \$orderId
    pId: \$pId
    reason: \$reason
    requestType: \$requestType
    qty: \$qty
  ) {
    id
    orderNo
    otp
    amount {
      qty
      subtotal
      discount
      shipping
      total
      tax
    }
    paymentOrderId
    paymentMode
    paymentAmount
    paymentCurrency
    paymentReferenceId
    delivery {
      otp
    }
    items {
      status
      pid
      posInvoiceNo
      itemOrderNo
      name
      slug
      img
      tracking
      shippingCharge
      tax
      brandName
      brandImg
      parentBrandName
      parentBrandImg
    }
    orderItems {
      status
      pid
      posInvoiceNo
      itemOrderNo
      name
      slug
      img
      tracking
      shippingCharge
      tax
      brandName
      brandImg
      parentBrandName
      parentBrandImg
    }
    address {
      firstName
      lastName
      phone
      lat
      lng
    }
    createdAt
    updatedAt
  }
}
""";
  }

  orderItem(){
    return """query orderItem(\$id: ID!) {
  orderItem(id: \$id) {
    id
    orderId
    status
    pid
    posInvoiceNo
    itemOrderNo
    name
    slug
    img
    imgCdn
    tracking
    shippingCharge
    price
    qty
    tax
    brandName
    brandImg
    size
    color
    trackingId
    returnTrackingId
    courierName
    returnCourierName
    days
    type
    #order level info
    orderNo
    otp
    createdAt
    paySuccess
    paymentMode
    paymentStatus
    paymentCurrency
    paymentReferenceId
    paymentOrderId
    paymentReceipt
    invoiceId
    paymentGateway
    codPaid
    amountPaid
    amountDue
    paymentMsg
    paymentTime
    paid
    userFirstName
    userLastName
    userPhone
    userEmail
    invoiceLink
    returnValidTill
    user {
      id
      firstName
    }
    address {
      firstName
      lastName
      town
      city
      state
      zip
      address
      lat
      lng
      email
      phone
    }
    orderHistory {
      id
      status
      title
      body
      icon
      public
      index
      time
    }
    vendor {
      firstName
      lastName
      phone
      address {
        address
      }
      store
    }
  }
}""";
  }

  paySuccessPageHit() {
    return """mutation paySuccessPageHit(\$orderId: ID, \$paymentReferenceId: String) {
  paySuccessPageHit(
    orderId: \$orderId
    paymentReferenceId: \$paymentReferenceId
  ) {
    id
    orderNo
    otp
    createdAt
    paySuccess
    paymentMode
    paymentStatus
    paymentCurrency
    paymentReferenceId
    paymentOrderId
    paymentReceipt
    invoiceId
    paymentGateway
    codPaid
    baseCodPaid
    amountPaid
    amountDue
    paymentMsg
    paymentTime
    paid
    totalAmountRefunded
    baseTotalAmountRefunded
    amount {
      qty
      subtotal
      tax
      discount
      total
      shipping
    }
    baseAmount {
      qty
      subtotal
      tax
      discount
      total
      shipping
    }
    userFirstName
    userLastName
    userPhone
    userEmail
    address {
      firstName
      lastName
      town
      city
      state
      zip
      address
      lat
      lng
    }
    items {
      id
      pid
      posInvoiceNo
      itemOrderNo
      name
      barcode
      img
      imgCdn
      slug
      price
      basePrice
      qty
      shippingCharge
      baseShippingCharge
      tax
      baseTax
      time
      options
      brandName
      brandImg
      color
      size
      status
      type
      returnReason

      vendorAddress {
        firstName
        lastName
        town
        city
        state
        zip
        address
        lat
        lng
      }
      status
      orderHistory {
        status
        title
        body
        icon
        public
        index
        time
      }
      amountRefunded
      baseAmountRefunded
    }
  }
}""";
  }

  checkWishList() {
    return """query checkWishlist(\$product: ID!, \$variant: ID!) {
  checkWishlist(product: \$product, variant: \$variant)
}""";
  }

  toggleWishList() {
    return """mutation toggleWishlist(\$product: ID!, \$variant: ID!) {
  toggleWishlist(product: \$product, variant: \$variant)
}""";
  }

  myWishlist() {
    return """query myWishlist(
  \$page: Int
  \$search: String
  \$limit: Int
  \$sort: String
  \$store: ID
) {
  myWishlist(
    page: \$page
    search: \$search
    limit: \$limit
    sort: \$sort
    store: \$store
  ) {
    count
    page
    pageSize
    data {
      id
      active
      createdAt
      updatedAt
      product {
        id
        name
        slug
        imgCdn
        price
        mrp
        brand {
          id
          name
          img
        }
      }
      variant {
        id
        name
      }
      user {
        id
        firstName
        lastName
      }
      store {
        id
        name
        email
      }
    }
  }
}""";
  }

  updateProfile() {
    return """mutation updateProfile(
  \$address: AddressInput
  \$firstName: String
  \$lastName: String
  \$email: String
  \$avatar: String
  \$dob: String
  \$gender: String
  # \$state: String
  # \$city: String
  \$phone: String
  \$info: InputInfo
) {
  updateProfile(
    firstName: \$firstName
    lastName: \$lastName
    email: \$email
    avatar: \$avatar
    phone:\$phone
    dob: \$dob
    gender: \$gender
    info: \$info
    address: \$address
  ) {
    firstName
    lastName
    email
    avatar
    role
    verified
    gender
    city
    address {
      address
      town
      city
      state
      zip
    }
    info {
      public
      store
    }
  }
}""";
  }

  fileUpload() {
    return """mutation fileUpload(\$files: [Upload!], \$folder: String) {
  fileUpload(files: \$files, folder: \$folder) {
    filename
    mimetype
    encoding
    url
  }
}""";
  }

  brands() {
    return """query brands(\$page: Int, \$search: String, \$limit: Int, \$sort: String, \$store: ID) {
  brands(page: \$page, search: \$search, limit: \$limit, sort: \$sort, store: \$store) {
    count
    page
    pageSize
    data {
      id
      name
      slug
      img
      position
      meta
      metaTitle
      metaDescription
      metaKeywords
      active
      featured
      createdAt
      updatedAt
    }
  }
}""";
  }

  subBrands() {
    return """query brands(\$page: Int, \$search: String, \$limit: Int, \$sort: String, \$parent: String, \$featured: Boolean) {
  brands(
    page: \$page
    search: \$search
    limit: \$limit
    sort: \$sort
    parent: \$parent
    featured:\$featured
  ) {
    count
    page
    pageSize
    data {
      id
      brandId
      name
      slug
      img
      position
      meta
      metaTitle
      metaDescription
      metaKeywords
      facebookUrl
      instaUrl
      twitterUrl
      linkedinUrl
      youtubeUrl
      active
      featured
      parent {
        id
        name
        __typename
      }
      createdAt
      updatedAt
      __typename
    }
    __typename
  }
}""";
  }

  parentBrands() {
    return """query parentBrands(
  \$page: Int
  \$search: String
  \$limit: Int
  \$sort: String
  \$featured: Boolean
) {
  parentBrands(
    page: \$page
    search: \$search
    limit: \$limit
    sort: \$sort
    featured: \$featured
  ) {
    count
    page
    pageSize
    data {
      id
      brandId
      name
      slug
      img
      position
      meta
      metaTitle
      metaDescription
      metaKeywords
      facebookUrl
      instaUrl
      twitterUrl
      linkedinUrl
      youtubeUrl
      active
      featured
      parent {
        id
        name
      }
      createdAt
      updatedAt
    }
  }
}""";
  }

  reviewSummary() {
    return """query reviewSummary(\$pid: ID!) {
  reviewSummary(pid: \$pid) {
    avg
    count
    total
    reviews
  }
}""";
  }

  paypalExecute(){
    return """mutation paypalExecute(\$PayerID: String!, \$paymentId: String!, \$token: String) {
  paypalExecute(PayerID: \$PayerID, paymentId: \$paymentId, token: \$token) {
    id
    orderNo
    otp
    createdAt
    paySuccess
    paymentMode
    paymentStatus
    paymentCurrency
    paymentReferenceId
    paymentOrderId
    paymentReceipt
    invoiceId
    paymentGateway
    codPaid
    baseCodPaid
    amountPaid
    amountDue
    paymentMsg
    paymentTime
    paid
    totalAmountRefunded
    baseTotalAmountRefunded
    amount {
      qty
      subtotal
      tax
      discount
      total
      shipping
    }
    baseAmount {
      qty
      subtotal
      tax
      discount
      total
      shipping
    }
    userFirstName
    userLastName
    userPhone
    userEmail
    address {
      firstName
      lastName
      town
      city
      state
      zip
      address
      lat
      lng
    }
    items {
      id
      pid
      posInvoiceNo
      itemOrderNo
      name
      barcode
      img
      slug
      price
      basePrice
      qty
      shippingCharge
      baseShippingCharge
      tax
      baseTax
      time
      options
      brandName
      brandImg
      color
      size
      status
      type
      returnReason

      vendorAddress {
        firstName
        lastName
        town
        city
        state
        zip
        address
        lat
        lng
      }
      status
      orderHistory {
        status
        title
        body
        icon
        public
        index
        time
      }
      amountRefunded
      baseAmountRefunded
    }
  }
}""";
  }

  brainTreeMakePayment(){
    return """mutation braintreeMakePayment(\$nonce: String!, \$token: String!) {
  braintreeMakePayment(nonce: \$nonce, token: \$token) {
    id
    orderNo
    otp
    createdAt
    paySuccess
    paymentMode
    paymentStatus
    paymentCurrency
    paymentReferenceId
    paymentOrderId
    paymentReceipt
    invoiceId
    paymentGateway
    codPaid
    baseCodPaid
    amountPaid
    amountDue
    paymentMsg
    paymentTime
    paid
    totalAmountRefunded
    baseTotalAmountRefunded
    amount {
      qty
      subtotal
      tax
      discount
      total
      shipping
    }
    baseAmount {
      qty
      subtotal
      tax
      discount
      total
      shipping
    }
    userFirstName
    userLastName
    userPhone
    userEmail
    address {
      firstName
      lastName
      town
      city
      state
      zip
      address
      lat
      lng
    }
    items {
      id
      pid
      posInvoiceNo
      itemOrderNo
      name
      barcode
      img
      slug
      price
      basePrice
      qty
      shippingCharge
      baseShippingCharge
      tax
      baseTax
      time
      options
      brandName
      brandImg
      color
      size
      status
      type
      returnReason

      vendorAddress {
        firstName
        lastName
        town
        city
        state
        zip
        address
        lat
        lng
      }
      status
      orderHistory {
        status
        title
        body
        icon
        public
        index
        time
      }
      amountRefunded
      baseAmountRefunded
    }
  }
}""";
  }

  brainTreeToken(){
    return"""mutation braintreeToken(\$address: ID) {
  braintreeToken(address: \$address) {
    id
    paymentOrderId
    paymentMode
    paymentGateway
    referenceId
    txMsg
    txTime
    invoiceId
    receipt
    paid
    amountPaid
    amountDue
    amountRefunded
    currency
    captured
    status
    orderId
    notes
    refundStatus
    description
    email
    contact
    fee
    tax
    errorCode
    errorDescription
    token
  }
}""";
  }

  paypalPayNow(){
    return """mutation paypalPayNow(\$address: ID) {
  paypalPayNow(address: \$address) {
    id
    intent
    state
    redirect_url
    transactions {
      amount {
        total
        currency
      }
      description
    }
    links {
      href
      rel
      method
    }
  }
}""";
  }

  // Stripe

  stripe(){
    return """
    mutation stripe(\$address: ID, \$paymentMethodId: String!) {
      stripe(address: \$address, paymentMethodId: \$paymentMethodId) {
        id
        clientSecret
  }
    }
    """;
  }


  cashfreePayNow() {
    return """mutation cashfreePayNow(\$address: ID) {
  cashfreePayNow(address: \$address) {
    appId
    orderId
    orderAmount
    orderCurrency
    orderNote
    customerName
    customerEmail
    customerPhone
    returnUrl
    notifyUrl
    signature
    stage
    url
    token
  }
}""";
  }

  productGroup() {
    return """query product_group(\$id: ID!) {
  product_group(id: \$id) {
    sizeGroup {
      id
      slug
      size {
        id
        name
      }
    }
    colorGroup {
      id
      slug
      color {
        id
        name
        color_code
      }
    }
  }
}""";
  }

  getLocationFromZip() {
    return """query getLocationFromZip(\$zip: Int!) {
  getLocationFromZip(zip: \$zip) {
    zip
    state
    city
    country
  }
}""";
  }

  coupons() {
    return """query coupons(\$page: Int, \$search: String, \$limit: Int, \$sort: String) {
  coupons(page: \$page, search: \$search, limit: \$limit, sort: \$sort) {
    count
    page
    pageSize
    data {
      id
      code
      value
      type
      info
      msg
      text
      terms
      color
      minimumCartValue
      maxAmount
      validFromDate
      validToDate
      active
      createdAt
      updatedAt
    }
  }
}""";
  }

  applyCoupon() {
    return """mutation applyCoupon(\$code: String!) {
  applyCoupon(code: \$code) {
     id
    items {
      pid
      barcode
      tax
      vendor {
        id
        store
        firstName
        lastName
        phone
      }
      brand {
        id
        name
      }
      name
      slug
      qty
      price
      shippingCharge
      img
      options
      tracking
    }
    qty
    subtotal
    discount {
      code
      value
      text
      amount
    }
    shipping {
      charge
    }
    total
    tax
  }
}""";
  }

  saveFcmToken() {
    return """mutation saveFcmToken(
  \$id: String!
  \$token: String
  \$platform: String
  \$device_id: String
  \$active: Boolean
) {
  saveFcmToken(
    id: \$id
    token: \$token
    platform: \$platform
    device_id: \$device_id
    active: \$active
  ) {
    id
    token
    platform
    device_id
    user_type
    sId
    user {
      id
    }
    active
    createdAt
    updatedAt
  }
}""";
  }

  myTokens() {
    return """query myTokens(\$page: Int, \$search: String, \$limit: Int, \$sort: String) {
  myTokens(page: \$page, search: \$search, limit: \$limit, sort: \$sort) {
    count
    page
    pageSize
    data {
      id
      token
      platform
      device_id
      user_type
      sId
      user {
        id
      }
      active
      createdAt
      updatedAt
    }
  }
}""";
  }

  megamenu() {
    return """query megamenu(\$id: ID, \$slug: String, \$search: String, \$sort: String, \$featured: Boolean, \$store: ID) {
  megamenu(
    id: \$id
    slug: \$slug
    search: \$search
    sort: \$sort
    featured: \$featured
    store: \$store
  ) {
    id
    name
    slug
    img
    featured
    children {
      name
      slug
      img
      featured
      children {
        name
        slug
        img
        featured
        children {
          name
          slug
          img
          featured
          children {
            name
            slug
            img
            featured
            children {
              name
              slug
              img
              featured
              children {
                name
                slug
                img
                featured
                children {
                  name
                  slug
                  img
                  featured
                  children {
                    name
                    slug
                    img
                    featured
                    children {
                      name
                      slug
                      img
                      featured
                      __typename
                    }
                    __typename
                  }
                  __typename
                }
                __typename
              }
              __typename
            }
            __typename
          }
          __typename
        }
        __typename
      }
      __typename
    }
    __typename
  }
}""";
  }
  saveReview(){
    return """
  mutation saveReview(
  \$id: String!
  \$pid: ID!
  \$variant: ID
  \$user: ID
  \$rating: Int
  \$message: String
  \$active: Boolean
  \$store: ID
) {
  saveReview(
    id: \$id
    pid: \$pid
    variant: \$variant
    user: \$user
    rating: \$rating
    message: \$message
    active: \$active
    store: \$store
  ) {
    id
    pid {
      name
      slug
      img
      type
    }
    user {
      firstName
      lastName
      phone
    }
    rating
    message
    active
  }
}""";

}
}

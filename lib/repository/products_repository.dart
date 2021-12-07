import '../../utility/api_provider.dart';

class ProductsRepository {
  ApiProvider _apiProvider = ApiProvider();

  fetchRecommendedProducts(){
   return _apiProvider.fetchRecommendedProducts(); 
  }
  
  fetchHotData() {
    return _apiProvider.fetchHotData();
  }

  fetchSuggestedData() {
    return _apiProvider.fetchSuggestedData();
  }

  fetchYouMayLikeData() {
    return _apiProvider.fetchYouMayLikeData();
  }

  fetchProductList(categoryName, searchText, brand, color, size, gender,priceRange,ageGroup,discount, page,parentBrand,brandId,urlLink,sort) {
    return _apiProvider.fetchProductList(
        categoryName, searchText, brand, color, size, gender,priceRange,ageGroup,discount, page,parentBrand,brandId,urlLink,sort);
  }

  fetchProductDetailApi(productId) {
    return _apiProvider.fetchProductDetailApi(productId);
  }
}

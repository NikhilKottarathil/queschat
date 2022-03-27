class Urls {

  String serverAddress = 'https://api.queschat.com/';
  String apiAddress = 'https://api.queschat.com/api/';
  String categoryImage = 'icons/category.svg';
  String productImage = 'icons/phone.svg';
  String razorPayApiKry = 'rzp_test_ggroFiTdfl4T5I';

  String getImageUrl(String imageUrl) {
    return serverAddress + imageUrl;
  }
}

class AppExceptions {
  Exception serverException = Exception(['Server is down']);
  Exception badGateWay = Exception('Bad gate way');
  Exception somethingWentWrong =
  Exception('Something went wrong please try again');
}
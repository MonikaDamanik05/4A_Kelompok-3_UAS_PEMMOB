class Endpoints {
  static String baseURLLive = "http://192.168.53.185:5000";

// update baseURL
  static void updateBaseURL(String url) {
    baseURLLive = url;
  }

  //auth
  static String get register => "$baseURLLive/api/v1/auth/register";
  static String get dataLogin => "$baseURLLive/api/v1/auth/login";
  static String get login1 => "$baseURLLive/api/v1/protected/data";

  //kuliner
  static String get readkuliner => "$baseURLLive/api/v1/kuliner/read";
  static String get createkuliner => "$baseURLLive/api/v1/kuliner/create";
  static String get updatekuliner =>"$baseURLLive/api/v1/kuliner/update";
  static String get deletekuliner => "$baseURLLive/api/v1/kuliner/delete";
  static String get upload => "$baseURLLive/api/v1/user/upload";
  static String get bintang => "$baseURLLive/api/v1/kuliner/rating";

  //ulasan
  static String get readkomentar => "$baseURLLive/api/v1/ulasan/read";
  static String get updatekomentar => "$baseURLLive/api/v1/ulasan/update";
  static String get deletekomentar => "$baseURLLive/api/v1/ulasan/delete";
  static String get createkomentar => "$baseURLLive/api/v1/ulasan/create";
  static String get fotokomentar => "$baseURLLive/api/v1/ulasan/upload";

  static String get readUserById => "$baseURLLive/api/v1/user/read_by_user";
  static String get updateUser => "$baseURLLive/api/v1/user/update";
  static String get uploadUserPhoto => "$baseURLLive/api/v1/user/upload";
  static String get getUserPhoto => "$baseURLLive/api/v1/user/photo";

  static String get getKulinerPhoto => "$baseURLLive/api/v1/kuliner/photo";
}

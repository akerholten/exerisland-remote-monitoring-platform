// TODO: HTTP Requests to back-end

class LoginHandler {
  // These functions could potentially return bools (success/failure) or ints (HTTP error codes)

  static bool isLoggedInWithCookie(){ // or doCookieVerification / tryCookieLogin
    // Check for cookie with doing a post request to back-end
    // Back-end will check for the cookie
    // If valid cookie, then login
    return false;
  }

  static bool login(String email, String password){
    // Hash and encrypt before sent to back-end
    // HTTP request to back-end for logging in
    // Login or not login ( create cookie on back end )
    return true;
  }

}
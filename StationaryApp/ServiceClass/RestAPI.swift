//
//  RestAPI.swift
//  MyPlayer11
//
//  Created by Mohd Arsad on 18/04/19.
//  Copyright © 2019 Mohd Arsad. All rights reserved.
//

import Foundation
import Alamofire

open class RestAPI {
    
    //Shared object to get single inctance
    static let shared = RestAPI()
    
    //Header data to put authentication by token
    var headerData : [String : String] {
        get {
            let token = UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.kUserSecuirityToken) ?? ""
            return ["Content-Type" : "application/json", "Authorization" : "Bearer \(token)"]
        }
    }
    
    var headerAdminData : [String : String] {
        get {
            
            let token = UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.kAdminSecuirityToken) ?? ""
            
            let timeInterval = String(format: "%.f", Date().timeIntervalSince1970)
            let nonceStr = "\(timeInterval)"
            
            var authStr: String = "OAuth "
            authStr += "oauth_consumer_key=\(APIHelper.consumerKey),"
            authStr += "oauth_token=\(APIHelper.accessToken),"
            authStr += "oauth_secret=\(APIHelper.tokenSecret),"
            authStr += "oauth_signature_method=HMAC-SHA1,"
            authStr += "oauth_timestamp=\(timeInterval),"
            authStr += "oauth_nonce=\(nonceStr),"
            authStr += "oauth_version=1.0,"
            authStr += "oauth_signature=\(token)"
            
//            let headerData = ["Authorization" : authStr, "Cache-Control" : "no-cache"]
            let headerData = ["Authorization" : "Bearer \(token)", "Cache-Control" : "no-cache"]
            return headerData
        }
    }
}

//MARK: - SignUp & Login
extension RestAPI {
    
    /// Get Token
    /// - Parameters:
    ///   - params: params of get token and user info to validate your authentication
    ///   - completion: API response to check your request result
    func getToken(params: [String : Any], completion: @escaping(_ message: String, _ errorCode: Int) -> Void) {
        
        //Generate API combined url to put on request
        let urlStr = APIConstant.MainUrl + APIConstant.getCustomerToken
        
        //Header data, used when request need authentication
        let headerData = RestAPI.shared.headerData
        
        Alamofire.request(urlStr, method: .post, parameters: params, encoding: JSONEncoding.default, headers:headerData).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote data: \(String(describing: response.result.error))")
                //Show default message when API failed or time out by internet connectivity or some issues.
                completion(APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                return
            }
            guard let data = response.data else { completion(APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
            print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")
            // make sure this JSON is in the format we expect
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let errorMessage = json["message"] as? String ?? APIHelper.apiFailedMessage
                completion(errorMessage, APIHelper.apiResponseErrorCode)
            } else if let token = try? JSONSerialization.jsonObject(with: data, options: []) as? String {
                UserDefaults.standard.setValue(token, forKey: Constant.UserDefaultKeys.kUserSecuirityToken)
                completion(token, APIHelper.apiResponseSuccessCode)
            } else if var token = String(data: data, encoding: String.Encoding.utf8) {
                if token.contains(" ") {
                    completion(APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                } else {
                    token = token.replacingOccurrences(of: "\"", with: "")
                    UserDefaults.standard.setValue(token, forKey: Constant.UserDefaultKeys.kUserSecuirityToken)
                    completion(token, APIHelper.apiResponseSuccessCode)
                }
            } else {
                completion(APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
            }
        }
    }
    
    /// Get Token
    /// - Parameters:
    ///   - params: params of get token and user info to validate your authentication
    ///   - completion: API response to check your request result
    func getAdminToken(completion: @escaping(_ errorCode: Int) -> Void) {
        
        //Generate API combined url to put on request
        let urlStr = APIConstant.MainUrl + APIConstant.getAdminToken
        
        //Header data, used when request need authentication
        let headerData = RestAPI.shared.headerData
        
        var params: [String: Any] = [:]
        params["username"] = "developer"
        params["password"] = "!developer11!"
        
        Alamofire.request(urlStr, method: .post, parameters: params, encoding: JSONEncoding.default, headers:headerData).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote data: \(String(describing: response.result.error))")
                //Show default message when API failed or time out by internet connectivity or some issues.
                completion(APIHelper.apiFailedCode)
                return
            }
            guard let data = response.data else { completion(APIHelper.apiFailedCode); return }
            print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")
            // make sure this JSON is in the format we expect
            if let _ = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                completion(APIHelper.apiResponseErrorCode)
            } else if let token = try? JSONSerialization.jsonObject(with: data, options: []) as? String {
                UserDefaults.standard.setValue(token, forKey: Constant.UserDefaultKeys.kAdminSecuirityToken)
                completion(APIHelper.apiResponseSuccessCode)
            } else if var token = String(data: data, encoding: String.Encoding.utf8) {
                if token.contains(" ") {
                    completion(APIHelper.apiFailedCode)
                } else {
                    token = token.replacingOccurrences(of: "\"", with: "")
                    UserDefaults.standard.setValue(token, forKey: Constant.UserDefaultKeys.kAdminSecuirityToken)
                    completion(APIHelper.apiResponseSuccessCode)
                }
            } else {
                completion(APIHelper.apiFailedCode)
            }
        }
    }
    
    /// SignUp API
    /// - Parameters:
    ///   - params: input params to validate on server
    ///   - completion: user info response to user in application
    func signUp(params: [String : Any], completion: @escaping(_ message: String, _ errorCode: Int) -> Void) {
        
        //Generate API combined url to put on request
        let urlStr = APIConstant.MainUrl + APIConstant.signUp
        //Header data, used when request need authentication
        let headerData = RestAPI.shared.headerData
        
        Alamofire.request(urlStr, method: .post, parameters: params, encoding: JSONEncoding.default, headers:headerData).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote data: \(String(describing: response.result.error))")
                //Show default message when API failed or time out by internet connectivity or some issues.
                completion(APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                return
            }
            guard let data = response.data else { completion(APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
            print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")
            do {
                //Validate data into your decodable model by JSONDecoder and use as your need
                let result = try JSONDecoder().decode(Profile.self, from: data)
                if let message = result.message {
                    completion(message, APIHelper.apiResponseErrorCode)
                } else {
                    completion("Profile Successfully Created", APIHelper.apiResponseSuccessCode)
                }
            } catch {
                //Show default message when data are not parsed into defined format
                completion(APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
            }
        }
    }
    
    /// Profile API
    /// - Parameters:
    ///   - params: input params to validate on server
    ///   - completion: user info response to user in application
    func getProfile(params: [String : Any], completion: @escaping(_ profile: Profile?, _ message: String, _ errorCode: Int) -> Void) {
        
        //Generate API combined url to put on request
        let urlStr = APIConstant.MainUrl + APIConstant.getProfile
        //Header data, used when request need authentication
        
        let headerData = RestAPI.shared.headerData
        print(headerData)
        Alamofire.request(urlStr, method: .get, parameters: nil, encoding: URLEncoding.default, headers:headerData).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote data: \(String(describing: response.result.error))")
                //Show default message when API failed or time out by internet connectivity or some issues.
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                return
            }
            guard let data = response.data else { completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
            print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")
            do {
                //Validate data into your decodable model by JSONDecoder and use as your need
                let result = try JSONDecoder().decode(Profile.self, from: data)
                if let message = result.message {
                    completion(result, message, APIHelper.apiResponseErrorCode)
                } else {
                    completion(result, "Profile Getting", APIHelper.apiResponseSuccessCode)
                    SupportMethod.cachedUserLoginData(data: result)
                }
            } catch {
                //Show default message when data are not parsed into defined format
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
            }
        }
    }
    
    /// Update Profile API
    /// - Parameters:
    ///   - params: input params to validate on server
    ///   - completion: user info response to user in application
    func updateProfile(params: [String : Any], completion: @escaping(_ message: String, _ errorCode: Int) -> Void) {
        
        //Generate API combined url to put on request
        let urlStr = APIConstant.MainUrl + APIConstant.getProfile
        let headerData = RestAPI.shared.headerData
        print(headerData)
        Alamofire.request(urlStr, method: .put, parameters: params, encoding: JSONEncoding.default, headers:headerData).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote data: \(String(describing: response.result.error))")
                //Show default message when API failed or time out by internet connectivity or some issues.
                completion(APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                return
            }
            guard let data = response.data else { completion(APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
            print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")
            do {
                //Validate data into your decodable model by JSONDecoder and use as your need
                let result = try JSONDecoder().decode(Profile.self, from: data)
                if let message = result.message {
                    completion(message, APIHelper.apiResponseErrorCode)
                } else {
                    completion("Profile Getting", APIHelper.apiResponseSuccessCode)
                    SupportMethod.cachedUserLoginData(data: result)
                }
            } catch {
                //Show default message when data are not parsed into defined format
                completion(APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
            }
        }
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

//MARK: - Category Section
extension RestAPI {
    
    func getHomeBanner(completion: @escaping(_ response: [String: Any]?, _ message: String, _ errorCode: Int) -> Void) {
            
            //Generate API combined url to put on request
            let urlStr = APIConstant.getHomeBanner
            
            Alamofire.request(urlStr, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching remote data: \(String(describing: response.result.error))")
                    //Show default message when API failed or time out by internet connectivity or some issues.
                    completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                    return
                }
                guard let data = response.data else { completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
//                print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")

                // make sure this JSON is in the format we expect
                if let serverObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(serverObject, "Slider Image Found", APIHelper.apiResponseSuccessCode)
                } else {
                    completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                }
            }
        }

    /// Get Main Categories API
    /// - Parameters:
    ///   - params: input params to validate on server
    ///   - completion: user info response to user in application
    func getCategories(params: [String : Any], completion: @escaping(_ category: Category?, _ message: String, _ errorCode: Int) -> Void) {
        
        //Generate API combined url to put on request
        let urlStr = APIConstant.MainUrl + APIConstant.getCategoryList
        //Header data, used when request need authentication
        print(headerAdminData)
        
        Alamofire.request(urlStr, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:RestAPI.shared.headerAdminData).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote data: \(String(describing: response.result.error))")
                //Show default message when API failed or time out by internet connectivity or some issues.
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                return
            }
            guard let data = response.data else { completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
//            print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")
            do {
                //Validate data into your decodable model by JSONDecoder and use as your need
                let result = try JSONDecoder().decode(Category.self, from: data)
                if let message = result.message {
                    if message.contains("The consumer isn't authorized to access") {
                        completion(nil, message, APIHelper.apiResponseLoginFailedCode)
                    } else {
                        completion(nil, message, APIHelper.apiResponseErrorCode)
                    }
                } else {
                    completion(result, "Categories Found", APIHelper.apiResponseSuccessCode)
                }
            } catch {
                //Show default message when data are not parsed into defined format
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
            }
        }
    }
    
    /// Get Main Categories API
    /// - Parameters:
    ///   - params: input params to validate on server
    ///   - completion: user info response to user in application
    func getCategories123(params: [String : Any], completion: @escaping(_ category: Category?, _ message: String, _ errorCode: Int) -> Void) {
        
        //Generate API combined url to put on request
        let urlStr = APIConstant.MainUrl + APIConstant.getCategoryList
        //Header data, used when request need authentication
        
        var token = UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.kUserSecuirityToken) ?? ""
//        token = "4qi6wqmzlw0b5c5hq1657em35jthjobb"
        print("Token: \(token)")
        
        let consumerKey: String = "nu11md46gjcrtmgj2j4tqakghmsgy7l6"
        let consumerSecret: String = "6ey7vxw3xkv3cog4flqdd0wwr0c99522"
        let accessToken: String = "vw9mpvx28m2qmb4gostxp81a11hfysxn"
        let tokenSecret: String = "ep9cnyasfok4qwnonyf7zxfs56kcq245"
        
//        OAuth oauth_consumer_key="nu11md46gjcrtmgj2j4tqakghmsgy7l6",oauth_token="vw9mpvx28m2qmb4gostxp81a11hfysxn",oauth_signature_method="HMAC-SHA1",oauth_timestamp="1591593702",oauth_nonce="ARJRnPMG78n",oauth_version="1.0",oauth_signature="nZLp8Mh4YBlbJKcintvlV5xVVHs="
        
        
        
        
        let timeInterval = String(format: "%.f", Date().timeIntervalSince1970)
        let nonceStr = ""//randomString(length: 15)
        
        var authStr: String = "OAuth "
        authStr += "oauth_consumer_key=\(consumerKey),"
        authStr += "oauth_token=\(accessToken),"
        authStr += "oauth_secret=\(tokenSecret),"
        authStr += "oauth_signature_method=HMAC-SHA1,"
        authStr += "oauth_timestamp=\(timeInterval),"
        authStr += "oauth_nonce=\(nonceStr),"
//        authStr += "oauth_version=1.0,"
        authStr += "oauth_signature=\(token)"//nZLp8Mh4YBlbJKcintvlV5xVVHs=
        
        //Cache-Control: no-cache
        let headerData = ["Authorization" : authStr, "Cache-Control" : "no-cache"] //"Bearer \(token)" RestAPI.shared.headerData
        
//        val consumer = OkHttpOAuthConsumer(BuildConfig.CONSUMER_KEY, BuildConfig.CONSUMER_SECRET)
//        consumer.setTokenWithSecret(BuildConfig.ACCESS_TOKEN, BuildConfig.TOKEN_SECRET)
//        httpClient.addInterceptor(logging)
//        httpClient.addInterceptor(SigningInterceptor(consumer))
//        builder.client(httpClient.build())
        
        
        
        
        print(headerData)
        Alamofire.request(urlStr, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:headerData).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote data: \(String(describing: response.result.error))")
                //Show default message when API failed or time out by internet connectivity or some issues.
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                return
            }
            guard let data = response.data else { completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
            print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")
            do {
                //Validate data into your decodable model by JSONDecoder and use as your need
                let result = try JSONDecoder().decode(Category.self, from: data)
                if let message = result.message {
                    completion(nil, message, APIHelper.apiResponseErrorCode)
                } else {
                    completion(result, "Categories Found", APIHelper.apiResponseSuccessCode)
                }
            } catch {
                //Show default message when data are not parsed into defined format
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
            }
        }
    }
}

//MARK: - Products
extension RestAPI {

    /// Get All Product API
    /// - Parameters:
    ///   - params: input params to validate on server
    ///   - completion: user info response to user in application
    func getProducts(pageNo: String = "1", key: String, value: String, completion: @escaping(_ category: ProductResponse?, _ message: String, _ errorCode: Int) -> Void) {
        
        //Generate API combined url to put on request
        var urlStr = APIConstant.MainUrl + APIConstant.productsList
        urlStr += pageNo
        urlStr += "&searchCriteria[filterGroups][0][filters][0][field]=\(key)&searchCriteria[filterGroups][0][filters][0][value]=\(value)"
        urlStr += "&searchCriteria[sortOrders][][field]=created_at"
        urlStr += "&searchCriteria[sortOrders][][direction]=ASC"
        //searchCriteria[sortOrders][][field] : created_at
        //searchCriteria[sortOrders][][direction] : ASC //DESC
        
        //Header data, used when request need authentication
        print(headerAdminData)
        
        Alamofire.request(urlStr, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:RestAPI.shared.headerAdminData).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote data: \(String(describing: response.result.error))")
                //Show default message when API failed or time out by internet connectivity or some issues.
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                return
            }
            guard let data = response.data else { completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
//            print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")

            // make sure this JSON is in the format we expect
            if let serverObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let result = ProductResponse(serverData: serverObject)
                if let message = result.message {
                    completion(nil, message, APIHelper.apiResponseErrorCode)
                } else {
                    completion(result, "Products Found", APIHelper.apiResponseSuccessCode)
                }
            } else {
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
            }
        }
    }
    
    /// Get Product Detail API
    /// - Parameters:
    ///   - params: input params to validate on server
    ///   - completion: user info response to user in application
    func getProductDetail(productSku: String, completion: @escaping(_ category: Product?, _ message: String, _ errorCode: Int) -> Void) {
        
        //Generate API combined url to put on request
        var urlStr = APIConstant.MainUrl + APIConstant.productsDetail + productSku
        urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        print(urlStr)
        
        //Header data, used when request need authentication
        print(headerAdminData)
        
        Alamofire.request(urlStr, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:RestAPI.shared.headerAdminData).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote data: \(String(describing: response.result.error))")
                //Show default message when API failed or time out by internet connectivity or some issues.
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                return
            }
            guard let data = response.data else { completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
//            print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")

            // make sure this JSON is in the format we expect
            if let serverObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let result = ProductResponse(serverData: serverObject)
                if let message = result.message {
                    completion(nil, message, APIHelper.apiResponseErrorCode)
                } else {
                    completion(result.product, "Products Found", APIHelper.apiResponseSuccessCode)
                }
            } else {
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
            }
        }
    }
    
    func cancelOrder(orderId: String, completion: @escaping(_ message: String, _ errorCode: Int) -> Void) {
            
        //Generate API combined url to put on request
        let urlStr = APIConstant.MainUrl + "orders/\(orderId)/cancel"
        
        //Header data, used when request need authentication
        print(headerAdminData)
        
        Alamofire.request(urlStr, method: .post, parameters: nil, encoding: JSONEncoding.default, headers:headerAdminData).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote data: \(String(describing: response.result.error))")
                //Show default message when API failed or time out by internet connectivity or some issues.
                completion(APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                return
            }
            guard let data = response.data else { completion(APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
            let str = String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data"
            print(str)
            do {
                //Validate data into your decodable model by JSONDecoder and use as your need
                let result = try JSONDecoder().decode(NoDataResponse.self, from: data)
                completion(result.message ?? "Your order has been cancelled.", APIHelper.apiResponseErrorCode)
            } catch {
                //Show default message when data are not parsed into defined format
                if str == "true" {
                    completion("Order Cancelled.", APIHelper.apiResponseSuccessCode)
                } else {
                    completion(APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                }
            }
        }
    }
}

//MARK: - CART
extension RestAPI {
    
    /// Create Product Cart  API
    /// - Parameters:
    ///   - params: input params to validate on server
    ///   - completion: user info response to user in application
    func createProductCart(completion: @escaping(_ message: String, _ errorCode: Int) -> Void) {
        
        //Generate API combined url to put on request
        let urlStr = APIConstant.MainUrl + (SupportMethod.isLogged ? APIConstant.createCart : APIConstant.guestAddProductInCart)
        
        let headerData = SupportMethod.isLogged ? RestAPI.shared.headerData : RestAPI.shared.headerAdminData
        
        Alamofire.request(urlStr, method: .post, parameters: nil, encoding: JSONEncoding.default, headers:headerData).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote data: \(String(describing: response.result.error))")
                //Show default message when API failed or time out by internet connectivity or some issues.
                completion(APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                return
            }
            guard let data = response.data else { completion(APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
            print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")

            // make sure this JSON is in the format we expect
            if let serverObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let message = serverObject["message"] as? String ?? APIHelper.apiFailedMessage
                completion(message, APIHelper.apiResponseErrorCode)
            } else if let cartId = String(data: data, encoding: String.Encoding.utf8) {
                if SupportMethod.isLogged {
                    UserDefaults.standard.setValue(cartId, forKey: Constant.UserDefaultKeys.cartId)
                    UserDefaults.standard.setValue(nil, forKey: Constant.UserDefaultKeys.guestCartId)
                } else {
                    var cartIdStr = cartId
                    cartIdStr = cartIdStr.replacingOccurrences(of: "\\", with: "")
                    cartIdStr = cartIdStr.replacingOccurrences(of: "\"", with: "")
                    UserDefaults.standard.setValue(nil, forKey: Constant.UserDefaultKeys.cartId)
                    UserDefaults.standard.setValue(cartIdStr, forKey: Constant.UserDefaultKeys.guestCartId)
                }
                completion("Cart Created", APIHelper.apiResponseSuccessCode)
            } else {
                completion(APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
            }
        }
    }
    
    func getCartProductList(completion: @escaping(_ response: [ProductItem]?, _ message: String, _ errorCode: Int) -> Void) {
        
        //Generate API combined url to put on request
        var urlStr = APIConstant.MainUrl
        if SupportMethod.isLogged {
            urlStr += APIConstant.getCart
        } else { //For Guest User
            var cartId = SupportMethod.isLogged ? (UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.cartId) ?? "") : (UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.guestCartId) ?? "")
            cartId = cartId.replacingOccurrences(of: "\\", with: "")
            cartId = cartId.replacingOccurrences(of: "\"", with: "")
            urlStr += APIConstant.guestAddProductInCart + "/\(cartId)/items"
        }
        
        let headerData = RestAPI.shared.headerData
        
        Alamofire.request(urlStr, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:headerData).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote data: \(String(describing: response.result.error))")
                //Show default message when API failed or time out by internet connectivity or some issues.
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                return
            }
            guard let data = response.data else { completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
            print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")

            // make sure this JSON is in the format we expect
            if let serverObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                var arr: [ProductItem] = []
                for object in serverObject {
                    arr.append(ProductItem(serverData: object))
                }
                completion(arr, "Cart Found", APIHelper.apiResponseSuccessCode)
            } else {
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
            }
        }
    }
    
    /// Add Product Cart Value API
    /// - Parameters:
    ///   - params: input params to validate on server
    ///   - completion: user info response to user in application
    func addSigleProductInCart(productSku: String, completion: @escaping(_ item: ProductItem?, _ message: String, _ errorCode: Int) -> Void) {
    
        var cartId = SupportMethod.isLogged ? (UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.cartId) ?? "") : (UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.guestCartId) ?? "")
        cartId = cartId.replacingOccurrences(of: "\\", with: "")
        cartId = cartId.replacingOccurrences(of: "\"", with: "")
        
        var params: [String: Any] = [:]
        params["sku"] = productSku
        params["qty"] = "1"
        params["quote_id"] = cartId
        
        let mainParams: [String: Any] = ["cartItem" : params]
        
        //Generate API combined url to put on request
        var urlStr = APIConstant.MainUrl
        if SupportMethod.isLogged {
            urlStr += APIConstant.getCart
        } else { //For Guest User
            urlStr += APIConstant.guestAddProductInCart + "/\(cartId)/items"
        }
        Alamofire.request(urlStr, method: .post, parameters: mainParams, encoding: JSONEncoding.default, headers:RestAPI.shared.headerData).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote data: \(String(describing: response.result.error))")
                //Show default message when API failed or time out by internet connectivity or some issues.
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                return
            }
            guard let data = response.data else { completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
            print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")

            // make sure this JSON is in the format we expect
            if let serverObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let result = ProductItem(serverData: serverObject)
                if let message = result.message {
                    completion(nil, message, APIHelper.apiResponseErrorCode)
                } else {
                    completion(result, "Products Found", APIHelper.apiResponseSuccessCode)
                }
            } else {
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
            }
        }
    }
    
    /// Add Product Cart Value API
    /// - Parameters:
    ///   - params: input params to validate on server
    ///   - completion: user info response to user in application
    func updateProductCountInCart(productSku: String, itemId: String, count: String, completion: @escaping(_ item: ProductItem?, _ message: String, _ errorCode: Int) -> Void) {
        
        var cartId = SupportMethod.isLogged ? (UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.cartId) ?? "") : (UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.guestCartId) ?? "")
        cartId = cartId.replacingOccurrences(of: "\\", with: "")
        cartId = cartId.replacingOccurrences(of: "\"", with: "")
    
        var params: [String: Any] = [:]
        params["sku"] = productSku
        params["qty"] = count
        params["quote_id"] = cartId
        
        let mainParams: [String: Any] = ["cartItem" : params]
        
        //Generate API combined url to put on request
        var urlStr = APIConstant.MainUrl
        if SupportMethod.isLogged {
            urlStr += (APIConstant.getCart + "/\(itemId)")
        } else { //For Guest User
            urlStr += APIConstant.guestAddProductInCart + "/\(cartId)/items/\(itemId)"
        }
        
        Alamofire.request(urlStr, method: .put, parameters: mainParams, encoding: JSONEncoding.default, headers:RestAPI.shared.headerData).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote data: \(String(describing: response.result.error))")
                //Show default message when API failed or time out by internet connectivity or some issues.
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                return
            }
            guard let data = response.data else { completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
            print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")

            // make sure this JSON is in the format we expect
            if let serverObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let result = ProductItem(serverData: serverObject)
                if let message = result.message {
                    completion(nil, message, APIHelper.apiResponseErrorCode)
                } else {
                    completion(result, "Product Items Found".localized, APIHelper.apiResponseSuccessCode)
                }
            } else {
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
            }
        }
    }
    
    func removeProductFromCart(itemId: String, completion: @escaping(_ message: String, _ errorCode: Int) -> Void) {
    
        //Generate API combined url to put on request
        var urlStr = APIConstant.MainUrl
        if SupportMethod.isLogged {
            urlStr += (APIConstant.getCart + "/\(itemId)")
        } else { //For Guest User
            let cartId = SupportMethod.isLogged ? (UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.cartId) ?? "") : (UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.guestCartId) ?? "")
            urlStr += APIConstant.guestAddProductInCart + "/\(cartId)/items/\(itemId)"
        }
        
        Alamofire.request(urlStr, method: .delete, parameters: nil, encoding: JSONEncoding.default, headers:RestAPI.shared.headerData).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote data: \(String(describing: response.result.error))")
                //Show default message when API failed or time out by internet connectivity or some issues.
                completion(APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                return
            }
            guard let data = response.data else { completion(APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
            print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")

            // make sure this JSON is in the format we expect
            if let _ = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                completion("Failed".localized, APIHelper.apiResponseErrorCode)
            } else if let isTrue = String(data: data, encoding: String.Encoding.utf8) {
                if isTrue == "true" {
                    completion("Item removed from cart".localized, APIHelper.apiResponseSuccessCode)
                } else {
                    completion("Failed".localized, APIHelper.apiResponseErrorCode)
                }
            } else {
                completion(APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
            }
        }
    }
    
    
    /// Get Product Cart  API
    /// - Parameters:
    ///   - params: input params to validate on server
    ///   - completion: user info response to user in application
    func getProductCart(completion: @escaping(_ response: [String: Any]?, _ message: String, _ errorCode: Int) -> Void) {
        
        //Generate API combined url to put on request
        let urlStr = APIConstant.MainUrl + APIConstant.createCart
        
        let headerData = RestAPI.shared.headerData
        
        Alamofire.request(urlStr, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:headerData).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote data: \(String(describing: response.result.error))")
                //Show default message when API failed or time out by internet connectivity or some issues.
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                return
            }
            guard let data = response.data else { completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
            print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")

            // make sure this JSON is in the format we expect
            if let serverObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let message = serverObject["message"] as? String {
                    completion(serverObject, message, APIHelper.apiResponseErrorCode)
                } else {
                    completion(serverObject, APIHelper.apiFailedMessage, APIHelper.apiResponseSuccessCode)
                }
            } else {
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
            }
        }
    }
    
    /// Get Product Reviews Value API
    /// - Parameters:
    ///   - params: input params to validate on server
    ///   - completion: user info response to user in application
    func getProductReviews(productSku: String, completion: @escaping(_ response: ReviewResponse?, _ message: String, _ errorCode: Int) -> Void) {
    
        //Generate API combined url to put on request
        var urlStr = APIConstant.MainUrl + APIConstant.productsDetail + "\(productSku)/reviews"
        urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        print(urlStr)
        
        Alamofire.request(urlStr, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:RestAPI.shared.headerAdminData).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote data: \(String(describing: response.result.error))")
                //Show default message when API failed or time out by internet connectivity or some issues.
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                return
            }
            guard let data = response.data else { completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
            print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")

            // make sure this JSON is in the format we expect
            if let serverObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let result = ReviewResponse(serverData: serverObject)
                if let message = result.message {
                    completion(nil, message, APIHelper.apiResponseErrorCode)
                } else {
                    completion(result, "Products Found".localized, APIHelper.apiResponseSuccessCode)
                }
            } else {
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
            }
            if let serverObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                completion(ReviewResponse(serverData: serverObject), "Data Found", APIHelper.apiResponseSuccessCode)
            } else if let serverObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let message = ReviewResponse(serverData: serverObject).message ?? APIHelper.apiFailedMessage
                completion(nil, message, APIHelper.apiResponseErrorCode)
            } else {
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
            }
        }
    }
    
    func updateProductReviews(params: [String: Any]?, completion: @escaping(_ response: ReviewResponse?, _ message: String, _ errorCode: Int) -> Void) {
        
        //Generate API combined url to put on request
        let urlStr = APIConstant.MainUrl + "reviews"
            
        Alamofire.request(urlStr, method: .post, parameters: params, encoding: JSONEncoding.default, headers:RestAPI.shared.headerAdminData).responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error while fetching remote data: \(String(describing: response.result.error))")
                    //Show default message when API failed or time out by internet connectivity or some issues.
                    completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                    return
                }
                guard let data = response.data else { completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
                print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")

                // make sure this JSON is in the format we expect
                if let serverObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    let result = ReviewResponse(serverData: serverObject)
                    if let message = result.message {
                        completion(nil, message, APIHelper.apiResponseErrorCode)
                    } else {
                        completion(nil, "Products Found".localized, APIHelper.apiResponseSuccessCode)
                    }
                } else {
                    completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                }
            }
        }
}

extension RestAPI {
    
    func estimateShippingAddress(params: [String: Any] ,completion: @escaping(_ response: [[String: Any]]? , _ message: String, _ errorCode: Int) -> Void) {
        
        //Generate API combined url to put on request

        let headerData = RestAPI.shared.headerData

        var cartId = SupportMethod.isLogged ? (UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.cartId) ?? "") : (UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.guestCartId) ?? "")
       cartId = cartId.replacingOccurrences(of: "\\", with: "")
       cartId = cartId.replacingOccurrences(of: "\"", with: "")
       
       //Generate API combined url to put on request
       var urlStr = ""
        if SupportMethod.isLogged {
            urlStr = APIConstant.MainUrl + APIConstant.estimateShippingAddress
        } else {
            urlStr = APIConstant.MainUrl + (APIConstant.guestAddProductInCart + "/\(cartId)/estimate-shipping-methods")
        }
        
        Alamofire.request(urlStr, method: .post, parameters: params, encoding: JSONEncoding.default, headers:headerData).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote data: \(String(describing: response.result.error))")
                //Show default message when API failed or time out by internet connectivity or some issues.
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                return
            }
            guard let data = response.data else { completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
            print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")

            // make sure this JSON is in the format we expect
            if let serverObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                completion(serverObject, "Data Found", APIHelper.apiResponseSuccessCode)
            } else if let serverObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let message = serverObject["message"] as? String ?? APIHelper.apiFailedMessage
                completion(nil, message, APIHelper.apiResponseErrorCode)
            } else if let _ = String(data: data, encoding: String.Encoding.utf8) {
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiResponseErrorCode)
            } else {
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
            }
        }
    }
    
    func estimateShippingInformation(params: [String: Any] ,completion: @escaping(_ response: [String: Any]? , _ message: String, _ errorCode: Int) -> Void) {
        
        //Generate API combined url to put on request
        
        var cartId = SupportMethod.isLogged ? (UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.cartId) ?? "") : (UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.guestCartId) ?? "")
        cartId = cartId.replacingOccurrences(of: "\\", with: "")
        cartId = cartId.replacingOccurrences(of: "\"", with: "")
        
        //Generate API combined url to put on request
        var urlStr = ""
         
         if SupportMethod.isLogged {
             urlStr = APIConstant.MainUrl + APIConstant.estimateShippingInformation
         } else {
             urlStr = APIConstant.MainUrl + (APIConstant.guestAddProductInCart + "/\(cartId)/shipping-information")
         }
        
        let headerData = RestAPI.shared.headerData
        
        Alamofire.request(urlStr, method: .post, parameters: params, encoding: JSONEncoding.default, headers:headerData).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote data: \(String(describing: response.result.error))")
                //Show default message when API failed or time out by internet connectivity or some issues.
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                return
            }
            guard let data = response.data else { completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
            print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")

            // make sure this JSON is in the format we expect
            if let serverObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let message = serverObject["message"] as? String ?? APIHelper.apiFailedMessage
                completion(serverObject, message, APIHelper.apiResponseSuccessCode)
            } else if let _ = String(data: data, encoding: String.Encoding.utf8) {
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiResponseErrorCode)
            } else {
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
            }
        }
    }
    
    func createOrder(params: [String: Any] ,completion: @escaping(_ orderId: String?, _ message: String, _ errorCode: Int) -> Void) {
        
        //Generate API combined url to put on request
        let urlStr = APIConstant.MainUrl + APIConstant.createOrder
        
        let headerData = RestAPI.shared.headerData
        
        Alamofire.request(urlStr, method: .post, parameters: params, encoding: JSONEncoding.default, headers:headerData).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote data: \(String(describing: response.result.error))")
                //Show default message when API failed or time out by internet connectivity or some issues.
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                return
            }
            guard let data = response.data else { completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
            print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")

            // make sure this JSON is in the format we expect
            if let serverObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let message = serverObject["message"] as? String ?? APIHelper.apiFailedMessage
                completion(nil, message, APIHelper.apiResponseErrorCode)
            } else if let orderId = String(data: data, encoding: String.Encoding.utf8) {
                completion(orderId, "Order created successfully", APIHelper.apiResponseSuccessCode)
            } else {
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
            }
        }
    }
    
    func createGuestOrder(params: [String: Any] ,completion: @escaping(_ orderId: String?, _ message: String, _ errorCode: Int) -> Void) {
            
        //Generate API combined url to put on request
        var cartId = SupportMethod.isLogged ? (UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.cartId) ?? "") : (UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.guestCartId) ?? "")
        cartId = cartId.replacingOccurrences(of: "\\", with: "")
        cartId = cartId.replacingOccurrences(of: "\"", with: "")
        
        //Generate API combined url to put on request
        let urlStr = APIConstant.MainUrl + (APIConstant.guestAddProductInCart + "/\(cartId)/order")
         
        let headerData = RestAPI.shared.headerData
        
        Alamofire.request(urlStr, method: .put, parameters: params, encoding: JSONEncoding.default, headers:headerData).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote data: \(String(describing: response.result.error))")
                //Show default message when API failed or time out by internet connectivity or some issues.
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                return
            }
            guard let data = response.data else { completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
            print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")

            // make sure this JSON is in the format we expect
            if let serverObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let message = serverObject["message"] as? String ?? APIHelper.apiFailedMessage
                completion(nil, message, APIHelper.apiResponseErrorCode)
            } else if let orderId = String(data: data, encoding: String.Encoding.utf8) {
                completion(orderId, "Order created successfully", APIHelper.apiResponseSuccessCode)
            } else {
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
            }
        }
    }
    
    func getOrders(completion: @escaping(_ response: [String: Any]?, _ message: String, _ errorCode: Int) -> Void) {
        
        let customerEmail = UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.email) ?? ""
        
        //Generate API combined url to put on request
        let urlStr = APIConstant.MainUrl + APIConstant.getOrderList + customerEmail
        
        let headerData = RestAPI.shared.headerAdminData
        
        Alamofire.request(urlStr, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:headerData).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote data: \(String(describing: response.result.error))")
                //Show default message when API failed or time out by internet connectivity or some issues.
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                return
            }
            guard let data = response.data else { completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
            print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")

            // make sure this JSON is in the format we expect
            if let serverObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let message = serverObject["message"] as? String {
                    completion(serverObject, message, APIHelper.apiResponseErrorCode)
                } else {
                    completion(serverObject, APIHelper.apiFailedMessage, APIHelper.apiResponseSuccessCode)
                }
            } else if let _ = String(data: data, encoding: String.Encoding.utf8) {
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiResponseErrorCode)
            } else {
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
            }
        }
    }
    
    func guestUserShippingAddress(completion: @escaping(_ address: Address?, _ message: String, _ errorCode: Int) -> Void) {
        var cartId = (UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.guestCartId) ?? "")
        cartId = cartId.replacingOccurrences(of: "\\", with: "")
        cartId = cartId.replacingOccurrences(of: "\"", with: "")
        
        //Generate API combined url to put on request
        let urlStr = APIConstant.MainUrl + APIConstant.guestAddProductInCart + "/\(cartId)/billing-address"
        //Header data, used when request need authentication
        
        let headerData = RestAPI.shared.headerData
        print(headerData)
        Alamofire.request(urlStr, method: .get, parameters: nil, encoding: URLEncoding.default, headers:headerData).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote data: \(String(describing: response.result.error))")
                //Show default message when API failed or time out by internet connectivity or some issues.
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                return
            }
            guard let data = response.data else { completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
            print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")
            do {
                //Validate data into your decodable model by JSONDecoder and use as your need
                let result = try JSONDecoder().decode(Address.self, from: data)
                if let message = result.message {
                    completion(result, message, APIHelper.apiResponseErrorCode)
                } else {
                    if let _ = result.firstname {
                        completion(result, "Address Found", APIHelper.apiResponseSuccessCode)
                    } else {
                        completion(result, "", APIHelper.apiResponseErrorCode)
                    }
                }
            } catch {
                //Show default message when data are not parsed into defined format
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
            }
        }
    }
    func updateShippingAddress(params: [String : Any], completion: @escaping(_ message: String, _ errorCode: Int) -> Void) {
        var cartId = SupportMethod.isLogged ? (UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.cartId) ?? "") : (UserDefaults.standard.string(forKey: Constant.UserDefaultKeys.guestCartId) ?? "")
        cartId = cartId.replacingOccurrences(of: "\\", with: "")
        cartId = cartId.replacingOccurrences(of: "\"", with: "")
        
        //Generate API combined url to put on request
        let urlStr = APIConstant.MainUrl + APIConstant.guestAddProductInCart + "/\(cartId)/billing-address"
        
        let headerData = RestAPI.shared.headerData
        print(headerData)
        Alamofire.request(urlStr, method: .post, parameters: params, encoding: JSONEncoding.default, headers:headerData).responseJSON { response in
            guard response.result.isSuccess else {
                print("Error while fetching remote data: \(String(describing: response.result.error))")
                //Show default message when API failed or time out by internet connectivity or some issues.
                completion(APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                return
            }
            guard let data = response.data else { completion(APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
            print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")
            //Validate data into your decodable model by JSONDecoder and use as your need
            if let serverObject = try? JSONDecoder().decode(Profile.self, from: data) {
                let message = serverObject.message ?? APIHelper.apiFailedMessage
                completion(message, APIHelper.apiResponseErrorCode)
            } else if let _ = String(data: data, encoding: String.Encoding.utf8) {
                completion("Address Updated", APIHelper.apiResponseSuccessCode)
            } else {
                completion(APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
            }
        }
    }
    
    func confirmSuccessfulOrder(params: [String: Any], orderId:String,completion: @escaping(_ orderId: String?, _ message: String, _ errorCode: Int) -> Void) {
             
         //Generate API combined url to put on request
        let urlStr = "\(APIConstant.MainUrl)order/\(orderId)/invoice"
        let headers = ["Content-Type" : "application/json", "Authorization" : "Bearer vw9mpvx28m2qmb4gostxp81a11hfysxn"]
        
         
         Alamofire.request(urlStr, method: .post, parameters: params, encoding: JSONEncoding.default, headers:headers).responseJSON { response in
             guard response.result.isSuccess else {
                 print("Error while fetching remote data: \(String(describing: response.result.error))")
                 //Show default message when API failed or time out by internet connectivity or some issues.
                 completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                 return
             }
             guard let data = response.data else { completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
             print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")

             // make sure this JSON is in the format we expect
             if let serverObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                 let message = serverObject["message"] as? String ?? APIHelper.apiFailedMessage
                 completion(nil, message, APIHelper.apiResponseErrorCode)
             } else if let orderId = String(data: data, encoding: String.Encoding.utf8) {
                 completion(orderId, "Order placed successfully", APIHelper.apiResponseSuccessCode)
             } else {
                 completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
             }
         }
     }
}

/*
//MARK: - Support API Methods
extension RestAPI {
    /// Upload Image on Server API
    ///
    /// - Parameters:
    ///   - completion: get success/error result for update image
    func uploadImage(imgData: Data, completion: @escaping(String?,String?, Int) -> ()) {
        
        let urlStr = APIConstant.MainUrl + APIConstant.uploadImage
        let headerData = RestAPI.shared.headerData
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            // import image to request
            multipartFormData.append(imgData, withName: "image", fileName: "fileImage.jpeg", mimeType: "image/jpeg")
        }, to: urlStr,headers : headerData,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    guard let data = response.data else { completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode); return }
                    print(String(data: data, encoding: String.Encoding.utf8) ?? "API: Blank Data")
                    do {
                        //Validate data into your decodable model by JSONDecoder and use as your need
                        let result = try JSONDecoder().decode(APIResponse<[String: String]>.self, from: data)
                        if let imageUrl = result.data?["image"] {
                            completion(imageUrl,result.message, result.error_code)
                        } else {
                            completion(nil,result.message, result.error_code)
                        }
                    } catch {
                        //Show default message when data are not parsed into defined format
                        completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
                    }
                }
            case .failure( _):
                completion(nil, APIHelper.apiFailedMessage, APIHelper.apiFailedCode)
            }
        })
    }
}
 */

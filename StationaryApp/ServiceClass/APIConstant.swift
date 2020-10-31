//
//  APIConstant.swift
//  MIM
//
//  Created by Mohd Arsad on 22/02/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

struct APIConstant {
    //Main URL for all APIs
    static let websiteUrl               = "http://www.alrawnaqwebstore.com"
    
    static var MainUrl: String {
        return APIConstant.websiteUrl + "/rest/\(languageParameter)/V1/"
    }
    
    static let ImageMainUrl             = APIConstant.websiteUrl + "/pub/media/catalog/product/"
    static let ImageBannerMainUrl       = APIConstant.websiteUrl + "/pub/media/mageplaza/bannerslider/banner/image/"
    static let getCustomerToken         = "integration/customer/token"
    static let getAdminToken            = "integration/admin/token"
    static let signUp                   = "customers"
    static let getProfile               = "customers/me"
    
    static let getHomeBanner            = APIConstant.websiteUrl + "/capi/index/getslidersimg/s_id/5"
    static let getCategoryList          = "mma/categories"
    static let popularProducts          = "products?searchCriteria[filterGroups][0][filters][0][field]=sw_featured&searchCriteria[filterGroups][0][filters][0][value]=1&searchCriteria[pageSize]=20&searchCriteria[currentPage]=1"
    static let productsList         = "products?searchCriteria[pageSize]=20&searchCriteria[currentPage]="
    static let productsDetail         = "products/"
    static let updateCartProductCount         = "carts/mine/items/"
    static let createCart           = "carts/mine"
    static let getCart              = "carts/mine/items"
    
    static let createOrder          = "carts/mine/payment-information"
    static let estimateShippingAddress = "carts/mine/estimate-shipping-methods"
    static let estimateShippingInformation = "carts/mine/shipping-information"
    static let getOrderList          = "orders?searchCriteria[filterGroups][0][filters][0][field]=customer_email&searchCriteria[filterGroups][0][filters][0][value]="
    
    //For Guest User
    static let guestCreateCart           = "carts"
    static let guestAddProductInCart     = "guest-carts"
}

struct APIHelper {
    
    static let apiResponseErrorCode = 0
    static let apiResponseSuccessCode = 1
    static let apiResponseLoginFailedCode = 2
    static let apiFailedCode = 1001
    static let apiFailedMessage = "Network Issue, Please try again later"//"Some Error Occurred, Please try again!"
    
    static let consumerKey = "nu11md46gjcrtmgj2j4tqakghmsgy7l6"
    static let consumerSecret = "6ey7vxw3xkv3cog4flqdd0wwr0c99522"
    static let accessToken = "vw9mpvx28m2qmb4gostxp81a11hfysxn"
    static let tokenSecret = "ep9cnyasfok4qwnonyf7zxfs56kcq245"
    
}

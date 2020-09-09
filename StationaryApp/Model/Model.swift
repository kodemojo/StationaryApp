//
//  Model.swift
//  StationaryApp
//
//  Created by Admin on 12/11/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class Model: NSObject {

}

struct NoDataResponse: Decodable {
    let message: String?
}

struct model {
    var img: UIImage?
    var name: String?
    
    init(img: UIImage?, name: String?) {
        self.img = img
        self.name = name
    }
}

struct AboutProduct {
    var title: String?
    var desc: String?
    
    init(title: String?, desc: String?) {
        self.title = title
        self.desc = desc
    }
}

struct Product1 {
    var isTrend: Bool?
    var desc: String?
    var rating: Double?
    var addToWish: Bool?
    var img: UIImage?
    
    init(isTrend: Bool?, desc: String?, rating: Double?, addToWish: Bool?, img: UIImage?) {
        self.isTrend = isTrend
        self.desc = desc
        self.rating = rating
        self.addToWish = addToWish
        self.img = img
    }
}

//MARK: - API All Responses
struct Profile: Decodable {
    let id: Int?
    let group_id: Int?
    let email: String?
    let firstname: String?
    let lastname: String?
    let store_id: Int?
    let website_id: Int?
    let addresses: [Address]?
    
    let message: String?
}

struct Address: Decodable {
    
    let message: String?
    
    struct Region: Decodable {
        let region_code: String?
        let region: String?
        let region_id: Int?
    }
    
    let id: Int?
    let customer_id: Int?
    let region: Region?
    let region_id: Int?
    let country_id: String?
    let street: [String]?
    let company: String?
    let telephone: String?
    let fax: String?
    let postcode: String?
    let city: String?
    let firstname: String?
    let lastname: String?
    let vat_id: String?
    
//    let default_billing: Int?
//    let default_shipping: Int?
    
    var isSelected: Bool? = false
}

struct OrderAddress {
    
    let id: Int?
    let customer_id: Int?
    let region_code: String?
    let region: String?
    let region_id: Int?
    let country_id: String?
    let street: [String]?
    let company: String?
    
    let telephone: String?
    let fax: String?
    let postcode: String?
    let city: String?
    let firstname: String?
    let lastname: String?
    let vat_id: String?

    init(serverData: [String: Any]) {
        self.id = serverData["id"] as? Int
        self.customer_id = serverData["customer_id"] as? Int
        self.region_code = serverData["region_code"] as? String
        self.region = serverData["region"] as? String
        self.region_id = serverData["region_id"] as? Int
        self.country_id = serverData["country_id"] as? String
        self.street = serverData["street"] as? [String]
        self.company = serverData["company"] as? String
        
        self.telephone = serverData["telephone"] as? String
        self.fax = serverData["fax"] as? String
        self.postcode = serverData["postcode"] as? String
        self.city = serverData["city"] as? String
        self.firstname = serverData["firstname"] as? String
        self.lastname = serverData["lastname"] as? String
        self.vat_id = serverData["vat_id"] as? String
    }
}


struct Category: Decodable {
    var id: Int?
    var parent_id: Int?
    var name: String?
    var image: String?
    var is_active: Bool? = false
    var position: Int?
    var level: Int?
    var product_count: Int?
    var children_data: [Category]?
    
    var message: String?
    
    init(id: Int, name: String, imageStr: String) {
        self.id = id
        self.name = name
        self.image = imageStr
    }
}

struct ProductAttribute {
    
    struct CategoryLink {
        var position: Int?
        var category_id: String?
        
        init(serverData: [String: Any]) {
            self.position = serverData["position"] as? Int
            self.category_id = serverData["category_id"] as? String
        }
    }
    
    var category_links: [CategoryLink] = []
    
    init(serverData: [String: Any]) {
        self.category_links = []
        if let items = serverData["category_links"] as? [[String: Any]] {
            for object in items {
                self.category_links.append(CategoryLink(serverData: object))
            }
        }
    }
}

struct CustomAttribute {
    var attribute_code: String?
    var value: String?
    
    init(serverData: [String: Any]) {
        self.attribute_code = serverData["attribute_code"] as? String
        self.value = serverData["value"] as? String
    }
}

struct Gallery {
    var id: Int?
    var media_type: String?
    var file: String?
    var types: [String] = []
    
    init(serverData: [String: Any]) {
        self.id = serverData["id"] as? Int
        self.media_type = serverData["media_type"] as? String
        self.file = serverData["file"] as? String
        self.types = serverData["types"] as? [String] ?? []
    }
}

struct ProductItem {
    var message: String?
    
    var item_id: Int?
    var sku: String?
    var qty: Int?
    var name: String?
    var price: Double?
    var product_type: String?
    var quote_id: String?
    var image: String?
    
    var qty_ordered: Int? //For Order support
    
    init(serverData: [String: Any]) {
        self.message = serverData["message"] as? String
        
        self.item_id = serverData["item_id"] as? Int
        self.sku = serverData["sku"] as? String
        self.name = serverData["name"] as? String
        self.qty = serverData["qty"] as? Int
        self.qty_ordered = serverData["qty_ordered"] as? Int
        self.price = serverData["price"] as? Double
        self.product_type = serverData["product_type"] as? String
        self.quote_id = serverData["quote_id"] as? String
        self.image = ""
    }
}

struct ReviewResponse {
    var message: String?
    var reviews: [Review]?
    
    init(serverData: [String: Any]) {
        self.message = serverData["message"] as? String
    }
    
    init(serverData: [[String: Any]]) {
        reviews = []
        for object in serverData {
            reviews?.append(Review(serverData: object))
        }
    }
}
struct Review {
    
    struct Rating {
        
        var rating_name: String?
        var percent: Int?
        var value: Int?
        var vote_id: Int?
        var rating_id: Int?
        
        init(serverData: [String: Any]) {
            self.vote_id = serverData["vote_id"] as? Int
            self.rating_id = serverData["rating_id"] as? Int
            self.rating_name = serverData["rating_name"] as? String
            self.percent = serverData["percent"] as? Int
            self.value = serverData["value"] as? Int
        }
    }
    
    var id: Int?
    var title: String?
    var detail: String?
    var nickname: String?
    var review_entity: String?
    var review_type: Int?
    var entity_pk_value: Int?
    var review_status: Int?
    var created_at: String?
    var store_id: Int?
    var ratings: [Rating]?
    
    init(serverData: [String: Any]) {
        self.id = serverData["id"] as? Int
        self.title = serverData["title"] as? String
        self.detail = serverData["detail"] as? String
        self.nickname = serverData["nickname"] as? String
        self.review_entity = serverData["review_entity"] as? String
        self.review_type = serverData["review_type"] as? Int
        self.entity_pk_value = serverData["entity_pk_value"] as? Int
        self.review_status = serverData["review_status"] as? Int
        self.created_at = serverData["created_at"] as? String
        self.store_id = serverData["store_id"] as? Int
        if let ratingData = serverData["ratings"] as? [[String: Any]] {
            ratings = []
            for object in ratingData {
                ratings?.append(Rating(serverData: object))
            }
        }
    }
    
 /*   {
    "id":17,
    "title":"Product Review",
    "detail":"cool pen",
    "nickname":"ankitmaurya!",
    "ratings":[{"vote_id":11,"rating_id":4,"rating_name":"Rating","percent":60,"value":3},{"vote_id":12,"rating_id":2,"rating_name":"Value","percent":80,"value":4},{"vote_id":13,"rating_id":3,"rating_name":"Price","percent":40,"value":2},{"vote_id":14,"rating_id":1,"rating_name":"Quality","percent":60,"value":3}],
    "review_entity":"product",
    "review_type":2,
    "review_status":1,
    "created_at":"2020-06-20 13:24:18",
    "entity_pk_value":1,
    "store_id":1,
    "stores":[1]
    } */
}

struct Product {
    
    var id: Int?
    var sku: String?
    var name: String?
    var attribute_set_id: Int?
    var price: Double?
    var status: Bool = false
    var type_id: String?
    var weight: Double?
    var created_at: String?
    var updated_at: String?
    
    var extension_attributes: ProductAttribute?
    var media_gallery_entries: [Gallery] = []
    var custom_attributes: [CustomAttribute] = []
    
    init(serverData: [String: Any]) {
        self.id = serverData["id"] as? Int
        self.sku = serverData["sku"] as? String
        self.name = serverData["name"] as? String
        self.attribute_set_id = serverData["attribute_set_id"] as? Int
        self.price = serverData["price"] as? Double
        self.status = serverData["status"] as? Bool ?? false
        self.type_id = serverData["type_id"] as? String
        self.weight = serverData["weight"] as? Double
        self.created_at = serverData["created_at"] as? String
        self.updated_at = serverData["updated_at"] as? String
        
        if let object = serverData["extension_attributes"] as? [String: Any] {
            self.extension_attributes = ProductAttribute(serverData: object)
        }
        if let objects = serverData["media_gallery_entries"] as? [[String: Any]] {
            media_gallery_entries = []
            for object in objects {
                self.media_gallery_entries.append(Gallery(serverData: object))
            }
        }
        if let objects = serverData["custom_attributes"] as? [[String: Any]] {
            custom_attributes = []
            for object in objects {
                self.custom_attributes.append(CustomAttribute(serverData: object))
            }
        }
    }
}

struct Order {
    
    var customer_firstname: String?
    var customer_lastname: String?
    var customer_id: Int?
    var entity_id: Int?
    var increment_id: String?
    var grand_total: Double?
    
    var updated_at: String?
    var items: [ProductItem]?
    var billing_address: OrderAddress?
    var status: String?
    var paymentStatus: String?
    var shippingDescription: String?
    
    init(serverData: [String: Any]) {
        
        self.customer_firstname = serverData["customer_firstname"] as? String
        self.customer_lastname = serverData["customer_lastname"] as? String
        self.customer_id = serverData["customer_id"] as? Int
        self.entity_id = serverData["entity_id"] as? Int
        self.grand_total = serverData["price"] as? Double
        self.updated_at = serverData["updated_at"] as? String
        self.grand_total = serverData["grand_total"] as? Double
        self.increment_id = serverData["increment_id"] as? String
        self.status = serverData["status"] as? String
        self.shippingDescription = serverData["shipping_description"] as? String ?? ""
        
        if let items = serverData["items"] as? [[String: Any]] {
            var tempItems: [ProductItem] = []
            for object in items {
                tempItems.append(ProductItem(serverData: object))
            }
            self.items = tempItems
        }
        
        if let histories = serverData["status_histories"] as? [[String: Any]], let status = histories.first, let statusStr = status["status"] as? String {
            self.paymentStatus = (statusStr == "pending_payment") ? "Pending" : statusStr
        }
        
        if let extensionAtt = serverData["extension_attributes"] as? [String: Any], let shipping_assignments = extensionAtt["shipping_assignments"] as? [[String: Any]], let shipping = shipping_assignments.first?["shipping"] as? [String: Any], let address = shipping["address"] as? [String: Any] {
            self.billing_address = OrderAddress(serverData: address)
        }
    }
}

struct ProductResponse {
    var message: String? //For when has no data
    var items: [Product] = []
    var product: Product?
    
    init(serverData: [String: Any]) {
        self.message = serverData["message"] as? String
        items = []
        if let itemsObject = serverData["items"] as? [[String: Any]] {
            for object in itemsObject {
                items.append(Product(serverData: object))
            }
        } else {
            self.product = Product(serverData: serverData)
        }
    }
}


//MARK: - Data Models
struct CustomPickerTitle {
    let title: String
    init(title: String) {
        self.title = title
    }
}

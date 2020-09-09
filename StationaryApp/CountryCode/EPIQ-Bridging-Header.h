//
//  EPIQ-Bridging-Header.h
//  EPIQ
//
//  Created by admin on 25/07/19.
//  Copyright © 2019 Mobiloitte. All rights reserved.
//

#ifndef EPIQ_Bridging_Header_h
#define EPIQ_Bridging_Header_h
#import "MBProgressHUD.h"
#import "SDWebImage.h"
#import "PayUServiceHelper.h"
#import <CommonCrypto/CommonDigest.h>
#import <PlugNPlay/PlugNPlay.h>
#define SCROLLVIEW_HEIGHT 600
#define SCROLLVIEW_WIDTH 320

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kMerchantKey @"mdyCKV"
#define kMerchantID @"4914106"
#define kMerchantSalt @"Je7q3652"

#endif /* EPIQ_Bridging_Header_h */

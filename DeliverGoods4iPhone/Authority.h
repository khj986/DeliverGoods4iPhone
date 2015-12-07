//
//  Authority.h
//  DeliverGoods4iPhone
//
//  Created by ztt on 15/12/4.
//  Copyright © 2015年 ztt. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AuthorityType) {
    AuthorityTypeNone = 0,
    AuthorityTypeManager = 1,
    AuthorityTypeCustomer = 2,
    AuthorityTypeDeliver = 3,
    AuthorityTypeCompany = 4,

};

extern AuthorityType authority ;

@interface Authority : NSObject

@end

//
//  TSCarMod.m
//  fashionDance
//
//  Created by Dylan on 3/14/16.
//  Copyright © 2016 汪俊. All rights reserved.
//

#import "TSCarMod.h"
#import <MJExtension.h>

@implementation TSCarMod
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"cid":@"id"};
}
@end

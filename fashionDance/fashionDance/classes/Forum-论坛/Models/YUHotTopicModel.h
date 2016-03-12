//
//  YUHotTopicModel.h
//  fashionDance
//
//  Created by qianfeng on 16/3/11.
//  Copyright © 2016年 汪俊. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Pics;
@interface YUHotTopicModel : NSObject

@property (nonatomic, assign) BOOL isElite;

@property (nonatomic, assign) BOOL isTop;

@property (nonatomic, assign) NSInteger replayCount;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *barName;

@property (nonatomic, copy) NSString *topicId;

@property (nonatomic, copy) NSString *threadType;

@property (nonatomic, assign) NSInteger clickCount;

@property (nonatomic, assign) NSInteger bid;

@property (nonatomic, copy) NSString *nickName;

@property (nonatomic, strong) NSArray<Pics *> *pics;

/** 原YUTopicList数据  */

@property (nonatomic, copy) NSString *imgUrl;

@property (nonatomic, assign) NSInteger replyCount;

@property (nonatomic, assign) NSInteger authorId;

@property (nonatomic, copy) NSString *authorName;

@property (nonatomic, copy) NSString *topicDescription;

@end
@interface Pics : NSObject

@property (nonatomic, copy) NSString *pid;

@property (nonatomic, copy) NSString *url;

@end


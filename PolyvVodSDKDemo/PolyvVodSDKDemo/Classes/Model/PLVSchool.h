//
//  PLVSchool.h
//  PolyvVodSDKDemo
//
//  Created by BqLin on 2017/11/10.
//  Copyright © 2017年 POLYV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLVSchool : NSObject

@property (nonatomic, copy) NSString *host;
@property (nonatomic, copy) NSString *schoolId;
@property (nonatomic, copy) NSString *apiId;
@property (nonatomic, copy) NSString *appSecretKey;
@property (nonatomic, copy) NSString *sdkKey;

/// 静态对象
+ (instancetype)sharedInstance;

@end
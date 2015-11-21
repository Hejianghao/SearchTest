//
//  AccountManager.m
//  SearchTest
//
//  Created by Johannes on 15/11/17.
//  Copyright © 2015年 何江浩. All rights reserved.
//

#import "AccountManager.h"

@implementation AccountManager

+ (AccountManager *) shareManager {
    static AccountManager *shareManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareManager = [[self alloc] init];
    });
    return shareManager;
}

@end

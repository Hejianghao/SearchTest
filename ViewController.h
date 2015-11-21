//
//  ViewController.h
//  SearchTest
//
//  Created by Johannes on 15/11/9.
//  Copyright © 2015年 何江浩. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddProtocol <NSObject>

- (void) addTangshi:(NSString *)tangshi;
- (void) updateTangshiWithIndex:(NSInteger)index andContent:(NSString *)content;

@end

@interface ViewController : UIViewController

@property (nonatomic, weak) id<AddProtocol> delegate;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSString *tangshiCtn;


@end


//
//  NavigationController.m
//  SearchTest
//
//  Created by Johannes on 15/11/9.
//  Copyright © 2015年 何江浩. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //以下用来测试
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    __block NSInteger max = 0;
    for (int i = 0; i <= 10; i++)
        dispatch_group_async(group, queue, ^{
            max += 3;
        });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    //dispatch_group_notify(<#dispatch_group_t group#>, <#dispatch_queue_t queue#>, <#^(void)block#>)
    NSLog(@"max:%d",max);
    //dispatch_source_set_timer(<#dispatch_source_t source#>, <#dispatch_time_t start#>, <#uint64_t interval#>, <#uint64_t leeway#>)
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL); //该队列内串行
    dispatch_queue_t concurQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_CONCURRENT);//该队列内并行
    for (int i = 0; i <= 9; i++) {
        dispatch_async(serialQueue, ^{//主线程同步
            //异步一个串行队列；
            if (i == 0)
                sleep(2);
            NSLog(@"i:%d",i);
        });
    }
    dispatch_sync(concurQueue, ^{//主线程异步
        
    });
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [userDefaults objectForKey:@"AppleLanguages"];
    NSLog(@"languages:%@",languages);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

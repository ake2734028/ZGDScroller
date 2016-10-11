//
//  ViewController.m
//  ZGDScrollerView
//
//  Created by 赵国栋 on 2016/10/11.
//  Copyright © 2016年 赵国栋. All rights reserved.
//

#import "ViewController.h"
#import "ZGDScrollView.h"
#define KWIDTH self.view.frame.size.width
#define KHEIGHT  self.view.frame.size.height

@interface ViewController ()

@end

@implementation ViewController
{
    NSMutableArray *array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    array = [NSMutableArray array];
    for (NSInteger i=0; i<5; i++) {
        array[i] = [UIImage imageNamed:[NSString stringWithFormat:@"%ld",i+1]];
        ;
    }
    //block 回调事件
    ZGDScrollView *scroll = [[ZGDScrollView alloc]initWithFrame:CGRectMake(0, 0, KWIDTH, KHEIGHT/3) picArray:array block:nil isweb:NO];
    
    [self.view addSubview:scroll];
}





@end

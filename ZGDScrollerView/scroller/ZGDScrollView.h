//
//  ZGDScrollView.h
//  双图轮播
//
//  Created by 赵国栋 on 16/10/10.
//  Copyright © 2016年 赵国栋. All rights reserved.
//
#import <UIKit/UIKit.h>

typedef void(^ActionBack)(NSInteger index);

@interface ZGDScrollView : UIView



- (instancetype)initWithFrame:(CGRect)frame picArray:(NSArray *)array block:(ActionBack)block isweb:(BOOL)isweb;

@end

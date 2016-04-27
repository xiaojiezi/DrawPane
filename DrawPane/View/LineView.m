//
//  LineView.m
//  DrawPane
//
//  Created by yangjie on 14-4-27.
//  Copyright (c) 2014年 YJ. All rights reserved.
//

#import "LineView.h"

@implementation LineView

- (void)drawRect:(CGRect)rect
{
    // 1. 设置颜色
    [[UIColor redColor] set];
    // 2. 绘制矩形
    UIRectFill(rect);
}

@end

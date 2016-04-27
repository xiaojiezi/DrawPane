//
//  DrawPath.m
//  DrawPane
//
//  Created by yangjie on 14-4-27.
//  Copyright (c) 2014年 YJ. All rights reserved.
//

#import "DrawPath.h"

@implementation DrawPath

+ (id)drawPathWith:(CGPathRef)cgPath
             color:(UIColor *)color
         lineWidth:(CGFloat)lineWidth
{
    DrawPath *d = [[DrawPath alloc] init];
    
    d.path = [UIBezierPath bezierPathWithCGPath:cgPath];
    d.color = color;
    d.lineWidth = lineWidth;
    
    return d;
}

@end

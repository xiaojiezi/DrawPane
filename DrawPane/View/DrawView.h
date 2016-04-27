//
//  DrawView.h
//  DrawPane
//
//  Created by yangjie on 14-4-27.
//  Copyright (c) 2014年 YJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

// 当前绘图的颜色
@property (strong, nonatomic) UIColor *color;
// 当前绘图的线宽
@property (assign, nonatomic) CGFloat lineWidth;

// 用户选择的照片
@property (strong, nonatomic) UIImage *image;

// 撤销
- (void)undo;

// 清屏
- (void)clear;

// 保存到相册
- (void)save;

@end

//
//  ColorView.m
//  DrawPane
//
//  Created by yangjie on 14-4-27.
//  Copyright (c) 2014年 YJ. All rights reserved.
//

#import "ColorView.h"

#define kButtonSpacing 10.0f

@interface ColorView()

// 供用户选择的颜色的数组
@property (strong, nonatomic) NSArray *colors;

@end

@implementation ColorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        self.colors = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor],
                        [UIColor cyanColor], [UIColor yellowColor], [UIColor magentaColor],
                        [UIColor orangeColor], [UIColor purpleColor], [UIColor blackColor]];
        
        // 提示：在一个方法内，尽量不要使用成员变量或者属性，这样便于方法的移植
        [self createButtonsWithArray:self.colors];
    }
    
    return self;
}

#pragma mark - 私有方法
#pragma mark 生成按钮图像
- (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size
{
    // 1. 开始图像上下文，开始之后的绘制都是针对图像上下文的，而不再往屏幕上绘制
    // 指定的size大小就是最终生成图像的大小！
    UIGraphicsBeginImageContext(size);
    
    //------------------------------------------------------------------
    // 以下几行才是真正的绘图代码！
    // 2. 添加路径绘制路径，绘制一个带颜色的矩形
    // 1) 设置颜色
    [color set];
    // 2) 绘制矩形
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    //------------------------------------------------------------------
    
    // 3. 从图像上下文获取到绘制生成的图像
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 4. 关闭图像上下文，千万不要省略此步骤！
    UIGraphicsEndImageContext();
    
    // 5. 返回图像
    // 注意：一定要关闭了上下文再返回，不要直接返回！
    return image;
}

#pragma mark 创建按钮
- (void)createButtonsWithArray:(NSArray *)colors
{
    // 循环建立按钮，计算按钮的宽度
    CGFloat w = self.bounds.size.width / colors.count;
    
    [colors enumerateObjectsUsingBlock:^(UIColor *color, NSUInteger idx, BOOL *stop) {
        // 1. 实例化按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // 2. 设置位置
        CGFloat x = idx * w;
        [button setFrame:CGRectMake(x, 0, w, self.bounds.size.height)];
        
        // 3. 设置标题
        CGSize size = CGSizeMake(w - kButtonSpacing, w - kButtonSpacing);
        UIImage *image = [self createImageWithColor:color size:size];
        [button setImage:image forState:UIControlStateNormal];
        
        button.tag = idx;
        
        // 5. 增加监听方法
        [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        
        // 4. 添加到视图
        [self addSubview:button];
        
    }];
    
    NSLog(@"%@", NSStringFromCGRect(self.superview.frame));
}

#pragma mark - 按钮监听方法
- (void)tapButton:(UIButton *)button
{
    // 根据按钮的tag，返回颜色
    UIColor *color = self.colors[button.tag];
    
    [_delegate colorViewSelectedColor:color];
}

@end

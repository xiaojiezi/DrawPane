//
//  ToolView.m
//  DrawPane
//
//  Created by yangjie on 14-4-27.
//  Copyright (c) 2014年 YJ. All rights reserved.
//

#import "ToolView.h"
#import "LineView.h"
#import "ColorView.h"

#define kSubViewHeight 44

@interface ToolView() <ColorViewDelegate>

// 上一次选中的按钮
@property (weak, nonatomic) UIButton *selectedButton;
// 按钮选中的红线
@property (weak, nonatomic) LineView *lineView;

// 选择颜色视图
@property (weak, nonatomic) ColorView *colorView;

@end

@implementation ToolView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        [self createButtons];
    }
    
    return self;
}

#pragma mark - 私有方法
#pragma mark 创建界面按钮
- (void)createButtons
{
    // 按钮标题数组
    NSArray *array = @[@"颜色", @"线宽", @"橡皮", @"撤销", @"清屏", @"相机", @"保存"];
    
    // 循环建立按钮
    CGFloat w = self.bounds.size.width / array.count;
    CGFloat y = 20;
    
    [array enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL *stop) {
        // 1. 实例化按钮
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        // 2. 设置标题
        [button setTitle:text forState:UIControlStateNormal];
        
        // 3. 设置位置
        CGFloat x = idx * w;
        [button setFrame:CGRectMake(x, y, w, kSubViewHeight)];
        
        // 设置按钮属性
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
        button.tag = idx;
        
        // 4. 添加到视图
        [self addSubview:button];
        
        // 5. 增加监听方法
        [button addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    }];
}

#pragma mark 绘制按钮底部红线
- (void)drawLineWithButton:(UIButton *)button
{
    // 计算红色线条的位置
    CGFloat x = button.frame.origin.x + button.titleLabel.frame.origin.x;
    CGFloat y = button.frame.origin.y + button.titleLabel.frame.origin.y + button.titleLabel.frame.size.height + 2.0f;
    CGFloat w = button.titleLabel.frame.size.width;
    
    // 实例化线条视图，懒加载（延迟加载）
    if (self.lineView == nil) {
        LineView *lineView = [[LineView alloc] initWithFrame:CGRectMake(x, y, w, 2.0)];
        [self addSubview:lineView];
        
        self.lineView = lineView;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.lineView setFrame:CGRectMake(x, y, w, 2.0)];
    }];
}

#pragma mark 按钮监听方法
- (void)tapButton:(UIButton *)button
{
    // 处理按钮状态，选中的按钮设置selected属性
    // 一次只设置一个按钮的selected属性为YES
    // 第一种：遍历所有的按钮
    // 【第二种】：记录上一次选中的按钮
    if (self.selectedButton == nil || self.selectedButton != button) {
        self.selectedButton.selected = NO;
    }
    
    [button setSelected:YES];
    self.selectedButton = button;
    
    // 绘制底部的红线
    [self drawLineWithButton:button];
    
    switch (button.tag) {
        case kToolViewColor: // 颜色
            [self showHideColorView];
            
            break;
        case kToolViewLineWidth:
            // 显示或隐藏线宽视图
            break;
        default:
            // 通知视图控制器，选中了某项功能
            [_delegate toolViewSelectedFunction:button.tag];
            break;
    }
}

#pragma mark - 子视图操作方法
#pragma mark 显示隐藏颜色视图
- (void)showHideColorView
{
    // 1. 懒加载颜色视图，初始应该在屏幕的外部
    if (self.colorView == nil) {
        ColorView *view = [[ColorView alloc] initWithFrame:CGRectMake(0, -self.bounds.size.height, self.bounds.size.width, kSubViewHeight)];
        
        // 在视图的最底层插入视图
        [self insertSubview:view atIndex:0];
        // 使用addSubview:view会在最顶层添加视图
//        [self addSubview:view];
        
        // 设置代理
        view.delegate = self;
        
        self.colorView = view;
    }
    
    // 2. 定义目标位置
    // 如果是隐藏状态，y < 0，要显示
    // 如果已经显示 y > 0 要隐藏
    CGRect frame = self.frame;
    CGRect colorFrame = self.colorView.frame;
    
    if (colorFrame.origin.y < 0) {
        colorFrame.origin.y = self.bounds.size.height;
        frame.size.height = kToolViewHeight + colorFrame.size.height;
    } else {
        colorFrame.origin.y = -self.bounds.size.height;
        frame.size.height = kToolViewHeight;
    }
    
    // 提示，虽然动画简单，一定先调试好，在加动画
    self.frame = frame;
    [UIView animateWithDuration:0.3f animations:^{
        [self.colorView setFrame:colorFrame];
    }];
}

#pragma mark - 代理实现
#pragma mark 演示视图
- (void)colorViewSelectedColor:(UIColor *)color
{
    // 工具视图需要将颜色向上传递给视图控制器
    [_delegate toolViewSelectedColor:color];
    
    // 隐藏颜色视图
    [self showHideColorView];
}

@end

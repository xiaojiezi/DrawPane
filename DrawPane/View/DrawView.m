//
//  DrawView.m
//  DrawPane
//
//  Created by yangjie on 14-4-27.
//  Copyright (c) 2014年 YJ. All rights reserved.
//

#import "DrawView.h"
#import "DrawPath.h"

@interface DrawView()

@property (assign, nonatomic) CGMutablePathRef path;

// 记录所有绘制路径的数组
@property (strong, nonatomic) NSMutableArray *pathsArray;
// 路径被释放的标记
@property (assign, nonatomic) BOOL pathReleased;

@end

@implementation DrawView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        // 实例化路径数组
        self.pathsArray = [NSMutableArray array];
        
        // 初始化默认属性
        self.color = [UIColor blueColor];
        self.lineWidth = 5.0f;
    }
    
    return self;
}

/**
 在重绘视图内容时，会清空原有所有内容，全部重新绘制！
 
 要保证重新绘制的内容不会出错！叠加层次越多，出错的可能性就越大，而且计算的复杂度越大！
 
 几乎所有的软件中，重新绘制都采取同样的机制！
 */
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawViewWithContext:context];
}

#pragma mark - 生成图像(使用绘制路径)
- (UIImage *)createImage
{
    // 1. 打开图像上下文
    UIGraphicsBeginImageContext(self.bounds.size);
    
    // 2. 获取上下文，因为开启了图像上下文，再次获取就是图像上下文了
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 首先绘制路径数组中的所有路径
    for (DrawPath *drawPath in self.pathsArray) {
        // 此时，路径中多了图像的可能
        // 判断是否是图像
        // 如果是图像，绘制图像
        // 如果不是图像，就是路径，直接绘制
        if (drawPath.image != nil) {
            [drawPath.image drawAtPoint:CGPointMake(100, 100)];
        } else {
            CGContextAddPath(context, drawPath.path.CGPath);
            
            // 3. 设置上下文属性
            [drawPath.color set];
            
            CGContextSetLineWidth(context, drawPath.lineWidth);
            CGContextSetLineCap(context, kCGLineCapButt);
            
            // 绘制路径
            CGContextDrawPath(context, kCGPathStroke);
        }
    }
    
    // 获取图像
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    // 返回图像
    return image;
}

#pragma mark - 重绘视图方法
- (void)drawViewWithContext:(CGContextRef)context
{
    // 首先绘制路径数组中的所有路径
    for (DrawPath *drawPath in self.pathsArray) {
        // 此时，路径中多了图像的可能
        // 判断是否是图像
        // 如果是图像，绘制图像
        // 如果不是图像，就是路径，直接绘制
        if (drawPath.image != nil) {
            [drawPath.image drawAtPoint:CGPointMake(100, 100)];
        } else {
            CGContextAddPath(context, drawPath.path.CGPath);
            
            // 3. 设置上下文属性
            [drawPath.color set];
            
            CGContextSetLineWidth(context, drawPath.lineWidth);
            CGContextSetLineCap(context, kCGLineCapButt);
            
            // 绘制路径
            CGContextDrawPath(context, kCGPathStroke);
        }
    }
    
    //---------------------------------------------------
    // 以下部分是绘制新路径的代码
    // 1. 将路径添加到上下文
    // 判断当前是否有新路径，如果有才绘制
    if (!self.pathReleased) {
        CGContextAddPath(context, self.path);
        
        // 3. 设置上下文属性
        [self.color set];
        /*
         1> CGContextSetLineWidth   设置线宽
         2> CGContextSetLineCap     设置线条顶点（起点，终点）的样式
         */
        CGContextSetLineWidth(context, self.lineWidth);
        CGContextSetLineCap(context, kCGLineCapButt);
        
        // 4. 绘制路径
        CGContextDrawPath(context, kCGPathStroke);
    }
}

#pragma mark - 手势事件
#pragma mark 手指按下.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 实例化路径
    self.path = CGPathCreateMutable();
    
    // 新的路径开始了
    self.pathReleased = NO;
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    CGPathMoveToPoint(self.path, NULL, location.x, location.y);
}

#pragma mark 手指移动
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 1. 取出手势
    UITouch *touch = [touches anyObject];
    
    // 2. 取出点
    CGPoint location = [touch locationInView:self];
    CGPathAddLineToPoint(self.path, NULL, location.x, location.y);
    
    // 4. setNeedDisplay重绘视图
    [self setNeedsDisplay];
}

#pragma mark 手指抬起
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 将路径添加到绘制数组
    // 在OC中，提供了一个贝塞尔路径的对象，是对CGPath的OC的封装
//    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:self.path];
    DrawPath *path = [DrawPath drawPathWith:self.path color:self.color lineWidth:self.lineWidth];
    
    [self.pathsArray addObject:path];
    
    // 释放路径
    CGPathRelease(self.path);
    
    // 新的路径结束了
    self.pathReleased = YES;
    
    // 测试代码
//    self.color = [UIColor greenColor];
//    self.lineWidth = 20.0f;
}

#pragma mark - 成员方法
#pragma mark 撤销
- (void)undo
{
    // 用户选择Undo时，手指是离开屏幕的，意味着当前没有新路径
    // 如果要撤销操作，直接删除数组中的最后一项
    [self.pathsArray removeLastObject];
    
    // 重新绘制
    [self setNeedsDisplay];
}

#pragma mark 清屏
- (void)clear
{
    [self.pathsArray removeAllObjects];
    
    [self setNeedsDisplay];
}

#pragma mark Image的set方法
- (void)setImage:(UIImage *)image
{
    // 1. 使用image建立一个DrawPath对象
    DrawPath *path = [[DrawPath alloc] init];
    path.image = image;
    
    // 2. 将DrawPath对象添加到数组
    [self.pathsArray addObject:path];
    
    // 重绘视图
    [self setNeedsDisplay];
}

#pragma mark 保存照片到相册
- (void)save
{
    // 1. 生成image，使用图像上下文重新绘制，生成图像，此时手指是离开屏幕
    UIImage *image = [self createImage];
    
    // 2. 保存到相册
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

#pragma mark 保存完成
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存成功!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    
    [alert show];
}

@end

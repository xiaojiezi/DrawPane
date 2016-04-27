//
//  ViewController.m
//  DrawPane
//
//  Created by yangjie on 14-4-27.
//  Copyright (c) 2014年 YJ. All rights reserved.
//

#import "ViewController.h"
#import "DrawView.h"
#import "ToolView.h"

@interface ViewController () <ToolViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) DrawView *drawView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 实例化绘图视图
    DrawView *view = [[DrawView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    
    self.drawView = view;
    
    // 实例化工具视图
    // 判断系统的版本
    ToolView *toolView = toolView = [[ToolView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kToolViewHeight)];
    
    toolView.delegate = self;
    
    [self.view addSubview:toolView];
    
    // 添加手势识别，监听两个手指的点按事件
    // 当事件发生时
    // 通过代理通知视图控制器，由视图控制器显示隐藏工具视图
    
}

#pragma mark - 代理方法
- (void)toolViewSelectedColor:(UIColor *)color
{
    // 告诉绘制视图，修改颜色
    [self.drawView setColor:color];
}

- (void)toolViewSelectedFunction:(kToolViewFunction)function
{
    switch (function) {
        case kToolViewEarser:
            self.drawView.color = [UIColor whiteColor];
            
            break;
        case kToolViewUndo:
            // 需要通知绘制视图撤销一步操作
            [self.drawView undo];
            
            break;
        case kToolViewClear:
            [self.drawView clear];
            
            break;
        case kToolViewPhoto:
            [self selectPhoto];
            
            break;
        case kToolViewSave:
            [self.drawView save];
            
            break;
        default:
            break;
    }
}

#pragma mark 选择照片
- (void)selectPhoto
{
    // 1. 实例化照片选择器
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    // 2. 设置从照片库选择照片，指定照片来源
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    // 3. 设置代理
    [picker setDelegate:self];
    
    // 4. 模态显示照片选择器
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark 照片选择器代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 1. 取出照片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 2. 把照片传递给绘制视图
    [self.drawView setImage:image];
    
    // 3. 关闭照片选择器
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

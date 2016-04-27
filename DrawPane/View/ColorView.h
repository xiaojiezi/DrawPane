//
//  ColorView.h
//  DrawPane
//
//  Created by yangjie on 14-4-27.
//  Copyright (c) 2014年 YJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorViewDelegate <NSObject>

- (void)colorViewSelectedColor:(UIColor *)color;

@end

@interface ColorView : UIView

@property (weak, nonatomic) id <ColorViewDelegate> delegate;

@end

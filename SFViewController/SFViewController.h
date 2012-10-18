//
//  SFViewController.h
//  SFViewController
//
//  Created by Sean Cheng on 10/14/12.
//  Copyright (c) 2012 Sean Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

//===========================================================
#pragma 委托
//===========================================================

@protocol SFViewControllerDelegate <NSObject>

@optional

// 在大于 Y 数值时激活
- (void)didPanToPositionX;

// 在大于 X 数值时激活
- (void)didPanToPositionY;

@end

//===========================================================
#pragma 接口
//===========================================================

@interface SFViewController : UIViewController <SFViewControllerDelegate>

@property (strong,nonatomic) id<SFViewControllerDelegate>	sfDelegate;

// 显示／隐藏／推送／返回 ViewController 的动画速度
@property (nonatomic) CGFloat															presentSpeed;

// 显示新 ModalView 时，背景 View 的遮罩颜色
@property (nonatomic) UIColor*														previousViewMaskColor;

// 显示新 ModalView 时，背景 View 的遮罩透明度
@property (nonatomic) CGFloat															previousViewMaskAlpha;

// 是否使用纵向拖动
@property (nonatomic) BOOL																enableVerticalPull;

// 是否使用横向拖动
@property (nonatomic) BOOL																enableHorizontalPull;

// X 数值，在大于这个数值时激活 didPanToPositionX
@property (nonatomic) CGFloat															positionX;

// Y 数值，在大于这个数值时激活 didPanToPositionY
@property (nonatomic) CGFloat															positionY;

//===========================================================
#pragma 函数
//===========================================================

//
- (void)panning:(UIPanGestureRecognizer*)pan;
@end

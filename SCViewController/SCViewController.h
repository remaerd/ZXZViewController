//
//  SCViewController.h
//  SCViewController
//
//  Created by Sean Cheng on 10/14/12.
//  Copyright (c) 2012 Sean Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

//===========================================================
#pragma 委托
//===========================================================

@protocol SCViewControllerDelegate <NSObject>

@optional

// 在满足指定的 Y 值时激活
- (void)didPanToPositionX;
- (void)didPanToPositionY;

@end

//===========================================================
#pragma 接口
//===========================================================

@interface SCViewController : UIViewController <SCViewControllerDelegate>

@property (strong,nonatomic) id<SCViewControllerDelegate>	scDelegate;

// 显示／隐藏／推送／返回 ViewController 的动画速度
@property (nonatomic) CGFloat															presentSpeed;

// 显示新 ModalView 时，背景 View 的遮罩颜色
@property (nonatomic) UIColor*														previousViewMaskColor;

// 显示新 ModalView 时，背景 View 的遮罩透明度
@property (nonatomic) CGFloat															previousViewMaskAlpha;

// 是否使用拖动退出 ModalView
@property (nonatomic) BOOL																enablePullToDismiss;

// 在大于这个数值时，返回到前一个 ViewController
@property (nonatomic) CGFloat															positionX;

// 在大于这个数值时，退出 ModalView
@property (nonatomic) CGFloat															positionY;

//===========================================================
#pragma 函数
//===========================================================

//
- (void)panning:(UIPanGestureRecognizer*)pan;
@end

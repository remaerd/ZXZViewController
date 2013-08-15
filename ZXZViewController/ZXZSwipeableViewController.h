//
//  ZXZSwipeableViewController.h
//  SCFoundation
//
//  Created by Sean Cheng on 8/9/13.
//  Copyright (c) 2013 Extremely Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCSwipeableViewControllerDelegate <NSObject>

@optional

/**
 *	在大于 Y 数值时激活
 */
- (void)didPanToPositionX;

/**
 *	在大于 X 数值时激活
 */
- (void)didPanToPositionY;

@end


@interface ZXZSwipeableViewController : UIViewController <SCSwipeableViewControllerDelegate>

@property (strong,nonatomic) UIColor*																navigationBackgroundColor;

@property (strong,nonatomic) id<SCSwipeableViewControllerDelegate>	sfDelegate;

/**
 *	显示／隐藏／推送／返回 ViewController 的动画速度
 */
@property (nonatomic) CGFloat					presentSpeed;

/**
 *	显示新 ModalView 时，背景 View 的遮罩颜色
 */
@property (copy,nonatomic) UIColor*		previousViewMaskColor;

/**
 *	显示新 ModalView 时，背景 View 的遮罩透明度
 */
@property (nonatomic) CGFloat					previousViewMaskAlpha;

/**
 *	是否使用纵向拖动
 */
@property (nonatomic) BOOL						enableVerticalPull;

/**
 *	是否使用横向拖动
 */
@property (nonatomic) BOOL						enableHorizontalPull;

/**
 *	X 数值，在大于这个数值时激活 didPanToPositionX
 */
@property (nonatomic) CGFloat					positionX;

/**
 *	Y 数值，在大于这个数值时激活 didPanToPositionY
 */
@property (nonatomic) CGFloat					positionY;


@end

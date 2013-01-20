/*============================================================
 
 The MIT License (MIT)
 Copyright (c) 2013 Sean Cheng
 
 ==============================================================
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 ==============================================================
 */

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

@property (strong,nonatomic) UIColor*	navigationBackgroundColor;

@property (strong,nonatomic) id<SFViewControllerDelegate>	sfDelegate;

// 显示／隐藏／推送／返回 ViewController 的动画速度
@property (nonatomic) CGFloat   presentSpeed;

// 显示新 ModalView 时，背景 View 的遮罩颜色
@property (copy,nonatomic) UIColor*  previousViewMaskColor;

// 显示新 ModalView 时，背景 View 的遮罩透明度
@property (nonatomic) CGFloat   previousViewMaskAlpha;

// 是否使用纵向拖动
@property (nonatomic) BOOL      enableVerticalPull;

// 是否使用横向拖动
@property (nonatomic) BOOL      enableHorizontalPull;

// X 数值，在大于这个数值时激活 didPanToPositionX
@property (nonatomic) CGFloat   positionX;

// Y 数值，在大于这个数值时激活 didPanToPositionY
@property (nonatomic) CGFloat	positionY;

//===========================================================
#pragma 函数
//===========================================================

@end

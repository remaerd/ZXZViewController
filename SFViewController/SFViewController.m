/*============================================================
 
 The MIT License (MIT)
 Copyright (c) 2012 Sean Cheng
 
 ==============================================================
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 ==============================================================
 */

#import <QuartzCore/QuartzCore.h>
#import "SFViewController.h"

@interface SFViewController()

@property (nonatomic) CGPoint										lastOffest;
@property (nonatomic) CGPoint										oldOffest;
@property (nonatomic) int												panMode;
@property (strong,nonatomic) UIView*						mask;
@property (strong,nonatomic) UIViewController*	modalViewController;
@end

@implementation SFViewController
@synthesize modalViewController;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
	if (self) [self defaultValues];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) [self defaultValues];
    return self;
}

- (id)init
{
	self = [super init];
	if (self) [self defaultValues];
	return self;
}

- (void)defaultValues
{
    self.sfDelegate = self;
    self.previousViewMaskAlpha = 0.5;
    self.previousViewMaskColor = [UIColor blackColor];
    self.presentSpeed = 0.4;
    self.enableVerticalPull = YES;
		self.enableHorizontalPull = YES;
    self.positionY = 70;
    self.positionX = 70;
}

- (void)viewDidLoad
{
	[self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panning:)]];
}

- (void)panning:(UIPanGestureRecognizer*)pan
{
	CGPoint point = [pan translationInView:self.view];
	
	if (pan.state == UIGestureRecognizerStateBegan) {
		
		if (fabs(point.x) <= fabs(point.y)) self.panMode = 0;
		else self.panMode = 1;
		
	} else if (pan.state == UIGestureRecognizerStateChanged) {
		if (self.panMode == 0 && self.enableVerticalPull) {
			if (self.navigationController.view.frame.origin.y >= 0) [self.navigationController.view setTransform:CGAffineTransformMakeTranslation(0, point.y)];
		} else {
			[self.navigationController.view setTransform:CGAffineTransformMakeTranslation(point.x, 0)];
		}
			
	} else if (pan.state == UIGestureRecognizerStateEnded) {
		if (self.panMode == 0 && self.enableVerticalPull) {
			if (point.y > self.positionY && self.enableVerticalPull) [self.sfDelegate didPanToPositionY];
			else {
				[UIView animateWithDuration:self.presentSpeed animations:^{
					[self.navigationController.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
				}];
			}
		}
	}
}

- (void)didPanToPositionY
{
    [UIView animateWithDuration:self.presentSpeed animations:^{
        [self.navigationController.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
    }];
}

- (void)didPanToPositionX
{
    [self.navigationController.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
	CGFloat speed = 0;
	if (flag) speed = self.presentSpeed;
	
	[self setModalViewController:viewControllerToPresent];
	[self.modalViewController.view setFrame:CGRectMake(0, 0, 320, 460)];
	[self.modalViewController.view setTransform:CGAffineTransformMakeTranslation(0, self.view.frame.size.height)];
	
	self.mask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.window.frame.size.height)];
	[self.mask setBackgroundColor:self.previousViewMaskColor];
	[self.mask setAlpha:0];
	
	if (self.navigationController) {
		[self.navigationController.view addSubview:self.mask];
		[self.navigationController.view addSubview:viewControllerToPresent.view];
	} else {
		[self.view addSubview:self.mask];
		[self.view addSubview:self.modalViewController.view];
	}
	
	[UIView animateWithDuration:speed animations:^{
		[self.mask setAlpha:self.previousViewMaskAlpha];
		[self.modalViewController.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
	}];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
	CGFloat speed = 0;
	if (flag) speed = self.presentSpeed;
	
	[UIView animateWithDuration:speed animations:^{
		[self.mask setAlpha:0];
		[self.modalViewController.view setTransform:CGAffineTransformMakeTranslation(0, self.view.window.frame.size.height)];
	} completion:^(BOOL finished) {
		[self.mask removeFromSuperview];
		[self.modalViewController.view removeFromSuperview];
		self.mask = nil;
		self.modalViewController = nil;
	}];
}

@end

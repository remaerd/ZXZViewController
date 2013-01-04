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

@property (nonatomic) int								panMode;
@property (strong,nonatomic) UIPanGestureRecognizer*	pan;
@property (strong,nonatomic) UIView*					mask;
@property (strong,nonatomic) UIViewController*          modalViewController;
@property (strong,nonatomic) UIView*                    backgroundView;
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
	self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panning:)];
	self.sfDelegate = self;
	self.previousViewMaskAlpha = 0.5;
	self.previousViewMaskColor = [UIColor blackColor];
	self.presentSpeed = 0.5;
	self.enableVerticalPull = YES;
	self.enableHorizontalPull = YES;
	self.positionY = 70;
	self.positionX = 70;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self setBackground];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[self.view addGestureRecognizer:self.pan];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
	[self.backgroundView removeFromSuperview];
	self.backgroundView = nil;
}

- (void)setBackground
{
	if (self.view) {
		if (self.navigationController) {
			for (UIView* view in self.navigationController.view.subviews) {
				if ([NSStringFromClass([view class]) isEqualToString:@"UINavigationTransitionView"]) {
					CGFloat height = [[UIScreen mainScreen]bounds].size.height - 20;
					self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, self.view.frame.size.width, height)];
					[self.backgroundView setAlpha:0];
					[self.navigationController.view insertSubview:self.backgroundView belowSubview:view];
                    [UIView animateWithDuration:0.3 animations:^{
                            [self.backgroundView setAlpha:1];
                    }];
                    if (self.navigationBackgroundColor) [self.backgroundView setBackgroundColor:self.navigationBackgroundColor];
                    else {
                        NSString* class = NSStringFromClass([[self class]superclass]);
                        if ([class isEqualToString:@"SFTableViewController"]) [self.backgroundView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"default-tableview-background"]]];
                        else [self.backgroundView setBackgroundColor:self.view.backgroundColor];
                    }
				}
			} 
        } else [self.view setBackgroundColor:self.view.backgroundColor];
    }
}

- (void)panning:(UIPanGestureRecognizer*)pan
{
	CGPoint point = [pan translationInView:self.navigationController.view];
	
	if (pan.state == UIGestureRecognizerStateBegan) {
		
		if (fabs(point.x) <= fabs(point.y)) self.panMode = 0;
		else self.panMode = 1;
		
	} else if (pan.state == UIGestureRecognizerStateChanged) {
        
		if (self.panMode == 0 && self.enableVerticalPull) {
			if (self.navigationController.view.frame.origin.y >= 0) [self.navigationController.view setTransform:CGAffineTransformMakeTranslation(0, point.y)];
		} else if (self.enableHorizontalPull && point.x >= 0 && self.navigationController) {
            [self.view setFrame:CGRectMake(point.x, 0, self.view.frame.size.width, self.view.frame.size.height)];
        }
			
	} else if (pan.state == UIGestureRecognizerStateEnded) {
		if (self.panMode == 0 && self.enableVerticalPull) {
			if (point.y > self.positionY && self.enableVerticalPull) [self.sfDelegate didPanToPositionY];
			else {
                [UIView animateWithDuration:self.presentSpeed animations:^{
                    [self.navigationController.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
                }];
            }
		} else {
            if (point.x > self.positionX && self.enableHorizontalPull && self.navigationController) [self.sfDelegate didPanToPositionX];
			else {
                [UIView animateWithDuration:self.presentSpeed animations:^{
                    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
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
	[UIView animateWithDuration:self.presentSpeed animations:^{
		[self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	}];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
	[self.view removeGestureRecognizer:self.pan];
	
	CGFloat speed = 0;
	if (flag) speed = self.presentSpeed;
	
	[self setModalViewController:viewControllerToPresent];
	CGRect bounds = [[UIScreen mainScreen]bounds];
	[self.modalViewController.view setFrame:CGRectMake(0, 0, bounds.size.width, bounds.size.height - 20)];
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
		[self.modalViewController.view setTransform:CGAffineTransformIdentity];
	} completion:nil];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
	CGFloat speed = 0;
	if (flag) speed = self.presentSpeed;
	
	[self.view addGestureRecognizer:self.pan];
	
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

//
//  SCViewController.m
//  SCViewController
//
//  Created by Sean Cheng on 10/14/12.
//  Copyright (c) 2012 Sean Cheng. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SCViewController.h"

@interface SCViewController()

@property (strong,nonatomic) UIView* mask;
@property (strong,nonatomic) UIViewController* modalViewController;
@end

@implementation SCViewController
@synthesize modalViewController;

- (id)init
{
	self = [super init];
	if (self) self.scDelegate = self;
	return self;
}

- (void)panning:(UIPanGestureRecognizer*)pan
{
	CGPoint point = [pan translationInView:self.view];
	
	if (pan.state == UIGestureRecognizerStateBegan) {
		
		if (fabs(point.x) <= fabs(point.y)) self.panMode = 0;
		else self.panMode = 1;
		
	} else if (pan.state == UIGestureRecognizerStateChanged) {
		if (self.panMode == 0) {
			if (self.navigationController.view.frame.origin.y >= 0) [self.navigationController.view setTransform:CGAffineTransformMakeTranslation(0, point.y)];
		} else {
			[self.navigationController.view setTransform:CGAffineTransformMakeTranslation(point.x, 0)];
		}
			
	} else if (pan.state == UIGestureRecognizerStateEnded) {
		if (self.panMode == 0) {
			if (point.y > 70) [self.scDelegate didPanToDismissPosition];
			else {
				[UIView animateWithDuration:0.3 animations:^{
					[self.navigationController.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
				}];
			}
		}
	}
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
	CGFloat speed = 0;
	if (flag) speed = 0.5;
	
	[self setModalViewController:viewControllerToPresent];
	[self.modalViewController.view setFrame:CGRectMake(0, 0, 320, 460)];
	[self.modalViewController.view setTransform:CGAffineTransformMakeTranslation(0, self.view.frame.size.height)];
	
	self.mask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.window.frame.size.height)];
	[self.mask setBackgroundColor:[UIColor blackColor]];
	[self.mask setAlpha:0];
	
	if (self.navigationController) {
		[self.navigationController.view addSubview:self.mask];
		[self.navigationController.view addSubview:viewControllerToPresent.view];
	} else {
		[self.view addSubview:self.mask];
		[self.view addSubview:self.modalViewController.view];
	}
	
	[UIView animateWithDuration:speed animations:^{
		[self.mask setAlpha:0.5];
		[self.modalViewController.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
	}];
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
	CGFloat speed = 0;
	if (flag) speed = 0.5;
	
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

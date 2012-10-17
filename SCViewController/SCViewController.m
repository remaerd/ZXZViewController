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

@property (nonatomic) CGPoint										lastOffest;
@property (nonatomic) CGPoint										oldOffest;
@property (nonatomic) int												panMode;
@property (strong,nonatomic) UIView*						mask;
@property (strong,nonatomic) UIViewController*	modalViewController;
@end

@implementation SCViewController
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
    self.scDelegate = self;
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
			if (point.y > self.positionY && self.enableVerticalPull) [self.scDelegate didPanToPositionY];
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

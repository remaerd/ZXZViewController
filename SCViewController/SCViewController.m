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
@property (strong,nonatomic) SCNavigationController*		modalView;
@property (strong,nonatomic) UIView*										mask;
@property (strong,nonatomic) UIPanGestureRecognizer*		pan;
@end

@implementation SCViewController

- (id)init
{
	self = [super init];
	if (self) {
		
		CGRect frame = (((UIWindow*)[UIApplication sharedApplication].windows[0]).frame);
		frame.size.height -= 20;
		
		self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panning:)];
		
		self.delegate = self;
		self.view = [[UIView alloc]initWithFrame:frame];
		[self.view addGestureRecognizer:self.pan];
		
		self.mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
		[self.mainView setClipsToBounds:YES];
		[self.view addSubview:self.mainView];
		
		self.navigationItem = [[UINavigationItem alloc]init];
	}
	return self;
}

- (void)disablePan
{
	[self.view removeGestureRecognizer:self.pan];
}

- (void)panning:(UIPanGestureRecognizer*)pan
{
	CGPoint point = [pan translationInView:self.view];
	
	if (pan.state == UIGestureRecognizerStateChanged) {
		if (self.navigationController.view.frame.origin.y >= 0) [self.navigationController.view setTransform:CGAffineTransformMakeTranslation(0, point.y)];
	}
	else if (pan.state == UIGestureRecognizerStateEnded) {
		if (point.y > 70) [self.delegate didPanToDismissPosition];
		else {
			[UIView animateWithDuration:0.3 animations:^{
				[self.navigationController.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
			}];
		}
	}
}

- (void)setTitle:(NSString *)title
{
	[self.navigationItem setTitle:title];
}

- (void)presentModalViewController:(SCViewController*)viewController
{
	self.modalView = [[SCNavigationController alloc]initWithRootViewController:viewController];
	[self.modalView.view setTransform:CGAffineTransformMakeTranslation(0, self.view.window.frame.size.height)];
	
	if (self.navigationController) [self.navigationController.view addSubview:self.modalView.view];
	else [self.view addSubview:self.modalView.view];
	
	self.mask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.window.frame.size.height)];
	[self.mask setBackgroundColor:[UIColor blackColor]];
	[self.mask setAlpha:0];
	[self.mainView addSubview:self.mask];
	
	[UIView animateWithDuration:0.3 animations:^{
		[self.mask setAlpha:0.3];
		[self.modalView.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
		[self.mainView.layer setTransform:CATransform3DMakeScale(0.9, 0.9, 1)];
	}];
}

- (void)dismissModalView
{
	[UIView animateWithDuration:0.4 animations:^{
		[self.mask setAlpha:0.0];
		[self.modalView.view setTransform:CGAffineTransformMakeTranslation(0, self.view.frame.size.height)];
		[self.mainView.layer setTransform:CATransform3DMakeScale(1, 1, 1)];
	} completion:^(BOOL finished) {
		[self.modalView.view removeFromSuperview];
		[self.mask removeFromSuperview];
		self.modalView = nil;
		self.mask = nil;
	}];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSLog(@"Touch!");
}

@end

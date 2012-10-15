//
//  SCNavigationController.m
//  SCViewController
//
//  Created by Sean Cheng on 10/14/12.
//  Copyright (c) 2012 Sean Cheng. All rights reserved.
//

#import "SCNavigationController.h"
#import "SCTableViewController.h"

@interface SCNavigationController()
@property (strong,nonatomic) UIScrollView*	views;
@end

@implementation SCNavigationController

- (id)initWithRootViewController:(SCViewController*)viewController
{
	self = [super init];
	if (self) {
		
		CGRect frame = (((UIWindow*)[UIApplication sharedApplication].windows[0]).frame);
		
		self.view = [[UIView alloc]initWithFrame:frame];
		
		self.views = [[UIScrollView alloc]initWithFrame:frame];
		[self.view addSubview:self.views];
		
		self.navigationBar = [[UINavigationBar alloc]init];
		[self.navigationBar setDelegate:self];
		[self.navigationBar setFrame:CGRectMake(0, 0, 320, 45)];
		[self.navigationBar pushNavigationItem:viewController.navigationItem animated:NO];
		[self.view addSubview:self.navigationBar];
		
		[viewController setNavigationController:self];
		[viewController.view setFrame:CGRectMake(0, self.view.frame.origin.y + 46, self.view.frame.size.width, self.view.frame.size.height - 66)];
		
		self.viewControllers = [[NSMutableArray alloc]initWithObjects:viewController, nil];
		[self.views addSubview:viewController.view];
	}
	return self;
}

- (void)pushViewController:(SCViewController*)viewController animated:(BOOL)animated
{
	[self.viewControllers addObject:viewController];
	
	int count = [self.viewControllers indexOfObject:viewController];
	[viewController.view setFrame:CGRectMake(320*count, self.view.frame.origin.y + 46, self.view.frame.size.width, self.view.frame.size.height - 66)];
	[viewController setNavigationController:self];
	[self.views addSubview:viewController.view];
	
	[self.views setContentOffset:CGPointMake(self.views.contentOffset.x + 320, self.views.contentOffset.y) animated:animated];
	[self.navigationBar pushNavigationItem:viewController.navigationItem animated:animated];
}

- (void)popViewControllerAnimated:(BOOL)animated
{
	[self.navigationBar popNavigationItemAnimated:YES];
	[UIView animateWithDuration:0.3 animations:^{
		[self.views setContentOffset:CGPointMake(self.views.contentOffset.x - 320, self.views.contentOffset.y) animated:NO];
	} completion:^(BOOL finished) {
		int count = (self.views.contentOffset.x / 320) + 1;
		[((SCTableViewController*)self.viewControllers[count]).view removeFromSuperview];
		[self.viewControllers removeObjectAtIndex:count];
	}];
}

- (void)popToRootViewControllerAnimated:(BOOL)animated
{
	[self.navigationBar popNavigationItemAnimated:YES];
	[UIView animateWithDuration:0.3 animations:^{
		[self.views setContentOffset:CGPointMake(0, self.views.contentOffset.y) animated:NO];
	} completion:^(BOOL finished) {
		for (int i = 1; i < [self.viewControllers count]; i++) {
			[((SCTableViewController*)self.viewControllers[i]).view removeFromSuperview];
			[self.viewControllers removeObjectAtIndex:i];
		}
	}];
}

@end

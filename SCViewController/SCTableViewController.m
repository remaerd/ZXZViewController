//
//  SCTableViewController.m
//  SCViewController
//
//  Created by Sean Cheng on 10/15/12.
//  Copyright (c) 2012 Sean Cheng. All rights reserved.
//

#import "SCTableViewController.h"

CGPoint oldOffest;
CGPoint lastOffest;

@implementation SCTableViewController

- (id)init
{
	self = [super init];
	if (self) {
		
		self.tableView = [[UITableView alloc]initWithFrame:self.view.frame];
		[self.tableView setDataSource:self];
		[self.tableView setDelegate:self];
		[self.view addSubview:self.tableView];
	}
	return self;
}

- (void)disablePanning
{
	
}

- (void)panning:(UIPanGestureRecognizer*)pan
{
	CGPoint point = [pan translationInView:self.view];
	
	if (pan.state == UIGestureRecognizerStateBegan) oldOffest = self.tableView.contentOffset;
	else if (pan.state == UIGestureRecognizerStateChanged) {
		if (self.tableView.contentOffset.y >= 0) {
			[self.tableView setContentOffset:CGPointMake(0, oldOffest.y - point.y)];
			lastOffest = point;
		} else if (self.navigationController.view.frame.origin.y >= 0) [self.navigationController.view setTransform:CGAffineTransformMakeTranslation(0, point.y-lastOffest.y)];
	}
	else if (pan.state == UIGestureRecognizerStateEnded) {
		if (self.tableView.contentOffset.y < 0) {
			if (point.y - lastOffest.y > 70) [self.delegate didPanToDismissPosition];
			else {
				[UIView animateWithDuration:0.3 animations:^{
					[self.navigationController.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
					[self.tableView setContentOffset:CGPointMake(0, 0)];
				}];
			}
		} else {
			int section = [self.tableView numberOfSections] - 1;
			CGRect lastRowRect= [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForItem:[self.tableView numberOfRowsInSection:section] - 1 inSection:section]];
			CGFloat contentHeight = lastRowRect.origin.y + lastRowRect.size.height - self.tableView.frame.size.height + 55;
			if (lastRowRect.origin.y + lastRowRect.size.height + 45 < self.tableView.frame.size.height) [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
			else if (self.tableView.contentOffset.y > contentHeight) [self.tableView setContentOffset:CGPointMake(0, contentHeight) animated:YES];
		}
	}
}

@end

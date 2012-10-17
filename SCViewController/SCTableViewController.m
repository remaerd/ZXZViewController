//
//  SCTableViewController.m
//  SCViewController
//
//  Created by Sean Cheng on 10/15/12.
//  Copyright (c) 2012 Sean Cheng. All rights reserved.
//

#import "SCTableViewController.h"
@implementation SCTableViewController

- (id)init
{
	self = [super init];
	if (self) {
		self.scDelegate = self;
		CGFloat height = [[UIScreen mainScreen]bounds].size.height - 45 - 20;
		self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, height) style:UITableViewStyleGrouped];
		[self.tableView setScrollEnabled:NO];
		[self.tableView setDelegate:self];
		[self.tableView setDataSource:self];
		[self.view addSubview:self.tableView];
	}
	return self;
}

- (void)panning:(UIPanGestureRecognizer*)pan
{
	CGPoint point = [pan translationInView:self.view];
	
	if (pan.state == UIGestureRecognizerStateBegan) {
		
		if (fabs(point.x) <= fabs(point.y)) {
			self.panMode = 0;
			self.oldOffest = self.tableView.contentOffset;
		} else {
			self.panMode = 1;
		}
		
	} else if (pan.state == UIGestureRecognizerStateChanged) {
		
		if (self.panMode == 0) {
			if (self.tableView.contentOffset.y >= 0) {
				[self.tableView setContentOffset:CGPointMake(0, self.oldOffest.y - point.y)];
				self.lastOffest = point;
			} else if (self.navigationController.view.frame.origin.y >= 0) [self.navigationController.view setTransform:CGAffineTransformMakeTranslation(0, point.y-self.lastOffest.y)];
		} else if (point.x >= 0) [self.tableView setTransform:CGAffineTransformMakeTranslation(point.x, 0)];
	}
	else if (pan.state == UIGestureRecognizerStateEnded) {
		if (self.panMode == 0) {
			if (self.tableView.contentOffset.y < 0) {
				if (point.y - self.lastOffest.y > 70) [self.scDelegate didPanToDismissPosition];
				else {
					[UIView animateWithDuration:0.3 animations:^{
						[self.navigationController.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
						[self.tableView setContentOffset:CGPointMake(0, 0)];
					}];
				}
			} else {
				int section = [self.tableView numberOfSections] - 1;
				CGRect lastRowRect= [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForItem:[self.tableView numberOfRowsInSection:section] - 1 inSection:section]];
				CGFloat contentHeight = lastRowRect.origin.y + lastRowRect.size.height - self.tableView.frame.size.height + 10;
				if (lastRowRect.origin.y + lastRowRect.size.height + 45 < self.tableView.frame.size.height) [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
				else if (self.tableView.contentOffset.y > contentHeight) [self.tableView setContentOffset:CGPointMake(0, contentHeight) animated:YES];
			}
		} else {
			if (point.x > 70 && self != self.navigationController.viewControllers[0]) [self.navigationController popViewControllerAnimated:YES];
			else {
				[UIView animateWithDuration:0.3 animations:^{
					[self.tableView setTransform:CGAffineTransformMakeTranslation(0, 0)];
				}];
			}
		}
	}
}

@end

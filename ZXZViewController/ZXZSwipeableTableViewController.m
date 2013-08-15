//
//  ZXZSwipeableTableViewController.m
//  SCFoundation
//
//  Created by Sean Cheng on 8/9/13.
//  Copyright (c) 2013 Extremely Limited. All rights reserved.
//

#import "ZXZSwipeableTableViewController.h"

@interface ZXZSwipeableTableViewController()
@property (nonatomic) CGPoint						lastOffest;
@property (nonatomic) CGPoint						oldOffest;
@property (nonatomic) int								panMode;
@property (nonatomic) UITableViewStyle	style;
@property (strong,nonatomic) UIView*		backgroundView;
@end

@implementation ZXZSwipeableTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super init];
	if (self) self.style = style;
	return self;
}

- (void)loadView
{
  [super loadView];
  self.sfDelegate = self;
	
  if (self.tableView) [self.tableView setBackgroundView:[[UIView alloc]init]];
  else {
		self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:self.style];
		[self.tableView setBackgroundView:[[UIView alloc]init]];
		[self.tableView setDelegate:self];
		[self.tableView setDataSource:self];
		[self setView:self.tableView];
	}
}

- (void)panning:(UIPanGestureRecognizer*)pan
{
	CGPoint point = [pan translationInView:self.view];
	
	if (pan.state == UIGestureRecognizerStateBegan) {
		if (fabs(point.x) <= fabs(point.y)) {
			self.panMode = 0;
			self.oldOffest = self.tableView.contentOffset;
		} else self.panMode = 1;
		
	} else if (pan.state == UIGestureRecognizerStateChanged) {
		
		if (self.panMode == 0 && self.enableVerticalPull) {
			if (self.tableView.contentOffset.y >= 0) {
				[self.tableView setContentOffset:CGPointMake(0, self.oldOffest.y - point.y)];
				self.lastOffest = point;
			} else if (self.navigationController.view.frame.origin.y >= 0) [self.navigationController.view setTransform:CGAffineTransformMakeTranslation(0, point.y-self.lastOffest.y)];
		} else if (point.x >= 0 && self.enableHorizontalPull && self.navigationController) [self.tableView setTransform:CGAffineTransformMakeTranslation(point.x, 0)];
	}
	else if (pan.state == UIGestureRecognizerStateEnded) {
		if (self.panMode == 0 && self.enableVerticalPull) {
			if (self.tableView.contentOffset.y < 0) {
				if (point.y - self.lastOffest.y > self.positionY) [self.sfDelegate didPanToPositionY];
				else {
					[UIView animateWithDuration:self.presentSpeed animations:^{
						if (self.navigationController) [self.navigationController.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
						[self.tableView setContentOffset:CGPointMake(0, 0)];
					}];
				}
			} else if (self.enableVerticalPull) {
				int section = [self.tableView numberOfSections] - 1;
				NSIndexPath* index = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:section] - 1 inSection:section];
				CGRect lastRowRect= [self.tableView rectForRowAtIndexPath:index];
				CGFloat contentHeight = lastRowRect.origin.y + lastRowRect.size.height - self.tableView.frame.size.height + 10;
				if (lastRowRect.origin.y + lastRowRect.size.height + 45 < self.tableView.frame.size.height) [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
				else if (self.tableView.contentOffset.y > contentHeight) [self.tableView setContentOffset:CGPointMake(0, contentHeight) animated:YES];
			}
		} else {
			if (point.x > self.positionX && self != self.navigationController.viewControllers[0] && self.enableHorizontalPull) [self didPanToPositionX];
			else {
				[UIView animateWithDuration:self.presentSpeed animations:^{
					[self.tableView setTransform:CGAffineTransformMakeTranslation(0, 0)];
				}];
			}
		}
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell* cell;
	return cell;
}

- (void)didPanToPositionY
{
	[UIView animateWithDuration:self.presentSpeed animations:^{
		if (self.navigationController) [self.navigationController.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
		[self.tableView setContentOffset:CGPointMake(0, 0)];
	}];
}

- (void)didPanToPositionX
{
	[UIView animateWithDuration:self.presentSpeed animations:^{
		[self.tableView setTransform:CGAffineTransformMakeTranslation(0, 0)];
	}];
}

@end

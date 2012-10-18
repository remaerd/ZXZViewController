/*============================================================
 
 The MIT License (MIT)
 Copyright (c) 2012 Sean Cheng
 
 ==============================================================
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 ==============================================================
 */

#import "SFTableViewController.h"

@interface SFTableViewController()
@property (nonatomic) CGPoint										lastOffest;
@property (nonatomic) CGPoint										oldOffest;
@property (nonatomic) int												panMode;
@property (nonatomic) UITableViewStyle					style;
@end

@implementation SFTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
	self = [super init];
	if (self) self.style = style;
	return self;
}

- (void)loadView
{
	self.sfDelegate = self;
	CGFloat height = [[UIScreen mainScreen]bounds].size.height - 45 - 20;
	
	self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, height)];
	
	self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, height) style:self.style];
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	
//	通过删掉 ScrollView 自带的 UIScrollViewPanGestureRecognizer，让 TableView 能够正常运行，防止出现滚动后
	for (UIGestureRecognizer* gesture in self.tableView.gestureRecognizers) {
		if ([NSStringFromClass([gesture class]) isEqualToString:@"UIScrollViewPanGestureRecognizer"]) [self.tableView removeGestureRecognizer:gesture];
	}
	[self.view addSubview:self.tableView];
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
		
		if (self.panMode == 0 && self.enableVerticalPull) {
			if (self.tableView.contentOffset.y >= 0) {
                
				[self.tableView setContentOffset:CGPointMake(0, self.oldOffest.y - point.y)];
				self.lastOffest = point;
			} else if (self.navigationController.view.frame.origin.y >= 0) [self.navigationController.view setTransform:CGAffineTransformMakeTranslation(0, point.y-self.lastOffest.y)];
		} else if (point.x >= 0 && self.enableHorizontalPull) [self.tableView setTransform:CGAffineTransformMakeTranslation(point.x, 0)];
	}
	else if (pan.state == UIGestureRecognizerStateEnded) {
        [self.tableView setUserInteractionEnabled:YES];
		if (self.panMode == 0 && self.enableVerticalPull) {
			if (self.tableView.contentOffset.y < 0) {
				if (point.y - self.lastOffest.y > self.positionY) [self.sfDelegate didPanToPositionY];
				else {
					[UIView animateWithDuration:self.presentSpeed animations:^{
						if (self.navigationController) [self.navigationController.view setTransform:CGAffineTransformMakeTranslation(0, 0)];
						[self.tableView setContentOffset:CGPointMake(0, 0)];
					}];
				}
			} else if (self.enableHorizontalPull) {
				int section = [self.tableView numberOfSections] - 1;
                NSIndexPath* index = [NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:section] - 1 inSection:section];
				CGRect lastRowRect= [self.tableView rectForRowAtIndexPath:index];
				CGFloat contentHeight = lastRowRect.origin.y + lastRowRect.size.height - self.tableView.frame.size.height + 10;
				if (lastRowRect.origin.y + lastRowRect.size.height + 45 < self.tableView.frame.size.height) [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
				else if (self.tableView.contentOffset.y > contentHeight) [self.tableView setContentOffset:CGPointMake(0, contentHeight) animated:YES];
                [self.tableView setUserInteractionEnabled:YES];
			}
		} else {
			if (point.x > self.positionX && self != self.navigationController.viewControllers[0]) [self didPanToPositionX];
			else {
				[UIView animateWithDuration:self.presentSpeed animations:^{
					[self.tableView setTransform:CGAffineTransformMakeTranslation(0, 0)];
				}];
			}
		}
	}
}

@end

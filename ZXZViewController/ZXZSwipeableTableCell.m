//
//  ZXZTableViewCell.m
//  SCFoundation
//
//  Created by Sean Cheng on 4/21/13.
//  Copyright (c) 2013 Extremely Limited. All rights reserved.
//

#import "ZXZSwipeableTableCell.h"
#import "ZXZSwipeableTableViewController.h"

@interface ZXZSwipeableTableCell()

@property (nonatomic,assign) SCSwipeableTableViewCellStatus	direction;
@property (nonatomic,assign) NSInteger											currentIndex;
@property (nonatomic,strong) UIImageView*										leftShadow;
@property (nonatomic,strong) UIPanGestureRecognizer*				pan;
@property (nonatomic,assign) NSInteger											leftButtonMargin;
@property (nonatomic,assign) NSInteger											rightButtonMargin;
@property (nonatomic,assign) CGFloat												originalPointX;

@end

@implementation ZXZSwipeableTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		self.leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
		[self.leftView setContentMode:UIViewContentModeCenter];
		[self.leftView setAlpha:0.3];
		[self.contentView addSubview:self.leftView];
		
		self.rightView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
		[self.rightView setContentMode:UIViewContentModeCenter];
		[self.rightView setAlpha:0.3];
		[self.contentView addSubview:self.rightView];
		
		self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panning:)];
		[self.pan setDelegate:self];
		
		self.content = [[UIView alloc]initWithFrame:CGRectMake(-5, 0, 330, 10)];
		[self.content setOpaque:YES];
		[self.content addGestureRecognizer:self.pan];
		[self.contentView addSubview:self.content];
		
		for (UIGestureRecognizer* gesture in self.contentView.gestureRecognizers) {
			[self.contentView removeGestureRecognizer:gesture];
		}
	}
	return self;
}

- (void)didMoveToSuperview
{
	[super didMoveToSuperview];
}

- (void)panning:(UIPanGestureRecognizer*)pan
{
	CGFloat x = [pan locationInView:self].x;
	if (pan.state == UIGestureRecognizerStateBegan) self.originalPointX = x;
	else if (pan.state == UIGestureRecognizerStateChanged) {
		
		[self.content setTransform:CGAffineTransformMakeTranslation(x - self.originalPointX, 0)];
		
		CGFloat transitX = x - self.originalPointX;
		self.currentIndex = fabs((int)(transitX / self.leftButtonMargin));
		
		if (transitX > 0) self.direction = SCSwipeableTableViewCellStatusLeft;
		else if (transitX < 0) self.direction = SCSwipeableTableViewCellStatusRight;
		else self.direction = SCSwipeableTableViewCellStatusCenter;
		
		if (self.direction == SCSwipeableTableViewCellStatusLeft) {
			[self.leftView setImage:self.leftButtons[self.currentIndex]];
			
			if ( transitX - 44 <= 10) transitX = 54;
			[self.leftView setTransform:CGAffineTransformMakeTranslation(transitX - 44, 0)];
			
			if (x - self.originalPointX > 60) {
				[UIView animateWithDuration:0.2 animations:^{
					[self.leftView setAlpha:1];
				}];
			} else {
				[UIView animateWithDuration:0.2 animations:^{
					[self.leftView setAlpha:0.3];
				}];
			}
		} else if (self.direction == SCSwipeableTableViewCellStatusRight) {
			[self.rightView setImage:self.rightButtons[self.currentIndex]];
			
			if ( transitX + 54 >= -10) transitX = -64;
			[self.rightView setTransform:CGAffineTransformMakeTranslation(transitX + 54, 0)];
			
			if (x - self.originalPointX < -60) {
				[UIView animateWithDuration:0.2 animations:^{
					[self.rightView setAlpha:1];
				}];
			} else {
				[UIView animateWithDuration:0.2 animations:^{
					[self.rightView setAlpha:0.3];
				}];
			}
		}
		
	} else if (pan.state == UIGestureRecognizerStateEnded) {
		
		BOOL failed;
		if (fabs(x - self.originalPointX) <= 60) failed = YES;
		else failed = NO;
		
		[UIView animateWithDuration:0.2 animations:^{
			if (failed) [self.content setTransform:CGAffineTransformIdentity];
			else {
				if (self.direction == SCSwipeableTableViewCellStatusLeft) [self.content setTransform:CGAffineTransformMakeTranslation(-10, 0)];
				else if (self.direction == SCSwipeableTableViewCellStatusRight)[self.content setTransform:CGAffineTransformMakeTranslation(10, 0)];
				[((ZXZSwipeableTableViewController*)self.superview).delegate tableViewCell:self didTriggerButtonDirection:self.direction index:self.currentIndex];
			}
		} completion:^(BOOL finished) {
			[self.leftView setTransform:CGAffineTransformIdentity];
			[self.leftView setAlpha:0.3];
			[self.rightView setTransform:CGAffineTransformIdentity];
			[self.rightView setAlpha:0.3];
			
			if (!failed) {
				[UIView animateWithDuration:0.1 animations:^{
					[self.content setTransform:CGAffineTransformIdentity];
				}];
			}
		}];
		self.direction = SCSwipeableTableViewCellStatusCenter;
		self.currentIndex = 0;
		self.originalPointX = 0;
	}
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	CGPoint location = [touch locationInView:self];
	if (location.x >= 20 & location.x <= 300) return YES;
	return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
	CGPoint translation = [gestureRecognizer translationInView:[self superview]];
	if (fabsf(translation.x) > fabsf(translation.y)) return YES;
	return NO;
}

- (void)setImageForDirection:(SCSwipeableTableViewCellStatus)direction atIndex:(NSInteger)index image:(UIImage*)image
{
	if (self.direction == SCSwipeableTableViewCellStatusRight) {
		NSMutableArray* array = [[NSMutableArray alloc]initWithArray:self.rightButtons];
		[array removeObjectAtIndex:index];
		[array insertObject:image atIndex:index];
		self.rightButtons = array;
	}
}

- (void)setLeftButtons:(NSArray *)leftButtons rightButtons:(NSArray*)rightButtons
{
	[self.content setFrame:CGRectMake(-5, 0, 330, self.frame.size.height)];
	
	if (leftButtons) {
		self.leftButtons = leftButtons;
		[self.leftView setImage:self.leftButtons[0]];
	}
	
	if (rightButtons) {
		self.rightButtons = rightButtons;
		[self.rightView setImage:self.rightButtons[0]];
	}
	
	self.leftButtonMargin = 320 / [self.leftButtons count];
	self.rightButtonMargin = 320 / [self.rightButtons count];
	
	[self.leftShadow setFrame:CGRectMake(-5, 0, 5, self.frame.size.height)];
	[self.leftView setFrame:CGRectMake(10, (self.frame.size.height / 2) - 12, 24, 24)];
	[self.rightView setFrame:CGRectMake(280, (self.frame.size.height / 2) - 12, 24, 24)];
}

@end

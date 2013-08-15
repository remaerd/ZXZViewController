//
//  ZXZTableViewCell.h
//  SCFoundation
//
//  Created by Sean Cheng on 4/21/13.
//  Copyright (c) 2013 Extremely Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	
	SCSwipeableTableViewCellStatusCenter = 0,
	SCSwipeableTableViewCellStatusLeft = 1,
	SCSwipeableTableViewCellStatusRight = 2
	
} SCSwipeableTableViewCellStatus;

@class ZXZSwipeableTableCell;

@interface ZXZSwipeableTableCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIView*      content;
@property (nonatomic,strong) NSArray*			leftButtons;
@property (nonatomic,strong) NSArray*			rightButtons;
@property (nonatomic,strong) UIImageView*	rightView;
@property (nonatomic,strong) UIImageView*	leftView;
@property (nonatomic,strong) UIView*			tagView;
@property (nonatomic,strong) id						item;

- (void)setLeftButtons:(NSArray *)leftButtons rightButtons:(NSArray*)rightButtons;
- (void)setItem:(id)item;

@end

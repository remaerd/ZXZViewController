//
//  ZXZSwipeableTableViewController.h
//  SCFoundation
//
//  Created by Sean Cheng on 8/9/13.
//  Copyright (c) 2013 Extremely Limited. All rights reserved.
//

#import "ZXZSwipeableViewController.h"
#import "ZXZSwipeableTableCell.h"

@protocol SCSwipeableTableViewControllerDelegate <NSObject>

- (void)tableViewCell:(ZXZSwipeableTableCell*)cell didTriggerButtonDirection:(SCSwipeableTableViewCellStatus)state index:(NSInteger)index;

@end

@interface ZXZSwipeableTableViewController : ZXZSwipeableViewController <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (strong,nonatomic) UITableView*																tableView;
@property (nonatomic,strong) id<SCSwipeableTableViewControllerDelegate>	delegate;

- (id)initWithStyle:(UITableViewStyle)style;

@end

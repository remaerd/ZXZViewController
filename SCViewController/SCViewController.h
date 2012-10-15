//
//  SCViewController.h
//  SCViewController
//
//  Created by Sean Cheng on 10/14/12.
//  Copyright (c) 2012 Sean Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCNavigationController.h"

@class SCNavigationController;

@protocol SCViewControllerDelegate <NSObject>

@optional
- (void)didPanToDismissPosition;

@end

@interface SCViewController : UIResponder <UITableViewDataSource,UITableViewDelegate,SCViewControllerDelegate>

@property (strong,nonatomic) id<SCViewControllerDelegate>	delegate;
@property (strong,nonatomic) SCNavigationController*			navigationController;
@property (strong,nonatomic) UINavigationItem*						navigationItem;
@property (strong,nonatomic) UIView*											mainView;
@property (strong,nonatomic) NSString*										title;
@property (strong,nonatomic) UIView*											view;

- (id)init;
- (void)setTitle:(NSString *)title;
- (void)presentModalViewController:(SCViewController*)viewController;
- (void)dismissModalView;
- (void)disablePan;

@end

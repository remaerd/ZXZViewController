//
//  SCNavigationController.h
//  SCViewController
//
//  Created by Sean Cheng on 10/14/12.
//  Copyright (c) 2012 Sean Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCViewController.h"

@class SCViewController;

@interface SCNavigationController : UIResponder <UINavigationBarDelegate>

@property (strong,nonatomic) NSMutableArray*	viewControllers;
@property (strong,nonatomic) UINavigationBar* navigationBar;
@property (strong,nonatomic) UIView*					view;

- (id)initWithRootViewController:(SCViewController*)viewController;
- (void)pushViewController:(SCViewController*)viewController animated:(BOOL)animated;
- (void)popViewControllerAnimated:(BOOL)animated;
- (void)popToRootViewControllerAnimated:(BOOL)animated;

@end

//
//  ZXZLoopViewController.h
//  Karenin
//
//  Created by Sean Cheng on 5/9/13.
//  Copyright (c) 2013 Extremely Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXZLoopViewController : UIViewController <UIGestureRecognizerDelegate>

#define DISABLE_ALPHA 0.4
#define SCALE 0.6f
#define MARGIN 10.0f

@property (nonatomic,strong) UIScrollView*              containerView;
@property (nonatomic,strong) UIViewController*          currentViewController;
@property (nonatomic,strong) NSMutableArray*            viewControllers;
@property (nonatomic,strong) NSMutableArray*            labels;
@property (nonatomic,assign) BOOL                       isListView;

- (void)toggleListView;
- (id)initWithViewControllers:(NSArray*)viewControllers rootIndex:(NSInteger)index;
- (void)moveToViewControllerAtIndex:(NSInteger)index animated:(BOOL)animated;

@end

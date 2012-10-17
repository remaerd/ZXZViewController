//
//  SCViewController.h
//  SCViewController
//
//  Created by Sean Cheng on 10/14/12.
//  Copyright (c) 2012 Sean Cheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCViewControllerDelegate <NSObject>

@optional

- (void)didPanToDismissPosition;

@end

@interface SCViewController : UIViewController <SCViewControllerDelegate>

@property (strong,nonatomic) id<SCViewControllerDelegate>	scDelegate;
@property (nonatomic) CGFloat															presentSpeed;
@property (nonatomic) CGFloat															pushPopSpeed;
@property (nonatomic) UIColor*														previousViewMaskColor;
@property (nonatomic) CGFloat															previousViewMaskAlpha;
@end

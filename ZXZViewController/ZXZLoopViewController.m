//
//  ZXZLoopViewController.m
//  Karenin
//
//  Created by Sean Cheng on 5/9/13.
//  Copyright (c) 2013 Extremely Limited. All rights reserved.
//

#import "ZXZLoopViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface ZXZLoopViewController()
{
  CGFloat   originalPointX;
  CGFloat   originalContentOffestX;
  CGFloat   nagitivePoint;
  NSInteger previousIndex;
  NSInteger baseIndex;
  NSInteger basicIndex;
}

@end

@implementation ZXZLoopViewController

#define FONT_REGULAR	@"Helvetica"
#define SCREEN_WIDTH	[UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT	[UIScreen mainScreen].bounds.size.height
#define LEFT_MARGIN (SCREEN_WIDTH - (SCREEN_WIDTH * SCALE) - 10)
#define LABEL_Y (SCREEN_HEIGHT * SCALE) + (SCREEN_HEIGHT - (SCREEN_HEIGHT * SCALE)) / 2 + 5
#define CURRENT_VIEW_TAG  ((float)self.currentViewController.view.tag - 10.0f)
#define VIEW_CONTROLLER_X  (((float)baseIndex * ((SCREEN_WIDTH * SCALE) + MARGIN) * (float)[self.viewControllers count])) + (CURRENT_VIEW_TAG * ((SCREEN_WIDTH * SCALE) + MARGIN))

- (id)init
{
  self = [super init];
  if (!self) return nil;
  else {
		self.isListView = NO;
  }
  return self;
}

- (id)initWithViewControllers:(NSArray*)viewControllers rootIndex:(NSInteger)index
{
	[UIFont systemFontOfSize:22];
  self = [self init];
  if (!self) return nil;
  else {
    
    self.viewControllers = [[NSMutableArray alloc]initWithArray:viewControllers];
    self.labels = [[NSMutableArray alloc]init];
    
    for (UIViewController* view in viewControllers) {
      [self.labels addObject:view.title];
    }
    
    basicIndex = index;
  }
  return self;
}

- (void)loadView
{
  [super loadView];
  
  self.containerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
	[self.containerView setContentSize:CGSizeMake((((SCREEN_WIDTH * SCALE) + MARGIN)*5 + LEFT_MARGIN), SCREEN_HEIGHT)];
	[self.containerView setContentOffset:CGPointMake(((SCREEN_WIDTH * SCALE) + MARGIN), 0)];
  [self.containerView setShowsHorizontalScrollIndicator:NO];
	[self.containerView setScrollEnabled:NO];
	[self.view addSubview:self.containerView];
	
  baseIndex = 0;
  
	for (int i=0; i < [self.viewControllers count]; i++) {
    
		UIViewController* view = self.viewControllers[i];
    [view.view setTag:i+10];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH * SCALE), 25)];
    [label setText:self.labels[i]];
    [label setTag:i + 100];
    [label setFont:[UIFont fontWithName:FONT_REGULAR size:22]];
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [self.containerView addSubview:label];
    
    [view.view.layer setShouldRasterize:YES];
    [view.view setUserInteractionEnabled:NO];
    [view.view setAlpha:DISABLE_ALPHA];
    [view.view setTransform:CGAffineTransformConcat(CGAffineTransformMakeTranslation((i*334), 0), CGAffineTransformMakeScale(SCALE, SCALE))];
    [label setTransform:CGAffineTransformMakeTranslation(view.view.frame.origin.x, LABEL_Y)];
    [label.layer setShouldRasterize:YES];
    [label setAlpha:DISABLE_ALPHA];
    
		[self.containerView addSubview:view.view];
	}
  
  [self selectViewControllerAtIndex:basicIndex];
  
  self.currentViewController = self.viewControllers[basicIndex];
  [self.currentViewController.view setTransform:CGAffineTransformMakeTranslation((basicIndex*(SCREEN_WIDTH * SCALE)+ 10), 0)];
  [self.currentViewController.view setAlpha:1];
  [self.currentViewController.view.layer setShouldRasterize:NO];
  [self.currentViewController.view setUserInteractionEnabled:YES];
  [self.containerView bringSubviewToFront:self.currentViewController.view];
  
  UIView* label = [self.containerView viewWithTag:100+CURRENT_VIEW_TAG];
  [label setAlpha:1];
  
  UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panning:)];
	[pan setDelegate:self];
  [self.view addGestureRecognizer:pan];
  
  UIPinchGestureRecognizer* pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinching:)];
  [pinch setDelegate:self];
  [self.view addGestureRecognizer:pinch];
  
  UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped:)];
  [tap setDelegate:self];
  [self.view addGestureRecognizer:tap];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.view bringSubviewToFront:self.containerView];
}

// 用户打开列表模式
- (void)toggleListView
{
	if (!self.isListView) {
    self.isListView = YES;
		[self.currentViewController.view.layer setShouldRasterize:YES];
    [self.currentViewController.view setUserInteractionEnabled:NO];
    [self prepareViewControllersAtIndex:CURRENT_VIEW_TAG];
    UIView* label = [self.containerView viewWithTag:100+CURRENT_VIEW_TAG];
    
		[UIView animateWithDuration:0.2 animations:^{
			[self.currentViewController.view setTransform:CGAffineTransformConcat(CGAffineTransformMakeScale(SCALE, SCALE), CGAffineTransformMakeTranslation(VIEW_CONTROLLER_X, 0))];
		} completion:^(BOOL finished) {
      [self.view sendSubviewToBack:self.containerView];
      [label setTransform:CGAffineTransformMakeTranslation(self.currentViewController.view.frame.origin.x, LABEL_Y)];
    }];
	}
}

// 识别滑动手势是否从边缘开始
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
  if (!self.isListView) {
    if ([[gestureRecognizer class]isSubclassOfClass:[UIPanGestureRecognizer class]]) {
      CGPoint location = [touch locationInView:self.view];
      if (location.x < 20 || location.x > SCREEN_WIDTH - 20) return YES;
    } else if ([[gestureRecognizer class]isSubclassOfClass:[UIPanGestureRecognizer class]]) return YES;
    else if ([[gestureRecognizer class]isSubclassOfClass:[UIPinchGestureRecognizer class]]) return YES;
  } else {
    if ([[gestureRecognizer class]isSubclassOfClass:[UIPanGestureRecognizer class]]) return YES;
    else if ([[gestureRecognizer class]isSubclassOfClass:[UITapGestureRecognizer class]]) return YES;
  }
	
  return NO;
}

// 检测出轻点手势，如在左右边缘轻点，移到上一个／下一个 ViewController。如果在中间点击，则打开当前的 ViewController
- (void)tapped:(UITapGestureRecognizer*)tap
{
  CGFloat tapX = [tap locationInView:self.view].x;
  if (tapX <= 43 || tapX >= SCREEN_WIDTH - 43) {
    
    
    NSInteger newIndex = [self getCurrentIndex:NO];
    if (tapX <= 43) {
      if (newIndex == 0) {
        newIndex = [self.viewControllers count] - 1;
        baseIndex -= 1;
      } else {
        newIndex -= 1;
      }
    } else {
      if (newIndex == [self.viewControllers count] - 1) {
        newIndex = 0;
        baseIndex += 1;
      } else newIndex += 1;
    }
    
    self.currentViewController = self.viewControllers[newIndex];
    [self.containerView setContentOffset:CGPointMake(VIEW_CONTROLLER_X, 0) animated:YES];
    [self prepareViewControllersAtIndex:newIndex];
    [self selectViewControllerAtIndex:newIndex];
    
  } else {
    
    self.isListView = NO;
    baseIndex = 0;
    [self.view bringSubviewToFront:self.containerView];
    [UIView animateWithDuration:0.2 animations:^{
      [self.containerView setContentOffset:CGPointMake(VIEW_CONTROLLER_X, 0) animated:NO];
      [self.currentViewController.view setTransform:CGAffineTransformMakeTranslation(VIEW_CONTROLLER_X, 0)];
      [self.containerView bringSubviewToFront:self.currentViewController.view];
    } completion:^(BOOL finished) {
      [self.currentViewController.view setUserInteractionEnabled:YES];
      [self.currentViewController.view.layer setShouldRasterize:NO];
      [self reset];
    }];
  }
	
}

// 监测缩放手势，进入列表模式
- (void)pinching:(UIPinchGestureRecognizer*)pinch
{
  if (pinch.state == UIGestureRecognizerStateBegan) {
    [self prepareViewControllersAtIndex:CURRENT_VIEW_TAG];
    [self.currentViewController.view setUserInteractionEnabled:NO];
    [self.currentViewController.view.layer setShouldRasterize:YES];
  } else if (pinch.state == UIGestureRecognizerStateChanged) {
    
    [self.currentViewController.view setTransform:CGAffineTransformConcat(CGAffineTransformMakeScale([pinch scale], [pinch scale]),  CGAffineTransformMakeTranslation(CURRENT_VIEW_TAG * ((SCREEN_WIDTH * SCALE) + MARGIN), 0))];
    
  } else if (pinch.state == UIGestureRecognizerStateEnded) {
    
    if ([pinch scale] < SCALE) [self toggleListView];
    else {
      [self.currentViewController.view setUserInteractionEnabled:YES];
      [self.currentViewController.view.layer setShouldRasterize:NO];
      [UIView animateWithDuration:0.2 animations:^{
        [self.currentViewController.view setTransform:CGAffineTransformConcat(CGAffineTransformMakeScale(1, 1),  CGAffineTransformMakeTranslation(CURRENT_VIEW_TAG * ((SCREEN_WIDTH * SCALE) + MARGIN), 0))];
      }];
    }
  }
}

// 拖动边缘时，切换 ViewController
- (void)panning:(UIPanGestureRecognizer*)pan
{
  CGFloat currentPointX = [pan locationInView:self.view].x;
	if (pan.state == UIGestureRecognizerStateBegan) {
    
    previousIndex = INT32_MAX;
    originalContentOffestX = self.containerView.contentOffset.x;
    originalPointX = currentPointX;
    [self prepareViewControllersAtIndex:CURRENT_VIEW_TAG];
    if (!self.isListView) {
      [self.currentViewController.view.layer setShouldRasterize:YES];
      [self.currentViewController.view setUserInteractionEnabled:NO];
      [UIView animateWithDuration:0.2 animations:^{
        [self.currentViewController.view setTransform:CGAffineTransformConcat(CGAffineTransformMakeScale(SCALE, SCALE), CGAffineTransformMakeTranslation(CURRENT_VIEW_TAG * ((SCREEN_WIDTH * SCALE) + MARGIN), 0))];
      }];
    }
  }
  else if (pan.state == UIGestureRecognizerStateChanged) {
    
    //  计算出 ScrollView Content 的当前位置
    nagitivePoint = -(currentPointX - originalPointX);
    CGFloat contentOffestX;
    
    if (self.isListView) contentOffestX = originalContentOffestX + nagitivePoint;
    else contentOffestX = originalContentOffestX + (nagitivePoint * (self.containerView.contentSize.width / SCREEN_WIDTH));
    
    [self.containerView setContentOffset:CGPointMake(contentOffestX, 0)];

    NSInteger currentIndex = [self getCurrentIndex:YES];
    
    if (currentIndex != previousIndex) {
      
      [self prepareViewControllersAtIndex:currentIndex];
      [self selectViewControllerAtIndex:currentIndex];
    }

  } else if (pan.state == UIGestureRecognizerStateEnded) {
    [self.containerView bringSubviewToFront:self.currentViewController.view];
    if (!self.isListView) {
      [UIView animateWithDuration:0.2 animations:^{
        [self.containerView setContentOffset:CGPointMake(CURRENT_VIEW_TAG * ((SCREEN_WIDTH * SCALE) + MARGIN), 0)];
        [self.currentViewController.view setTransform:CGAffineTransformConcat(CGAffineTransformMakeScale(1, 1), CGAffineTransformMakeTranslation(CURRENT_VIEW_TAG * ((SCREEN_WIDTH * SCALE) + MARGIN), 0))];
      } completion:^(BOOL finished) {
        [self reset];
        [self.currentViewController.view setUserInteractionEnabled:YES];
        [self.currentViewController.view.layer setShouldRasterize:NO];
        [self.containerView setContentOffset:CGPointMake(VIEW_CONTROLLER_X, 0)];
//        NSLog(@"%f",self.containerView.contentOffset.x);
      }];
      
    } else {
      [UIView animateWithDuration:0.2 animations:^{
        [self.containerView setContentOffset:CGPointMake(VIEW_CONTROLLER_X, 0)];
      } completion:^(BOOL finished) {
        [self reset];
        [self.containerView setContentOffset:CGPointMake(VIEW_CONTROLLER_X, 0)];
        [self.currentViewController.view setTransform:CGAffineTransformConcat(CGAffineTransformMakeScale(SCALE, SCALE), CGAffineTransformMakeTranslation(CURRENT_VIEW_TAG * ((SCREEN_WIDTH * SCALE) + MARGIN), 0))];
        [self prepareViewControllersAtIndex:CURRENT_VIEW_TAG];
      }];
    }
  }
}

// 获取当前 ViewController 的 Index
- (CGFloat)getCurrentIndex:(BOOL)pan
{
  NSInteger currentIndex = 0;
  CGFloat   currentOffestX = self.containerView.contentOffset.x;
  NSInteger viewControllerNum = [self.viewControllers count];
 
  if (currentOffestX >= 0) currentIndex = (currentOffestX + 117) / ((SCREEN_WIDTH * SCALE) + MARGIN);
  else currentIndex = (self.containerView.contentOffset.x - 117) / ((SCREEN_WIDTH * SCALE) + MARGIN);
  
  if (pan) {
    if (currentOffestX >= 0) baseIndex = (int)(currentIndex / viewControllerNum);
    else baseIndex = (int)(currentIndex / viewControllerNum) - 1;
  }
  
  if (previousIndex == INT32_MAX) previousIndex = currentIndex;
  else {
    while (currentIndex >= viewControllerNum) currentIndex = currentIndex - viewControllerNum;
    while (currentIndex < 0) currentIndex = viewControllerNum + currentIndex;
  }
  
  return currentIndex;
}

// 为当前的 ViewController 移动之前／之后的 ViewController
- (void)prepareViewControllersAtIndex:(NSInteger)index
{
  NSInteger direction;
  
  NSInteger viewControllerNum = [self.viewControllers count];
  
  if (previousIndex == 0 && index == viewControllerNum - 1) direction = 1;
  else if (previousIndex == index) direction = 2;
  else if (previousIndex == viewControllerNum - 1 && index == 0) direction = 0;
  else if (previousIndex > index) direction = 1;
  else direction = 0;
  
  if (direction == 1 || direction == 2) [self moveViewControllerOnLeft:YES ofIndex:index];
  if (direction == 0 || direction == 2) [self moveViewControllerOnLeft:NO ofIndex:index];
}

// 移动当前 ViewController 之前／之后的 ViewController
- (void)moveViewControllerOnLeft:(BOOL)left ofIndex:(NSInteger)index
{
  UIViewController* view;
  UIView* label;
  CGFloat posX = 0;
  CGFloat currentTag;
  CGFloat viewControllerNum = [self.viewControllers count];
  
  if (left) {
    if (index == 0) {
      view = [self.viewControllers lastObject];
      currentTag = view.view.tag - 10;
      posX = ((float)(baseIndex - 1) * ((SCREEN_WIDTH * SCALE) + MARGIN) * viewControllerNum) + (currentTag * ((SCREEN_WIDTH * SCALE) + MARGIN));
    } else {
      view = self.viewControllers[index - 1];
      currentTag = view.view.tag - 10;
      posX = (currentTag * ((SCREEN_WIDTH * SCALE) + MARGIN)) + ((float)baseIndex * ((SCREEN_WIDTH * SCALE) + MARGIN) * viewControllerNum);
    }
    
  } else {
    
    if (index == [self.viewControllers count] - 1) {
      view = self.viewControllers[0];
      currentTag = view.view.tag - 10;
      posX = (currentTag * ((SCREEN_WIDTH * SCALE) + MARGIN)) + ((float)(baseIndex + 1) * ((SCREEN_WIDTH * SCALE) + MARGIN) * viewControllerNum);
    } else {
      view = self.viewControllers[index + 1];
      currentTag = view.view.tag - 10;
      posX = (currentTag * ((SCREEN_WIDTH * SCALE) + MARGIN)) + (baseIndex * ((SCREEN_WIDTH * SCALE) + MARGIN) * viewControllerNum);
    }
  }
  
//  NSLog(@"%f,%f,%i",posX,currentTag,baseIndex);

  label = [self.view viewWithTag:currentTag + 100];
  [view.view setTransform:CGAffineTransformConcat(CGAffineTransformMakeScale(SCALE, SCALE), CGAffineTransformMakeTranslation(posX, 0))];
  [label setTransform:CGAffineTransformMakeTranslation(view.view.frame.origin.x, LABEL_Y)];
//  NSLog(@"%f",view.view.frame.origin.x);
}

// 播放之前和当前的 ViewController 淡出淡入动画

- (void)selectViewControllerAtIndex:(NSInteger)index
{
  UIViewController* previousView = self.viewControllers[previousIndex];
  UIView* prevLabel = [self.containerView viewWithTag:100 + previousIndex];
  UIView* nextLabel = [self.containerView viewWithTag:100 + index];
  self.currentViewController = self.viewControllers[index];
  previousIndex = index;
  
  [UIView animateWithDuration:0.1 animations:^{
    [prevLabel setAlpha:DISABLE_ALPHA];
    [previousView.view setAlpha:DISABLE_ALPHA];
  } completion:^(BOOL finished) {
    [UIView animateWithDuration:0.1 animations:^{
      [self.currentViewController.view setAlpha:1];
      [nextLabel setAlpha:1];
    }];
  }];
}

- (void)moveToViewControllerAtIndex:(NSInteger)index animated:(BOOL)animated
{
	
}

// 如果用户在无限滚动模式时，BaseIndex 不等于 0，就会重置全部 ViewController 的位置
- (void)reset
{
  if (baseIndex != 0) {
    baseIndex = 0;
    NSInteger tag = CURRENT_VIEW_TAG;
    UIViewController* view1;
    UIViewController* view2;
    if (tag == 0) {
      view1 = self.viewControllers[[self.viewControllers count] - 1];
      view2 = self.viewControllers[1];
    } else if (tag == [self.viewControllers count] - 1) {
      view1 = self.viewControllers[[self.viewControllers count] - 2];
      view2 = self.viewControllers[0];
    } else {
      view1 = self.viewControllers[tag - 1];
      view2 = self.viewControllers[tag + 1];
    }
    
    [view1.view setTransform:CGAffineTransformConcat(CGAffineTransformMakeTranslation((view1.view.tag - 10) * 334, 0), CGAffineTransformMakeScale(SCALE, SCALE))];
    [view2.view setTransform:CGAffineTransformConcat(CGAffineTransformMakeTranslation((view2.view.tag - 10) * 334, 0), CGAffineTransformMakeScale(SCALE, SCALE))];
    
    UIView* label1 = [self.containerView viewWithTag:100+(view1.view.tag - 10)];
    [label1 setTransform:CGAffineTransformMakeTranslation(view1.view.frame.origin.x, LABEL_Y)];
    
    UIView* label2 = [self.containerView viewWithTag:100+(view2.view.tag - 10)];
    [label2 setTransform:CGAffineTransformMakeTranslation(view2.view.frame.origin.x, LABEL_Y)];
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

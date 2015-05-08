//
//  CRPixellatedView.h
//  CRPixellateTransitionDemo
//
//  Created by Christian Roman on 6/17/14.
//  Copyright (c) 2014 Christian Roman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRPixellatedView : UIImageView

@property (nonatomic, assign) CGFloat pixelScale;
@property (nonatomic, assign) CGFloat pixelateAnimationDuration;

@property (nonatomic, strong) UIImage *inputImage;
@property (nonatomic, assign, getter = isReverse) BOOL reverse;

@property (nonatomic, assign) UIViewContentMode imageContentMode;

/**
 *  NSDefaultRunLoopMode or NSRunLoopCommonModes, default is NSRunLoopCommonModes
 */
@property (nonatomic, copy) NSString *runLoopCommonMode;

- (void)animate;
- (void)animateWithCompletion:(void (^)(BOOL finished))completion;

@end

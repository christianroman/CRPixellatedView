//
//  CRPixellatedView.m
//  CRPixellatedView
//
//  Created by Christian Roman on 6/17/14.
//  Copyright (c) 2014 Christian Roman. All rights reserved.
//

#import "CRPixellatedView.h"

@interface CRPixellatedView ()

@property (nonatomic, assign) CGFloat filterProgress;

@property (nonatomic, assign) CGFloat startInputScale;
@property (nonatomic, assign) CGFloat endInputScale;
@property (nonatomic, strong) UIImage *resizedImage;

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CGFloat animationFromValue;
@property (nonatomic, assign) CGFloat animationToValue;
@property (nonatomic, assign) CFTimeInterval animationStartTime;

@property (nonatomic, copy) void (^completion)(BOOL finished);

@end

@implementation CRPixellatedView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self defaults];
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self defaults];
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self defaults];
        [self setup];
    }
    return self;
}

- (void)defaults {
    self.backgroundColor = [UIColor clearColor];
    self.pixelateAnimationDuration = 1.0f;
    self.pixelScale = 20.0f;
    self.startInputScale = 0.0f;
    self.endInputScale = self.pixelScale;
    self.imageContentMode = UIViewContentModeScaleAspectFit;
    self.runLoopCommonMode = NSRunLoopCommonModes;
}

- (void)setup {
    //Set up the view
}

#pragma mark Appearance

- (void)setInputImage:(UIImage *)inputImage {
    _inputImage = inputImage;
    
    [self setNeedsDisplay];
}

- (UIImage *)resizeImage:(UIImage *)image
             contentMode:(UIViewContentMode)contentMode
                  bounds:(CGSize)bounds
    interpolationQuality:(CGInterpolationQuality)quality
{
    CGFloat horizontalRatio = bounds.width / image.size.width;
    CGFloat verticalRatio = bounds.height / image.size.height;
    CGFloat ratio;
    
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
            
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
            
        default:
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %d", (int)contentMode];
    }
    
    CGSize newSize = CGSizeMake(image.size.width * ratio, image.size.height * ratio);
    
    BOOL drawTransposed;
    
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wswitch"
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
    }
    
#pragma clang diagnostic pop
    
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = image.CGImage;
    
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    CGContextConcatCTM(bitmap, transform);
    CGContextSetInterpolationQuality(bitmap, quality);
    CGContextDrawImage(bitmap, drawTransposed ? transposedRect : newRect, imageRef);
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

- (void)setPixelScale:(CGFloat)pixelScale {
    _pixelScale = pixelScale;
    _endInputScale = _pixelScale;
}

#pragma mark - Actions

- (void)animate {
    [self startAnimation];
}

- (void)animateWithCompletion:(void (^)(BOOL finished))completion {
    self.completion = completion;
    [self startAnimation];
}

- (void)startAnimation {
    _filterProgress = 0.0f;
    
    _animationStartTime = CACurrentMediaTime();
    _animationFromValue = _filterProgress;
    _animationToValue = 1.0f;
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateStep)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:self.runLoopCommonMode];
}

- (void)animateStep {
    __block CRPixellatedView *blockSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        CRPixellatedView *strongSelf = blockSelf;
        CGFloat t = (strongSelf.displayLink.timestamp - strongSelf.animationStartTime) / strongSelf.pixelateAnimationDuration;
        strongSelf.filterProgress = strongSelf.animationFromValue + t * (strongSelf.animationToValue - strongSelf.animationFromValue);
        [strongSelf issuePixelate];
        if (t > 1.0) {
            [strongSelf.displayLink removeFromRunLoop:NSRunLoop.mainRunLoop forMode:strongSelf.runLoopCommonMode];
            strongSelf.displayLink = nil;
            if (strongSelf.completion) {
                strongSelf.completion(YES);
            }
        }
    });
}

-(void) issuePixelate {
    UIImage *pixelatedImage = [self pixelate];
    self.image = pixelatedImage;
}

#pragma mark - Layout
- (void)layoutSubviews {
    [super layoutSubviews];
    self.resizedImage = [self resizeImage:self.inputImage
                        contentMode:self.imageContentMode
                             bounds:self.bounds.size
               interpolationQuality:kCGInterpolationHigh];
    [self issuePixelate];
}

#pragma mark - Drawing

- (UIImage *)pixelate {
    CIImage *image = [CIImage imageWithCGImage:self.resizedImage.CGImage];
    
    // Affine
    CIFilter *affineClampFilter = [CIFilter filterWithName:@"CIAffineClamp"];
    [affineClampFilter setValue:image forKey:kCIInputImageKey];
    CGAffineTransform xform = CGAffineTransformMakeScale(1.0, 1.0);
    [affineClampFilter setValue:[NSValue valueWithBytes:&xform objCType:@encode(CGAffineTransform)] forKey:@"inputTransform"];
    
    // Pixellate
    CIFilter *pixellateFilter = [CIFilter filterWithName:@"CIPixellate"];
    [pixellateFilter setDefaults];
    [pixellateFilter setValue:affineClampFilter.outputImage forKey:kCIInputImageKey];
    
    CGFloat value;
    if (!self.isReverse) {
        value = _startInputScale + ((_endInputScale - _startInputScale) * _filterProgress);
    } else {
        value = _endInputScale + ((_startInputScale - _endInputScale) * _filterProgress);
    }
    
    [pixellateFilter setValue:@(value) forKey:@"inputScale"];
    CIVector *center = [CIVector vectorWithCGPoint:CGPointMake(image.extent.size.width / 2.0, image.extent.size.height / 2.0)];
    [pixellateFilter setValue:center forKey:@"inputCenter"];
    
    // Crop
    CIFilter *cropFilter = [CIFilter filterWithName: @"CICrop"];
    [cropFilter setDefaults];
    [cropFilter setValue:pixellateFilter.outputImage forKey:kCIInputImageKey];
    [cropFilter setValue:[CIVector vectorWithX:0 Y:0 Z:self.resizedImage.size.width W:self.resizedImage.size.height] forKey:@"inputRectangle"];
    
    image = [cropFilter valueForKey:kCIOutputImageKey];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imgRef = [context createCGImage:image fromRect:image.extent];
    
    UIImage *pixelatedImage = [UIImage imageWithCGImage:imgRef];
    CGImageRelease(imgRef);
    
    return pixelatedImage;
}

@end
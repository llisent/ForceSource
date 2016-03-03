//
//  FSIndicator.m
//  ForceSource
//
//  Created by 翁志方 on 16/3/1.
//  Copyright © 2016年 wzf. All rights reserved.
//

#import "FSIndicator.h"

@interface FSIndicator()
{
    CAShapeLayer *lineLayer;
    CAShapeLayer *mainBubbleLayer;
    CAShapeLayer *backgroundLayer;
    CAShapeLayer *backgroundBubbleLayer;
    NSMutableArray *smallBubbleLayers;
    
    UITapGestureRecognizer *tap;
}

@end

@implementation FSIndicator

@synthesize smallBubbleSize;
@synthesize mainBubbleSize;
@synthesize bubbleXOffsetSpace;
@synthesize bubbleYOffsetSpace;
@synthesize margin;
@synthesize animationDuration;
@synthesize smallBubbleMoveRadius;

@synthesize backgroundColor;
@synthesize bigBubbleColor;
@synthesize smallBubbleColor;

- (id)init{
    return [self initWithNumbers:6];
}

- (id)initWithNumbers:(NSInteger) numbers
{
    self = [super init];
    
    if (self) {
        smallBubbleSize = 16;
        mainBubbleSize = 20;
        bubbleXOffsetSpace = 12;
        bubbleYOffsetSpace = 10;
        margin = 3;
        
        animationDuration = 0.2;
        smallBubbleMoveRadius = smallBubbleSize + bubbleXOffsetSpace;
        
        backgroundColor = [UIColor colorWithRed:0.357 green:0.196 blue:0.337 alpha:1];
        bigBubbleColor = [UIColor colorWithRed:0.961  green:0.561  blue:0.518 alpha:1];
        smallBubbleColor = [UIColor colorWithRed:0.788 green:0.216 blue:0.337 alpha:1];

        self.numberOfPages = numbers;
        self.currentPage = 0;
        
        // 根据配置初始化页面
        [self configuration];
    }
    return self;
}
- (void)configuration
{
    CGFloat width = smallBubbleSize + bubbleXOffsetSpace;
    CGFloat height = margin*2 + smallBubbleSize + bubbleYOffsetSpace;
    CGRect frame;
    frame.size.width = margin*2 + (smallBubbleSize + bubbleXOffsetSpace) * self.numberOfPages;
    frame.size.height = height;
    self.frame = frame;
    
    frame.origin.x = margin;
    frame.origin.y = margin;
    frame.size.width -= margin*2;
    frame.size.height -= margin*2;
    
    backgroundLayer = [CAShapeLayer layer];
    backgroundLayer.fillColor = backgroundColor.CGColor;
    backgroundLayer.path = [UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:frame.size.height/2].CGPath;
    [self.layer addSublayer:backgroundLayer];
    
    backgroundBubbleLayer = [CAShapeLayer layer];
    backgroundBubbleLayer.fillColor = backgroundColor.CGColor;
    backgroundBubbleLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, height, height)].CGPath;
    [self.layer addSublayer:backgroundBubbleLayer];
    
    mainBubbleLayer = [CAShapeLayer layer];
    mainBubbleLayer.fillColor = bigBubbleColor.CGColor;
    mainBubbleLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(margin+width/2-mainBubbleSize/2, height/2-mainBubbleSize/2, mainBubbleSize, mainBubbleSize)].CGPath;
    [self.layer addSublayer:mainBubbleLayer];
    
    smallBubbleLayers = [NSMutableArray array];
    CGRect smallFrame;
    smallFrame.origin.x = margin + width/2 - smallBubbleSize/2;
    smallFrame.origin.y = height/2-smallBubbleSize/2;
    smallFrame.size.width = smallBubbleSize;
    smallFrame.size.height = smallBubbleSize;
    
    for (int i=0; i<self.numberOfPages; ++i) {
        if (i != self.currentPage){
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.fillColor = smallBubbleColor.CGColor;
            layer.path = [UIBezierPath bezierPathWithOvalInRect:smallFrame].CGPath;
            [self.layer addSublayer:layer];
            [smallBubbleLayers addObject:layer];
        }
        smallFrame.origin.x += width;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint pos = [touch locationInView:self];
    NSInteger index = (pos.x-margin)/(smallBubbleSize + bubbleXOffsetSpace);
    
    if (self.currentPage != index) {
        [self setCurrentPage:index];
    }
    
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    if (currentPage > smallBubbleLayers.count || _currentPage == currentPage) {
        return;
    }
    
    CGFloat width = smallBubbleSize + bubbleXOffsetSpace;
    CGFloat height = margin*2 + smallBubbleSize + bubbleYOffsetSpace;
    
    // 背景球的平移和缩放
    {
        CGFloat desPosX = margin + currentPage*width;
        
        // 计算位置，开始动画
        [CATransaction begin];
        backgroundBubbleLayer.position = CGPointMake(desPosX, 0);
        [CATransaction commit];
    }
    
    // 大球平移缩放
    {
        CGFloat desPosX = margin + currentPage*width;
        
        // 计算位置，开始动画
        [CATransaction begin];
        mainBubbleLayer.position = CGPointMake(desPosX, 0);
        [CATransaction commit];
    }
    
    // 小球的旋转轨迹动画与到终点时的震动
    {
        BOOL isLeft;
        NSInteger st,ed;
        if (currentPage>_currentPage) {
            isLeft = true;
            st = _currentPage;
            ed = currentPage;
        }else{
            isLeft = false;
            st = currentPage;
            ed = _currentPage;
        }
        
        for (NSInteger i=st; i<ed; ++i) {
            
            CGFloat desPosX = isLeft?-width:0;
            // 计算位置，开始动画
            
            [CATransaction begin];
            
            CAShapeLayer *layer = smallBubbleLayers[i];
            layer.position = CGPointMake(desPosX, 0);
            [CATransaction commit];
        }
        
    }
    
    _currentPage = currentPage;
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    for (int i=0; i<smallBubbleLayers.count; ++i) {
        CAShapeLayer *layer = smallBubbleLayers[i];
        CGPoint pos = CGPointZero;
        if (i<_currentPage) {
            CGFloat width = smallBubbleSize + bubbleXOffsetSpace;
            pos.x = -width;
        }
        layer.position = pos;
    }
}


@end

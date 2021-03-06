//
//  LevelView.m
//  PlatformPanda
//
//  Created by Keegan Mann on 4/29/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import "LevelView.h"
#import "Element.h"
#import "Graphics.h"
#import "BoxGraphics.h"
#import "ImageGraphics.h"
#import "ImageSetGraphics.h"

@implementation LevelView

@synthesize viewController;
@synthesize screenStiffness;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    switch (viewController.state) {
        case STATE_WON:
            [[UIImage imageNamed:@"won-land.png"] drawInRect:self.bounds];
            break;
        case STATE_DEAD:
            [[UIImage imageNamed:@"dead-land.png"] drawInRect:self.bounds];
            break;
        case STATE_MAIN_MENU:
            [[UIImage imageNamed:@"start-land.png"] drawInRect:self.bounds];
            break;
        default:
            [self drawLevel];
            break;
    }
}

-(void) drawLevel{
    //[backdrop drawInRect:self.bounds];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (Element *elem in viewController.elementList){
        CGRect drawRect = CGRectOffset(elem.bounds, 
                                       -screenPosition.x+self.bounds.size.width/2.0, 
                                       -screenPosition.y+self.bounds.size.height/2.0);
        if ([elem.graphics isKindOfClass:[BoxGraphics class]]) {
            BoxGraphics *g = (BoxGraphics *)(elem.graphics);
            [g.color setFill];
            [[UIColor blackColor] setStroke];
            CGContextAddRect(context, drawRect);
            CGContextFillPath(context);
            CGContextAddRect(context, drawRect);
            CGContextStrokePath(context);
        }
        else if ([elem.graphics isKindOfClass:[ImageGraphics class]]) {
            ImageGraphics *g = (ImageGraphics *)(elem.graphics);
            [g.image drawInRect:drawRect];
        }
        else if ([elem.graphics isKindOfClass:[ImageSetGraphics class]]) {
            ImageSetGraphics *g = (ImageSetGraphics *)(elem.graphics);
            [g.currentImage drawInRect:drawRect];
        }
    }
    
    
    [[UIColor blackColor] setStroke];
    if ([self.viewController getHealth] > 66){
        [[UIColor greenColor] setFill];
    }
    else if ([self.viewController getHealth] > 33){
        [[UIColor orangeColor] setFill];
    }
    else {
        [[UIColor redColor] setFill];
    }
    CGContextAddRect(context, CGRectMake(self.bounds.size.width-120, 20, [self.viewController getHealth], 20));
    CGContextFillPath(context);
    CGContextAddRect(context, CGRectMake(self.bounds.size.width-120, 20, 100, 20));
    CGContextSetLineWidth(context, 2.0f);
    CGContextStrokePath(context);
    //draw guides
    
    
    [[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2] setStroke];
    CGContextMoveToPoint(context, 100, 0);
    CGContextAddLineToPoint(context, 100, 10);
    CGContextMoveToPoint(context, self.bounds.size.width-100, 0);
    CGContextAddLineToPoint(context, self.bounds.size.width-100, 10);
    
    CGContextMoveToPoint(context, 100, self.bounds.size.height-10);
    CGContextAddLineToPoint(context, 100, self.bounds.size.height);
    CGContextMoveToPoint(context, self.bounds.size.width-100, self.bounds.size.height-10);
    CGContextAddLineToPoint(context, self.bounds.size.width-100, self.bounds.size.height);
    
    CGContextStrokePath(context);
}

- (void) slideScreen:(CGPoint)target forTime:(float)tmInt{
    screenPosition = CGPointMake(screenPosition.x + tmInt*screenStiffness*(target.x-screenPosition.x), 
                                 screenPosition.y + tmInt*screenStiffness*(target.y-screenPosition.y));
}

-(BOOL) isMultipleTouchEnabled{
    return YES;
}

-(void) loadResources{
    frontdrop = [UIImage imageNamed:@"frontdrop.png"];
    backdrop  = [UIImage imageNamed:@"backdrop2.png" ];
}

@end

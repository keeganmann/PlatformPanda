//
//  Protag.m
//  PlatformPanda
//
//  Created by Keegan Mann on 4/29/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import "Protag.h"
#import "BoxGraphics.h"
#import "ImageGraphics.h"
#import "ImageSetGraphics.h"


@interface Protag (){
    int walkCycleLength;
    float stepLength;
    float stepLengthElapsed;
    BOOL wasJumping;
}
@end

@implementation Protag

@synthesize right;
@synthesize left;
@synthesize up;
@synthesize down;

@synthesize jumpSpeed;
@synthesize runSpeed;

-(void) simulateWithTimeInterval:(float)tmInt{
    [super simulateWithTimeInterval:tmInt];
    
    if(grounded){
        if(wasJumping){
            wasJumping = NO;
            ((ImageSetGraphics*)self.graphics).currentIndex = 0;
        }
        stepLengthElapsed += self.vx*tmInt;
        if(stepLengthElapsed >= stepLength){
            ((ImageSetGraphics*)self.graphics).currentIndex = (((ImageSetGraphics*)self.graphics).currentIndex + 1)%walkCycleLength;
            stepLengthElapsed = 0;
        }
        else if(-stepLengthElapsed >= stepLength){
            ((ImageSetGraphics*)self.graphics).currentIndex = (((ImageSetGraphics*)self.graphics).currentIndex - 1)%walkCycleLength;
            stepLengthElapsed = 0;
        }
        if (((ImageSetGraphics*)self.graphics).currentIndex < 0){
            ((ImageSetGraphics*)self.graphics).currentIndex = walkCycleLength - 1;
        }
    }
    else {
        ((ImageSetGraphics*)self.graphics).currentIndex = walkCycleLength;
        wasJumping = YES;
    }
    
    if ([self.graphics isKindOfClass:[BoxGraphics class]]) {
        if(grounded){
            if (up){
                ((BoxGraphics*)self.graphics).color = [UIColor blueColor];
            }
            else{
                ((BoxGraphics*)self.graphics).color = [UIColor yellowColor];
            }
        }
        else {
            ((BoxGraphics*)self.graphics).color = [UIColor greenColor];
        }
    } 
    
    if(up && grounded){
        [self jump];
    }
    if(left){
        self.vx = -self.runSpeed;
    }
    else if(right){
        self.vx = self.runSpeed;
    }
    else{
        self.vx = 0;
    }
    grounded = 0;
}

-(void) jump{
    self.vy = self.vy - self.jumpSpeed;
    self.bounds = CGRectOffset(self.bounds, 0, -1);
    grounded = false;
}

-(void) pushedBy:(Element*)elem inDirection:(int)direc{
    if ( direc == DIR_UP ){
        grounded = 1;
        self.vy = 0.1;
    }
    else if ( direc == DIR_DOWN ) {
        if(self.vy < 0){ 
            self.vy = -self.vy;
        }
    }
}

-(id) initWithX:(float)x andY:(float)y{
    self = [super initWithBounds:CGRectMake(x, y, 50, 75)];
    if (self) {
        self.jumpSpeed = 370;
        self.runSpeed = 200;
        walkCycleLength = 8;
        stepLength = 7;
    }
    return self;
}

-(void) setupGraphics{
    //self.graphics = [[ImageGraphics alloc] initWithImageName:@"p1.png"];
    self.graphics = [[ImageSetGraphics alloc] initWithImageNames:
                     @"p1.png", 
                     @"p2.png", 
                     @"p3.png", 
                     @"p4.png", 
                     @"p5.png", 
                     @"p6.png", 
                     @"p7.png", 
                     @"p8.png", 
                     @"pj.png", nil];
    ((ImageSetGraphics *)self.graphics).currentIndex = 0;
}

@end

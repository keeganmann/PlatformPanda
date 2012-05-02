//
//  ImageSetGraphics.m
//  PlatformPanda
//
//  Created by Keegan Mann on 5/1/12.
//  Copyright (c) 2012 UC Berkeley. All rights reserved.
//

#import "ImageSetGraphics.h"

@implementation ImageSetGraphics

@synthesize images;
@synthesize currentIndex;

-(id) initWithImageNames: (NSString *)firstImage, ...{
    self = [super init];
    if(self){
        images = [[NSMutableArray alloc] init];
        va_list args;
        va_start(args, firstImage);
        
        NSString *imagename = firstImage;
        do {
            [images addObject:[UIImage imageNamed:imagename]];
        } while ( (imagename = va_arg(args, NSString *)) != nil ) ;
        
        va_end(args);
    }
    return self;
}

-(UIImage *)currentImage{
    return (UIImage *)[images objectAtIndex:currentIndex];
}

@end

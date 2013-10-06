//
//  UIView+RemovingMotionEffects.m
//  RESideMenuExample
//
//  Created by Sam Oakley on 06/10/2013.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "UIView+RemovingMotionEffects.h"

@implementation UIView (RemovingMotionEffects)
-(void)removeAllMotionEffects
{
    NSArray *motionEffects = [self.motionEffects copy];
    [motionEffects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self removeMotionEffect:obj];
    }];
}
@end

//
//  UIImageView+Rounded.m
//  GitApiTest
//
//  Created by Pavel Bochilo on 27.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import "UIImageView+Rounded.h"

@implementation UIImageView (Rounded)

-(void)makeRounded {
    self.layer.cornerRadius = self.frame.size.height/2;
    self.clipsToBounds = YES;
}

-(void)setCurrentState:(int)state {
    switch (state) {
        case 0:
            self.backgroundColor = [UIColor blueColor];
            break;
        case 1:
            self.backgroundColor = [UIColor orangeColor];
            break;
        default:
            self.backgroundColor = [UIColor grayColor];
            break;
    }
}

@end

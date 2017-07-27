//
//  GATTableRepoCell.m
//  GitApiTest
//
//  Created by Pavel Bochilo on 27.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import "GATTableRepoCell.h"
#import "UIImageView+Rounded.h"

@implementation GATTableRepoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.imageViewLanguage makeRounded];
    self.contentViewBorder.layer.borderWidth = 1;
    self.contentViewBorder.layer.cornerRadius = 5;
    self.contentViewBorder.layer.borderColor = [UIColor grayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)populateWithDict:(NSDictionary *)dict {
    if (dict) {
        if (dict[@"full_name"]) {
            NSArray* pts = [[dict valueForKeyPath:@"full_name"] componentsSeparatedByString: @"/"];
            if (pts[1]) {
                self.projectName.text = pts[1];
            }
        }
    }
    if (dict[@"description"] && dict[@"description"] != [NSNull null]) {
        self.projectDescription.text = dict[@"description"];
    } else {
        self.projectDescription.text = @"";
    }
    
    if (dict[@"language"] != [NSNull null]) {
        [self setColorForImageView:dict[@"language"]];
    }
    
    
}


- (void)setColorForImageView:(NSString *)str {
    if (![str isEqualToString:@""] ) {
        if ([str isEqualToString:@"Objective-C"]) {
            [self.imageViewLanguage setCurrentState:0];
        }
        if ([str isEqualToString:@"Swift"]) {
            [self.imageViewLanguage setCurrentState:1];
        }
        self.languageLabel.text = str;
    } else {
        [self.imageViewLanguage setCurrentState:3];
    }
    
}

@end

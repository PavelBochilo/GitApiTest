//
//  GATTableRepoCell.h
//  GitApiTest
//
//  Created by Pavel Bochilo on 27.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GATTableRepoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *projectName;
@property (weak, nonatomic) IBOutlet UILabel *projectDescription;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewLanguage;
@property (weak, nonatomic) IBOutlet UIView *contentViewBorder;


- (void)populateWithDict:(NSDictionary *)dict;

@end

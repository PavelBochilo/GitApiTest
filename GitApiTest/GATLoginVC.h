//
//  GATLoginVC.h
//  GitApiTest
//
//  Created by Pavel Bochilo on 26.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GATLoginVC : UIViewController <UIWebViewDelegate, NSURLSessionDataDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginIndicator;
- (void)pushTableRepos;

@end

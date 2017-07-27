//
//  GATTableReposVC.h
//  GitApiTest
//
//  Created by Pavel Bochilo on 26.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GATTableReposVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

-(void)performUpdatesRepoWithArray:(NSArray *)repoAr withUser:(NSDictionary *)userDict;

@end

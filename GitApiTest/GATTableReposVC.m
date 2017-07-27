//
//  GATTableReposVC.m
//  GitApiTest
//
//  Created by Pavel Bochilo on 26.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import "GATTableReposVC.h"
#import "PrefHeader.pch"
#import "GATTableRepoCell.h"

static NSString *cellNibName = @"GATTableRepoCell";
static NSString *cellId = @"tableRepoCell";

@interface GATTableReposVC ()

@property (strong, nonatomic) NSArray *userRepo;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation GATTableReposVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userRepo = [NSArray new];
    [self.indicator startAnimating];
    [self regiterNibForCell];
    [[GATWebServiceManager sharedInstance] getUserInforequestwithVC:self];
}

- (void)regiterNibForCell {
    [self.tableView registerNib:[UINib nibWithNibName: cellNibName bundle:nil]
         forCellReuseIdentifier: cellId];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

-(void)performUpdatesRepoWithArray:(NSArray *)repoAr withUser:(NSDictionary *)userDict {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.userRepo = repoAr;
        [self setNavTitleWithDict:userDict];
        [self stopAnimatingAndLoadTable];
    });
}

- (void)stopAnimatingAndLoadTable {
    [self.tableView reloadData];
    if (self.tableView.hidden) {
        self.tableView.hidden = false;
    }
    [self.indicator stopAnimating];    
}

- (void)setNavTitleWithDict:(NSDictionary *)dict {
    NSString *name = [dict valueForKeyPath:@"name"];
    if ([name isEqualToString:@""] || [dict valueForKeyPath:@"name"] != [NSNull null]) {
        if (dict[@"login"] && dict[@"login"] != [NSNull null]) {
            [self.navigationItem setTitle:dict[@"login"]];
        } else {
            [self.navigationItem setTitle:@"n/a"];
        }
    } else {
        [self.navigationItem setTitle:name];
    }
}

#pragma mark - TableView Cell Delegates and DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userRepo.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 107;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GATTableRepoCell *cell = (GATTableRepoCell *)[tableView dequeueReusableCellWithIdentifier: cellId];
    NSMutableDictionary *indexDict = self.userRepo[indexPath.row];
    if (indexDict) {
        [cell populateWithDict:indexDict];
    }
    return cell;
}


@end

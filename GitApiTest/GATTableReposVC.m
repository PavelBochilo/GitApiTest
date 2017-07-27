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

@interface GATTableReposVC ()

@property (strong, nonatomic) NSArray *userRepo;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation GATTableReposVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.userRepo) {
        self.userRepo = [NSArray new];
    }
    [self.indicator startAnimating];
    [[GATWebServiceManager sharedInstance] getUserInforequestwithVC:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

-(void)performUpdatesRepoWithArray:(NSArray *)repoAr withUser:(NSDictionary *)userDict {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.userRepo = repoAr;
        [self setNavTitleWithDict:userDict];
        NSLog(@"%@", self.userRepo);
        [self.tableView reloadData];
        if (self.tableView.hidden) {
            self.tableView.hidden = false;
        }
        [self.indicator stopAnimating];
    });
}

- (void)setNavTitleWithDict:(NSDictionary *)dict {
    NSString *name = [dict valueForKeyPath:@"name"];
    if ([name isEqualToString:@""]) {
       [self.navigationItem setTitle:@"n/a"];
    } else {
        [self.navigationItem setTitle:name];
    }
}

#pragma mark - TableView Cell Delegates and DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userRepo.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 107;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    NSString *currentId = [[NSString alloc] initWithFormat: @"%ld", indexPath.section];
    [self.tableView registerNib:[UINib nibWithNibName: cellNibName bundle:nil]
         forCellReuseIdentifier: currentId];
    GATTableRepoCell *cell = (GATTableRepoCell *)[tableView dequeueReusableCellWithIdentifier: currentId];
    NSMutableDictionary *indexDict = self.userRepo[indexPath.row];
    if (indexDict) {
        [cell populateWithDict:indexDict];
    }
    return cell;
}


@end

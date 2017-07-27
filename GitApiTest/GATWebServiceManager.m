//
//  GATWebServiceManager.m
//  GitApiTest
//
//  Created by Pavel Bochilo on 26.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//


#define GITHUB_AUTHURL                     @"http://github.com/login/oauth/authorize/"
#define GITHUB_CLIENT_ID                   @"ea8072c4ff24d8161b6d"
#define GITHUB_REDIRECT_URI                @"https://www.epam.com/"
#define GITHUB_OAUTH_URL                   @"https://github.com/login/oauth/access_token"
#define GITHUB_CLIENTSERCRET               @"059cd7d2544d94a8667d9a6d08dead30f3043ca2"
#define GITHUB_SCOPE

#import "GATWebServiceManager.h"
#import "GATLoginVC.h"
#import "UrlCredentials.h"
#import "GATTableReposVC.h"

@interface GATWebServiceManager ()

@property (strong, nonatomic) UrlCredentials *credential;
@property (strong, nonatomic) GATLoginVC *loginVC;

@end

@implementation GATWebServiceManager


#pragma mark - Singleton
+ (GATWebServiceManager *)sharedInstance {
    static GATWebServiceManager *serviceManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serviceManager = [[GATWebServiceManager alloc] init];
    });
    return serviceManager;
}


-(void)sendPOSTRequestWithCode:(NSString *)code fromVC:(UIViewController *)loginVc {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        __weak typeof(self) weakSelf = self;
        self.loginVC = (GATLoginVC*) loginVc;
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate: nil delegateQueue:nil];
        NSString *post = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&code=%@",
                          GITHUB_CLIENT_ID, GITHUB_CLIENTSERCRET,code];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                            [NSURL URLWithString:GITHUB_OAUTH_URL]
                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                               timeoutInterval:60.0];
        [requestData setHTTPMethod:@"POST"];
        [requestData setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [requestData setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [requestData setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [requestData setHTTPBody:postData];
        NSURLSessionDataTask *postDataTask =
        [session dataTaskWithRequest:requestData completionHandler:^(NSData *data,
                                                                     NSURLResponse *response,
                                                                     NSError *error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            int statusRes = (int)[httpResponse statusCode];
            if (!error && statusRes == 200) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:NSJSONReadingAllowFragments error:nil];
                
                //SaveData
                self.credential = [[UrlCredentials alloc] init];
                [_credential addNewData:[dict valueForKey:@"scope"] andWithTokenPass:[dict valueForKey:@"access_token"]];
                [weakSelf.loginVC pushTableRepos];
            } else {
                NSLog(@"%@", error);
            }
        }];
        [postDataTask resume];
    });
}

#pragma mark - Get User Info
-(void)getUserInforequestwithVC:(UIViewController *)viewController {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if (!self.credential) {
            self.credential = [[UrlCredentials alloc] init];
        }
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate: self delegateQueue:nil];
        NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                            [NSURL URLWithString:
                                             [NSString stringWithFormat:
                                              @"https://api.github.com/user/repos?access_token=%@",
                                              [self.credential returnUserDict][@"access_token"]]]];
        [requestData setHTTPMethod:@"GET"];
        NSURLSessionDataTask *postDataTask =
        [session dataTaskWithRequest:
         requestData completionHandler: ^(NSData *data,NSURLResponse *response,NSError *error) {
             
             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
             int statusRes = (int)[httpResponse statusCode];
             if (!error && statusRes == 200) {
                 NSArray *userRepoArray = [NSJSONSerialization JSONObjectWithData: data
                                                                          options:NSJSONReadingAllowFragments
                                                                            error:nil];
                 
                 [self getAdditionalUserInfo:viewController withArr:userRepoArray];
             }
             else {
                 NSLog(@"%@", error);
             }
         }];
        [postDataTask resume];
    });
}

-(void)getAdditionalUserInfo:(UIViewController *)viewController withArr:(NSArray *)arr {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if (!self.credential) {
            self.credential = [[UrlCredentials alloc] init];
        }
        GATTableReposVC * vc = (GATTableReposVC *)viewController;
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate: self delegateQueue:nil];
        NSMutableURLRequest *requestData = [NSMutableURLRequest requestWithURL:
                                            [NSURL URLWithString:
                                             [NSString stringWithFormat:
                                              @"https://api.github.com/user?access_token=%@",
                                              [self.credential returnUserDict][@"access_token"]]]];
        [requestData setHTTPMethod:@"GET"];
        NSURLSessionDataTask *postDataTask =
        [session dataTaskWithRequest:
         requestData completionHandler: ^(NSData *data,NSURLResponse *response,NSError *error) {
             
             NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
             int statusRes = (int)[httpResponse statusCode];
             if (!error && statusRes == 200) {
                 NSDictionary *userDict = [NSJSONSerialization JSONObjectWithData: data
                                                                          options:NSJSONReadingAllowFragments
                                                                            error:nil];
                 [vc performUpdatesRepoWithArray:arr withUser:userDict];
             }
             else {
                 NSLog(@"%@", error);
             }
         }];
        [postDataTask resume];
    });
}



@end


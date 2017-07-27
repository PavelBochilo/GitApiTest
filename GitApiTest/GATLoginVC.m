//
//  GATLoginVC.m
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
#define GITHUB_SCOPE                       @"user+repo"

#import "GATLoginVC.h"
#import "PrefHeader.pch"


@interface GATLoginVC ()

@property (weak, nonatomic) IBOutlet UIWebView *loginWebView;

@end

@implementation GATLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    NSString* authURL;
 
    authURL = [NSString stringWithFormat: @"%@?client_id=%@&scope=%@", GITHUB_AUTHURL, GITHUB_CLIENT_ID, GITHUB_SCOPE];
    [self.loginWebView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: authURL]]];
    [self.loginWebView setDelegate:self];
}

#pragma mark webView delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    return [self checkRequestForCallbackURL: request];
}

- (void) webViewDidStartLoad:(UIWebView *)webView {
    [self.loginIndicator startAnimating];
    [self.loginWebView.layer removeAllAnimations];
    self.loginWebView.userInteractionEnabled = NO;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView {

    [self.loginWebView.layer removeAllAnimations];
    self.loginWebView.userInteractionEnabled = YES;
    [self.loginIndicator stopAnimating];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self webViewDidFinishLoad: webView];
}


#pragma mark auth logic

- (BOOL) checkRequestForCallbackURL: (NSURLRequest*) request
{
    NSString* urlString = [[request URL] absoluteString];
    if([urlString hasPrefix: GITHUB_REDIRECT_URI])
    {
        // extract and handle access token
        NSRange range = [urlString rangeOfString: @"code="];
        [[GATWebServiceManager sharedInstance]
         sendPOSTRequestWithCode:[urlString substringFromIndex: range.location+range.length] fromVC:self];
        return NO;
        
    }
    return YES;
}

#pragma mark go to Repos

- (void)pushTableRepos {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self performSegueWithIdentifier:@"showTable" sender:nil];
    });
}

@end

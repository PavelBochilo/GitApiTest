//
//  GATWebServiceManager.h
//  GitApiTest
//
//  Created by Pavel Bochilo on 26.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GATWebServiceManager : NSObject <NSURLSessionDataDelegate, NSURLSessionDelegate>

+ (GATWebServiceManager *)sharedInstance;

-(void)sendPOSTRequestWithCode:(NSString *)code fromVC:(UIViewController *)loginVc;
-(void)getUserInforequestwithVC:(UIViewController *)viewController;

@end

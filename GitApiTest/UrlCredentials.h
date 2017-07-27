//
//  UrlCredentials.h
//  GitApiTest
//
//  Created by Pavel Bochilo on 26.07.17.
//  Copyright © 2017 Pavel Bochilo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlCredentials : NSObject

@property (nonatomic, strong) NSURLCredential *keychainData;
@property (nonatomic, strong) NSURLProtectionSpace *protSpace;

-(void)addNewData:(NSString *)idUser andWithTokenPass:(NSString *)tok;
-(NSDictionary *)returnUserDict;
-(void)resetCredentials;

@end

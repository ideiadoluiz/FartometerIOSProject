//
//  FacebookHelper.m
//  fartometer
//
//  Created by Luiz Fernando Peres on 2015-11-03.
//  Copyright © 2015 Ideia do Luiz. All rights reserved.
//

#import "FacebookHelper.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface FacebookHelper ()

@property (nonatomic) FBSDKLoginManager *fbLogin;

@end

@implementation FacebookHelper

+ (instancetype) sharedInstance
{
    static FacebookHelper *sharedStore;
    
    if (!sharedStore)
        sharedStore = [[self alloc] initPrivate];
    
    return sharedStore;
}

- (instancetype) init
{
    [NSException raise:@"Singleton" format:@"Use +[FacebookHelper sharedStore]"];
    return nil;
}

- (instancetype) initPrivate
{
    self = [super init];
    if (self)
    {
        _fbLogin = [[FBSDKLoginManager alloc] init];
    }
    return self;
}

// Once the button is clicked, show the login dialog
- (void) loginButtonClicked
{
    // when fromViewController is nil, it chooses the topmost UIViewController
    // see https://developers.facebook.com/docs/reference/ios/current/class/FBSDKLoginManager/
    if (!self.isLoggedIn)
    {
        [self.fbLogin
         logInWithReadPermissions: @[@"public_profile", /*@"email",*/ @"user_friends"]
         fromViewController:nil
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                 NSLog(@"Process error");
             } else if (result.isCancelled) {
                 NSLog(@"Cancelled");
             } else {
                 NSLog(@"Logged in");
                 [self statusChanged];
             }
         }];
    }
    else
    {
        [self.fbLogin logOut];
        NSLog(@"Logged out");
        [self statusChanged];
    }
}

- (void) statusChanged
{
    if ([self.delegate respondsToSelector:@selector(loginStatusDidChange:)])
    {
        [self.delegate loginStatusDidChange:self.isLoggedIn];
    }
}

- (BOOL) isLoggedIn
{
    return  [FBSDKAccessToken currentAccessToken] != nil;
}

@end

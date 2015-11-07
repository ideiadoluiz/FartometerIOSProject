//
//  FacebookHelper.m
//  fartometer
//
//  Created by Luiz Fernando Peres on 2015-11-03.
//  Copyright © 2015 Ideia do Luiz. All rights reserved.
//

#import "FacebookHelper.h"
#import "SessionHelper.h"

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
    [NSException raise:@"Singleton" format:@"Use +[FacebookHelper sharedInstance]"];
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
             if ([[SessionHelper sharedInstance] isDebugging])
             {
                 if (error) {
                     NSLog(@"Process error");
                 } else if (result.isCancelled) {
                     NSLog(@"Cancelled");
                 } else {
                     NSLog(@"Logged in");
                 }
             }
             
             if (!error && !result.isCancelled)
                 [self getFacebookProfileInfo];
             
             [self statusChanged];
         }];
    }
    else
    {
        [self.fbLogin logOut];
        if([[SessionHelper sharedInstance] isDebugging])
            NSLog(@"Logged out");
        
        [self statusChanged];
    }
}

- (void) getFacebookProfileInfo
{
    FBSDKGraphRequest *requestMe = [[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:nil];
    FBSDKGraphRequestConnection *connection = [[FBSDKGraphRequestConnection alloc] init];
    
    [connection addRequest:requestMe completionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
    {
        if(result)
        {
            if ([result objectForKey:@"name"])
                _nameUserFacebook = [result objectForKey:@"name"];
            
            _picUserFacebook = [[FBSDKProfilePictureView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
            [_picUserFacebook setProfileID:[result objectForKey:@"id"]];
            [_picUserFacebook setPictureMode:FBSDKProfilePictureModeSquare];
        }
        
    }];
    
    [connection start];
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

- (void) setEnableUpdatesOnAccessTokenChange:(BOOL)enableUpdatesOnAccessTokenChange
{
    _enableUpdatesOnAccessTokenChange = enableUpdatesOnAccessTokenChange;
    [FBSDKProfile enableUpdatesOnAccessTokenChange:enableUpdatesOnAccessTokenChange];
}

@end

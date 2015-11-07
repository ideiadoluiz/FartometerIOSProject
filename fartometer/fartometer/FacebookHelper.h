//
//  FacebookHelper.h
//  fartometer
//
//  Created by Luiz Fernando Peres on 2015-11-03.
//  Copyright © 2015 Ideia do Luiz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FBSDKProfilePictureView;

@protocol FacebookHelperDelegate <NSObject>

- (void) loginStatusDidChange:(BOOL)isLoggedIn;

@end

@interface FacebookHelper : NSObject

+ (instancetype) sharedInstance;

@property (weak) id <FacebookHelperDelegate> delegate;
@property (nonatomic, readonly) BOOL isLoggedIn;
@property (nonatomic) BOOL enableUpdatesOnAccessTokenChange;
@property (nonatomic, readonly) NSString *nameUserFacebook;
@property (nonatomic, readonly) FBSDKProfilePictureView *picUserFacebook;

- (void)loginButtonClicked;

@end

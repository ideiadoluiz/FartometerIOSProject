//
//  FacebookHelper.h
//  fartometer
//
//  Created by Luiz Fernando Peres on 2015-11-03.
//  Copyright © 2015 Ideia do Luiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FacebookHelperDelegate <NSObject>

- (void) loginStatusDidChange:(BOOL)isLoggedIn;

@end

@interface FacebookHelper : NSObject

+ (instancetype) sharedInstance;

@property (weak) id <FacebookHelperDelegate> delegate;
@property (nonatomic) BOOL isLoggedIn;

- (void)loginButtonClicked;

@end

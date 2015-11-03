//
//  SessionHelper.h
//  fartometer
//
//  Created by Luiz Fernando Peres on 2015-11-03.
//  Copyright © 2015 Ideia do Luiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionHelper : NSObject

@property (nonatomic) BOOL isDebugging;

+ (instancetype) sharedInstance;
- (NSString *) getLocalizedStringForName:(NSString *)stringName;

@end

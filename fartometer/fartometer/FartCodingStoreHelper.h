//
//  FartCodingStoreHelper.h
//  fartometer
//
//  Created by Marcos Natan on 2015-11-07.
//  Copyright © 2015 Ideia do Luiz. All rights reserved.
//

#import "FartCoding.h"

#import <UIKit/UIKit.h>

@interface FartCodingStoreHelper : NSObject

+ (instancetype) sharedInstance;

- (BOOL) saveChanges;

- (void) createNewFartData:(FartCoding *)fart;
- (NSArray<FartCoding *> *) getFartsForKey:(NSString *)key;

@end

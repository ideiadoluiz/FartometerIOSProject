//
//  BLEHelper.h
//  fartometer
//
//  Created by Luiz Fernando Peres on 2015-11-04.
//  Copyright © 2015 Ideia do Luiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLEHelperDelegate <NSObject>

- (void) deviceDidScanBluetooth:(NSArray *)peripherals;

@end

@interface BLEHelper : NSObject

+ (instancetype) sharedInstance;

@property (weak) id <BLEHelperDelegate> delegate;
- (BOOL) startBLEShieldScan;

@end

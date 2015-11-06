//
//  BLEHelper.h
//  fartometer
//
//  Created by Luiz Fernando Peres on 2015-11-04.
//  Copyright © 2015 Ideia do Luiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol BLEHelperDelegate <NSObject>

@optional
- (void) deviceDidScanBluetooth:(NSArray *)peripherals;
- (void) deviceDidChangeConnectionState:(BOOL)isConnected;
- (void) couldNotConnectToDevice;

@end

@interface BLEHelper : NSObject

+ (instancetype) sharedInstance;

@property (weak) id <BLEHelperDelegate> delegate;
@property (nonatomic, readonly) BOOL isConnected;
- (BOOL) startBLEShieldScan;
- (void) connectToDevice:(CBPeripheral *)device;

@end

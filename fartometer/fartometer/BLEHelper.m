//
//  BLEHelper.m
//  fartometer
//
//  Created by Luiz Fernando Peres on 2015-11-04.
//  Copyright © 2015 Ideia do Luiz. All rights reserved.
//

#import "BLEHelper.h"
#import "BLE.h"

@interface BLEHelper () <BLEDelegate>

@property (nonatomic) BLE *bleShield;
@property (nonatomic) NSMutableArray *mPeripherals;

@end

@implementation BLEHelper

+ (instancetype) sharedInstance
{
    static BLEHelper *sharedStore;
    
    if (!sharedStore)
        sharedStore = [[self alloc] initPrivate];
    
    return sharedStore;
}

- (instancetype) init
{
    [NSException raise:@"Singleton" format:@"Use +[BLEHelper sharedInstance]"];
    return nil;
}

- (instancetype) initPrivate
{
    self = [super init];
    if (self)
    {
        _bleShield = [[BLE alloc] init];
        [_bleShield controlSetup];
        _bleShield.delegate = self;
        _mPeripherals = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL) startBLEShieldScan
{
    if (self.bleShield.activePeripheral)
    {
        if(self.bleShield.activePeripheral.state == CBPeripheralStateConnected)
        {
            [[self.bleShield CM] cancelPeripheralConnection:[self.bleShield activePeripheral]];
        }
    }
    
    if (self.bleShield.peripherals)
    {
        self.bleShield.peripherals = nil;
        [self.mPeripherals removeAllObjects];
    }
    
    int startScanning = [self.bleShield findBLEPeripherals:3];
    
    [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
    
    return startScanning == 0;
}

// Called when scan period is over
-(void) connectionTimer:(NSTimer *)timer
{
    if(self.bleShield.peripherals.count > 0)
    {
        //Scan for all BLE in range and prepare a list
        [self.mPeripherals removeAllObjects];
        
        int i;
        for (i = 0; i < self.bleShield.peripherals.count; i++)
        {
            CBPeripheral *p = [self.bleShield.peripherals objectAtIndex:i];
            
            if (p.identifier != NULL)
            {
                [self.mPeripherals insertObject:p atIndex:i];
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(deviceDidScanBluetooth:)])
    {
        [self.delegate deviceDidScanBluetooth:self.mPeripherals];
    }
}

@end

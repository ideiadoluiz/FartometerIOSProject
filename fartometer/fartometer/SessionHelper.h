//
//  SessionHelper.h
//  fartometer
//
//  Created by Luiz Fernando Peres on 2015-11-03.
//  Copyright © 2015 Ideia do Luiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
@class FartCoding;

@interface SessionHelper : NSObject

#define FART_HEIGHT_CELL 50
#define FART_HEIGHT_CELL_BIG 80
#define FART_MAX_VALUE 160
#define FART_MIN_VALUE 60
#define FART_BTN_FRAME CGRectMake(0, 0, 170, 20)
#define FART_BLUE_COLOR_LINK [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]

@property (nonatomic, readonly) BOOL isDebugging;

+ (instancetype) sharedInstance;

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;
- (NSString *) getLocalizedStringForName:(NSString *)stringName;
- (void) gotoMainViewControllerWithNavigationController:(UINavigationController *)navController shouldRefreshBluetoothDevices:(BOOL)shouldRefresh;
- (UIColor *) getTextColorWithFart:(FartCoding *)fart;
- (NSString *) getStringWithFart:(FartCoding *)fart;
- (NSString *) getAKAStringWithFart:(FartCoding *)fart;

@end

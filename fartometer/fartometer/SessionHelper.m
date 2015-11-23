//
//  SessionHelper.m
//  fartometer
//
//  Created by Luiz Fernando Peres on 2015-11-03.
//  Copyright © 2015 Ideia do Luiz. All rights reserved.
//

#import "SessionHelper.h"
#import "MainViewController.h"
#import "FartCoding.h"

@interface SessionHelper ()

@property (nonatomic) NSDictionary *dicStrings;

@end

@implementation SessionHelper

+ (instancetype) sharedInstance
{
    static SessionHelper *sharedStore;
    
    if (!sharedStore)
        sharedStore = [[self alloc] initPrivate];
    
    return sharedStore;
}

- (instancetype) init
{
    [NSException raise:@"Singleton" format:@"Use +[SessionHelper sharedInstance]"];
    return nil;
}

- (instancetype) initPrivate
{
    self = [super init];
    if (self)
    {
        NSString *fname = [[NSBundle mainBundle] pathForResource:@"" ofType:@"strings"];
        self.dicStrings = [NSDictionary dictionaryWithContentsOfFile:fname];
    }
    return self;
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSString *)getLocalizedStringForName:(NSString *)stringName
{
    return [self.dicStrings objectForKey:stringName];
}

- (void) gotoMainViewControllerWithNavigationController:(UINavigationController *)navController shouldRefreshBluetoothDevices:(BOOL)shouldRefresh
{
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[navController viewControllers]];
    for (UIViewController *aViewController in allViewControllers) {
        if ([aViewController isKindOfClass:[MainViewController class]])
        {
            ((MainViewController *)aViewController).shouldRefreshBluetoothDevices = shouldRefresh;
            [navController popToViewController:aViewController animated:NO];
        }
    }
}

- (UIColor *) getTextColorWithFart:(FartCoding *)fart
{
    CGFloat range = FART_MAX_VALUE - FART_MIN_VALUE;
    
    if (fart.methaneValue <=  (range / 3) + FART_MIN_VALUE)
        return [self darkerColorForColor:[UIColor greenColor]];
    else if (fart.methaneValue <= (range / 3 * 2) + FART_MIN_VALUE)
        return [self darkerColorForColor:[UIColor yellowColor]];
    else
        return [UIColor redColor];
}

- (NSString *)getStringWithFart:(FartCoding *)fart
{
    CGFloat range = FART_MAX_VALUE - FART_MIN_VALUE;
    
    if (fart.methaneValue <= FART_MIN_VALUE)
        return [self getLocalizedStringForName:@"msg_very_weak"];
    else if (fart.methaneValue <= (range / 3) + FART_MIN_VALUE)
        return [self getLocalizedStringForName:@"msg_weak"];
    else if (fart.methaneValue <= (range / 3 * 2) + FART_MIN_VALUE)
        return [self getLocalizedStringForName:@"msg_regular"];
    else if (fart.methaneValue <= range + FART_MIN_VALUE)
        return [self getLocalizedStringForName:@"msg_strong"];
    else
        return [self getLocalizedStringForName:@"msg_very_strong"];
}

- (NSString *)getAKAStringWithFart:(FartCoding *)fart
{
    CGFloat range = FART_MAX_VALUE - FART_MIN_VALUE;
    
    if (fart.methaneValue <= FART_MIN_VALUE)
        return [self getLocalizedStringForName:@"msg_fresh_air"];
    else if (fart.methaneValue <= (range / 3) + FART_MIN_VALUE)
        return [self getLocalizedStringForName:@"msg_little_poo"];
    else if (fart.methaneValue <= (range / 3 * 2) + FART_MIN_VALUE)
        return [self getLocalizedStringForName:@"msg_silent_bomb"];
    else if (fart.methaneValue <= range + FART_MIN_VALUE)
        return [self getLocalizedStringForName:@"msg_liquid_fart"];
    else
        return [self getLocalizedStringForName:@"msg_need_doctor"];
}

- (UIColor *)lighterColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + 0.2, 1.0)
                               green:MIN(g + 0.2, 1.0)
                                blue:MIN(b + 0.2, 1.0)
                               alpha:a];
    return nil;
}

- (UIColor *)darkerColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.2, 0.0)
                               green:MAX(g - 0.2, 0.0)
                                blue:MAX(b - 0.2, 0.0)
                               alpha:a];
    return nil;
}

- (BOOL) isDebugging
{
    return NO;
}

@end

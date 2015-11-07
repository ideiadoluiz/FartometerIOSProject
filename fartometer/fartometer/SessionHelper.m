//
//  SessionHelper.m
//  fartometer
//
//  Created by Luiz Fernando Peres on 2015-11-03.
//  Copyright © 2015 Ideia do Luiz. All rights reserved.
//

#import "SessionHelper.h"
#import "MainViewController.h"

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

- (BOOL) isDebugging
{
    return NO;
}

@end

//
//  MainTabBarController.m
//  fartometer
//
//  Created by Luiz Fernando Peres on 2015-11-05.
//  Copyright © 2015 Ideia do Luiz. All rights reserved.
//

#import "MainTabBarController.h"
#import "SessionHelper.h"
#import "FartometerViewController.h"
#import "FartometerDetailViewController.h"
#import "BLEHelper.h"

@interface MainTabBarController () <BLEHelperDelegate, UITabBarControllerDelegate, FartometerSensorDelegate>

@property (nonatomic) FartometerViewController *ftVC;
@property (nonatomic) FartometerDetailViewController *ftdVC;

@property (nonatomic) UIBarButtonItem *rightButton;

@end

@implementation MainTabBarController

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        _ftVC = [FartometerViewController new];
        _ftVC.tabBarItem = [[UITabBarItem alloc]  initWithTitle:[[SessionHelper sharedInstance] getLocalizedStringForName:@"fart"] image:[UIImage imageNamed:@"fart"] selectedImage:[UIImage imageNamed:@"fart"]];
        _ftdVC = [FartometerDetailViewController new];
        _ftdVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:[[SessionHelper sharedInstance] getLocalizedStringForName:@"history"] image:[UIImage imageNamed:@"list"] selectedImage:[UIImage imageNamed:@"list"]];
        self.viewControllers = [NSArray arrayWithObjects:_ftVC, _ftdVC, nil];
    }
    
    return self;
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:[[SessionHelper sharedInstance] getLocalizedStringForName:@"refresh_devices"]
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(onBackButtonTapped:)];
    
    self.rightButton = [[UIBarButtonItem alloc] initWithTitle:[[SessionHelper sharedInstance] getLocalizedStringForName:@"start"]
                                                   style:UIBarButtonItemStyleDone
                                                  target:self
                                                  action:@selector(onRightButtonTapped:)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = self.rightButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [BLEHelper sharedInstance].delegate = self;
    self.delegate = self;
    self.ftVC.delegate = self;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[FartometerViewController class]])
    {
        self.navigationItem.rightBarButtonItem = self.rightButton;
    }
    else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void) onBackButtonTapped:(id)sender
{
    [[SessionHelper sharedInstance] gotoMainViewControllerWithNavigationController:self.navigationController shouldRefreshBluetoothDevices:YES];
}

- (void) onRightButtonTapped:(id)sender
{
    [[BLEHelper sharedInstance] sendCommand:CMD_START];
    [self.ftVC startUpdatingSensors];
    [self.rightButton setEnabled:NO];
}

- (void)doneUpdatingSensors
{
    [[BLEHelper sharedInstance] sendCommand:CMD_STOP];
    [self.rightButton setEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)deviceDidChangeConnectionState:(BOOL)isConnected
{
    if (!isConnected)
        [[SessionHelper sharedInstance] gotoMainViewControllerWithNavigationController:self.navigationController shouldRefreshBluetoothDevices:YES];
}

- (void)deviceDidReceiveData:(NSString *)data
{
    [self.ftVC newData:data];
}

@end

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

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        UIViewController *ftVC = [FartometerViewController new];
        ftVC.tabBarItem = [[UITabBarItem alloc]  initWithTitle:@"Fart!" image:[UIImage imageNamed:@"fart"] selectedImage:[UIImage imageNamed:@"fart"]];
        UIViewController *ftdVC = [FartometerDetailViewController new];
        ftdVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"History" image:[UIImage imageNamed:@"list"] selectedImage:[UIImage imageNamed:@"list"]];
        self.viewControllers = [NSArray arrayWithObjects:ftVC, ftdVC, nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:[[SessionHelper sharedInstance] getLocalizedStringForName:@"refresh_devices"]
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(onBackButtonTapped:)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
}

- (void) onBackButtonTapped:(id)sender
{
    [[SessionHelper sharedInstance] gotoMainViewControllerWithNavigationController:self.navigationController shouldRefreshBluetoothDevices:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

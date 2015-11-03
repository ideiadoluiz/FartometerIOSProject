//
//  MainViewController.m
//  fartometer
//
//  Created by Luiz Fernando Peres on 2015-10-15.
//  Copyright © 2015 Ideia do Luiz. All rights reserved.
//

#import "MainViewController.h"
#import "FacebookHelper.h"
#import "SessionHelper.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface MainViewController () <FacebookHelperDelegate>

@property (nonatomic) UILabel *lblFacebookLogin;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addFacebookButton];
}

- (void) addFacebookButton
{
    CGRect frame = CGRectMake(0, 0, 170, 20);
    UIButton *fbLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fbLoginBtn.frame = frame;
    [fbLoginBtn setTitle: @"" forState: UIControlStateNormal];
    self.lblFacebookLogin = [[UILabel alloc]initWithFrame:frame];
    self.lblFacebookLogin.text = [[SessionHelper sharedInstance] getLocalizedStringForName:@"login_fb"];
    self.lblFacebookLogin.textAlignment = NSTextAlignmentCenter;
    self.lblFacebookLogin.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    [fbLoginBtn addSubview:self.lblFacebookLogin];
    fbLoginBtn.center = self.view.center;
    
    
    // Handle clicks on the button
    [fbLoginBtn
     addTarget:[FacebookHelper sharedInstance]
     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // Handle LogIn status changed
    [FacebookHelper sharedInstance].delegate = self;
    
    // Add the button to the view
    [self.view addSubview:fbLoginBtn];
}

- (void)loginStatusDidChange:(BOOL)isLoggedIn
{
    self.lblFacebookLogin.text = isLoggedIn ? [[SessionHelper sharedInstance] getLocalizedStringForName:@"logout_fb"]  : [[SessionHelper sharedInstance] getLocalizedStringForName:@"login_fb"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

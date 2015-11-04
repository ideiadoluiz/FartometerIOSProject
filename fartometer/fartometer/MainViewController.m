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
#import "BLEHelper.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface MainViewController () <FacebookHelperDelegate, BLEHelperDelegate>

@property (nonatomic) UILabel *lblFacebookLogin;
@property (nonatomic) UILabel *lblBluetooth;
@property (nonatomic) UIButton *btnFB;
@property (nonatomic) UIButton *btnBluetooth;
@property (nonatomic) UIImageView *imgView;
@property (nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createViews];
    
    // Handle LogIn status changed
    [FacebookHelper sharedInstance].delegate = self;
    
    [BLEHelper sharedInstance].delegate = self;
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (void) createViews
{
    UIImage *img = [UIImage imageNamed:@"fart-img.png"];
    
    // my image is a square, be careful when scaling images, though :)
    img = self.view.frame.size.width <= img.size.width ? [SessionHelper imageWithImage:img scaledToSize:CGSizeMake(self.view.frame.size.width * 0.8, self.view.frame.size.width * 0.8)]: img;
    self.imgView = [[UIImageView alloc] initWithImage:img];
    [self createFacebookButton];
    [self createBluetoothButton];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    UIView *newView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.imgView.image.size.width, self.imgView.image.size.height + self.btnBluetooth.frame.size.height + self.btnFB.frame.size.height + 100)];
    newView.center = self.view.center;
    [newView addSubview:self.imgView];
    [newView addSubview:self.btnFB];
    [newView addSubview:self.btnBluetooth];
    [newView addSubview:self.activityIndicator];
    
    self.btnFB.center = CGPointMake(self.imgView.center.x, self.imgView.image.size.height + 50);
    self.btnBluetooth.center = CGPointMake(self.btnFB.center.x, self.btnFB.center.y + 40);
    self.activityIndicator.center = self.btnBluetooth.center;
    [self.activityIndicator setHidden:YES];
    
    [self.view addSubview:newView];
}

- (void) createFacebookButton
{
    self.btnFB = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnFB.frame = FART_BTN_FRAME;
    [self.btnFB setTitle: @"" forState: UIControlStateNormal];
    self.lblFacebookLogin = [[UILabel alloc]initWithFrame:FART_BTN_FRAME];
    self.lblFacebookLogin.text = [[SessionHelper sharedInstance] getLocalizedStringForName:@"login_fb"];
    self.lblFacebookLogin.textAlignment = NSTextAlignmentCenter;
    self.lblFacebookLogin.textColor = FART_BLUE_COLOR_LINK;
    [self.btnFB addSubview:self.lblFacebookLogin];
    
    // Handle clicks on the button
    [self.btnFB
     addTarget:[FacebookHelper sharedInstance]
     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void) createBluetoothButton
{
    self.btnBluetooth = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnBluetooth.frame = FART_BTN_FRAME;
    [self.btnBluetooth setTitle: @"" forState: UIControlStateNormal];
    self.lblBluetooth = [[UILabel alloc]initWithFrame:FART_BTN_FRAME];
    self.lblBluetooth.text = [[SessionHelper sharedInstance] getLocalizedStringForName:@"bluetooth"];
    self.lblBluetooth.textAlignment = NSTextAlignmentCenter;
    [self handleView:[[FacebookHelper sharedInstance] isLoggedIn]];
    [self.btnBluetooth addSubview:self.lblBluetooth];
    
    // Handle clicks on the button
    [self.btnBluetooth
     addTarget:self
     action:@selector(bluetoothButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)bluetoothButtonClicked
{
    BOOL resScan = [[BLEHelper sharedInstance] startBLEShieldScan];
    [self.btnBluetooth setHidden:resScan];
    [self.activityIndicator setHidden:!resScan];
    if(resScan)
        [self.activityIndicator startAnimating];
}

- (void) deviceDidScanBluetooth:(NSArray *)peripherals
{
    [self.btnBluetooth setHidden:NO];
    [self.activityIndicator stopAnimating];
    [self.activityIndicator setHidden:YES];
    
    NSLog(@"%@", peripherals);
}

- (void) handleView:(BOOL)isLoggedIn
{
    self.lblBluetooth.textColor = isLoggedIn ? FART_BLUE_COLOR_LINK : [UIColor lightGrayColor];
    [self.btnBluetooth setEnabled:isLoggedIn];
    
    self.lblFacebookLogin.text = isLoggedIn ? [[SessionHelper sharedInstance] getLocalizedStringForName:@"logout_fb"]  : [[SessionHelper sharedInstance] getLocalizedStringForName:@"login_fb"];
}

- (void)loginStatusDidChange:(BOOL)isLoggedIn
{
    [self handleView:isLoggedIn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

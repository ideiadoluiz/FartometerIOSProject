//
//  FartometerViewController.m
//  fartometer
//
//  Created by Luiz Fernando Peres on 2015-11-05.
//  Copyright © 2015 Ideia do Luiz. All rights reserved.
//

#import "FartometerViewController.h"
#import "SessionHelper.h"

@interface FartometerViewController ()

@property (nonatomic) UIImageView *imgViewArrow;

@end

@implementation FartometerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self fillImages];
}

- (void) fillImages
{
    CGFloat widthScreen = self.view.frame.size.width;
    UIImage *imgFart = [UIImage imageNamed:@"fartometer-obj.png"];
    
    UIImageView *imgViewFartometer = [[UIImageView alloc] initWithImage:[[SessionHelper sharedInstance] imageWithImage:imgFart scaledToSize:CGSizeMake(widthScreen, widthScreen)]];
    imgViewFartometer.center = self.view.center;
    [self.view addSubview:imgViewFartometer];
    
    CGFloat proportionImgToScreen = widthScreen / imgFart.size.width;
    UIImage *imgArrow = [UIImage imageNamed:@"fartometer-obj-arrow.png"];
    CGFloat widthArrow = imgArrow.size.width * proportionImgToScreen;
    CGFloat heightArrow = imgArrow.size.height * proportionImgToScreen;
    self.imgViewArrow = [[UIImageView alloc] initWithImage:[[SessionHelper sharedInstance] imageWithImage:imgArrow scaledToSize:CGSizeMake(widthArrow, heightArrow)]];
    self.imgViewArrow.center = CGPointMake(imgViewFartometer.center.x, imgViewFartometer.center.y + (heightArrow / 3.5)); // 3.5 is the approximately proportion of the arrow's circle
    [self.view addSubview:self.imgViewArrow];
}

- (void) connectionTimer:(NSTimer *)timer
{
    if ([self.delegate respondsToSelector:@selector(doneUpdatingSensors)])
    {
        [self.delegate doneUpdatingSensors];
    }
    _isUpdating = false;
}

- (void) startUpdatingSensors
{
    _isUpdating = true;
    [NSTimer scheduledTimerWithTimeInterval:(float)10.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
}

- (void) newData:(NSString *)string
{
    self.imgViewArrow.transform = CGAffineTransformMakeRotation(M_PI_2);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

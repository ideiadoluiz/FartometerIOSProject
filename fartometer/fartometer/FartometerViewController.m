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

@property (nonatomic) CGFloat lastAngle;
@property (nonatomic) BOOL isAnimating;

@end

@implementation FartometerViewController

#define MAIN_ANIMATION @"RotateAnimation"

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
    UIImage *imgArrow = [UIImage imageNamed:@"fartometer-obj-arrow2.png"];
    CGFloat widthArrow = imgArrow.size.width * proportionImgToScreen;
    CGFloat heightArrow = imgArrow.size.height * proportionImgToScreen;
    self.imgViewArrow = [[UIImageView alloc] initWithImage:[[SessionHelper sharedInstance] imageWithImage:imgArrow scaledToSize:CGSizeMake(widthArrow, heightArrow)]];
    self.imgViewArrow.center = CGPointMake(imgViewFartometer.center.x, imgViewFartometer.center.y);//imgViewFartometer.center.y + (heightArrow / 3.5)); // 3.5 is the approximately proportion of the arrow's circle
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
    
    if ([string containsString:@"met:"])
    {
        int currentMetValue = [[string substringFromIndex:4] intValue];
        CGFloat rotateAngle = [self getAngleFartometer:currentMetValue];
        self.imgViewArrow.transform = CGAffineTransformRotate(self.imgViewArrow.transform, rotateAngle);
    }
}

- (CGFloat) getAngleFartometer:(int)methaneValue
{
    CGFloat startPositionArrow = M_PI_4;
    CGFloat endPositionArrow = ((3 * M_PI / 2) + M_PI_4);
    // a weak fart is about 60ppm, while an average is 110ppm, so I'm setting 160ppm as a very strong fart
    CGFloat MAX_VALUE = 160;
    CGFloat MIN_VALUE = 60;
    
    CGFloat angle = 0;
    
    if (methaneValue <= MIN_VALUE)
        angle = startPositionArrow;
    else if (methaneValue >= MAX_VALUE)
        angle = endPositionArrow;
    else
        angle = methaneValue / MAX_VALUE * endPositionArrow;
    
    NSLog(@"%d %f %f", methaneValue, angle, self.lastAngle);
    
    // negative and positive is the direction of the rotation
    CGFloat rotateAngle = fabs(angle) > fabs(self.lastAngle) ? (fabs(angle) - fabs(self.lastAngle)) : (fabs(self.lastAngle) - fabs(angle))  * -1;
    
    self.lastAngle = angle;
    
    return rotateAngle;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

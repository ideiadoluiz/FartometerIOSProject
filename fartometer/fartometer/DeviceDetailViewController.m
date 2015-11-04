//
//  DeviceDetailViewController.m
//  fartometer
//
//  Created by Luiz Fernando Peres on 2015-11-04.
//  Copyright © 2015 Ideia do Luiz. All rights reserved.
//

#import "DeviceDetailViewController.h"

@interface DeviceDetailViewController ()

@property (nonatomic, weak) NSArray *peripherals;

@end

@implementation DeviceDetailViewController

- (instancetype) init
{
    [NSException raise:@"Wrong initializer" format:@"Use initWithPeripherals:"];
    return nil;
}

- (instancetype) initWithPeripherals:(NSArray *)peripherals
{
    self = [super init];
    if (self)
    {
        _peripherals = peripherals;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

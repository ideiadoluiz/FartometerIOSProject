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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UILabel* label =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    label.text = [self.peripherals firstObject];
    [self.view addSubview:label];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Title for NavigationBar";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

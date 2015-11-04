//
//  DeviceDetailViewController.m
//  fartometer
//
//  Created by Luiz Fernando Peres on 2015-11-04.
//  Copyright © 2015 Ideia do Luiz. All rights reserved.
//

#import "DeviceDetailViewController.h"
#import "SessionHelper.h"

#import <CoreBluetooth/CoreBluetooth.h>

@interface DeviceDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) NSArray *peripherals;
@property (nonatomic) UITableView *tableView;

@property (nonatomic) UILabel *lbl1;
@property (nonatomic) UILabel *lbl2;

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

-(BOOL)shouldAutorotate {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = [[SessionHelper sharedInstance] getLocalizedStringForName:@"devices"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor orangeColor]}];
    
    CGFloat barHeight = 0;//self.navigationController.navigationBar.frame.size.height;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, barHeight, self.view.frame.size.width, self.view.frame.size.height - barHeight) style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FART_HEIGHT_CELL;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.peripherals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    CBPeripheral *peripheral = (CBPeripheral *) self.peripherals[indexPath.row];
    cell = [self fillCell:cell andPeripheral:peripheral];
    
    [self.lbl1 setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]];
    [self.lbl1 setTextColor:[UIColor darkGrayColor]];
    self.lbl1.text = [NSString stringWithFormat:@"%@ %@",[[SessionHelper sharedInstance] getLocalizedStringForName:@"device_name_label"], peripheral.name];
    
    [self.lbl2 setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];
    [self.lbl2 setTextColor:[UIColor grayColor]];
    self.lbl2.text = [peripheral.identifier UUIDString];
    
    return cell;
}

- (UITableViewCell *) fillCell:(UITableViewCell *)cell andPeripheral:(CBPeripheral *)peripheral
{
    self.lbl1 = (UILabel *)[cell.contentView viewWithTag:1];
    self.lbl2 = (UILabel *)[cell.contentView viewWithTag:2];
    
    if (!self.lbl1 && !self.lbl2)
    {
        self.lbl1 = [UILabel new];
        self.lbl1.tag = 1;
        self.lbl1.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addSubview:self.lbl1];
        
        self.lbl2 = [UILabel new];
        self.lbl2.tag = 2;
        self.lbl2.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addSubview:self.lbl2];
    }
    
    UIImageView *imageView = cell.imageView;
    NSDictionary *viewsDictionary = @{@"lbl1View":self.lbl1, @"lbl2View":self.lbl2, @"imgView": imageView};
    NSDictionary *metrics = @{@"vSpacing":@10, @"hSpacing":@15};
    
    
    NSArray *constraintPOSV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[lbl1View]-[lbl2View]|"
                                                                      options:0
                                                                      metrics:metrics
                                                                        views:viewsDictionary];
    
    NSArray *lbl1ConstraintPOSH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-hSpacing-[lbl1View]|"
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:viewsDictionary];
    
    NSArray *lbl2ConstraintPOSH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-hSpacing-[lbl2View]|"
                                                                          options:0
                                                                          metrics:metrics
                                                                            views:viewsDictionary];
    [cell.contentView addConstraints:constraintPOSV];
    [cell.contentView addConstraints:lbl1ConstraintPOSH];
    [cell.contentView addConstraints:lbl2ConstraintPOSH];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

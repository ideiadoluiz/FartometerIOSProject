//
//  FartometerDetailViewController.m
//  fartometer
//
//  Created by Luiz Fernando Peres on 2015-11-05.
//  Copyright © 2015 Ideia do Luiz. All rights reserved.
//

#import "FartometerDetailViewController.h"
#import "SessionHelper.h"
#import "FartCoding.h"
#import "FartCodingStoreHelper.h"
#import "BLEHelper.h"
#import "FacebookHelper.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface FartometerDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UILabel *lbl1;
@property (nonatomic) UILabel *lbl2;
@property (nonatomic) UILabel *lbl3;
@property (nonatomic) UIImageView *imgView;

@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *arrFarts;

@end

@implementation FartometerDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.arrFarts = [[FartCodingStoreHelper sharedInstance] getFartsForKey:[[BLEHelper sharedInstance].currentPeripheral.identifier UUIDString]];
    [self.tableView reloadData];
    
    [super viewWillAppear:animated];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return FART_HEIGHT_CELL_BIG;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrFarts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    FartCoding *fart = (FartCoding *) self.arrFarts[indexPath.row];
    cell = [self fillCell:cell andFart:fart];
    
    [self.lbl1 setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline]];
    [self.lbl1 setTextColor:[UIColor darkGrayColor]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *strDate = [dateFormatter stringFromDate:fart.date];
    NSString *strLbl1 = [NSString stringWithFormat:[[SessionHelper sharedInstance] getLocalizedStringForName:@"user_date_fart"], fart.namePerson, strDate];
    NSDictionary *attribsLbl1 = @{
                              NSForegroundColorAttributeName: self.lbl1.textColor,
                              NSFontAttributeName: self.lbl1.font
                              };
    NSMutableAttributedString *attributedTextLbl1 =
    [[NSMutableAttributedString alloc] initWithString:strLbl1
                                           attributes:attribsLbl1];
    
    NSRange rangeLbl1 = [strLbl1 rangeOfString:strDate];
    [attributedTextLbl1 setAttributes:@{NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]} range:rangeLbl1];
    self.lbl1.attributedText = attributedTextLbl1;
    
    
    [self.lbl2 setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];
    [self.lbl2 setTextColor:[UIColor grayColor]];
    UIColor *colorText = [[SessionHelper sharedInstance] getTextColorWithFart:fart];
    NSString *fartLevelString = [[SessionHelper sharedInstance] getStringWithFart:fart];
    NSString *fartAKALevelString = [[SessionHelper sharedInstance] getAKAStringWithFart:fart];
    NSString *strStrength = [NSString stringWithFormat:[[SessionHelper sharedInstance] getLocalizedStringForName:@"history_methane_level"], fartAKALevelString, fart.methaneValue];
    NSRange rangeStringFart = [strStrength rangeOfString:fartLevelString];
    NSRange rangeStringAKAFart = [strStrength rangeOfString:fartAKALevelString];
    NSDictionary *attribs = @{
                              NSForegroundColorAttributeName: self.lbl2.textColor,
                              NSFontAttributeName: self.lbl2.font
                              };
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:strStrength
                                           attributes:attribs];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:colorText}
                            range:rangeStringFart];
    [attributedText setAttributes:@{NSForegroundColorAttributeName:colorText}
                            range:rangeStringAKAFart];
    self.lbl2.attributedText = attributedText;
    
    [self.lbl3 setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleFootnote]];
    [self.lbl3 setTextColor:[UIColor grayColor]];
    self.lbl3.text = [NSString stringWithFormat:@"%@: %@", fart.nameDevice, fart.keyDevice];
    
    return cell;
}
     
- (UITableViewCell *) fillCell:(UITableViewCell *)cell andFart:(FartCoding *)fart
{
    self.imgView = (UIImageView *)[cell.contentView viewWithTag:0];
    self.lbl1 = (UILabel *)[cell.contentView viewWithTag:1];
    self.lbl2 = (UILabel *)[cell.contentView viewWithTag:2];
    self.lbl3 = (UILabel *)[cell.contentView viewWithTag:3];
    
    if (!self.lbl1 && !self.lbl2)
    {
        CGSize sizePicFacebook = FART_FB_PROFILE_PIC_FRAME.size;
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (FART_HEIGHT_CELL_BIG - sizePicFacebook.height) / 2, sizePicFacebook.width, sizePicFacebook.height)];
        self.imgView.tag = 0;
        FBSDKProfilePictureView *profilePic = [[FacebookHelper sharedInstance] getFacebookProfilePictureWithId:fart.idPerson];
        [self.imgView addSubview:profilePic];
        self.imgView.layer.cornerRadius = self.imgView.frame.size.width / 2;
        self.imgView.layer.borderColor = [UIColor grayColor].CGColor;
        self.imgView.layer.borderWidth = 1;
        self.imgView.clipsToBounds = YES;
        self.imgView.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addSubview:self.imgView];
        
        self.lbl1 = [UILabel new];
        self.lbl1.tag = 1;
        self.lbl1.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addSubview:self.lbl1];
        
        self.lbl2 = [UILabel new];
        self.lbl2.tag = 2;
        self.lbl2.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addSubview:self.lbl2];
        
        self.lbl3 = [UILabel new];
        self.lbl3.tag = 3;
        self.lbl3.translatesAutoresizingMaskIntoConstraints = NO;
        [cell.contentView addSubview:self.lbl3];
    
        NSDictionary *viewsDictionary = @{@"lbl1View":self.lbl1, @"lbl2View":self.lbl2, @"lbl3View": self.lbl3};
        NSDictionary *metrics = @{@"vSpacing":@10, @"hSpacing":[NSNumber numberWithFloat:self.imgView.frame.size.width + 20]};
        
        NSArray *constraintPOSV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-vSpacing-[lbl1View]-[lbl2View]-[lbl3View]|"
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
        
        NSArray *lbl3ConstraintPOSH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-hSpacing-[lbl3View]|"
                                                                              options:0
                                                                              metrics:metrics
                                                                                views:viewsDictionary];
        
        [cell.contentView addConstraints:constraintPOSV];
        [cell.contentView addConstraints:lbl1ConstraintPOSH];
        [cell.contentView addConstraints:lbl2ConstraintPOSH];
        [cell.contentView addConstraints:lbl3ConstraintPOSH];
    }
    
    return cell;

}


@end

//
//  FartCoding.m
//  fartometer
//
//  Created by Marcos Natan on 2015-11-07.
//  Copyright © 2015 Ideia do Luiz. All rights reserved.
//

#import "FartCoding.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation FartCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    NSString *keyDevice = [aDecoder decodeObjectForKey:@"key"];
    NSString *nameDevice = [aDecoder decodeObjectForKey:@"nameDevice"];
    NSString *namePerson = [aDecoder decodeObjectForKey:@"namePerson"];
    FBSDKProfilePictureView *picPerson = [aDecoder decodeObjectForKey:@"picPerson"];
    int methaneValue = [aDecoder decodeIntForKey:@"methaneValue"];
    NSDate *date = [aDecoder decodeObjectForKey:@"date"];
    
    return [self initWithKey:keyDevice nameDevice:nameDevice namePerson:namePerson picPerson:picPerson methaneValue:methaneValue andDate:date];
}

- (instancetype) initWithKey:(NSString *)key nameDevice:(NSString *)nameDevice namePerson:(NSString *)namePerson picPerson:(FBSDKProfilePictureView *)picPerson methaneValue:(int)metValue andDate:(NSDate *)date;
{
    self = [super init];
    if (self)
    {
        _keyDevice = key;
        _nameDevice = nameDevice;
        _namePerson = namePerson;
        _picPerson = picPerson;
        _methaneValue = metValue;
        _date = date;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.keyDevice forKey:@"key"];
    [aCoder encodeObject:self.nameDevice forKey:@"nameDevice"];
    [aCoder encodeObject:self.nameDevice forKey:@"namePerson"];
    [aCoder encodeObject:self.nameDevice forKey:@"picPerson"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeInt:self.methaneValue forKey:@"methaneValue"];
}

@end

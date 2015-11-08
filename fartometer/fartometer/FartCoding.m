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
    NSString *idPerson = [aDecoder decodeObjectForKey:@"idPerson"];
    int methaneValue = [aDecoder decodeIntForKey:@"methaneValue"];
    NSDate *date = [aDecoder decodeObjectForKey:@"date"];
    
    return [self initWithKey:keyDevice nameDevice:nameDevice namePerson:namePerson idPerson:idPerson methaneValue:methaneValue andDate:date];
}

- (instancetype) initWithKey:(NSString *)key nameDevice:(NSString *)nameDevice namePerson:(NSString *)namePerson idPerson:(NSString *)idPerson methaneValue:(int)metValue andDate:(NSDate *)date;
{
    self = [super init];
    if (self)
    {
        _keyDevice = key;
        _nameDevice = nameDevice;
        _namePerson = namePerson;
        _idPerson = idPerson;
        _methaneValue = metValue;
        _date = date;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.keyDevice forKey:@"key"];
    [aCoder encodeObject:self.nameDevice forKey:@"nameDevice"];
    [aCoder encodeObject:self.namePerson forKey:@"namePerson"];
    [aCoder encodeObject:self.idPerson forKey:@"idPerson"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeInt:self.methaneValue forKey:@"methaneValue"];
}

@end

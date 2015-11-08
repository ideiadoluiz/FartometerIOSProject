//
//  FartCoding.h
//  fartometer
//
//  Created by Marcos Natan on 2015-11-07.
//  Copyright © 2015 Ideia do Luiz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FBSDKProfilePictureView;

@interface FartCoding : NSObject <NSCoding>

@property (nonatomic, readonly) NSString *keyDevice;
@property (nonatomic, readonly) NSString *nameDevice;
@property (nonatomic, readonly) NSString *namePerson;
@property (nonatomic, readonly) NSString *idPerson;
@property (nonatomic, readonly) int methaneValue;
@property (nonatomic, readonly) NSDate *date;

- (instancetype) initWithKey:(NSString *)key nameDevice:(NSString *)nameDevice namePerson:(NSString *)namePerson idPerson:(NSString *)idPerson methaneValue:(int)metValue andDate:(NSDate *)date;

@end

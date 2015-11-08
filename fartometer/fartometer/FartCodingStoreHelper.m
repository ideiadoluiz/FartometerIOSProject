//
//  FartCodingStoreHelper.m
//  fartometer
//
//  Created by Marcos Natan on 2015-11-07.
//  Copyright © 2015 Ideia do Luiz. All rights reserved.
//

#import "FartCodingStoreHelper.h"
#import "FartCoding.h"

@interface FartCodingStoreHelper ()

@property (nonatomic) NSMutableArray *arrPrivate;

@end

@implementation FartCodingStoreHelper

+ (instancetype) sharedInstance
{
    static FartCodingStoreHelper *sharedInstance;
    
    if (!sharedInstance)
        sharedInstance = [[self alloc] initPrivate];
    
    return sharedInstance;
}

- (instancetype)init
{
    [NSException raise:@"Singleton" format:@"Use +[FartCodingStoreHelper sharedInstance]"];
    return nil;
}

- (instancetype) initPrivate
{
    self = [super init];
    if (self)
    {
        NSString *path = [self itemArchivePath];
        _arrPrivate = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        
        if (!_arrPrivate)
            _arrPrivate = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    return [documentDirectory stringByAppendingPathComponent:@"farts.archive"];
}

- (BOOL) saveChanges
{
    NSString *path = [self itemArchivePath];
    return [NSKeyedArchiver archiveRootObject:self.arrPrivate toFile:path];
}

- (void) createNewFartData:(FartCoding *)fart
{
    [self.arrPrivate addObject:fart];
}

- (NSArray<FartCoding *> *) getFartsForKey:(NSString *)key
{
    NSArray *arr = [self.arrPrivate filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        NSString *str = ((FartCoding *)evaluatedObject).keyDevice;
        return [str isEqualToString:key];
    }]];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                 ascending:NO];
    return  [arr sortedArrayUsingDescriptors:@[sortDescriptor]];
}


@end

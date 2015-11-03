//
//  SessionHelper.m
//  fartometer
//
//  Created by Luiz Fernando Peres on 2015-11-03.
//  Copyright © 2015 Ideia do Luiz. All rights reserved.
//

#import "SessionHelper.h"

@interface SessionHelper ()

@property (nonatomic) NSDictionary *dicStrings;

@end

@implementation SessionHelper

+ (instancetype) sharedInstance
{
    static SessionHelper *sharedStore;
    
    if (!sharedStore)
        sharedStore = [[self alloc] initPrivate];
    
    return sharedStore;
}

- (instancetype) init
{
    [NSException raise:@"Singleton" format:@"Use +[SessionHelper sharedStore]"];
    return nil;
}

- (instancetype) initPrivate
{
    self = [super init];
    if (self)
    {
        NSString *fname = [[NSBundle mainBundle] pathForResource:@"" ofType:@"strings"];
        self.dicStrings = [NSDictionary dictionaryWithContentsOfFile:fname];
    }
    return self;
}

- (NSString *)getLocalizedStringForName:(NSString *)stringName
{
    return [self.dicStrings objectForKey:stringName];
}

@end

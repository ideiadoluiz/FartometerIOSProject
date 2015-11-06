//
//  FartometerViewController.h
//  fartometer
//
//  Created by Luiz Fernando Peres on 2015-11-05.
//  Copyright © 2015 Ideia do Luiz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FartometerSensorDelegate <NSObject>

- (void) doneUpdatingSensors;

@end

@interface FartometerViewController : UIViewController

@property (weak) id <FartometerSensorDelegate> delegate;
@property (nonatomic, readonly) BOOL isUpdating;
- (void) startUpdatingSensors;
- (void) newData:(NSString *)string;

@end

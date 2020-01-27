//
//  LightAmbientSensor.h
//  Gyroscope-test
//
//  Created by Luke Gavin on 16.01.20.
//  Copyright © 2020 Luke Gavin. All rights reserved.
//

#ifndef LightAmbientSensor_h
#define LightAmbientSensor_h


@interface LightAmbientSensor : NSObject

@property (strong, nonatomic) id someProperty;

+ (void) printHello;
+ (NSString *)sayHello;

+ (void) handle_event:(void*) target secondParam: (void*) refcon thirdParam:(IOHIDServiceRef) service fourthParam: (IOHIDEventRef) event;
- (int)max:(int)num1 andNum2:(int)num2;

- (int) max:(int) num1 secondNumber:(int) num2
//+ (NSString *)sayHello;
//- (void) someMethod;

@end

#endif /* LightAmbientSensor_h */

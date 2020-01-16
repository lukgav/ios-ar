//
//  CustomObject.h
//  LightAmbientSensor_Test
//
//  Created by Luke Gavin on 16.01.20.
//  Copyright © 2020 Luke Gavin. All rights reserved.
//

#ifndef LightAmbientSensor_h
#define LightAmbientSensor_h

#import <Foundation/Foundation.h>

@interface CustomObject : NSObject

@property (strong, nonatomic) id someProperty;

+ (void) printHello;
+ (NSString *)sayHello;


- (void) someMethod;



@end

#endif
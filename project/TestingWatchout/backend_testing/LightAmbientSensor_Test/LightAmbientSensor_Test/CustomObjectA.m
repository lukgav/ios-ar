//
//  CustomObject.m
//  LightAmbientSensor_Test
//
//  Created by Luke Gavin on 16.01.20.
//  Copyright © 2020 Luke Gavin. All rights reserved.
//

#import "CustomObjectA.h"

@implementation CustomObject : NSObject

+ (void) printHello {
    NSLog(@" \n Hello Phone World");
}

+(NSString *)sayHello{
    NSString * var;
    
    var = @" Hello from objective-c class.";
    
    return var;
    
}

- (void) someMethod {
    NSLog(@"\n SomeMethod Ran");
    
}

@end

//
//  Objc.h
//  Conventional
//
//  Created by Vladimir Borodko on 24/03/2018.
//

#import <Foundation/Foundation.h>

@interface Objc : NSObject

+ (BOOL)performOrThrow:(void(^)())tryBlock error:(__autoreleasing NSError **)error;

@end

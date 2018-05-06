//
//  Objc.m
//  Conventional
//
//  Created by Vladimir Borodko on 24/03/2018.
//

#import "Objc.h"
#include <exception>
#include <typeinfo>
#include <stdexcept>
#include <string>
#include <sstream>
#include <iostream>

@implementation Objc

+ (NSError*)errorWithName:(nonnull NSString*)name
                     reason:(nonnull NSString*)reason
{
  return [NSError errorWithDomain:name code:0 userInfo: @{@"Conventional.description": [NSString stringWithFormat:@"%@: %@", name, reason]}];
}

+ (BOOL)performOrThrow:(void(^)())tryBlock
                 error:(__autoreleasing NSError **)error
{
  try {
    @try { tryBlock(); return YES; }
    @catch (NSException *exception) {
      *error = [Objc errorWithName:exception.name reason:exception.reason];
      return NO;
    }
  } catch (const std::exception& ex) {
    NSString *reason = [NSString stringWithCString:ex.what() encoding:NSUTF8StringEncoding];
    *error = [Objc errorWithName:@"Error" reason:reason];
    return NO;
  } catch (const std::string& str) {
    NSString *reason = [NSString stringWithCString:str.c_str() encoding:NSUTF8StringEncoding];
    *error = [Objc errorWithName:@"Error" reason:reason];
    return NO;
  } catch (const std::wstring& str) {
    NSString *reason =  [[NSString alloc] initWithBytes:str.data() length:str.size() * sizeof(wchar_t) encoding:NSUTF32LittleEndianStringEncoding];
    *error = [Objc errorWithName:@"Error" reason:reason];
    return NO;
  } catch(...) {
    *error = [Objc errorWithName:@"Error" reason:@"Unrecognized c++ exception"];
    return NO;
  }
}

@end

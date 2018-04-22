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

+ (BOOL)performOrThrow:(void(^)())tryBlock
                 error:(__autoreleasing NSError **)error
{
  try {
    @try { tryBlock(); return YES; }
    @catch (NSException *exception) {
      *error = [[NSError alloc] initWithDomain:exception.name code:0 userInfo:exception.userInfo];
      return NO;
    }
  } catch (const std::exception& ex) {
    *error = [[NSError alloc] initWithDomain:[NSString stringWithCString:ex.what() encoding:NSUTF8StringEncoding] code:0 userInfo:nil];
    return NO;
  } catch (const std::string& str) {
    NSString* msg = [NSString stringWithCString:str.c_str() encoding:NSUTF8StringEncoding];
    *error = [[NSError alloc] initWithDomain:msg code:0 userInfo:nil];
    return NO;
  } catch (const std::wstring& str) {
    NSString * msg = [[NSString alloc] initWithBytes:str.data() length:str.size() * sizeof(wchar_t) encoding:NSUTF32LittleEndianStringEncoding];
    *error = [[NSError alloc] initWithDomain:msg code:0 userInfo:nil];
    return NO;
  } catch(...) {
    *error = [[NSError alloc] initWithDomain:@"Unrecognized c++ exception" code:0 userInfo:nil];
    return NO;
  }
}

@end

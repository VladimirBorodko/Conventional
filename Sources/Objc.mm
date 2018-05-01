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

+ (NSError*)errorWithDomain:(nonnull NSString*)domain
                     reason:(nonnull NSString*)reason
                   userInfo:(nullable NSDictionary<NSErrorUserInfoKey, id> *)dict
{
  NSDictionary<NSErrorUserInfoKey, id> *userInfo = dict ? dict.mutableCopy : [[NSMutableDictionary<NSErrorUserInfoKey, id> alloc] init];
  if(![userInfo valueForKey:NSDebugDescriptionErrorKey]) {
    [userInfo setValue:reason forKey:NSDebugDescriptionErrorKey];
  }
  return [NSError errorWithDomain:domain code:0 userInfo:userInfo];
}

+ (BOOL)performOrThrow:(void(^)())tryBlock
                 error:(__autoreleasing NSError **)error
{
  try {
    @try { tryBlock(); return YES; }
    @catch (NSException *exception) {
      *error = [Objc errorWithDomain:exception.name reason:exception.reason userInfo:exception.userInfo];
      return NO;
    }
  } catch (const std::exception& ex) {
    NSString *reason = [NSString stringWithCString:ex.what() encoding:NSUTF8StringEncoding];
    *error = [Objc errorWithDomain:@"std::exception" reason:reason userInfo:nil];
    return NO;
  } catch (const std::string& str) {
    NSString *reason = [NSString stringWithCString:str.c_str() encoding:NSUTF8StringEncoding];
    *error = [Objc errorWithDomain:@"std::string" reason:reason userInfo:nil];
    return NO;
  } catch (const std::wstring& str) {
    NSString *reason =  [[NSString alloc] initWithBytes:str.data() length:str.size() * sizeof(wchar_t) encoding:NSUTF32LittleEndianStringEncoding];
    *error = [Objc errorWithDomain:@"std::wstring" reason:reason userInfo:nil];
    return NO;
  } catch(...) {
    *error = [Objc errorWithDomain:@"c++ exception" reason:@"Unrecognized exception" userInfo:nil];
    return NO;
  }
}

@end

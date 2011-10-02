#import <Foundation/Foundation.h>

/**
 The APGKeychain class is a convenience class for securely persisting and retrieving
 strings from the system keychain.
 */
@interface APGKeychain : NSObject {
}

/**
 Securely persists a string with the key you provide.
 Example: [APGKeychain setString:@"secret" forKey:@"smartKey"];
 @return BOOL for whether or not the string was successfully persisted
 */
+ (BOOL)setString:(NSString *)string forKey:(NSString *)key;

/**
 Retrieves a string with the key you provide.
 Example: NSString *smartKey = [APGKeychain stringForKey:@"smartKey"];
 @return NSString the string in the keychain
 */
+ (NSString *)stringForKey:(NSString *)key;

/**
 Retrieves a previously persisted string from the keychain.
 @return BOOL for whether or not the delete was successful
 */
+ (BOOL)deleteStringForKey:(NSString *)key;

@end

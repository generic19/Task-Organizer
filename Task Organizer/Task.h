//
//  Task.h
//  Task Organizer
//
//  Created by Basel Alasadi on 23/04/2025.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

enum Status {
    StatusPending = 1,
    StatusInProgress = 2,
    StatusCompleted = 4,
};

enum Priority {
    PriorityLow = 1,
    PriorityNormal,
    PriorityHigh,
};

@interface Task : NSObject <NSCoding, NSSecureCoding, NSCopying>

@property (readonly) NSString* title;
@property (readonly) NSString* content;
@property (readonly) NSDate* creationDate;
@property (readonly) NSDate* dueDate;
@property (readonly) enum Status status;
@property (readonly) enum Priority priority;
@property (readonly) NSString* notificationIdentifier;

@property (class, readonly) BOOL supportsSecureCoding;

+ (instancetype)taskWithTitle:(NSString*)title content:(NSString*)content dueDate:(NSDate*)dueDate status:(enum Status)status priority:(enum Priority)priority notificationIdentifier:(NSString* _Nullable)notificationIdentifier;

- (instancetype)copyWithTitle:(NSString* _Nullable)title content:(NSString* _Nullable)content dueDate:(NSDate* _Nullable)dueDate status:(enum Status)status priority:(enum Priority)priority notificationIdentifier:(NSString* _Nullable)notificationIdentifier setNotificationIdentifier:(BOOL)setNotificationIdentifier;

- (instancetype)copyWithStatus:(enum Status)status;

- (instancetype)copyWithPriority:(enum Priority)priority;

@end

NS_ASSUME_NONNULL_END

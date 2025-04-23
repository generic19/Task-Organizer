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
    StatusInProgress,
    StatusCompleted,
};

enum Priority {
    PriorityLow = 1,
    PriorityNormal,
    PriorityHigh,
};

@interface Task : NSObject <NSCoding, NSCopying>

@property (readonly) NSString* title;
@property (readonly) NSString* content;
@property (readonly) NSDate* creationDate;
@property (readonly) NSDate* dueDate;
@property (readonly) enum Status status;
@property (readonly) enum Priority priority;

+ (instancetype)taskWithTitle:(NSString*)title content:(NSString*)content dueDate:(NSDate*)dueDate status:(enum Status)status priority:(enum Priority)priority;

- (instancetype)copyWithTitle:(NSString* _Nullable)title content:(NSString* _Nullable)content dueDate:(NSDate* _Nullable)dueDate status:(enum Status)status priority:(enum Priority)priority;

- (instancetype)copyWithStatus:(enum Status)status;

- (instancetype)copyWithPriority:(enum Priority)priority;

@end

NS_ASSUME_NONNULL_END

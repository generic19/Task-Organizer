//
//  Task.m
//  Task Organizer
//
//  Created by Basel Alasadi on 23/04/2025.
//

#import "Task.h"

@interface Task ()

@property (readwrite) NSString* title;
@property (readwrite) NSString* content;
@property (readwrite) NSDate* creationDate;
@property (readwrite) NSDate* dueDate;
@property (readwrite) enum Status status;
@property (readwrite) enum Priority priority;
@property (readwrite) NSString* notificationIdentifier;

@end

@implementation Task

+ (BOOL)supportsSecureCoding {
    return YES;
}

+ (instancetype)taskWithTitle:(NSString*)title content:(NSString*)content dueDate:(NSDate*)dueDate status:(enum Status)status priority:(enum Priority)priority notificationIdentifier:(NSString* _Nullable)notificationIdentifier {
    Task* task = [[Task alloc] init];
    
    task.title = title;
    task.content = content;
    task.creationDate = [NSDate date];
    task.dueDate = dueDate;
    task.status = status;
    task.priority = priority;
    task.notificationIdentifier = notificationIdentifier;
    
    return task;
}

- (instancetype)copyWithTitle:(NSString* _Nullable)title content:(NSString* _Nullable)content dueDate:(NSDate* _Nullable)dueDate status:(enum Status)status priority:(enum Priority)priority notificationIdentifier:(NSString* _Nullable)notificationIdentifier setNotificationIdentifier:(BOOL)setNotificationIdentifier {
    Task* task = [[Task alloc] init];
    
    task.title = title ? title : self.title;
    task.content = content ? content : self.content;
    task.creationDate = self.creationDate;
    task.dueDate = dueDate ? dueDate : self.dueDate;
    task.status = status ? status : self.status;
    task.priority = priority ? priority : self.priority;
    task.notificationIdentifier = setNotificationIdentifier || notificationIdentifier ? notificationIdentifier : self.notificationIdentifier;
    
    return task;
}

- (instancetype)copyWithStatus:(enum Status)status {
    return [self copyWithTitle:nil content:nil dueDate:nil status:status priority:0 notificationIdentifier:nil setNotificationIdentifier:NO];
}

- (instancetype)copyWithPriority:(enum Priority)priority {
    return [self copyWithTitle:nil content:nil dueDate:nil status:0 priority:priority notificationIdentifier:nil setNotificationIdentifier:NO];
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder { 
    [coder encodeObject:_title forKey:@"title"];
    [coder encodeObject:_content forKey:@"content"];
    [coder encodeDouble:[_dueDate timeIntervalSinceReferenceDate] forKey:@"creationDate"];
    [coder encodeDouble:[_dueDate timeIntervalSinceReferenceDate] forKey:@"dueDate"];
    [coder encodeInt:_status forKey:@"status"];
    [coder encodeInt:_priority forKey:@"priority"];
    [coder encodeObject:_notificationIdentifier forKey:@"notificationIdentifier"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder { 
    if (self) {
        _title = [coder decodeObjectForKey:@"title"];
        _content = [coder decodeObjectForKey:@"content"];
        _creationDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[coder decodeDoubleForKey:@"creationDate"]];
        _dueDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[coder decodeDoubleForKey:@"dueDate"]];
        _status = [coder decodeIntForKey:@"status"];
        _priority = [coder decodeIntForKey:@"priority"];
        _notificationIdentifier = [coder decodeObjectForKey:@"notificationIdentifier"];
    }
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone { 
    Task* task = [[Task allocWithZone:zone] init];
    
    task.title = _title;
    task.content = _content;
    task.creationDate = _creationDate;
    task.dueDate = _dueDate;
    task.status = _status;
    task.priority = _priority;
    task.notificationIdentifier = _notificationIdentifier;
    
    return task;
}

@end

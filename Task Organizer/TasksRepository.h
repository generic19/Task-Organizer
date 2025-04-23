//
//  TasksRepository.h
//  Task Organizer
//
//  Created by Basel Alasadi on 23/04/2025.
//

#import <Foundation/Foundation.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface TasksRepository : NSObject

+ (instancetype)instance;

@property (readonly) NSArray<Task*>* tasks;

- (void)addTask:(Task*)task;
- (void)removeTask:(Task*)task;
- (void)replaceTask:(Task*)oldTask with:(Task*)task;

@end

NS_ASSUME_NONNULL_END

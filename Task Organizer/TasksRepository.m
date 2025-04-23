//
//  TasksRepository.m
//  Task Organizer
//
//  Created by Basel Alasadi on 23/04/2025.
//

#import "TasksRepository.h"

@interface TasksRepository ()

@property (readwrite) NSMutableArray<Task*>* tasks;

@end

@implementation TasksRepository {
    NSUserDefaults* defaults;
}

+ (nonnull instancetype)repositoryWithUserDefaults:(nonnull NSUserDefaults *)userDefaults {
    TasksRepository* repo = [[TasksRepository alloc] init];
    
    if (repo != nil) {
        repo->defaults = userDefaults;
        [repo loadTasks];
    }
    
    return repo;
}

- (void)loadTasks {
    NSData* data = [defaults objectForKey:@"tasks"];
    
    NSArray<Task*>* unarchived = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithArray:@[[NSArray class], [Task class], [NSString class]]] fromData:data error:nil];
    
    if (unarchived == nil) {
        _tasks = [NSMutableArray array];
    } else {
        _tasks = [NSMutableArray arrayWithArray:unarchived];
    }
}

- (void)saveTasks {
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:_tasks requiringSecureCoding:YES error:nil];
    
    if (data != nil) {
        [defaults setObject:data forKey:@"tasks"];
    }
}

- (void)addTask:(nonnull Task *)task {
    [_tasks addObject:task];
    [self saveTasks];
}

- (void)removeTask:(nonnull Task *)task {
    [_tasks removeObject:task];
    [self saveTasks];
}

- (void)replaceTask:(nonnull Task *)oldTask with:(nonnull Task *)task {
    NSUInteger index = [_tasks indexOfObject:oldTask];
    
    if (index != NSNotFound) {
        _tasks[index] = task;
        [self saveTasks];
    }
}

@end

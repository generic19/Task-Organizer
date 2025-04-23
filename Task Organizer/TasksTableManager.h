//
//  TasksTableManager.h
//  Task Organizer
//
//  Created by Basel Alasadi on 23/04/2025.
//

#import <UIKit/UIKit.h>
#import "TasksRepository.h"

NS_ASSUME_NONNULL_BEGIN

enum Sorting {
    SortByCreationDate,
    SortByDueDate,
    SortByTitle,
    SortByPriority,
};

static const int STATUS_ALL = StatusPending | StatusInProgress | StatusCompleted;

@protocol TasksTableManagerDelegate <NSObject>

- (void)tableManagerOnSelectTask:(Task*)task;

@end

@interface TasksTableManager : NSObject <UITableViewDelegate, UITableViewDataSource>

@property id<TasksTableManagerDelegate> delegate;
@property BOOL groupByPriority;
@property enum Sorting sorting;
@property int statusFilter;
@property NSString* titleFilter;

+ (instancetype) managerForDelegate:(id<TasksTableManagerDelegate>)delegate tableView:(UITableView*)tableView repository:(TasksRepository*)repository groupByPriority:(BOOL)groupByPriority sorting:(enum Sorting)sorting statusFilter:(int)statusFilter;

- (void) reload;

@end

NS_ASSUME_NONNULL_END

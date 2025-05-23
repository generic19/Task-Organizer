//
//  CompletedTasksViewController.h
//  Task Organizer
//
//  Created by Basel Alasadi on 23/04/2025.
//

#import <UIKit/UIKit.h>
#import "TaskDetailViewController.h"
#import "TasksTableManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface CompletedTasksViewController : UIViewController <TaskDetailViewControllerDelegate, TasksTableManagerDelegate>

@end

NS_ASSUME_NONNULL_END

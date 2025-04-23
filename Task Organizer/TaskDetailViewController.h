//
//  TaskDetailViewController.h
//  Task Organizer
//
//  Created by Basel Alasadi on 23/04/2025.
//

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TaskDetailViewControllerDelegate <NSObject>

- (void)saveTask:(Task*)task replacing:(Task* _Nullable)oldTask;

@end

@interface TaskDetailViewController : UIViewController <UITextFieldDelegate>

@property id<TaskDetailViewControllerDelegate> delegate;
@property (nullable) Task* task;

@end

NS_ASSUME_NONNULL_END

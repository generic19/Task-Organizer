//
//  TaskDetailViewController.m
//  Task Organizer
//
//  Created by Basel Alasadi on 23/04/2025.
//

#import "TaskDetailViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface TaskDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfTitle;
@property (weak, nonatomic) IBOutlet UITextField *tfDescription;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scPriority;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scStatus;
@property (weak, nonatomic) IBOutlet UIDatePicker *dpDueDate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEditOrSave;
@property (weak, nonatomic) IBOutlet UISwitch *swRemind;

@property BOOL editing;

@end

@implementation TaskDetailViewController {
    BOOL _editing;
    BOOL notificationsGranted;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tfTitle.delegate = self;
    _tfDescription.delegate = self;
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->notificationsGranted = settings.authorizationStatus == UNAuthorizationStatusAuthorized;
            
            if (self->notificationsGranted) {
                if (self.task.notificationIdentifier && [self.task.dueDate timeIntervalSinceNow] > 0) {
                    [self.swRemind setOn:YES];
                } {
                    [self.swRemind setOn:NO];
                }
                
                self.swRemind.userInteractionEnabled = self.editing;
            } else if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
                [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    
                    self->notificationsGranted = granted;
                    
                    if (self.task.notificationIdentifier && [self.task.dueDate timeIntervalSinceNow] > 0 && granted) {
                        [self.swRemind setOn:YES];
                    } {
                        [self.swRemind setOn:NO];
                    }
                    
                    self.swRemind.userInteractionEnabled = self.editing && granted;
                }];
            }
        });
    }];
    
    if (_task == nil) {
        self.editing = YES;
        
        _scPriority.selectedSegmentIndex = 1;
        
        _scStatus.selectedSegmentIndex = 0;
        [_scStatus setEnabled:NO forSegmentAtIndex:1];
        [_scStatus setEnabled:NO forSegmentAtIndex:2];
    } else {
        self.editing = NO;
        
        _tfTitle.text = _task.title;
        _tfDescription.text = _task.content;
        
        switch (_task.priority) {
            case PriorityHigh:
                _scPriority.selectedSegmentIndex = 2;
                break;
                
            case PriorityNormal:
                _scPriority.selectedSegmentIndex = 1;
                break;
                
            case PriorityLow:
                _scPriority.selectedSegmentIndex = 0;
                break;
        }
        
        switch (_task.status) {
            case StatusPending:
                _scStatus.selectedSegmentIndex = 0;
                break;
                
            case StatusInProgress:
                _scStatus.selectedSegmentIndex = 1;
                [_scStatus setEnabled:NO forSegmentAtIndex:0];
                break;
                
            case StatusCompleted:
                _scStatus.selectedSegmentIndex = 2;
                [_scStatus setEnabled:NO forSegmentAtIndex:0];
                [_scStatus setEnabled:NO forSegmentAtIndex:1];
                _btnEditOrSave.enabled = NO;
                break;
        }
        
        _dpDueDate.date = _task.dueDate;
        
        if (_task.notificationIdentifier && [_task.dueDate timeIntervalSinceNow] > 0 && notificationsGranted) {
            [_swRemind setOn:YES];
        } {
            [_swRemind setOn:NO];
        }
    }
}

- (BOOL)editing {
    return _editing;
}

- (void)setEditing:(BOOL)editing {
    _editing = editing;
    
    _btnEditOrSave.title = editing ? @"Save" : @"Edit";
    
    _tfTitle.userInteractionEnabled = editing;
    _tfDescription.userInteractionEnabled = editing;
    _scPriority.userInteractionEnabled = editing;
    _scStatus.userInteractionEnabled = editing;
    _dpDueDate.userInteractionEnabled = editing;
    _swRemind.userInteractionEnabled = editing && notificationsGranted;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = !editing;
    
    if (_editing) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Discard" style:(UIBarButtonItemStylePlain) target:self action:@selector(onDiscard)];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor systemRedColor];
        
        _dpDueDate.minimumDate = [NSDate date];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)onDiscard {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Discard changes?" message:@"All unsaved changes will be lost." preferredStyle:(UIAlertControllerStyleAlert)];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {}]];
    
     [alert addAction:[UIAlertAction actionWithTitle:@"Discard" style:(UIAlertActionStyleDestructive) handler:^(UIAlertAction * _Nonnull action) {
         [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)editOrSaveAction:(UIBarButtonItem *)sender {
    if (_editing) {
        enum Priority priority = PriorityNormal;
        switch (_scPriority.selectedSegmentIndex) {
            case 0:
                priority = PriorityLow;
                break;
            case 1:
                priority = PriorityNormal;
                break;
            case 2:
                priority = PriorityHigh;
                break;
        }
        
        enum Status status = StatusPending;
        switch (_scStatus.selectedSegmentIndex) {
            case 0:
                status = StatusPending;
                break;
            case 1:
                status = StatusInProgress;
                break;
            case 2:
                status = StatusCompleted;
                break;
        }
        
        NSString* notificationIdentifier = nil;
        
        if (_task.notificationIdentifier) {
            [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:@[_task.notificationIdentifier]];
        }
        
        if (_swRemind.isOn) {
            notificationIdentifier = [[NSUUID UUID] UUIDString];
            
            UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
            content.title = @"You have a task due now!";
            content.body = [NSString stringWithFormat:@"Task \"%@\" is due now.", _tfTitle.text];
            content.sound = [UNNotificationSound defaultSound];
            
            double interval = [_dpDueDate.date timeIntervalSinceNow];
            interval = interval > 0 ? interval : 1;
            
            UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:interval repeats:NO];
            
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:notificationIdentifier content:content trigger:trigger];
            
            [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error scheduling notification" message:error.description preferredStyle:(UIAlertControllerStyleAlert)];
                        
                        [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:(UIAlertActionStyleCancel) handler:nil]];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                    } else {
                        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Reminder scheduled." message:[NSString stringWithFormat:@"Reminder after %.0f seconds", interval] preferredStyle:(UIAlertControllerStyleAlert)];
                        
                        [alert addAction:[UIAlertAction actionWithTitle:@"Okay" style:(UIAlertActionStyleCancel) handler:nil]];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                });
            }];
        }
        
        Task* newTask = [Task taskWithTitle:_tfTitle.text content:_tfDescription.text dueDate:_dpDueDate.date status:status priority:priority notificationIdentifier:notificationIdentifier];
        
        [self.delegate saveTask:newTask replacing:_task];
        
        if (_task == nil) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    self.editing = !_editing;
}

@end

//
//  TaskDetailViewController.m
//  Task Organizer
//
//  Created by Basel Alasadi on 23/04/2025.
//

#import "TaskDetailViewController.h"

@interface TaskDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfTitle;
@property (weak, nonatomic) IBOutlet UITextField *tfDescription;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scPriority;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scStatus;
@property (weak, nonatomic) IBOutlet UIDatePicker *dpDueDate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEditOrSave;

@property BOOL editing;

@end

@implementation TaskDetailViewController {
    BOOL _editing;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tfTitle.delegate = self;
    _tfDescription.delegate = self;
    _dpDueDate.minimumDate = [NSDate date];
    
    if (_task == nil) {
        self.editing = YES;
        
        _scPriority.selectedSegmentIndex = 1;
        _scStatus.selectedSegmentIndex = 0;
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
                break;
                
            case StatusCompleted:
                _scStatus.selectedSegmentIndex = 2;
                break;
        }
        
        _dpDueDate.date = _task.dueDate;
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
        
        Task* newTask = [Task taskWithTitle:_tfTitle.text content:_tfDescription.text dueDate:_dpDueDate.date status:status priority:priority];
        
        [self.delegate saveTask:newTask replacing:_task];
        
        if (_task == nil) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    self.editing = !_editing;
}

@end

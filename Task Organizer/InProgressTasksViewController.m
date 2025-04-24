//
//  InProgressTasksViewController.m
//  Task Organizer
//
//  Created by Basel Alasadi on 23/04/2025.
//

#import "InProgressTasksViewController.h"
#import "TasksRepository.h"

@interface InProgressTasksViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation InProgressTasksViewController {
    TasksRepository* repository;
    TasksTableManager* tableManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    repository = [TasksRepository instance];
    
    tableManager = [TasksTableManager managerForDelegate:self tableView:_tableView repository:repository groupByPriority:NO sorting:SortByPriority statusFilter:StatusInProgress];
    
    [tableManager reload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"In-Progress Tasks";
    
    UIBarButtonItem* newAction = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"square.and.pencil"] style:UIBarButtonItemStylePlain target:self action:@selector(newTaskAction)];
    
    UIBarButtonItem* groupAction = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStylePlain target:self action:@selector(toggleGroupingAction)];
    
    groupAction.image = [UIImage systemImageNamed:tableManager.groupByPriority ? @"folder.circle.fill" : @"folder.circle"];
    
    self.tabBarController.navigationItem.rightBarButtonItems = @[newAction, groupAction];
    
    [tableManager reload];
}

- (void)toggleGroupingAction {
    tableManager.groupByPriority = !tableManager.groupByPriority;
    
    self.tabBarController.navigationItem.rightBarButtonItems[1].image = [UIImage systemImageNamed:tableManager.groupByPriority ? @"folder.circle.fill" : @"folder.circle"];
    
    [tableManager reload];
}

- (void)saveTask:(nonnull Task *)task replacing:(Task * _Nullable)oldTask { 
    if (oldTask != nil) {
        [repository replaceTask:oldTask with:task];
    } else {
        [repository addTask:task];
    }
    
    [tableManager reload];
}

- (void)tableManagerOnSelectTask:(nonnull Task *)task { 
    TaskDetailViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"taskDetail"];
    controller.delegate = self;
    controller.task = task;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)newTaskAction {
    TaskDetailViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"taskDetail"];
    controller.delegate = self;
    controller.task = nil;
    [self.navigationController pushViewController:controller animated:YES];
}

@end

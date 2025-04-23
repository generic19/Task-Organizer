//
//  AllTasksViewController.m
//  Task Organizer
//
//  Created by Basel Alasadi on 23/04/2025.
//

#import "PendingTasksViewController.h"
#import "TasksTableManager.h"
#import "TaskDetailViewController.h"

@interface PendingTasksViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PendingTasksViewController {
    TasksRepository* repository;
    TasksTableManager* tableManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    repository = [TasksRepository instance];
    
    tableManager = [TasksTableManager managerForDelegate:self tableView:_tableView repository:repository groupByPriority:YES sorting:SortByDueDate statusFilter:StatusPending];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    tableManager.titleFilter = searchText;
    [tableManager reload];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"All Tasks";
    
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"square.and.pencil"] style:UIBarButtonItemStylePlain target:self action:@selector(newTaskAction)];
    
    [tableManager reload];
}

- (void)newTaskAction {
    TaskDetailViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"taskDetail"];
    controller.delegate = self;
    controller.task = nil;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)saveTask:(Task *)task replacing:(Task *)oldTask {
    if (oldTask != nil) {
        [repository replaceTask:oldTask with:task];
    } else {
        [repository addTask:task];
    }
    
    [tableManager reload];
}

- (void)tableManagerOnSelectTask:(Task *)task {
    TaskDetailViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"taskDetail"];
    controller.delegate = self;
    controller.task = task;
    [self.navigationController pushViewController:controller animated:YES];
}

@end

//
//  AllTasksViewController.m
//  Task Organizer
//
//  Created by Basel Alasadi on 23/04/2025.
//

#import "AllTasksViewController.h"
#import "TasksTableManager.h"
#import "TaskDetailViewController.h"

@interface AllTasksViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AllTasksViewController {
    TasksRepository* repository;
    TasksTableManager* tableManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    repository = [TasksRepository repositoryWithUserDefaults:[NSUserDefaults standardUserDefaults]];
    
    tableManager = [TasksTableManager managerForDelegate:self tableView:_tableView repository:repository groupByPriority:YES sorting:SortByCreationDate statusFilter:STATUS_ALL];
    
    [tableManager reload];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    tableManager.titleFilter = searchText;
    [tableManager reload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"All Tasks";
    
    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"square.and.pencil"] style:UIBarButtonItemStylePlain target:self action:@selector(newTaskAction)];
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

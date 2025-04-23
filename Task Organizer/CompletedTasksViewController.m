//
//  CompletedTasksViewController.m
//  Task Organizer
//
//  Created by Basel Alasadi on 23/04/2025.
//

#import "CompletedTasksViewController.h"

@interface CompletedTasksViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CompletedTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.navigationItem.title = @"Completed Tasks";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"Completed Tasks";
}

@end

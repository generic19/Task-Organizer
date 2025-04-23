//
//  InProgressTasksViewController.m
//  Task Organizer
//
//  Created by Basel Alasadi on 23/04/2025.
//

#import "InProgressTasksViewController.h"

@interface InProgressTasksViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation InProgressTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.navigationItem.title = @"In-Progress Tasks";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.title = @"In-Progress Tasks";
}

@end

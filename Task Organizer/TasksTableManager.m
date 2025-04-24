//
//  TasksTableManager.m
//  Task Organizer
//
//  Created by Basel Alasadi on 23/04/2025.
//

#import "TasksTableManager.h"
#import "TaskTableViewCell.h"

@implementation TasksTableManager {
    __weak UITableView* tableView;
    TasksRepository* tasksRepository;
    
    NSMutableArray<NSString*>* sections;
    NSMutableArray<NSMutableArray<Task*>*>* tasksBySection;
}

+ (instancetype) managerForDelegate:(id<TasksTableManagerDelegate>)delegate tableView:(UITableView*)tableView repository:(TasksRepository*)repository groupByPriority:(BOOL)groupByPriority sorting:(enum Sorting)sorting statusFilter:(int)statusFilter {
    
    TasksTableManager* manager = [[TasksTableManager alloc] initWithTableView:tableView tasksRepository:repository];
    
    if (manager) {
        manager.delegate = delegate;
        manager.groupByPriority = groupByPriority;
        manager.sorting = sorting;
        manager.statusFilter = statusFilter;
    }
    
    return manager;
}

- (instancetype) initWithTableView:(UITableView*)tableView tasksRepository:(TasksRepository*)repo {
    self = [self init];
    if (self) {
        self->tableView = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 83;
        
        tasksRepository = repo;
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];
    
    Task* task = tasksBySection[indexPath.section][indexPath.row];
    
    cell.tfTitle.text = task.title;
    cell.tfSubtitle.text = task.content;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    NSString* formattedDate = [dateFormatter stringFromDate:task.dueDate];
    
    cell.tfDate.text = [NSString stringWithFormat:@"Due %@", formattedDate];
    
    switch (task.priority) {
        case PriorityHigh:
            cell.ivIcon.image = [UIImage systemImageNamed:@"exclamationmark.3"];
            cell.ivIcon.tintColor = [UIColor systemOrangeColor];
            break;
            
        case PriorityNormal:
            cell.ivIcon.image = [UIImage systemImageNamed:@"exclamationmark.2"];
            cell.ivIcon.tintColor = [UIColor systemBlueColor];
            break;
            
        case PriorityLow:
            cell.ivIcon.image = [UIImage systemImageNamed:@"exclamationmark"];
            cell.ivIcon.tintColor = [UIColor systemGrayColor];
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sections == nil ? 0 : [sections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return sections[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tasksBySection[section].count;
}

- (void)reload {
    NSArray* tasks = tasksRepository.tasks;
    NSMutableArray<Task*>* tasksToDisplay = [NSMutableArray array];
    
    for (int i = 0; i < tasks.count; i++) {
        Task* task = tasks[i];
        if (task.status & _statusFilter) {
            if (_titleFilter == nil || _titleFilter.length == 0 || [task.title localizedCaseInsensitiveContainsString:_titleFilter]) {
                [tasksToDisplay addObject:task];
            }
        }
    }
    
    NSSortDescriptor* sortDescriptor;
    NSSortDescriptor* secondarySortDescriptor;
    switch (_sorting) {
        case SortByCreationDate:
            sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO selector:@selector(timeIntervalSinceReferenceDate)];
            secondarySortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
            break;
            
        case SortByDueDate:
            sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dueDate" ascending:NO selector:@selector(timeIntervalSinceReferenceDate)];
            secondarySortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
            break;
            
        case SortByTitle:
            sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
            secondarySortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO selector:@selector(timeIntervalSinceReferenceDate)];
            break;
            
        case SortByPriority:
            sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"priority" ascending:NO];
            secondarySortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dueDate" ascending:NO selector:@selector(timeIntervalSinceReferenceDate)];
            break;
    }
    
    [tasksToDisplay sortUsingDescriptors:@[sortDescriptor, secondarySortDescriptor]];
    
    if (_groupByPriority) {
        sections = [NSMutableArray arrayWithArray:@[@"High Priority", @"Normal Priority", @"Low Priority"]];
        
        NSMutableArray<Task*>* high = [NSMutableArray array];
        NSMutableArray<Task*>* normal = [NSMutableArray array];
        NSMutableArray<Task*>* low = [NSMutableArray array];
        
        tasksBySection = [NSMutableArray arrayWithObjects:high, normal, low, nil];
        
        for (int i = 0; i < tasksToDisplay.count; i++) {
            Task* task = tasksToDisplay[i];
            
            switch (task.priority) {
                case PriorityHigh:
                    [high addObject:task];
                    break;
                    
                case PriorityNormal:
                    [normal addObject:task];
                    break;
                    
                case PriorityLow:
                    [low addObject:task];
                    break;
            }
        }
    } else {
        sections = [NSMutableArray arrayWithArray:@[@"Pending", @"In Progress", @"Completed"]];
        
        NSMutableArray<Task*>* pending = [NSMutableArray array];
        NSMutableArray<Task*>* inProgress = [NSMutableArray array];
        NSMutableArray<Task*>* completed = [NSMutableArray array];
        
        tasksBySection = [NSMutableArray arrayWithObjects:pending, inProgress, completed, nil];
        
        for (int i = 0; i < tasksToDisplay.count; i++) {
            Task* task = tasksToDisplay[i];
            
            switch (task.status) {
                case StatusPending:
                    [pending addObject:task];
                    break;
                    
                case StatusInProgress:
                    [inProgress addObject:task];
                    break;
                    
                case StatusCompleted:
                    [completed addObject:task];
                    break;
            }
        }
    }
    
    for (int i = (int)(sections.count) - 1; i >= 0; i--) {
        if (tasksBySection[i].count == 0) {
            [tasksBySection removeObjectAtIndex:i];
            [sections removeObjectAtIndex:i];
        }
    }
    
    [tableView reloadData];
}

- (void)removeTaskAtIndexPath:(NSIndexPath*)indexPath {
    Task* task = tasksBySection[indexPath.section][indexPath.row];
    
    [tasksRepository removeTask:task];
    [tasksBySection[indexPath.section] removeObjectAtIndex:indexPath.row];
    
    if (tasksBySection[indexPath.section].count == 0) {
        [sections removeObjectAtIndex:indexPath.section];
        [tasksBySection removeObjectAtIndex:indexPath.section];
        
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)changeTaskStatusAtIndexPath:(NSIndexPath*)indexPath to:(enum Status)status {
    Task* task = tasksBySection[indexPath.section][indexPath.row];
    
    if (task.status == status) {
        return;
    }
    
    [tasksRepository replaceTask:task with:[task copyWithStatus:status]];
    [tasksBySection[indexPath.section] removeObjectAtIndex:indexPath.row];
    
    if (tasksBySection[indexPath.section].count == 0) {
        [sections removeObjectAtIndex:indexPath.section];
        [tasksBySection removeObjectAtIndex:indexPath.section];
        
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_delegate tableManagerOnSelectTask:tasksBySection[indexPath.section][indexPath.row]];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIContextualAction* deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self removeTaskAtIndexPath:indexPath];
    }];
    
    deleteAction.image = [UIImage systemImageNamed:@"trash"];
    
    return [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    Task* task = tasksBySection[indexPath.section][indexPath.row];
    
    NSString* actionName;
    UIImage* actionImage;
    UIColor* actionColor;
    enum Status nextStatus;
    switch (task.status) {
        case StatusPending:
            actionName = @"Mark In-Progress";
            actionImage = [UIImage systemImageNamed:@"hourglass"];
            actionColor = [UIColor systemBlueColor];
            nextStatus = StatusInProgress;
            break;
            
        case StatusInProgress:
            actionName = @"Mark Completed";
            actionImage = [UIImage systemImageNamed:@"flag.pattern.checkered"];
            actionColor = [UIColor systemGreenColor];
            nextStatus = StatusCompleted;
            break;
            
        default:
            return nil;
    }
    
    UIContextualAction* statusAction = [UIContextualAction contextualActionWithStyle:(UIContextualActionStyleNormal) title:actionName handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [self changeTaskStatusAtIndexPath:indexPath to:nextStatus];
        completionHandler(YES);
    }];
    
    statusAction.image = actionImage;
    statusAction.backgroundColor = actionColor;
    
    return [UISwipeActionsConfiguration configurationWithActions:@[statusAction]];
}

@end

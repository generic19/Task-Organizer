//
//  TaskTableViewCell.h
//  Task Organizer
//
//  Created by Basel Alasadi on 23/04/2025.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TaskTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *ivIcon;
@property (weak, nonatomic) IBOutlet UILabel *tfTitle;
@property (weak, nonatomic) IBOutlet UILabel *tfDate;
@property (weak, nonatomic) IBOutlet UILabel *tfSubtitle;

@end

NS_ASSUME_NONNULL_END

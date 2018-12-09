//
//  TabCollectionViewCell.h
//  MotorMouth
//
//  Created by Pushpendra on 23/10/17.
//  Copyright © 2017 Pushpendra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblTabName;
@property (strong, nonatomic) IBOutlet UILabel *lblBottomLine;
@property (weak, nonatomic) IBOutlet UIImageView *groupTabImageView;
@end

//
//  ViewController.m
//  LZColorDetector
//
//  Created by comst on 16/3/31.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "ViewController.h"
#import "UIView+LZFrame.h"
#import "SVProgressHUD.h"
#import "LZPickerColorController.h"
#import "LZColorCell.h"
#import "LZColorStorage.h"


@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerLeading;
@property (nonatomic, strong) UIImagePickerController *imagePickerVC;
@property (weak, nonatomic) IBOutlet UITableView *colorHistoryTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configColorHistoryTableView];
    
}

- (void)configColorHistoryTableView{
    self.colorHistoryTableView.delegate = self;
    self.colorHistoryTableView.dataSource = self;
    [self.colorHistoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([LZColorCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LZColorCell"];
    self.colorHistoryTableView.rowHeight = 100;
    self.colorHistoryTableView.tableFooterView = [[UIView alloc] init];
}


#pragma mark - new or history
- (IBAction)historyButtonClick:(UIButton *)sender {
    
     self.containerLeading.constant = - self.view.width;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        [self.colorHistoryTableView reloadData];
        
    }];
}
- (IBAction)nButtonClick:(UIButton *)sender {
    
    self.containerLeading.constant = 0;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}


#pragma mark - new color

- (IBAction)albumButtonClick:(UIButton *)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self.navigationController presentViewController:self.imagePickerVC animated:YES completion:^{
            
        }];
        
    }else{
        
        [SVProgressHUD showErrorWithStatus:@"无法获取照片库"];
    }
}

- (IBAction)photoButtonClick:(UIButton *)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self.navigationController presentViewController:self.imagePickerVC animated:YES completion:^{
            
        }];
        
    }else{
        
        [SVProgressHUD showErrorWithStatus:@"无法获取照片库"];
    }
}


- (IBAction)realButtonClick:(UIButton *)sender {
    
}



#pragma mark - imagePickerViewController


//UIImagePickerControllerMediaType = "public.image";
//UIImagePickerControllerOriginalImage = "<UIImage: 0x7f833352d250> size {3000, 2002} orientation 0 scale 1.000000";
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *sourceImage = info[UIImagePickerControllerOriginalImage];
    LZPickerColorController *pickerVC = [[LZPickerColorController alloc] init];
    pickerVC.selectedImage = sourceImage;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pickerVC];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        [self.navigationController presentViewController:nav animated:YES completion:^{
             
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - lazy load

- (UIImagePickerController *)imagePickerVC{
    if (!_imagePickerVC) {
        _imagePickerVC = [[UIImagePickerController alloc] init];
        _imagePickerVC.delegate = self ;
    }
    return _imagePickerVC;
}

#pragma mark - historytableview delegate 


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[LZColorStorage sharedColorStorage] allColors] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LZColorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LZColorCell"];
    cell.currentColor = [[LZColorStorage sharedColorStorage] allColors][indexPath.row];
    
    return cell;
}

@end

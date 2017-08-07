//
//  ViewController.m
//  WJCircleTableView
//
//  Created by tqh on 2017/8/4.
//  Copyright © 2017年 tqh. All rights reserved.
//

#import "ViewController.h"
#import "WJCircleTableView.h"
#import "WJCircleTabCell.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) WJCircleTableView *tableView;
@property (nonatomic,strong) UIButton *button;  //按钮
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.button];
    self.view.backgroundColor = [UIColor grayColor];
}

#pragma mark -  <UITableViewDelegate,UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *test = @"table";
    WJCircleTabCell *cell = (WJCircleTabCell*)[tableView dequeueReusableCellWithIdentifier:test];
    if( !cell )
    {
        cell = [[WJCircleTabCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:test];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}

#pragma mark - 懒加载

- (WJCircleTableView *)tableView {
    if (!_tableView) {
        //CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.width)
        _tableView = [[WJCircleTableView alloc]initWithFrame:self.view.bounds];
        _tableView.backgroundColor = [UIColor orangeColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView
    }
    return _tableView;
}

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton new];
        _button.backgroundColor = [UIColor whiteColor];
        _button.frame = CGRectMake(-55, self.view.frame.size.height/2-40, 110, 80);
        _button.layer.cornerRadius = 80/2;
        _button.layer.masksToBounds = YES;
    }
    return _button;
}

@end

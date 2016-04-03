//
//  WJSummarizeController.m
//  fashionDance
//
//  Created by 汪俊 on 16/3/16.
//  Copyright © 2016年 汪俊. All rights reserved.
//

#import "YuSummarizeController.h"
#import "YUSummarizeHeaderView.h"
#import "SVProgressHUD.h"
#import "YUSummarizeCell.h"
#import "YUSummarizeHeaderView.h"
#import "YUCarCellModel.h"
#import "YUCarDetailModel.h"
#import "LLDBCarManager.h"

static NSString *Id = @"cell";

@interface YuSummarizeController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) YUSummarizeHeaderView *headerView;

@property (nonatomic, strong) NSArray *CarCellModels;

@property(nonatomic,strong)YUCarDetailModel * headModel;

@property(nonatomic,weak)UIView * footerView;
@property(nonatomic,assign)BOOL isSelected;
@end

@implementation YuSummarizeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // http://autoapp.auto.sohu.com/api/model/info/4905
    // http://autoapp.auto.sohu.com/api/model/trimList/4905
    // http://saa.auto.sohu.com/v5/mobileapp/club/modelClubInfo.do?modelId=1571
    
    
    [self setupTableView];
    [self loadHeaderData];
    [self loadCellData];
    
}

-(UIView *)footerView
{
    if (!_footerView) {
        CGFloat heigthFooter = 60;
        UIView * view = [[UIView alloc]init];
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(0);
            make.trailing.equalTo(0);
            int offSet = -95;
            if (self.view.frame.size.height + self.view.frame.origin.y > WJScreenH) {
                
            }
            else
            {
                offSet = 0;
            }
            make.baseline.equalTo(self.view).offset(offSet);
            make.height.equalTo(@(heigthFooter));
        }];
        
        UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"emptyStar"]];
        [imageView setFrame:CGRectMake((WJScreenW - 25)/2, (heigthFooter - 25)/2, 25, 25)];
        [view addSubview:imageView];
        
        //为footer view 添加手势
        UITapGestureRecognizer * gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleFavorite)];
        [view addGestureRecognizer:gestureRecognizer];
        //判断有没有收藏
        self.isSelected = NO;
        NSArray * array = [[LLDBCarManager sharedManager] searchAllCar];
        for (YUCarDetailModel * model in array) {
            if (model.modelId == self.modelId.integerValue) {
                self.isSelected = YES;
            }
        }
        
        [view setBackgroundColor:[UIColor grayColor]];
        _footerView = view;
    }
    return _footerView;
}

-(void)handleFavorite
{
    if (!self.isSelected) {
        //收藏
        [[LLDBCarManager sharedManager] insertCar:self.headModel];
        
        self.isSelected = YES;
        UIImageView * imageView = [self.footerView.subviews lastObject];
        [imageView setImage:[UIImage imageNamed:@"like_selected"]];
    }
    else
    {
        [[LLDBCarManager sharedManager] deleteCarWithmodelId:[self.modelId integerValue]];
        self.isSelected = NO;
        UIImageView * imageView = [self.footerView.subviews lastObject];
        [imageView setImage:[UIImage imageNamed:@"emptyStar"]];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.view bringSubviewToFront:self.footerView];
}

- (void)loadHeaderData
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    NSString *urlString = [NSString stringWithFormat:@"http://autoapp.auto.sohu.com/api/model/info/%@",self.modelId];
    
    __weak typeof (self) weakSelf = self;
    [[WJHttpTool httpTool] get:urlString params:nil success:^(id result) {
        
      //   NSLog(@"%@",result);
        
        YUCarDetailModel *detailModel = [YUCarDetailModel mj_objectWithKeyValues:result];
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.headerView.model = detailModel;
        });
        
        [SVProgressHUD dismiss];
        
        self.headModel = detailModel;
        //浏览记录
        [[LLDBCarManager sharedManager] insertCarfootmark:detailModel];

    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
    
}

- (void)loadCellData
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    
    NSString *urlString = [NSString stringWithFormat:@"http://autoapp.auto.sohu.com/api/model/trimList/%@",self.modelId];
    
    __weak typeof (self) weakSelf = self;
    [[WJHttpTool httpTool] get:urlString params:nil success:^(id result) {
        
        //   NSLog(@"%@",result);
        
        weakSelf.CarCellModels = [YUCarCellModel mj_objectArrayWithKeyValuesArray:result];
        [weakSelf.tableView reloadData];
        [SVProgressHUD dismiss];
        
        //后期添加的收藏
        [self footerView];


    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
    
}

- (void)setupTableView
{
    // 设置tableview
    self.automaticallyAdjustsScrollViewInsets = YES;
    UITableView *tableView = [[UITableView alloc]init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置inset
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64 + 35, 0);
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
    }];
    tableView.backgroundColor = [UIColor colorWithWhite:0.929 alpha:1.000];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([YUSummarizeCell class]) bundle:nil] forCellReuseIdentifier:Id];
    
    // 添加headerView
    YUSummarizeHeaderView *headerView = [YUSummarizeHeaderView headerView];
    self.headerView = headerView;
    
    self.tableView.tableHeaderView = headerView;
    tableView.rowHeight = 95;
}

#pragma mark -tableVew代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.CarCellModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YUSummarizeCell  *cell = [tableView dequeueReusableCellWithIdentifier:Id];
    
    cell.model = self.CarCellModels[indexPath.section];
       
    return cell;
}

@end

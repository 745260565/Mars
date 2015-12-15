//
//  AllocateDetailViewController.m
//  Mars
//
//  Created by jiamai on 15/11/9.
//  Copyright © 2015年 runsdata. All rights reserved.
//

#import "AllocateDetailViewController.h"
#import "AppDelegate.h"
#import "CHPopoverListView.h"
#import "AlertShowWithString.h"

//#import "MalfunctionEntity.h"

@interface AllocateDetailViewController ()<CHPopoverListDatasource,CHPopoverListDelegate>
{
    UITextField *ideaTextField;
    NSUInteger tag;
    NSArray *chooseArray;
    NSArray *memberArray;//成员信息数组
    NSArray *memberNameArray;//成员姓名数组
    UILabel *memberLabel;
    NSMutableArray *chooseMemberArray;//选中的成员信息
    NSMutableDictionary *chooseMemberDictionary;//选中成员信息组成一个字典
}
@end

@implementation AllocateDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.title = @"故障分派详情";
    chooseMemberArray = [[NSMutableArray alloc]init];
    chooseMemberDictionary = [[NSMutableDictionary alloc]init];
    // Do any additional setup after loading the view from its nib.
}


- (void)initView{
    
    CGRect viewRect = self.view.frame;
    UIView *tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewRect.size.width, 100)];
    tableHeader.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    UILabel *labe1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 30)];
    labe1.font = [UIFont systemFontOfSize:18];
    labe1.text = @"意见:";
    [tableHeader addSubview:labe1];
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectMake(70, 0, kScreenWidth -80, 40)];
    
    UITapGestureRecognizer *chooseIdea = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseIdea)];
    [buttonView addGestureRecognizer:chooseIdea];
    ideaTextField= [[UITextField alloc]initWithFrame:CGRectMake(10, 5, buttonView.frame.size.width - 60, 30)];
    ideaTextField.frame = CGRectMake(0, 0, 200, 40);
    ideaTextField.font = [UIFont systemFontOfSize:18];
    ideaTextField.text = @"重要,请尽快处理。";
    ideaTextField.returnKeyType = UIReturnKeyDone;
    ideaTextField.delegate = self;
   [buttonView addSubview:ideaTextField];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0 , 40, buttonView.frame.size.width - 60, 1)];
    lineView1.backgroundColor = [UIColor grayColor];
    [buttonView addSubview:lineView1];

    
 
    UIImageView *ideaChooseImage = [[UIImageView alloc]initWithFrame:CGRectMake(buttonView.frame.size.width-40-10, 5, 30, 30)];
    ideaChooseImage.image = [UIImage imageNamed:@"iconfont-angledoubledown.png"];
    [buttonView addSubview:ideaChooseImage];
    [tableHeader addSubview:buttonView];
    
    UIButton *dealPerson = [[UIButton alloc]initWithFrame:CGRectMake(10, 50, 60, 40)];
    dealPerson.titleLabel.font = [UIFont systemFontOfSize: 16];
    [dealPerson setTitle:@"处理人" forState:UIControlStateNormal];
    [dealPerson addTarget:self action:@selector(choosePerson) forControlEvents:UIControlEventTouchUpInside];
    [dealPerson setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dealPerson.layer.borderColor = [UIColor grayColor].CGColor;
    dealPerson.layer.borderWidth = 1;
    dealPerson.layer.cornerRadius = 5;
    [tableHeader addSubview:dealPerson];
    
    UIScrollView *memberView = [[UIScrollView alloc]initWithFrame:CGRectMake(70, 50, kScreenWidth - 80, 40)];
    memberView.contentSize = CGSizeMake(500, 35);
    memberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 500, 35)];
   // memberView.backgroundColor = [AppDelegate sharedApplicationDelegate].backgroundGrayColor;
    [memberView addSubview:memberLabel];
    memberView.showsHorizontalScrollIndicator = false;

    [tableHeader addSubview:memberView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(70 , 90, kScreenWidth - 80, 1)];
    lineView.backgroundColor = [UIColor grayColor];
    [tableHeader addSubview:lineView];
    
    mainTable.tableHeaderView = tableHeader;
}

- (void) orderDataDidLoad
{
    [self initMemberArray];
}
- (void)initMemberArray{
    memberArray = [[NSArray alloc]init];
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc]init];
    [requestDictionary setObject:[orderDetail objectForKey:@"groupCode"] forKey:@"groupCode"];
    [HttpNetworkManager request:requestDictionary withPath:@"/api/basis/setFaultgroupDel/selectMembersTreeByGroupNo" targetClass:[NSArray class] completion:^(NSArray *resultArray, NSError *error) {
        if (error) {
            NSLog(@"error:%@",error);
        }else{
            NSDictionary *memberDictionary = resultArray[0];
            memberArray = [memberDictionary objectForKey:@"children"];
            NSMutableArray *memberTextArray = [[NSMutableArray alloc]init];
            for (NSDictionary *memberDetailDictionary in memberArray) {
                NSString *text = [memberDetailDictionary objectForKey:@"text"];
                [memberTextArray addObject:text];
            }
            memberNameArray = [memberTextArray copy];
        }
    } withMethod:HttpMethodPost];
}
- (void)chooseIdea{
    chooseArray = @[@"重要，请尽快处理并反馈",@"紧急，请优先处理此工单",@"一般，请安排处理",@"未交维，请转派工程处理",@"请转其他专业处理"];
    CHPopoverListView *listView = [[CHPopoverListView alloc]initWithFrame:CGRectMake(0, 0, 260, 44*chooseArray.count)];
    listView.datasource = self;
    listView.delegate = self;
    tag = 1;
    [listView show];
}
- (void)choosePerson{
    chooseArray = memberNameArray;
    CHPopoverListView *listView;
    if (memberNameArray.count*44<400) {
        listView = [[CHPopoverListView alloc]initWithFrame:CGRectMake(0, 0, 200, 44*memberNameArray.count)];
    }else{
        listView = [[CHPopoverListView alloc]initWithFrame:CGRectMake(0, 0, 200, 400)];
    }
    listView.delegate = self;
    listView.datasource = self;
    tag = 2;
    [listView show];
}


- (void)dispatchTask{
    if(chooseMemberArray.count ==0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请选择成员" message:@"成员不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }else{
        NSString *chooseMemberNameString =[[NSString alloc]init];
        NSString *chooseMemberAccountString = [[NSString alloc]init];
        for (NSDictionary *chooseMemberDetailDictionary in chooseMemberArray) {
            if (chooseMemberNameString.length==0) {
                chooseMemberNameString = [chooseMemberDetailDictionary objectForKey:@"text"];
            }else{
                chooseMemberNameString = [NSString stringWithFormat:@"%@,%@",chooseMemberNameString, [chooseMemberDetailDictionary objectForKey:@"text"]];
            }
            if (chooseMemberAccountString.length==0) {
                chooseMemberAccountString = [chooseMemberDetailDictionary objectForKey:@"PatrolMembersAccount"];
            }else{
                chooseMemberAccountString = [NSString stringWithFormat:@"%@,%@",chooseMemberAccountString,[chooseMemberDetailDictionary objectForKey:@"PatrolMembersAccount"]];
            }
        }
        NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc]init];
        [requestDictionary setObject:chooseMemberNameString forKey:@"handleUserName"];
        [requestDictionary setObject:chooseMemberAccountString forKey:@"handleUserAccount"];
        [requestDictionary setValue:@"故障分派" forKey:@"actionName"];
        [requestDictionary setValue:orderId forKey:@"id"];
        if (ideaTextField.text.length>0) {
            [requestDictionary setObject:ideaTextField.text forKey:@"comment"];
        }
        [HttpNetworkManager request:requestDictionary withPath:@"/api/fault/faultOrderInfo/faultAssign" targetClass:[NSString class] completion:^(NSString *resultString, NSError *error) {
            if (error) {
                [AlertShowWithString alertShowWithString:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
            }else{
                [AlertShowWithString alertShowWithString:@"故障分派成功"];
                if (self.completion) {
                    self.completion(true);
                }
                [self.navigationController popViewControllerAnimated:YES];
            }
        } withMethod:HttpMethodPost];
    }
}

- (void)rejectTask{
    NSMutableDictionary *requestDictionary = [[NSMutableDictionary alloc]init];
    [requestDictionary setValue:@"退单" forKey:@"actionName"];
    [requestDictionary setValue:orderId forKey:@"id"];
    if (ideaTextField.text.length>0) {
        [requestDictionary setObject:ideaTextField.text forKey:@"comment"];
    }
    [HttpNetworkManager request:requestDictionary withPath:@"/api/fault/faultOrderInfo/faultAssign" targetClass:[NSString class] completion:^(id resultDictionary, NSError *error) {
        if (error) {
            NSLog(@"退单error:%@",error);
            [AlertShowWithString alertShowWithString:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
        }else{
            [AlertShowWithString alertShowWithString:@"退单成功"];
            if (self.completion) {
                self.completion(true);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    } withMethod:HttpMethodPost];
}






- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [ideaTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- CHPopoverListView dataSouce delegate
- (NSInteger)popoverListView:(CHPopoverListView *)tableView numberOfRowsInSection:(NSInteger)section{
    return chooseArray.count;
}

- (UITableViewCell *)popoverListView:(CHPopoverListView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identitfier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusablePopoverCellWithIdentifier:identitfier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identitfier];
    }
    NSInteger row = indexPath.row;
    cell.textLabel.text = chooseArray[row];
    cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    
    if (tag == 2) {
        NSDictionary *currentMembers = memberArray[row];
        NSString *currentMemberAccount = [currentMembers objectForKey:@"PatrolMembersAccount"];
        for (NSDictionary *memberSelectDictionary in chooseMemberArray) {
            NSString *memberSelectAccount = [memberSelectDictionary objectForKey:@"PatrolMembersAccount"];
            if ([currentMemberAccount isEqualToString:memberSelectAccount]) {
                cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
                break;
            }
        }
    }
    return cell;
}

- (void)popoverListView:(CHPopoverListView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tag == 1) {
        ideaTextField.text = chooseArray[indexPath.row];
        UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
        [tableView touchForDismissSelf];
    }else{
        UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
        NSDictionary *selectMembers = memberArray[indexPath.row];
        if ([cell.imageView.image isEqual:[UIImage imageNamed:@"fs_main_login_selected.png"]]) {
            cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
            [chooseMemberDictionary removeObjectForKey:[selectMembers objectForKey:@"text"]];
        }else{
            cell.imageView.image = [UIImage imageNamed:@"fs_main_login_selected.png"];
            [chooseMemberDictionary setObject:[selectMembers objectForKey:@"PatrolMembersAccount"] forKey:[selectMembers objectForKey:@"text"]];
        }
        NSArray *chooseMemberNameArray = [chooseMemberDictionary allKeys];//选择的人物姓各数组
        if (chooseMemberNameArray.count>0) {
            memberLabel.text = @"";
            [chooseMemberArray removeAllObjects];
            for (NSString *chooseMemberName in chooseMemberNameArray) {
                if (memberLabel.text.length == 0) {
                    memberLabel.text = chooseMemberName;
                }else{
                    memberLabel.text = [NSString stringWithFormat:@"%@,%@",memberLabel.text,chooseMemberName];
                }
                NSDictionary *memberDictionary = @{@"text":chooseMemberName,@"PatrolMembersAccount":[chooseMemberDictionary objectForKey:chooseMemberName]};
                [chooseMemberArray addObject:memberDictionary];
            }
        }else{
            memberLabel.text = @"";
            [chooseMemberArray removeAllObjects];
        }
    }
}

- (void)popoverListView:(CHPopoverListView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tag ==1) {
        UITableViewCell *cell = [tableView popoverCellForRowAtIndexPath:indexPath];
        cell.imageView.image = [UIImage imageNamed:@"fs_main_login_normal.png"];
    }
}

#pragma mark --textFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [ideaTextField resignFirstResponder];
    return YES;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) handleMenu:(NSInteger)index
{
    switch (index) {
        case 0:
            //故障分派
            [self dispatchTask];
            break;
        case 1:
            [self rejectTask];
        default:
            break;
    }
}
@end

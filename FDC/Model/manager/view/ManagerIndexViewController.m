//
//  ManagerIndexViewController.m
//  FDC
//
//  Created by NewDoone on 15/1/13.
//  Copyright (c) 2015年 wlpiaoyi. All rights reserved.
//

#import "ManagerIndexViewController.h"
#import "AdminManager.h"
#import "ConfigManage+Expand.h"
#import "UserEntity.h"
#import "CustomIOS7AlertView.h"
#import "LoginController.h"

@interface ManagerIndexViewController ()<CustomIOS7AlertViewDelegate,LeveyPopListViewDelegate>
@property(nonatomic,strong) NSMutableArray* projectNames;
@property (weak, nonatomic) IBOutlet UIView *detailsView;
//@property (weak, nonatomic) IBOutlet UILabel *phoneIn;
//@property (weak, nonatomic) IBOutlet UILabel *visit;
//@property (weak, nonatomic) IBOutlet UILabel *sureBuy;
//@property (weak, nonatomic) IBOutlet UILabel *contactBuy;
//@property (weak, nonatomic) IBOutlet UILabel *sureCount;
//@property (weak, nonatomic) IBOutlet UILabel *contactCount;
//@property (weak, nonatomic) IBOutlet UILabel *shouldPay;
//@property (weak, nonatomic) IBOutlet UILabel *accturllyPay;
@property (nonatomic,strong) MCProgressBarView * phoneIn;
@property (nonatomic,strong) MCProgressBarView * visit;
@property (nonatomic,strong) MCProgressBarView * sureBuy;
@property (nonatomic,strong) MCProgressBarView * contactBuy;
@property (nonatomic,strong) MCProgressBarView * sureCount;
@property (nonatomic,strong) MCProgressBarView * contactCount;
@property (nonatomic,strong) MCProgressBarView * shouldPay;
@property (nonatomic,strong) MCProgressBarView * accturllyPay;

@property (weak, nonatomic) IBOutlet UILabel *houseNo1;
@property (weak, nonatomic) IBOutlet UILabel *houseNo2;
@property (weak, nonatomic) IBOutlet UILabel *houseNo3;
@property (weak, nonatomic) IBOutlet UILabel *houseNo1Name;
@property (weak, nonatomic) IBOutlet UILabel *houseNo2Name;
@property (weak, nonatomic) IBOutlet UILabel *houseNo3Name;
@property (weak, nonatomic) IBOutlet UILabel *countNo1;
@property (weak, nonatomic) IBOutlet UILabel *countNo2;
@property (weak, nonatomic) IBOutlet UILabel *countNo3;
@property (weak, nonatomic) IBOutlet UILabel *countNo1Name;
@property (weak, nonatomic) IBOutlet UILabel *countNo2Name;
@property (weak, nonatomic) IBOutlet UILabel *countNo3Name;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *cicles;
@property(nonatomic,strong) UILabel* tempLb1;
@property(nonatomic,strong) UILabel* tempLb2;




@end

@implementation ManagerIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    /*
     hiddenCaculateView
     */
    for (UIImageView* iv in self.cicles) {
        iv.hidden=YES;
    }
    self.countNo1.hidden=YES;
    self.countNo2.hidden=YES;
    self.countNo3.hidden=YES;
    self.countNo1Name.hidden=YES;
    self.countNo2Name.hidden=YES;
    self.countNo3Name.hidden=YES;
    /*
        hiddenEnd
     */
    
    self.photoView.layer.cornerRadius=35;
    self.photoView.clipsToBounds=YES;
    UIBarButtonItem*rightBar= [self createButtonItemLogout:@selector(logoutAction)];
    UIBarButtonItem*leftBar=[self createButtonItemSelecteObject:@selector(selectObejct)];
    self.navigationItem.rightBarButtonItem=rightBar;
    self.navigationItem.leftBarButtonItem=leftBar;
    
    NSDateFormatter * frm=[[NSDateFormatter alloc]init];
    [frm setDateFormat:@"yyyy-MM-dd"];
    NSDate* startDate=[NSDate getFirstDayOfWeek];
//    NSDate* endDate=[NSDate getLastDayOfWeek];
    NSString* start=[frm stringFromDate:startDate];
//    NSString* end=[frm stringFromDate:endDate];
    self.fromDate.text=start;
    self.toDate.text=start;
    [self loadDataWithStartDate:start EndDate:start];
}
-(void)logoutAction{
    UIAlertView* al=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"确定要注销此账号？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    al.tag=90;
    [al show];
}

-(void)selectObejct{
    self.projectNames=nil;
    self.projectNames=[NSMutableArray array];
    UserEntity* user=[ConfigManage getLoginUser];
    NSArray* arr=user.authorityInfoObjectGroup;
    for (NSDictionary* dics in arr) {
        [self.projectNames addObject:[dics objectForKey:@"WY_WYMC"]];
    }
    LeveyPopListView* view=[[LeveyPopListView alloc]initWithTitle:@"请选择项目名称" options:self.projectNames];
    view.delegate=self;
    [view showInView:self.view.window animated:YES];
}
-(void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex{
    self.buildingName.text=[self.projectNames objectAtIndex:anIndex];
    UserEntity* user=[ConfigManage getLoginUser];
    user.objectName=[self.projectNames objectAtIndex:anIndex];
    [ConfigManage setLoginUser:user];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==90) {
        if (buttonIndex==1) {
            LoginController* vc=[[LoginController alloc]init];
            vc.mark=@"logout";
            [self presentViewController:vc animated:YES completion:^{
                
            }];
        }
    }
}
-(void)initView{
    UserEntity* user=[ConfigManage getLoginUser];
    self.userName.text=user.sellerName;
    self.buildingName.text=user.objectName;
    self.title=@"首页";
    self.scrollView.frame=[UIScreen mainScreen].bounds;
    CGRect frame =self.scrollView.frame;
    frame.size.height=frame.size.height-self.navigationController.toolbar.frameHeight;
    self.scrollView.frame=frame;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.showsVerticalScrollIndicator =NO;
    self.scrollView.bounces=NO;
    self.detailsView.frame=CGRectMake(8, 236, [UIScreen mainScreen].bounds.size.width-16, 200);
    //view
    if (![self.countNo1 isHidden]) {
        self.mostSellView.frame=CGRectMake(8, self.detailsView.frame.origin.y+205, [UIScreen mainScreen].bounds.size.width-16, 235);
    }else{
        self.mostSellView.frame=CGRectMake(8, self.detailsView.frame.origin.y+205, [UIScreen mainScreen].bounds.size.width-16, 100);
    }
    
    self.sellPlanView.frame=CGRectMake(8, self.mostSellView.frame.origin.y+self.mostSellView.frame.size.height+20, [UIScreen mainScreen].bounds.size.width-16, 180);
    //detailsView
//     CGFloat detailViewWith=self.sellPlanView.frame.size.width;
    self.phoneIn=[[MCProgressBarView alloc]initWithFrame:CGRectMake(10, 5, DEVICE_WIDTH-20, 20) backgroundImage:[[UIImage imageNamed:@"darkGray.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] foregroundImage:[[UIImage imageNamed:@"rectCircle.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    self.phoneIn.progress=1;
    self.phoneIn.left_nameLabel.frame=CGRectMake(10, 2, 60, 20);
    self.phoneIn.right_valueLabel.frame=CGRectMake(self.phoneIn.frame.size.width-110, 2, 100, 20);
    self.phoneIn.right_valueLabel.textAlignment=NSTextAlignmentRight;
    [self.phoneIn configLabelWithLeftName:@"来电" leftValue:nil rightName:nil rightValue:@"0个" labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor whiteColor] RlabelTextColor:[UIColor whiteColor]];
    [self.detailsView addSubview:self.phoneIn];
    
    self.visit=[[MCProgressBarView alloc]initWithFrame:CGRectMake(10, 28, DEVICE_WIDTH-20, 20) backgroundImage:[[UIImage imageNamed:@"darkGray.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] foregroundImage:[[UIImage imageNamed:@"rectCircle.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    self.visit.progress=1;
    self.visit.left_nameLabel.frame=CGRectMake(10, 2, 60, 20);
    self.visit.right_valueLabel.frame=CGRectMake(self.visit.frame.size.width-110, 2, 100, 20);
    self.visit.right_valueLabel.textAlignment=NSTextAlignmentRight;
    [self.visit configLabelWithLeftName:@"来访" leftValue:nil rightName:nil rightValue:@"0个" labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor whiteColor] RlabelTextColor:[UIColor whiteColor]];
    [self.detailsView addSubview:self.visit];
    
    self.sureBuy=[[MCProgressBarView alloc]initWithFrame:CGRectMake(10, 51, DEVICE_WIDTH-20, 20) backgroundImage:[[UIImage imageNamed:@"darkGray.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] foregroundImage:[[UIImage imageNamed:@"rectCircle.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    self.sureBuy.progress=1;
    self.sureBuy.left_nameLabel.frame=CGRectMake(10, 2, 60, 20);
    self.sureBuy.right_valueLabel.frame=CGRectMake(self.sureBuy.frame.size.width-110, 2, 100, 20);
    self.sureBuy.right_valueLabel.textAlignment=NSTextAlignmentRight;
    [self.sureBuy configLabelWithLeftName:@"认购" leftValue:nil rightName:nil rightValue:@"0套" labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor whiteColor] RlabelTextColor:[UIColor whiteColor]];
    [self.detailsView addSubview:self.sureBuy];
    
    self.contactBuy=[[MCProgressBarView alloc]initWithFrame:CGRectMake(10, 74, DEVICE_WIDTH-20, 20) backgroundImage:[[UIImage imageNamed:@"darkGray.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] foregroundImage:[[UIImage imageNamed:@"rectCircle.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    self.contactBuy.progress=1;
    self.contactBuy.left_nameLabel.frame=CGRectMake(10, 2, 60, 20);
    self.contactBuy.right_valueLabel.frame=CGRectMake(self.contactBuy.frame.size.width-110, 2, 100, 20);
    self.contactBuy.right_valueLabel.textAlignment=NSTextAlignmentRight;
    [self.contactBuy configLabelWithLeftName:@"契约" leftValue:nil rightName:nil rightValue:@"0套" labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor whiteColor] RlabelTextColor:[UIColor whiteColor]];
    [self.detailsView addSubview:self.contactBuy];
    
    self.sureCount=[[MCProgressBarView alloc]initWithFrame:CGRectMake(10, 97, DEVICE_WIDTH-20, 20) backgroundImage:[[UIImage imageNamed:@"darkGray.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] foregroundImage:[[UIImage imageNamed:@"rectCircle.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    self.sureCount.progress=1;
    self.sureCount.left_nameLabel.frame=CGRectMake(10, 2, 60, 20);
    self.sureCount.right_valueLabel.frame=CGRectMake(self.sureCount.frame.size.width-110, 2, 100, 20);
    self.sureCount.right_valueLabel.textAlignment=NSTextAlignmentRight;
    [self.sureCount configLabelWithLeftName:@"认购金额" leftValue:nil rightName:nil rightValue:@"0万元" labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor whiteColor] RlabelTextColor:[UIColor whiteColor]];
    [self.detailsView addSubview:self.sureCount];

    self.contactCount=[[MCProgressBarView alloc]initWithFrame:CGRectMake(10, 120, DEVICE_WIDTH-20, 20) backgroundImage:[[UIImage imageNamed:@"darkGray.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] foregroundImage:[[UIImage imageNamed:@"rectCircle.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    self.contactCount.progress=1;
    self.contactCount.left_nameLabel.frame=CGRectMake(10, 2, 60, 20);
    self.contactCount.right_valueLabel.frame=CGRectMake(self.contactCount.frame.size.width-110, 2, 100, 20);
    self.contactCount.right_valueLabel.textAlignment=NSTextAlignmentRight;
    [self.contactCount configLabelWithLeftName:@"契约金额" leftValue:nil rightName:nil rightValue:@"0万元" labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor whiteColor] RlabelTextColor:[UIColor whiteColor]];
    [self.detailsView addSubview:self.contactCount];
    
    self.shouldPay=[[MCProgressBarView alloc]initWithFrame:CGRectMake(10, 143, DEVICE_WIDTH-20, 20) backgroundImage:[[UIImage imageNamed:@"darkGray.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] foregroundImage:[[UIImage imageNamed:@"rectCircle.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    self.shouldPay.progress=1;
    self.shouldPay.left_nameLabel.frame=CGRectMake(10, 2, 60, 20);
    self.shouldPay.right_valueLabel.frame=CGRectMake(self.shouldPay.frame.size.width-90, 2, 80, 20);
    self.shouldPay.right_valueLabel.textAlignment=NSTextAlignmentRight;
    [self.shouldPay configLabelWithLeftName:@"应收款" leftValue:nil rightName:nil rightValue:@"0万元" labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor whiteColor] RlabelTextColor:[UIColor whiteColor]];
    [self.detailsView addSubview:self.shouldPay];
    
    self.accturllyPay=[[MCProgressBarView alloc]initWithFrame:CGRectMake(10, 166, DEVICE_WIDTH-20, 20) backgroundImage:[[UIImage imageNamed:@"darkGray.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] foregroundImage:[[UIImage imageNamed:@"rectCircle.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    self.accturllyPay.progress=1;
    self.accturllyPay.left_nameLabel.frame=CGRectMake(10, 2, 60, 20);
    self.accturllyPay.right_valueLabel.frame=CGRectMake(self.accturllyPay.frame.size.width-110, 2, 100, 20);
    self.accturllyPay.right_valueLabel.textAlignment=NSTextAlignmentRight;
    [self.accturllyPay configLabelWithLeftName:@"实收款" leftValue:nil rightName:nil rightValue:@"0万元" labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor whiteColor] RlabelTextColor:[UIColor whiteColor]];
    [self.detailsView addSubview:self.accturllyPay];
    
    //PlanProView
    CGFloat planViewWith=self.sellPlanView.frame.size.width;
    self.firstSeasonView=[[MCProgressBarView alloc]initWithFrame:CGRectMake(10, 44, planViewWith-20, 24) backgroundImage:[[UIImage imageNamed:@"darkGray.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] foregroundImage:[[UIImage imageNamed:@"rectCircle.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    self.firstSeasonView.progress=1;
    //leftLabel
    self.firstSeasonView.left_nameLabel.frame=CGRectMake(10, 2, 60, 20);
//    self.forthSeasonView.left_valueLabel.frame=CGRectMake(74, 2, 30, 20);
    //rightLabel
    self.firstSeasonView.right_valueLabel.frame=CGRectMake(self.firstSeasonView.frame.size.width-110, 2, 100, 20);
//    self.forthSeasonView.right_nameLabel.frame=CGRectMake(self.forthSeasonView.frame.size.width-70, 2, 30, 16);
    self.firstSeasonView.right_valueLabel.textAlignment=NSTextAlignmentRight;
    [self.firstSeasonView configLabelWithLeftName:@"一季度" leftValue:nil rightName:nil rightValue:@"0万" labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor blackColor] RlabelTextColor:[UIColor blackColor]];
    [self.sellPlanView addSubview:self.firstSeasonView];
    //=====
    self.secondSeasonView=[[MCProgressBarView alloc]initWithFrame:CGRectMake(10, 78, planViewWith-20, 24) backgroundImage:[[UIImage imageNamed:@"darkGray.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] foregroundImage:[[UIImage imageNamed:@"rectCircle.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    self.secondSeasonView.progress=1;
    //leftLabel
    self.secondSeasonView.left_nameLabel.frame=CGRectMake(10, 2, 60, 20);
//    self.thirdSeasonView.left_valueLabel.frame=CGRectMake(74, 2, 30, 16);
    //rightLabel
    self.secondSeasonView.right_valueLabel.frame=CGRectMake(self.secondSeasonView.frame.size.width-110, 2, 100, 20);
//    self.thirdSeasonView.right_nameLabel.frame=CGRectMake(self.thirdSeasonView.frame.size.width-70, 2, 30, 16);
    self.secondSeasonView.right_valueLabel.textAlignment=NSTextAlignmentRight;
    [self.secondSeasonView configLabelWithLeftName:@"二季度" leftValue:nil rightName:nil rightValue:@"0万" labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor blackColor] RlabelTextColor:[UIColor blackColor]];
    [self.sellPlanView addSubview:self.secondSeasonView];
    //=====
    self.thirdSeasonView=[[MCProgressBarView alloc]initWithFrame:CGRectMake(10, 112,  planViewWith-20, 24) backgroundImage:[[UIImage imageNamed:@"darkGray.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] foregroundImage:[[UIImage imageNamed:@"rectCircle.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    self.thirdSeasonView.progress=1;
    //leftLabel
    self.thirdSeasonView.left_nameLabel.frame=CGRectMake(10, 2, 60, 20);
//    self.secondSeasonView.left_valueLabel.frame=CGRectMake(74, 2, 30, 16);
    //rightLabel
    self.thirdSeasonView.right_valueLabel.frame=CGRectMake(self.thirdSeasonView.frame.size.width-110, 2, 100, 20);
//    self.secondSeasonView.right_nameLabel.frame=CGRectMake(self.secondSeasonView.frame.size.width-70, 2, 30, 16);
    self.thirdSeasonView.right_valueLabel.textAlignment=NSTextAlignmentRight;
    [self.thirdSeasonView configLabelWithLeftName:@"三季度" leftValue:nil rightName:nil rightValue:@"0万" labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor blackColor] RlabelTextColor:[UIColor blackColor]];
    [self.sellPlanView addSubview:self.thirdSeasonView];
    //====
    self.forthSeasonView=[[MCProgressBarView alloc]initWithFrame:CGRectMake(10, 146, planViewWith-20, 24) backgroundImage:[[UIImage imageNamed:@"darkGray.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) ] foregroundImage:[[UIImage imageNamed:@"rectCircle.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]];
    self.forthSeasonView.progress=1;
    //leftLabel
    self.forthSeasonView.left_nameLabel.frame=CGRectMake(10, 2, 60, 20);
//    self.forthSeasonView.left_valueLabel.frame=CGRectMake(74, 2, 30, 16);
    //rightLabel
    self.forthSeasonView.right_valueLabel.frame=CGRectMake(self.forthSeasonView.frame.size.width-110, 2, 100, 20);
//    self.forthSeasonView.right_nameLabel.frame=CGRectMake(self.forthSeasonView.frame.size.width-70, 2, 30, 16);
    self.forthSeasonView.right_valueLabel.textAlignment=NSTextAlignmentRight;
    [self.forthSeasonView configLabelWithLeftName:@"四季度" leftValue:nil rightName:nil rightValue:@"0万" labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor blackColor] RlabelTextColor:[UIColor blackColor]];
    [self.sellPlanView addSubview:self.forthSeasonView];
    //config ScrollView ContentSize
    self.scrollView.contentSize=CGSizeMake(DEVICE_WIDTH, self.sellPlanView.frameY+self.sellPlanView.frameHeight+80);
    
}
-(void)loadDataWithStartDate:(NSString*) start EndDate:(NSString*) end{
    
    [Utils showLoading:@"正在加载数据..."];
    AdminManager* manager=[[AdminManager alloc]init];
    UserEntity* user=[ConfigManage getLoginUser];
    NSData* data=[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL_LOGO ,user.logo]]];
    UIImage * image=[UIImage imageWithData:data];
    self.photoView.image=image;
    
    [manager queryManagerMainInfoWithObjectId:user.objectId UserId:user.userId startTime:start endTime:end success:^(id data, NSDictionary *userInfo) {
        NSArray* datas=(NSArray*)data;
        NSDictionary* customer=[datas objectAtIndex:0];
        NSArray* customers=[customer objectForKey:@"LstArry"];
        // 来电  来访
        NSDictionary* phoneComeIn=[customers objectAtIndex:0];
        NSDictionary* interView=[customers objectAtIndex:1];
        [self.phoneIn configLabelWithLeftName:@"来电" leftValue:nil rightName:nil rightValue:[phoneComeIn objectForKey:@"ZD_ZDVAL"] labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor whiteColor] RlabelTextColor:[UIColor whiteColor]];
         [self.visit configLabelWithLeftName:@"来访" leftValue:nil rightName:nil rightValue:[interView objectForKey:@"ZD_ZDVAL"] labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor whiteColor] RlabelTextColor:[UIColor whiteColor]];
//        self.phoneIn.text=[phoneComeIn objectForKey:@"ZD_ZDVAL"];
//        self.visit.text=[interView objectForKey:@"ZD_ZDVAL"];
        //认购 签约
        NSDictionary* sureBuy=[customers objectAtIndex:2];
        NSDictionary* sign=[customers objectAtIndex:3];
          [self.sureBuy configLabelWithLeftName:@"认购" leftValue:nil rightName:nil rightValue:[sureBuy objectForKey:@"ZD_ZDVAL"] labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor whiteColor] RlabelTextColor:[UIColor whiteColor]];
        [self.contactBuy configLabelWithLeftName:@"契约" leftValue:nil rightName:nil rightValue:[sign objectForKey:@"ZD_ZDVAL"] labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor whiteColor] RlabelTextColor:[UIColor whiteColor]];
//        self.sureBuy.text=[sureBuy objectForKey:@"ZD_ZDVAL"];
//        self.contactBuy.text=[sign objectForKey:@"ZD_ZDVAL"];
        //认购签约 金额
        NSDictionary* sureBuyCount=[customers objectAtIndex:4];
        NSDictionary* signCount=[customers objectAtIndex:5];
        [self.sureCount configLabelWithLeftName:@"认购金额" leftValue:nil rightName:nil rightValue:[sureBuyCount objectForKey:@"ZD_ZDVAL"] labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor whiteColor] RlabelTextColor:[UIColor whiteColor]];
        [self.contactCount configLabelWithLeftName:@"契约金额" leftValue:nil rightName:nil rightValue:[signCount objectForKey:@"ZD_ZDVAL"] labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor whiteColor] RlabelTextColor:[UIColor whiteColor]];
//        self.sureCount.text=[sureBuyCount objectForKey:@"ZD_ZDVAL"];
//        self.contactCount.text=[signCount objectForKey:@"ZD_ZDVAL"];
             //实收  应收
        NSDictionary* realCount=[customers objectAtIndex:6];
        NSDictionary* shouldCount=[customers objectAtIndex:7];
        [self.shouldPay configLabelWithLeftName:@"应收款" leftValue:nil rightName:nil rightValue:[realCount objectForKey:@"ZD_ZDVAL"] labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor whiteColor] RlabelTextColor:[UIColor whiteColor]];
        [self.accturllyPay configLabelWithLeftName:@"实收款" leftValue:nil rightName:nil rightValue:[shouldCount objectForKey:@"ZD_ZDVAL"] labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor whiteColor] RlabelTextColor:[UIColor whiteColor]];
//        self.shouldPay.text=[realCount objectForKey:@"ZD_ZDVAL"];
//        self.accturllyPay.text=[shouldCount objectForKey:@"ZD_ZDVAL"];
        
               //畅销户型  空数据暂时1！！！！！！！！！
        NSDictionary* house=[datas objectAtIndex:1];
        NSArray* arr1=[house objectForKey:@"LstArry"];
        if (arr1.count>0) {
            NSDictionary* houseNo1=[arr1 objectAtIndex:0];
            NSDictionary* houseNo2=[arr1 objectAtIndex:1];
            NSDictionary* houseNo3=[arr1 objectAtIndex:2];
            self.houseNo1.text=[houseNo1 objectForKey:@"ZD_ZDVAL"];
            self.houseNo1Name.text=[houseNo1 objectForKey:@"ZD_ZDMC"];
            self.houseNo2.text=[houseNo2 objectForKey:@"ZD_ZDVAL"];
            self.houseNo2Name.text=[houseNo2 objectForKey:@"ZD_ZDMC"];
            self.houseNo3.text=[houseNo3 objectForKey:@"ZD_ZDVAL"];
            self.houseNo3Name.text=[houseNo3 objectForKey:@"ZD_ZDMC"];
            NSDictionary* house2=[datas objectAtIndex:2];
            NSArray* arr2=[house2 objectForKey:@"LstArry"];
            NSDictionary* count1=[arr2 objectAtIndex:0];
            NSDictionary* count2=[arr2 objectAtIndex:1];
            NSDictionary* count3=[arr2 objectAtIndex:2];
            self.countNo1.text=[count1 objectForKey:@"ZD_ZDVAL"];
            self.countNo1Name.text=[count1 objectForKey:@"ZD_ZDMC"];
            self.countNo2.text=[count2 objectForKey:@"ZD_ZDVAL"];
            self.countNo2Name.text=[count2 objectForKey:@"ZD_ZDMC"];
            self.countNo3.text=[count3 objectForKey:@"ZD_ZDVAL"];
            self.countNo3Name.text=[count3 objectForKey:@"ZD_ZDMC"];
        }
        
        
        //计划
        NSDictionary* plan=[datas objectAtIndex:3];
        NSArray* plans=[plan objectForKey:@"LstArry"];
//        NSString* mark=@"|";
        if (plans.count>0) {
            //四季度
            NSDictionary* four=[plans objectAtIndex:3];
            NSString* value_four=[four objectForKey:@"ZD_ZDVAL"];
            NSString* name_four=[four objectForKey:@"ZD_ZDMC"];
            [self.forthSeasonView configLabelWithLeftName:name_four leftValue:nil rightName:nil rightValue:value_four labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor blackColor] RlabelTextColor:[UIColor blackColor]];
            //三季度
            NSDictionary* three=[plans objectAtIndex:2];
            NSString* value_three=[three objectForKey:@"ZD_ZDVAL"];
            NSString* name_three=[three objectForKey:@"ZD_ZDMC"];
            [self.thirdSeasonView configLabelWithLeftName:name_three leftValue:nil rightName:nil rightValue:value_three labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor blackColor] RlabelTextColor:[UIColor blackColor]];
            //二季度
            NSDictionary* two=[plans objectAtIndex:1];
            NSString* value_two=[two objectForKey:@"ZD_ZDVAL"];
            NSString* name_two=[two objectForKey:@"ZD_ZDMC"];
            [self.secondSeasonView configLabelWithLeftName:name_two leftValue:nil rightName:nil rightValue:value_two labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor blackColor] RlabelTextColor:[UIColor blackColor]];
            //一季度
            NSDictionary* one=[plans objectAtIndex:0];
            NSString* value_one=[one objectForKey:@"ZD_ZDVAL"];
            NSString* name_one=[one objectForKey:@"ZD_ZDMC"];
            [self.firstSeasonView configLabelWithLeftName:name_one leftValue:nil rightName:nil rightValue:value_one labelFont: [UIFont systemFontOfSize:12] LlabelTextColor:[UIColor blackColor] RlabelTextColor:[UIColor blackColor]];
        }
               [Utils hiddenLoading];
        
    } faild:^(id data, NSDictionary *userInfo) {
         [Utils hiddenLoading];
    }];
    

}

- (IBAction)queryTodayData:(id)sender {
    NSDate* endDate=[NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: endDate];
    NSDate *localeDate = [endDate  dateByAddingTimeInterval: interval];
    
    NSDateFormatter *frm=[[NSDateFormatter alloc]init];
    NSLocale *mylocal=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
    [frm setLocale:mylocal];
    [frm setDateFormat:@"YYYY-MM-dd"];
    NSString* end=[frm stringFromDate:localeDate];
    [self loadDataWithStartDate:end EndDate:end];
    self.fromDate.text=[frm stringFromDate:localeDate];
    self.toDate.text=[frm stringFromDate:localeDate];
}
- (IBAction)queryWeekData:(id)sender {
    [self showAlertView];
}
-(void)showAlertView{
    NSLog(@"showAlertView");
    UIView* backGroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 150)];
    backGroundView.backgroundColor=[UIColor whiteColor];
    CustomIOS7AlertView* al=[[CustomIOS7AlertView alloc]init];
    al.parentView=self.view;
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    titleLabel.text=@"请选择时间";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.backgroundColor=[UIColor colorWithRed:0.396 green:0.788 blue:0.996 alpha:1];
    titleLabel.textColor=[UIColor whiteColor];
    [backGroundView addSubview:titleLabel];
    
    UILabel* start=[[UILabel alloc]initWithFrame:CGRectMake(10, 50, 60, 30)];
    start.text=@"开始时间";
    start.textAlignment=NSTextAlignmentLeft;
    start.textColor=[UIColor blackColor];
    start.font=[UIFont systemFontOfSize:14.0];
    [backGroundView addSubview:start];
    
    UILabel* startTF=[[UILabel alloc]initWithFrame:CGRectMake(80, 50, 100, 30)];
    startTF.font=[UIFont systemFontOfSize:14.0];
    startTF.tag=100;
    startTF.text=self.fromDate.text;
    startTF.userInteractionEnabled=YES;
    startTF.backgroundColor=[UIColor lightGrayColor];
    UITapGestureRecognizer* start_tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseDate:)];
    [startTF addGestureRecognizer:start_tap];
    [backGroundView addSubview:startTF];
    self.tempLb1=startTF;
    
    UILabel* end=[[UILabel alloc]initWithFrame:CGRectMake(10, 90, 60, 30)];
    end.text=@"结束时间";
    end.textAlignment=NSTextAlignmentLeft;
    end.textColor=[UIColor blackColor];
    end.font=[UIFont systemFontOfSize:14.0];
    [backGroundView addSubview:end];
    
    UILabel* endTF=[[UILabel alloc]initWithFrame:CGRectMake(80, 90, 100, 30)];
    endTF.tag=200;
    endTF.text=self.toDate.text;
    endTF.font=[UIFont systemFontOfSize:14.0];
    endTF.userInteractionEnabled=YES;
    endTF.backgroundColor=[UIColor lightGrayColor];
    UITapGestureRecognizer* end_tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseDate:)];
    [endTF addGestureRecognizer:end_tap];
    [backGroundView addSubview:endTF];
    self.tempLb2=endTF;
    
    al.containerView=backGroundView;
    NSArray* titles=@[@"关闭",@"查询"];
    al.buttonTitles=titles;
    al.delegate=self;
    [al show];
}
-(void)chooseDate:(UITapGestureRecognizer*) gesture{
     NSDateFormatter * frm=[[NSDateFormatter alloc]init];
    [frm setDateFormat:@"yyyy-MM-dd"];
    UIDatePicker* dp=[[UIDatePicker alloc]initWithFrame:CGRectMake(-20, 40, [UIScreen mainScreen].bounds.size.width, 216)];
    dp.datePickerMode=UIDatePickerModeDate;
    
    if (gesture.view.tag==100) {
        UILabel* lab=(UILabel*)gesture.view;
        dp.date=[frm dateFromString:lab.text];
    }
    if (gesture.view.tag==200) {
        UILabel* lab=(UILabel*)gesture.view;
        dp.date=[frm dateFromString:lab.text];
    }
    if (IOS8_OR_LATER) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请选择时间\n\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [frm setDateFormat:@"YYYY-MM-dd"];
            if (gesture.view.tag==100) {
                
                ((UILabel*)gesture.view).text=[frm stringFromDate:dp.date];
            }
            if (gesture.view.tag==200) {
                ((UILabel*)gesture.view).text=[frm stringFromDate:dp.date];
            }
        }];
        [alertController.view addSubview:dp];
        [alertController addAction:cancleAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:@"请选择时间\n\n\n\n\n\n\n\n\n\n\n\n"] delegate:self cancelButtonTitle:@"确定" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        [dp addTarget:self action:@selector(datePickerValueChanged:WithGesture:) forControlEvents:UIControlEventValueChanged];
        [sheet addSubview:dp];
        if (gesture.view.tag==100) {
            
            dp.minuteInterval=1;
        }
        if (gesture.view.tag==200) {
            dp.minuteInterval=2;
        }
        
        [sheet showFromToolbar:self.navigationController.toolbar];
    }
    
}
-(void)datePickerValueChanged:(UIDatePicker*)sender WithGesture:(UITapGestureRecognizer*)gesture
{
    NSDateFormatter * frm=[[NSDateFormatter alloc]init];
    [frm setDateFormat:@"YYYY-MM-dd"];
    if (sender.minuteInterval==1) {
        self.tempLb1.text=[frm stringFromDate:sender.date];
    }
    if (sender.minuteInterval==2) {
        self.tempLb2.text=[frm stringFromDate:sender.date];
    }

}
- (void)customIOS7dialogButtonTouchUpInside:(CustomIOS7AlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        [alertView close];
    }
    if (buttonIndex==1) {
        
        NSArray* arr=alertView.containerView.subviews;
        for (UIView *view in arr) {
            if (view.tag==100) {
                self.fromDate.text=((UILabel*)view).text;
            }
            if (view.tag==200) {
             self.toDate.text =((UILabel*)view).text;
            }
        }
        [self loadDataWithStartDate:self.fromDate.text EndDate:self.toDate.text ];
        [alertView close];
    }
    
}

@end
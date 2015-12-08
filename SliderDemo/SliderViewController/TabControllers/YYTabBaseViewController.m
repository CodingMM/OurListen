#import "YYTabBaseViewController.h"
#import "LeftViewController.h"
#import "SliderViewControllerHeader.h"
#import "MainTabViewController.h"

@interface YYTabBaseViewController ()

@end

@implementation YYTabBaseViewController

-(void)dealloc
{

    
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
       
    }
    return self;
}
-(void)tapedAddIcon:(id)sender
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    _nav = [[YYNavView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, 64 * SCREEN_SIZE.height/568)];
    _nav.backgroundColor = [UIColor colorWithRed:234/255.0f green:114/255.0f blue:66/255.0f alpha:1];
    [_nav.leftButton setImage:[UIImage imageNamed:@"nav_more"] forState:UIControlStateNormal];
    [_nav.leftButton setImage:[UIImage imageNamed:@"nav_more_clicked"]forState:(UIControlStateHighlighted)];
    [_nav.leftButton addTarget:self action:@selector(showLeftViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIImage *rightImage = [UIImage imageNamed:@"nav_message"];
    [_nav.rightButton setImage:rightImage forState:UIControlStateNormal];
    [_nav.rightButton setImage:[UIImage imageNamed:@"nav_message_clicked"] forState:(UIControlStateHighlighted)];
    _nav.rightButton.frame =CGRectMake(_nav.rightButton.frame.origin.x + 8, (_nav.frame.size.height - (rightImage.size.height/2/1.5))/2 + 8, rightImage.size.width/2/1.5, rightImage.size.height/2/1.5);
    [_nav.rightButton addTarget:self action:@selector(enterMessageVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nav];
     */
    
    headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, MaxMoveY)];
    headerView.backgroundColor = [UIColor colorWithRed:234/255.0f green:114/255.0f blue:66/255.0f alpha:1];

    dataTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_SIZE.width, SCREEN_SIZE.height - 64- TabarHeight) style:UITableViewStylePlain];
    dataTable.indicatorStyle=UIScrollViewIndicatorStyleWhite;
    dataTable.delegate = self;
    dataTable.dataSource = self;
    dataTable.tableHeaderView = headerView;
    dataTable.backgroundColor = sliderViewColor;
    dataTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:dataTable];
   
    


    MainTabViewController *mainVC = [MainTabViewController getMain];
    [mainVC.tabBarController.view addSubview:roundView];
    [mainVC.tabBarController.view addSubview:addBtn];
    NSLog(@"%f,%f,%f,%f",roundView.frame.origin.x,roundView.frame.origin.y,roundView.frame.size.width,roundView.frame.size.height);
    
    roundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapAddIcon = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapedAddIcon:)];
    tapAddIcon.numberOfTapsRequired = 1;
    tapAddIcon.numberOfTouchesRequired =1;
    [roundView addGestureRecognizer:tapAddIcon];
    
    _titleL = [[UILabel alloc]initWithFrame:CGRectMake(70 * SCREEN_SIZE.width/320, 64 + headerView.frame.size.height /2- 15, 150, 30)];
    _titleL.textColor = [UIColor whiteColor];
    _titleL.font = [UIFont boldSystemFontOfSize:19];
    _titleL.textAlignment = NSTextAlignmentLeft;
    _titleL.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_titleL];
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0f green:114/255.0f blue:66/255.0f alpha:1];
    self.view.backgroundColor = sliderViewColor;
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    roundView.hidden = YES;
    addBtn.hidden = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    roundView.hidden = NO;
    addBtn.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)enterMessageVC:(id)sender
{
    
}
#pragma mark UITableView DataSourse Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = @"滚动动画";
    return cell;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
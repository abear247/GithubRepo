//
//  ViewController.m
//  GithubRepo
//
//  Created by Alex Bearinger on 2017-01-30.
//  Copyright © 2017 Alex Bearinger. All rights reserved.
//

#import "ViewController.h"
#import "TableViewCell.h"
#import "Repo.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *repos;
@property NSMutableArray *repoObjects;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSURL *url = [NSURL URLWithString:@"https://api.github.com/users/abear247/repos"];
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error){
        
        if(error){
            NSLog(@"error: %@", error.localizedDescription);
            return;
        }
        
        NSError *jsonError = nil;
        self.repos = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        
        
        if(jsonError){
            NSLog(@"jsonError: %@",jsonError.localizedDescription);
            return;
        }
        self.repoObjects = [NSMutableArray new];
        for (NSDictionary *repo in self.repos){
            Repo *newRepo = [Repo new];
            newRepo.name = repo[@"name"];
        //    NSString *repoName = repo[@"name"];
            NSLog(@"Repo: %@",newRepo.name);
            [self.repoObjects addObject:newRepo];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tableView reloadData];
            }];
        }
        
    }];
    [dataTask resume];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.repoLabel.text = self.repos[indexPath.item][@"name"];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.repos.count;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

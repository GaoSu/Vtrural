//
//  SelectShiPinViewController.m
//  yinxin
//
//  Created by handong001 on 16/11/4.
//  Copyright © 2016年 RWN. All rights reserved.
//

#import "SelectShiPinViewController.h"
#import "SelectShipinCell.h"
#import <Photos/Photos.h>
#import "ShiPinModel.h"
//#import <BaiduBCEBasic/BaiduBCEBasic.h>
//#import <BaiduBCEBOS/BaiduBCEBOS.h>
#import "KYLocalVideoPlayVC.h"

typedef void(^ResultPath)(NSString *filePath, NSString *fileName);
static NSString *cellID = @"selectShipin";
@interface SelectShiPinViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,ReturnBarButtonDelegate>{

//    MPMoviePlayerViewController * _moviePlayerController;

}


@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)UICollectionView * collectionView;

@property(nonatomic,strong)NSMutableArray *selectedArray;
@end

@implementation SelectShiPinViewController

//-(instancetype)init{
//    if (self = [super init]) {
//        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self];
//        self.nav = nav;
//        [self setNav];
//        [self setUI];
//    }
//    
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    [self setNav];
    [self setUI];
    [self getBenDiVideo];
}


//获取本地的视频
-(void)getBenDiVideo{

     dispatch_async(dispatch_get_main_queue(), ^{
         [SVProgressHUD showWithStatus:@"加载中"];
//      [MBProgressHUD showMessage:@"加载中" toView:self.view];
         
      });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
     
        // 获得所有的自定义相簿
        PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumVideos options:nil];
        // 遍历所有的自定义相簿
        for (PHAssetCollection *assetCollection in assetCollections) {
            [self enumerateAssetsInAssetCollection:assetCollection original:NO];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:self.view];
            [SVProgressHUD dismiss];
            
            [self.collectionView reloadData];
        });
        
        
    });
    
   
    
}

//3.遍历相册
/**
 *  遍历相簿中的所有图片
 *  @param assetCollection 相簿
 *  @param original        是否要原图
 */
- (void)enumerateAssetsInAssetCollection:(PHAssetCollection *)assetCollection original:(BOOL)original
{
    
//    NSLog(@"相簿名:%@", assetCollection.localizedTitle);
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    // 同步获得图片, 只会返回1张图片
    options.synchronous = YES;
    
    // 获得某个相簿中的所有PHAsset对象
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    for (PHAsset *asset in assets) {
        
        ShiPinModel * model=[[ShiPinModel alloc] init];
        model.asset=asset;
//        [self getVideoPathFromPHAsset:asset Complete:^(NSString *filePath, NSString *fileName) {
//            model.fileName=fileName;
//            model.filePath=filePath;
        
            // 是否要原图
//            CGSize size = original ? CGSizeMake(asset.pixelWidth, asset.pixelHeight) : CGSizeMake(50, 50);
             CGSize size =  CGSizeMake(asset.pixelWidth*0.2, asset.pixelHeight*0.2) ;
        
            // 从asset中获得图片
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
                if ([[info valueForKey:@"PHImageResultIsDegradedKey"]integerValue]==0){
                    // Do something with the FULL SIZED image
                    
                    NSLog(@"12345");
                    model.pic=result;
                    [self.dataArray addObject:model];
                } else {
                    
                    NSLog(@"4444444");
                    
                    // Do something with the regraded image
                }
//
                
            }];
            
        
            
//        }];
        
        
    }
    
}

- (void)getVideoPathFromPHAsset:(PHAsset *)asset Complete:(ResultPath)result {
    
    NSArray *assetResources = [PHAssetResource assetResourcesForAsset:asset];
    PHAssetResource *resource;
    
    for (PHAssetResource *assetRes in assetResources) {
        if (assetRes.type == PHAssetResourceTypePairedVideo ||
            assetRes.type == PHAssetResourceTypeVideo) {
            resource = assetRes;
        }
    }

    
    NSString *fileName =[NSString stringWithFormat:@"v%@.mov",[self uuidString]];
    if (asset.mediaType == PHAssetMediaTypeVideo || asset.mediaSubtypes == PHAssetMediaSubtypePhotoLive) {
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHImageRequestOptionsVersionCurrent;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        
        NSString *PATH_MOVIE_FILE = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        [[NSFileManager defaultManager] removeItemAtPath:PATH_MOVIE_FILE error:nil];
        [[PHAssetResourceManager defaultManager] writeDataForAssetResource:resource
                                                                    toFile:[NSURL fileURLWithPath:PATH_MOVIE_FILE]
                                                                   options:nil
                                                         completionHandler:^(NSError * _Nullable error) {
                                                             if (error) {
                                                                 result(nil, nil);
                                                             } else {
                                                                 result(PATH_MOVIE_FILE, fileName);
                                                             }
                                                         }];
    } else {
        result(nil, nil);
    }
}
//iOS生成一个32位的UUID
- (NSString *)uuidString

{
    
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    
    CFRelease(uuid_ref);
    
    CFRelease(uuid_string_ref);
    
    return [uuid lowercaseString];
    
}


#pragma mark=======================UI相关==========================================
#pragma mark--设置导航试图
-(void)setNav{
    self.navigationItem.title=@"选择视频";
    
    // 添加右侧的按钮
//    UIButton *rightbtn=[[UIButton alloc] initWithFrame:CGRectMake(13, 30, 40, 15)];
//    //    [rightbtn setImage:[UIImage imageNamed:@"icon_tianjia"] forState:UIControlStateNormal];
//    [rightbtn setTitle:@"上传" forState:UIControlStateNormal];
//    rightbtn.titleLabel.font=[UIFont systemFontOfSize:15];
//    [rightbtn setTitleColor:[UIColor hexStringToColor:@"#cdcdcd"] forState:UIControlStateNormal];
//    [rightbtn addTarget:self action:@selector(WanchengAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc] initWithCustomView:rightbtn];
//    self.navigationItem.rightBarButtonItem=rightBar;
    
    //
    UIButton *rightbtn=[[UIButton alloc] initWithFrame:CGRectMake(13, 30, 40, 15)];
    //    [rightbtn setImage:[UIImage imageNamed:@"icon_tianjia"] forState:UIControlStateNormal];
    [rightbtn setTitle:@"完成" forState:UIControlStateNormal];
    rightbtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [rightbtn setTitleColor:[UIColor hexStringToColor:@"#cdcdcd"] forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(btnClickedToChooseVideo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar=[[UIBarButtonItem alloc] initWithCustomView:rightbtn];
    self.navigationItem.rightBarButtonItem=rightBar;
    //
    
    
    ReturnBarButtonItem *retu=[[ReturnBarButtonItem alloc] init];
    retu.delegate=self;
    self.navigationItem.leftBarButtonItem=retu;
    
}

-(void)didClickReturnItem:(ReturnBarButtonItem *)buttonItem{

    [self.navigationController popViewControllerAnimated:YES];

}


#pragma mark--设置UI视图
-(void)setUI{
    
    //collectionView
    UICollectionViewFlowLayout * mycollectionViewLayout = [[UICollectionViewFlowLayout alloc]init];
    mycollectionViewLayout.minimumInteritemSpacing = 3;
    mycollectionViewLayout.minimumLineSpacing = 3;
    mycollectionViewLayout.itemSize = CGSizeMake((ScreenWidth - 12) / 3, (ScreenWidth-12) /3);
    mycollectionViewLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    mycollectionViewLayout.sectionInset = UIEdgeInsetsMake(5,3,5,3);
    UICollectionView *mycolletionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) collectionViewLayout:mycollectionViewLayout];
    mycolletionView.delegate = self;
    mycolletionView.dataSource = self;
    [mycolletionView registerNib:[UINib nibWithNibName:@"SelectShipinCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    mycolletionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mycolletionView];
    self.collectionView=mycolletionView;
    
    
}
#pragma mark========完成=====
//update by yuanchaofan
-(void)btnClickedToChooseVideo:(UIButton *)sender
{
    if (self.selectedArray.count==0) {
        [SVProgressHUD showErrorWithStatus:@"请选择一个视频"];

        
        return ;
    }

     //未压缩的视频
    __weak typeof(self)weakSelf = self;
     ShiPinModel *model = [self.selectedArray firstObject];
     [self getVideoPathFromPHAsset:model.asset Complete:^(NSString *filePath, NSString *fileName) {
     
     
     model.filePath=filePath;
     model.fileName=fileName;
         if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(selectedVideoArray:)])
         {

             [weakSelf.delegate selectedVideoArray:weakSelf.selectedArray];
             [weakSelf.navigationController popViewControllerAnimated:YES];

         }

     
     }];

    
//    //压缩视频
//    __block ShiPinModel *model = [self.selectedArray firstObject];
//    
//    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
//    options.version = PHVideoRequestOptionsVersionOriginal;
//    
//    __weak typeof(self)weakSelf = self;
//    
//    [[PHImageManager defaultManager] requestAVAssetForVideo:model.asset options:options resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
//        
//        if ([asset isKindOfClass:[AVURLAsset class]]) {
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                
//                NSURL *localVideoUrl = [(AVURLAsset *)asset URL];
//                
//                [JFCompressionVideo compressedVideoOtherMethodWithURL:localVideoUrl compressionType:AVAssetExportPresetMediumQuality compressionResultPath:^(NSString *resultPath, float memorySize, NSString *fileName) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        model.fileName=fileName;
//                        model.filePath=resultPath;
//                        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(selectedVideoArray:)])
//                        {
//                            
//                            [weakSelf.delegate selectedVideoArray:weakSelf.selectedArray];
//                            [weakSelf.navigationController popViewControllerAnimated:YES];
//                            
//                        }
//                    });
//                }];
//                
//                
//                
//            });
//        }
//    }];
    
    
    

}
//
-(void)WanchengAction:(UIButton *)button{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (self.selectedArray.count==0) {
            [SVProgressHUD showErrorWithStatus:@"请选择一个视频"];
//            [MBProgressHUD showError:@"请选择一个视频"];
            
            return ;
        }
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showProgress:0 status:@"上传进度"];
//        [MBProgressHUD showMessage:@"上传中" toView:self.view];
       
            [self uploadVideo];
     
    });
    
}

-(void)uploadVideo{

    /*
     //未压缩的视频
    ShiPinModel *model = [self.selectedArray firstObject];
    [self getVideoPathFromPHAsset:model.asset Complete:^(NSString *filePath, NSString *fileName) {
        
        
        model.filePath=filePath;
        model.fileName=fileName;
        
         [self uploadBaiduYun];
    
    }];
    */
    

    
    //压缩视频
    __block ShiPinModel *model = [self.selectedArray firstObject];

    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    
    __weak typeof(self)weakSelf = self;
    
    [[PHImageManager defaultManager] requestAVAssetForVideo:model.asset options:options resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
        
        if ([asset isKindOfClass:[AVURLAsset class]]) {

            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                NSURL *localVideoUrl = [(AVURLAsset *)asset URL];
                
                [JFCompressionVideo compressedVideoOtherMethodWithURL:localVideoUrl compressionType:AVAssetExportPresetMediumQuality compressionResultPath:^(NSString *resultPath, float memorySize, NSString *fileName) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        model.fileName=fileName;
                        model.filePath=resultPath;
//                        [self uploadBaiduYunWithName:fileName];
                    });
                }];
                
               
                
            });
        }
    }];
    
    
    
}





//-(void)uploadBaiduYunWithName:(NSString*)name{
//    
//    
////    NSString *name = [NSString stringWithFormat:@"v%@.mov",[self uuidString]];
//    
//    ShiPinModel *model = [self.selectedArray firstObject];
//    BCECredentials* credentials = [[BCECredentials alloc] init];
//    credentials.accessKey = @"5d15553712d4421098b34bbf1439bbb4";
//    credentials.secretKey = @"61022523edcd43fd9f95dc590669257d";
//    
//    BOSClientConfiguration* configuration = [[BOSClientConfiguration alloc] init];
//    configuration.endpoint = @"https://bj.bcebos.com";
//    configuration.credentials = credentials;
//    
//    BOSClient* client = [[BOSClient alloc] initWithConfiguration:configuration];
//    
//    // 初始化分块上传
//    BOSInitiateMultipartUploadRequest* initMPRequest = [[BOSInitiateMultipartUploadRequest alloc] init];
//    initMPRequest.bucket = @"yinxinvdo";
////    initMPRequest.key = [NSString stringWithFormat:@"%@",model.fileName];
//     initMPRequest.key = name;
//    initMPRequest.contentType = @".mov";
//    
//    __block BOSInitiateMultipartUploadResponse* initMPResponse = nil;
//    BCETask* task = [client initiateMultipartUpload:initMPRequest];
//    task.then(^(BCEOutput* output) {
//        if (output.response) {
//            initMPResponse = (BOSInitiateMultipartUploadResponse*)output.response;
//            NSLog(@"initiate multipart upload success!");
//        }
//        
//        if (output.error) {
//            NSLog(@"initiate multipart upload failure");
//            
//            [MBProgressHUD hideHUDForView:self.view];
//            [MBProgressHUD showError:@"上传失败"];
//            
////            [SVProgressHUD dismiss];
////            [SVProgressHUD showErrorWithStatus:@"上传失败"];
//        }
//    });
//    [task waitUtilFinished];
//    
//    NSString* uploadID = initMPResponse.uploadId;
//    
//    // 计算分块个数
//    NSString* file = [NSString stringWithFormat:@"%@",model.filePath];
//    NSDictionary<NSString*, id>* attr = [[NSFileManager defaultManager] attributesOfItemAtPath:file error:nil];
//    uint64_t fileSize = attr.fileSize;
//    uint64_t partSize = 1024 * 1024 * 5L;
//    uint64_t partCount = fileSize / partSize;
//    if (fileSize % partSize != 0) {
//        ++partCount;
//    }
//    
//    NSMutableArray<BOSPart*>* parts = [NSMutableArray array];
//    
//    NSFileHandle* handle = [NSFileHandle fileHandleForReadingAtPath:[NSString stringWithFormat:@"%@",model.filePath]];
//    for (uint64_t i = 0; i < partCount; ++i) {
//        // seek
//        uint64_t skip = partSize * i;
//        [handle seekToFileOffset:skip];
//        uint64_t size = (partSize < fileSize - skip) ? partSize : fileSize - skip;
//        
//        // data
//        NSData* data = [handle readDataOfLength:size];
//        
//        // request
//        BOSUploadPartRequest* uploadPartRequest = [[BOSUploadPartRequest alloc] init];
//        uploadPartRequest.bucket = @"yinxinvdo";
//        uploadPartRequest.key = name;
//        uploadPartRequest.objectData.data = data;
//        uploadPartRequest.partNumber = i + 1;
//        uploadPartRequest.uploadId = uploadID;
//        
//        __block BOSUploadPartResponse* uploadPartResponse = nil;
//        task = [client uploadPart:uploadPartRequest];
//        task.then(^(BCEOutput* output) {
//            if (output.response) {
//                uploadPartResponse = (BOSUploadPartResponse*)output.response;
//                BOSPart* part = [[BOSPart alloc] init];
//                part.partNumber = i + 1;
//                part.eTag = uploadPartResponse.eTag;
//                [parts addObject:part];
//            }
//            if (output.progress) {
//                
////                dispatch_async(dispatch_get_main_queue(), ^{
////                    [SVProgressHUD showProgress:([output.progress floatValue]+i*100)/(100*partCount) status:@"上传进度"];
////                });
//    
//                // NSLog(@"%f",[output.progress floatValue]);
//            }
//            
//            if (output.error) {
//                [MBProgressHUD showError:@"上传失败"];
//                [MBProgressHUD hideHUDForView:self.view];
//            }
//            
//            
//        });
//        [task waitUtilFinished];
//    }
//    
//    BOSCompleteMultipartUploadRequest* compMultipartRequest = [[BOSCompleteMultipartUploadRequest alloc] init];
//    compMultipartRequest.bucket = @"yinxinvdo";
//    compMultipartRequest.key = name;
//    compMultipartRequest.uploadId = uploadID;
//    compMultipartRequest.parts = parts;
//    
//    __block BOSCompleteMultipartUploadResponse* complResponse = nil;
//    task = [client completeMultipartUpload:compMultipartRequest];
//    task.then(^(BCEOutput* output) {
//        if (output.response) {
//            complResponse = (BOSCompleteMultipartUploadResponse*)output.response;
//            NSLog(@"complte multiparts success!");
//            //移除自己复制的那一份视频
//            
////            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
////                [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@",model.filePath]  error:nil];
////            });
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
////                if (self.delegate && [self.delegate respondsToSelector:@selector(selectedVideoArray:)]) {
////                    
////                    [self.delegate selectedVideoArray:self.selectedArray];
////                    
////                }
//                
//                [self sendVideoWithCount:0];
//                
//                
//                [MBProgressHUD showSuccess:@"上传成功" toView:self.view];
//                [MBProgressHUD hideHUDForView:self.view];
//                
////                [self.navigationController popViewControllerAnimated:YES];
//                
//
//                
//            });
//        }
//        
//        if (output.error) {
//            NSLog(@"complte multiparts failure %@", output.error);
//        }
//    });
//    [task waitUtilFinished];
//
//}


//-(void)sendVideoWithCount:(NSInteger)count{
//    
////    [self.view endEditing:YES];
////    ShiPinModel *model=nil;
////    
////    if (self.collectionDataArray.count>count) {
////        model=self.collectionDataArray[count];
////    }
//      ShiPinModel *model = [self.selectedArray firstObject];
//    
//    //    NSIndexPath *index = [NSIndexPath indexPathForRow:self.sendCount inSection:0];
//    //    CommiteCell *cell = [self.collectionView cellForItemAtIndexPath:index];
////    if ([self.allType.titleLabel.text isEqualToString:@"请选择文件夹"]) {
////        [MBProgressHUD showError:@"请选择文件夹"];
////        return;
////    }
//    //    else if ([model.title isEqualToString:@""]){
//    //        [MBProgressHUD showError:@"请填写视频标题"];
//    //        return;
//    //    }
//    //    MyLog(@"您点击了上传按钮");
//    [MBProgressHUD showMessage:@"上传中" toView:self.view];
//    NSString *urlStr = [NSString stringWithFormat:@"%@mbRecord/auth/addRecord.json",ftpPath];
//    NSMutableDictionary *diction=[NSMutableDictionary dictionary];
//    NSString *token = [NSUserDefaults defaultToken];
//    diction[@"token"] = token;
//    [diction setValue:[NSString stringWithFormat:@"%@",self.folderId] forKey:@"folderid"];
//    // 文件夹id
////    if (self.isSearch || [self.type isEqualToString:@"1"]) {
////        
////        
////        [diction setValue:[NSString stringWithFormat:@"%ld",self.model.folderid] forKey:@"folderid"];
////        
////    }else if (self.isNewFloder){
////        [diction setValue:[NSString stringWithFormat:@"%ld",self.xinFloder.folderid] forKey:@"folderid"];
////    }else{
////        folderModel *folermodel = self.dataArray[self.selectIndexPath.row];
////        [diction setValue:[NSString stringWithFormat:@"%ld",folermodel.folderid] forKey:@"folderid"];
////    }
//    
//    
//    //记录类型 1：照片2：语音，3：视频，4：文字
//    [diction setValue:@"3" forKey:@"recordtype"];
//    // 图片的url
//    //    if (self.collectionDataArray.count > self.sendCount) {
//    [diction setValue:model.fileName forKey:@"memortydir"];
//    //    }else{
//    //        return;
//    //    }
//    // 文件名称
//    [diction setValue:@"" forKey:@"recordname"];
//    
//    [SPHttpWithYYCache postRequestUrlStr:urlStr withDic:diction success:^(NSDictionary *requestDic, NSString *msg) {
//        if ([requestDic[@"status"] intValue]==1) {
////            _sendCount ++;
////            if (_sendCount == self.collectionDataArray.count) {
//               [MBProgressHUD hideHUDForView:self.view];
//                [MBProgressHUD showSuccess:@"上传成功"];
//                [self removePhothWihtArray:self.selectedArray];
//                
////            }else{
////                [self sendVideoWithCount:_sendCount];
////            }
//            
//        }else{
//            NSString *error=requestDic[@"message"];
//            [MBProgressHUD showError:error];
//            [MBProgressHUD hideHUDForView:self.view];
//        }
//        
//    } failure:^(NSString *errorInfo) {
//        
//        [MBProgressHUD showError:errorInfo];
//        [MBProgressHUD hideHUDForView:self.view];
//    }];
//    
//    
//}

-(void)removePhothWihtArray:(NSMutableArray *)array{
    
//    if (array.count>_deleteCount) {
    
    
        ShiPinModel *model =array[0];
        PHAsset *asset=model.asset;
        [self  deleteVidelWithAsset:asset];
        
//    }
}



-(void)deleteVidelWithAsset:(PHAsset *)asselt{
    
    typeof(self)weakSelf=self;
    NSArray *delAssets = [[NSArray alloc] initWithObjects:asselt,  nil];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        [PHAssetChangeRequest deleteAssets:delAssets];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
//        _deleteCount++;
//        if (_deleteCount==self.collectionDataArray.count) {
        
            dispatch_async(dispatch_get_main_queue(), ^{
                
                                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(selectedVideoArray:)]) {
                
                                    [weakSelf.delegate selectedVideoArray:weakSelf.selectedArray];
                
                                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
            
//        }else{
//            
//            [weakSelf removePhothWihtArray:weakSelf.collectionDataArray];
//            
//        }
    }];
    
}




#pragma mark=======================代理事件相关==========================================
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SelectShipinCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.tag = 200 + indexPath.row;
    cell.isSelect = NO;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playVidel:)];
    [cell.shipinIcon addGestureRecognizer:tap];
    
    if (self.dataArray.count>indexPath.row) {
        
      ShiPinModel *model=self.dataArray[indexPath.row];
      cell.mainContentImg.image=model.pic;
      
        if (model.isSelected) {
        cell.isSelect=YES;
        }else{
        cell.isSelect=NO;
        }
        
//     for (ShiPinModel *seletedmodel in self.modelArray) {
//            if ([seletedmodel.pic isEqual:model.pic]) {
//                cell.isSelect=YES;
//            }else{
//              cell.isSelect=NO;
//            }
//        }
    }
    return cell;
}

-(void)playVidel:(UITapGestureRecognizer *)tap{

    SelectShipinCell *cell =(SelectShipinCell *)[ [tap.view superview] superview];
    NSIndexPath *path = [self.collectionView indexPathForCell:cell];
    
    if (self.dataArray.count>path.row) {
        
        ShiPinModel *model=self.dataArray[path.row];
        /*
        [self getVideoPathFromPHAsset:model.asset Complete:^(NSString *filePath, NSString *fileName) {
            
            KYLocalVideoPlayVC *pushViewController = [[KYLocalVideoPlayVC alloc] init];
            pushViewController.title = @"隐信视频";
            pushViewController.URLString=filePath;
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
            backItem.title = @"返回";
            self.navigationItem.backBarButtonItem = backItem;
            [self.navigationController pushViewController:pushViewController animated:YES];
            
            
            
        }];
         */
        
        PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
        options.version = PHVideoRequestOptionsVersionOriginal;
        
        [[PHImageManager defaultManager] requestAVAssetForVideo:model.asset options:options resultHandler:^(AVAsset *asset, AVAudioMix *audioMix, NSDictionary *info) {
            
            if ([asset isKindOfClass:[AVURLAsset class]]) {
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    NSURL *localVideoUrl = [(AVURLAsset *)asset URL];
                   
                    KYLocalVideoPlayVC *pushViewController = [[KYLocalVideoPlayVC alloc] init];
                    pushViewController.title = @"掌一眼短视频";
                    NSString *url=[localVideoUrl path];
                    model.fileUrl=url;
                    pushViewController.URLString=url;
                    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
                    backItem.title = @"返回";
                    self.navigationItem.backBarButtonItem = backItem;
                    [self.navigationController pushViewController:pushViewController animated:YES];
                });
                
                
            }
        }];
        
        
        
        
    }
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    SelectShipinCell *cell =[collectionView cellForItemAtIndexPath:indexPath];
    SelectShipinCell *cell = [self.view viewWithTag:200 + indexPath.row];
    
    
    ShiPinModel *model=self.dataArray[indexPath.row];
    if (cell.isSelect) {
        model.isSelected=NO;
        cell.isSelect = NO;
        [self.selectedArray removeObject:model];
    }else{
        
        if (self.selectedArray.count>0) {
            [SVProgressHUD showErrorWithStatus:@"最多选择一个视频"];
//            [MBProgressHUD showError:@"最多选择一个视频"];
            
            return;
        }
        model.isSelected=YES;
        cell.isSelect = YES;
        [self.selectedArray addObject:model];
    }
    
    
    
    
}

#pragma mark=======================其他常用相关==========================================
#pragma mark=======================懒加载相关==========================================

-(NSMutableArray *)dataArray{

    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;

}

-(NSMutableArray *)selectedArray{
    
    if (!_selectedArray) {
        _selectedArray=[NSMutableArray array];
    }
    return _selectedArray;
    
}

- (void) convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                         completeHandler:( void (^)(AVAssetExportSession*session))handler
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    //  NSLog(resultPath);
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         switch (exportSession.status) {
             case AVAssetExportSessionStatusCancelled:
                 NSLog(@"AVAssetExportSessionStatusCancelled");
                 break;
             case AVAssetExportSessionStatusUnknown:
                 NSLog(@"AVAssetExportSessionStatusUnknown");
                 break;
             case AVAssetExportSessionStatusWaiting:
                 NSLog(@"AVAssetExportSessionStatusWaiting");
                 break;
             case AVAssetExportSessionStatusExporting:
                 NSLog(@"AVAssetExportSessionStatusExporting");
                 break;
             case AVAssetExportSessionStatusCompleted:
                 NSLog(@"AVAssetExportSessionStatusCompleted");
                 NSLog(@"%@",[NSString stringWithFormat:@"%f s", [self getVideoLength:outputURL]]);
                 NSLog(@"%@", [NSString stringWithFormat:@"%.2f kb", [self getFileSize:[outputURL path]]]);
                 
                 //UISaveVideoAtPathToSavedPhotosAlbum([outputURL path], self, nil, NULL);//这个是保存到手机相册
                 
//                 [self alertUploadVideo:outputURL];
                 break;
             case AVAssetExportSessionStatusFailed:
                 NSLog(@"AVAssetExportSessionStatusFailed");
                 break;
         }
         
     }];
    
}


- (CGFloat) getFileSize:(NSString *)path
{
    NSLog(@"%@",path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024;
    }else{
        NSLog(@"找不到文件");
    }
    return filesize;
}//此方法可以获取文件的大小，返回的是单位是KB。
- (CGFloat) getVideoLength:(NSURL *)URL
{
    
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:URL];
    CMTime time = [avUrl duration];
    int second = ceil(time.value/time.timescale);
    return second;
}//此方法可以获取视频文件的时长。


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

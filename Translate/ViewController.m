//
//  ViewController.m
//  Translate
//
//  Created by CBK-Admin on 5/29/2560 BE.
//  Copyright © 2560 CBK-Admin. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

NSString *URL_STRING;

NSString *TR_URL_STRING;

NSString *GT_URL_STRING;
NSString *GOOGLE_KEY;

NSString *AZURE_URL_STRING;
NSString *AZURE_GET_TOKEN;
NSString *AZURE_KEY;
NSString *AZURE_TOKEN;

NSString *LANGUAGE_FROM;
NSString *LANGUAGE_TO;
NSString *TEXT;

NSArray *languageArray;
NSArray *languagePickerArray;

NSString *GoogleSegment;
NSString *TransltrSegment;
NSString *AzureSegment;

int segmentIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    languageArray = @[@"ja",@"th",@"en"];
    languagePickerArray = @[@"Japanese",@"Thai",@"English"];
    
    GOOGLE_KEY = @"AIzaSyBUW6u9suObXCKEufys_gjlduwd_Pu_EZ4";
    
    AZURE_KEY = @"96ca59a634a64c90b53477198726c852";
    AZURE_GET_TOKEN = @"https://api.cognitive.microsoft.com/sts/v1.0/issueToken";
    AZURE_URL_STRING = @"https://api.microsofttranslator.com/v2/http.svc/Translate?";
    
    
    
    TR_URL_STRING = @"http://www.transltr.org/api/translate?";
    GT_URL_STRING = @"https://www.googleapis.com/language/translate/v2?key=";
    GT_URL_STRING = [NSString stringWithFormat:@"%@%@",GT_URL_STRING,GOOGLE_KEY];
    
    segmentIndex = 0;
    
    URL_STRING = GT_URL_STRING;
    
    GoogleSegment = @"Google";
    TransltrSegment = @"Transltr";
    AzureSegment = @"Azure";
    
    [self getTokenAzure];
    
    [self setPickerView];
    
    self.outputTextfield.text = @"";

}

-(void)checklang{
    NSString *text = @"hello さようなら สวัสดี ÄÁÀãÃ";
    
    NSArray *tagschemes = [NSArray arrayWithObjects:NSLinguisticTagSchemeLanguage, nil];
    NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:tagschemes options:0];
    [tagger setString:text];
    NSString *language = [tagger tagAtIndex:0 scheme:NSLinguisticTagSchemeLanguage tokenRange:NULL sentenceRange:NULL];
    NSLog(@"language :%@",language);
}


-(void)LanguageValidation:(NSString *)text {
    
    NSString *trimmed = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSRegularExpression *japanRegex = [NSRegularExpression regularExpressionWithPattern:@"[ぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをんゔゕゖゝゞゟ゠ァアィイゥウェエォオカガキギクグケゲコゴサザシジスズセゼソゾタダチヂッツヅテデトドナニヌネノハバパヒビピフブプヘベペホボポマミムメモャヤュユョヨラリルレロヮワヰヱヲンヴヵヶヷヸヹヺ・ーヽヾヿ⺀⺁⺂⺃⺄⺅⺆⺇⺈⺉⺊⺋⺌⺍⺎⺏⺐⺑⺒⺓⺔⺕⺖⺗⺘⺙⺛⺜⺝⺞⺟⺠⺡⺢⺣⺤⺥⺦⺧⺨⺩⺪⺫⺬⺭⺮⺯⺰⺱⺲⺳⺴⺵⺶⺷⺸⺹⺺⺻⺼⺽⺾⺿⻀⻁⻂⻃⻄⻅⻆⻇⻈⻉⻊⻋⻌⻍⻎⻏⻐⻑⻒⻓⻔⻕⻖⻗⻘⻙⻚⻛⻜⻝⻞⻟⻠⻡⻢⻣⻤⻥⻦⻧⻨⻩⻪⻫⻬⻭⻮⻯⻰⻱⻲⻳⼀⼁⼂⼃⼄⼅⼆⼇⼈⼉⼊⼋⼌⼍⼎⼏⼐⼑⼒⼓⼔⼕⼖⼗⼘⼙⼚⼛⼜⼝⼞⼟⼠⼡⼢⼣⼤⼥⼦⼧⼨⼩⼪⼫⼬⼭⼮⼯⼰⼱⼲⼳⼴⼵⼶⼷⼸⼹⼺⼻⼼⼽⼾⼿⽀⽁⽂⽃⽄⽅⽆⽇⽈⽉⽊⽋⽌⽍⽎⽏⽐⽑⽒⽓⽔⽕⽖⽗⽘⽙⽚⽛⽜⽝⽞⽟⽠⽡⽢⽣⽤⽥⽦⽧⽨⽩⽪⽫⽬⽭⽮⽯⽰⽱⽲⽳⽴⽵⽶⽷⽸⽹⽺⽻⽼⽽⽾⽿⾀⾁⾂⾃⾄⾅⾆⾇⾈⾉⾊⾋⾌⾍⾎⾏⾐⾑⾒⾓⾔⾕⾖⾗⾘⾙⾚⾛⾜⾝⾞⾟⾠⾡⾢⾣⾤⾥⾦⾧⾨⾩⾪⾫⾬⾭⾮⾯⾰⾱⾲⾳⾴⾵⾶⾷⾸⾹⾺⾻⾼⾽⾾⾿⿀⿁⿂⿃⿄⿅⿆⿇⿈⿉⿊⿋⿌⿍⿎⿏⿐⿑⿒⿓⿔⿕]"
                                       
                                                                                options:0
                                                                                  error:nil];
    NSRegularExpression *thaiRegex = [NSRegularExpression regularExpressionWithPattern:@"[กขฃคฅงจฉชซฎฏฐฑฒณดตถทธนบปผฝพฟภมยรลวศษสหฬอฮฦัะา ิ ี ึ ื ุ ูำใไๆ่้๊๋๑๒๓๔๕๖๗๘๙๐]"
                                                                               options:0
                                                                                 error:nil];
    
    NSRegularExpression *englishRegex = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z]"
                                                                                  options:0
                                                                                    error:nil];

    double japanLetters = [japanRegex matchesInString:trimmed
                                              options:0
                                                range:NSMakeRange(0, trimmed.length)].count;
    
    double thaiLetters = [thaiRegex matchesInString:trimmed
                                              options:0
                                                range:NSMakeRange(0, trimmed.length)].count;
    
    double englishLetters = [englishRegex matchesInString:trimmed
                                              options:0
                                                range:NSMakeRange(0, trimmed.length)].count;
    
    NSUInteger characterCount = [trimmed length];
    double otherCharacter = characterCount-japanLetters-thaiLetters-englishLetters;
    
    NSLog(@"japanLetters :%f  = %.2f",japanLetters,japanLetters*100/characterCount);
    NSLog(@"thaiLetters :%f  = %.2f",thaiLetters,thaiLetters*100/characterCount);
    NSLog(@"englishLetters :%f  = %.2f",englishLetters,englishLetters*100/characterCount);
    NSLog(@"otherCharacter :%f  = %.2f",otherCharacter,otherCharacter*100/characterCount);

}

-(void)setPickerView{
    
    
    self.pickerViewTo = [[UIPickerView alloc] init];
    self.pickerViewTo.dataSource = self;
    self.pickerViewTo.delegate = self;
    self.pickerViewTo.tag = 1;
    self.pickerViewTo.showsSelectionIndicator = YES;
    
    self.pickerViewFrom = [[UIPickerView alloc] init];
    self.pickerViewFrom.dataSource = self;
    self.pickerViewFrom.delegate = self;
    self.pickerViewFrom.tag = 2;
    self.pickerViewFrom.showsSelectionIndicator = YES;
    
    self.toTextfield.inputView = self.pickerViewTo;
    self.fromTexfield.inputView = self.pickerViewFrom;
     
    
}
- (IBAction)segmentAction:(id)sender {
    
    NSString *title = [sender titleForSegmentAtIndex:_segment.selectedSegmentIndex];
    if ([title isEqualToString:GoogleSegment]) {
        segmentIndex = 0;
    }
    else if ([title isEqualToString:TransltrSegment]){
        segmentIndex = 1;
    }
    else{
        segmentIndex = 2;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 1) {
        self.toTextfield.text = [languagePickerArray objectAtIndex:row];
        LANGUAGE_TO = [languageArray objectAtIndex:row];
    }
    else if (pickerView.tag == 2) {
        self.fromTexfield.text = [languagePickerArray objectAtIndex:row];
        LANGUAGE_FROM = [languageArray objectAtIndex:row];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return languagePickerArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    return [languagePickerArray objectAtIndex:row];
    
    
}

-(void)changeDateFromLabel:(id)sender
{
    [self.toTextfield resignFirstResponder];
    [self.fromTexfield resignFirstResponder];
}

- (IBAction)translateButton:(id)sender {
    self.outputTextfield.text = @"";
    
    [self.inputTextfield resignFirstResponder];
    TEXT = self.inputTextfield.text;
    
    NSString *param;
    if (segmentIndex == 0) {
        param = [self gtTextParam];
        URL_STRING = GT_URL_STRING;
    }
    else if (segmentIndex == 1) {
        param = [self trTextParam];
        URL_STRING = TR_URL_STRING;
    }
    else {
        param = [self azTextParam];
        URL_STRING = AZURE_URL_STRING;
    }
    
    NSLog(@"%@",param);
    [self get:param];
    
    
//    NSDictionary *param = [self jsonParam];
//    [self post:param];
  
}

-(NSString*)azTextParam{
    
    return [NSString stringWithFormat:@"&text=%@&to=%@&from=%@",@"test",@"th",@"en"];
}

-(NSString*)trTextParam{
    return [NSString stringWithFormat:@"text=%@&to=%@&from=%@",TEXT,LANGUAGE_TO,LANGUAGE_FROM];
}

-(NSString*)gtTextParam{
    return [NSString stringWithFormat:@"&q=%@&target=%@&source=%@",TEXT,LANGUAGE_TO,LANGUAGE_FROM];
}


-(NSDictionary *)trJsonParam{
    
    NSDictionary *param =  @{
             @"text" : TEXT,
             @"from" : LANGUAGE_FROM,
             @"to" : LANGUAGE_TO
             };
    return param;
}

-(void)getTokenAzure{
        
        NSString *urlString = [AZURE_GET_TOKEN stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        [manager.requestSerializer setValue:AZURE_KEY forHTTPHeaderField:@"Ocp-Apim-Subscription-Key"];
        [manager.requestSerializer setValue:@"application/jwt" forHTTPHeaderField:@"Content-Type"];
    
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/jwt", nil];

    
        [manager POST:urlString parameters:@"" progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            AZURE_TOKEN = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"Azure Token :%@",AZURE_TOKEN);
            
            AZURE_TOKEN = [NSString stringWithFormat:@"&appid=Bearer %@",AZURE_TOKEN];
            AZURE_URL_STRING = [NSString stringWithFormat:@"%@%@",AZURE_URL_STRING,AZURE_TOKEN];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error: %@", error.description);
        }];
        
    
}

- (void)post:(NSDictionary*)param{
    
    NSString *urlString = [URL_STRING stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [manager POST:urlString parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"responseDictionary :%@",responseDictionary);
        
        NSString *translationText = [responseDictionary objectForKey:@"translationText"];
        NSLog(@"translationText :%@",translationText);
        
        self.outputTextfield.text = translationText;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error.description);
    }];

}
 

- (void)get:(NSString*)param{
   
    
    //NSString *string = [NSString stringWithFormat:@"%@%@",URL_STRING,param];
    //NSLog(@"request :%@",string);
    
    NSString *string = @"https://api.microsofttranslator.com/v2/http.svc/Translate?&appid=Bearer%20eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzY29wZSI6Imh0dHBzOi8vYXBpLm1pY3Jvc29mdHRyYW5zbGF0b3IuY29tLyIsInN1YnNjcmlwdGlvbi1pZCI6ImQ2ZDMzMTA0OGE5MDQwNDZiZjEwZTJmZmE5NGJhMzcwIiwicHJvZHVjdC1pZCI6IlRleHRUcmFuc2xhdG9yLkYwIiwiY29nbml0aXZlLXNlcnZpY2VzLWVuZHBvaW50IjoiaHR0cHM6Ly9hcGkuY29nbml0aXZlLm1pY3Jvc29mdC5jb20vaW50ZXJuYWwvdjEuMC8iLCJhenVyZS1yZXNvdXJjZS1pZCI6Ii9zdWJzY3JpcHRpb25zLzU4NjNmNWI0LTZiMjQtNGViOS04YzM1LTkzZGY1YzE3Zjc4OS9yZXNvdXJjZUdyb3Vwcy9DQksvcHJvdmlkZXJzL01pY3Jvc29mdC5Db2duaXRpdmVTZXJ2aWNlcy9hY2NvdW50cy9UcmFuc2xhdGUiLCJpc3MiOiJ1cm46bXMuY29nbml0aXZlc2VydmljZXMiLCJhdWQiOiJ1cm46bXMubWljcm9zb2Z0dHJhbnNsYXRvciIsImV4cCI6MTQ5ODczMDQ1NH0.ZYuDCMb9cdgpBMi3F42lHwbmTJF8a0G2I0lb3xcEx9Y&text=Test%20lockscreen&to=th&from=en";
    NSString *urlString = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //[manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject :%@",responseObject);
        
        if ([URL_STRING isEqualToString:GT_URL_STRING]) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSDictionary *data = responseDictionary[@"data"];
            NSArray *translations = data[@"translations"];
            for (NSDictionary *translation in translations) {
//                NSString *detectedLanguage = translation[@"detectedSourceLanguage"];
                NSString *translatedText = translation[@"translatedText"];
                self.outputTextfield.text = translatedText;
            }
        }
        else if ([URL_STRING isEqualToString:TR_URL_STRING]) {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            NSString *translationText = [responseDictionary objectForKey:@"translationText"];
            self.outputTextfield.text = translationText;
        }
        else{
            NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            NSString *haystack = responseString;
            NSString *haystackPrefix = @"<string xmlns=""http://schemas.microsoft.com/2003/10/Serialization/"">";
            NSString *haystackSuffix = @"</string>";
            NSRange needleRange = NSMakeRange(haystackPrefix.length,
                                              haystack.length - haystackPrefix.length - haystackSuffix.length);
            NSString *needle = [haystack substringWithRange:needleRange];
            NSRange range = [needle rangeOfString:@""">"];
            NSString *substring = [[needle substringFromIndex:NSMaxRange(range)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            self.outputTextfield.text = substring;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error.description);
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  ViewController.m
//  13gennaioTapChallenge
//
//  Created by Maurizio on 13/01/17.
//  Copyright © 2017 Maurizio. All rights reserved.
//

#import "ViewController.h"

#define GameTimer 1
#define GameTime 3
#define FirstAppLaunch @"FirstAppLaunch"

@interface ViewController () {
    int _tapsCount;
    int _timeCount;
    NSTimer *_gameTimer;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initializeGame];
}

-(void) viewDidAppear:(BOOL)animated {
    if ([self firstAppLaunch]) {
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:FirstAppLaunch];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        int risultato = [self risultato];
        if (risultato > 0) {
            [self mostraUltimoRisultato:risultato];
        }
    }
    
    if ([self risultato] != 0) {
        [self mostraUltimoRisultato:[self risultato]];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initializeGame {
    _tapsCount = 0;
    _timeCount = GameTime;
    [self.tapsCountLabel setText:@"Tap to play"];
    
    [self.timeLabel setText:@"Time Challenge"];
    
}

#pragma mark -Actions
-(IBAction)buttonPressed:(id)sender {
    NSLog(@"buttonPressed: %i", _tapsCount);
    
    //crea il timer solo una volta
    if (_gameTimer == nil) {
        _gameTimer = [NSTimer scheduledTimerWithTimeInterval:GameTimer target:self selector:@selector(timerTick) userInfo:(nil) repeats:(true)];
    }
    
    //incrementa il contatore
    _tapsCount++;
    //aggiorna il valore della label
    [self.tapsCountLabel setText:[NSString stringWithFormat:@"%i",_tapsCount ]];
}

- (void) timerTick {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    _timeCount --;
    //aggiorna i secondi rimanenti
    [self.timeLabel setText:[NSString stringWithFormat:@"%i sec",_timeCount]];
    
    if (_timeCount == 0) {
        //invalida il timer
        [_gameTimer invalidate];
        _gameTimer = nil;
        
        NSString *message = [NSString stringWithFormat:@"Hai fatto %i taps",_tapsCount];
        UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Game Over" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Chiudi" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //salva il risultato
            [self salvaRisultato];
            
            [self initializeGame];
            NSLog(@"ok premuta");
        }];
        [alertViewController addAction: okAction];
        [self presentViewController:alertViewController animated:true completion:nil];
    }
}

#pragma mark - Persistenza
- (void) mostraUltimoRisultato:(int) risultato {
    //voglio che un UIalert controller mi mostri all'avvio dell'app il precedente risultato dell'utente
    NSString *message = [NSString stringWithFormat:@"La precedente partita hai fatto %i taps",risultato];
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Game Over" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Chiudi" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    
    }];
    [alertViewController addAction: okAction];
    [self presentViewController:alertViewController animated:true completion:nil];
    
    
}


- (int) risultato {
    //ricavo i dati salvati dali userDefaults
    int value = (int) [[NSUserDefaults standardUserDefaults] integerForKey:@"TapsCount"];
    //loggo la variabile
    NSLog(@"VALORE USER DEFAULTS %i",value);
    
    return value;

}

- (void)salvaRisultato {
    [[NSUserDefaults standardUserDefaults] setInteger:_tapsCount forKey:@"TapsCount"];
    //syncronize forza la scrittura sul disco
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(bool) firstAppLaunch {
    return [[NSUserDefaults standardUserDefaults] boolForKey:FirstAppLaunch];
}

@end

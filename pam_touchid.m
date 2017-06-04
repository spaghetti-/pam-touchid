#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

#define PAM_SM_AUTH

#include <security/pam_appl.h>
#include <security/pam_modules.h>


typedef enum {
  RESULT_NONE,
  RESULT_ALLOWED,
  RESULT_FAILED
} TouchIdResult;


int pam_sm_authenticate(pam_handle_t* pamh, int flags,
                        int argc, const char** argv)
{
  uid_t _uid = geteuid();
  gid_t _gid = getegid();
  seteuid(501); // alex
  setegid(20); // staff

  LAContext* ctx = [[LAContext alloc] init];
  const bool can_auth = [ctx 
    canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:nil];
  if (!can_auth) return PAM_AUTH_ERR;

  __block TouchIdResult result = RESULT_NONE;

  [ctx evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics 
      localizedReason:@"sudo" reply:^(BOOL success, NSError * _Nullable error) {
        result = success ? RESULT_ALLOWED : RESULT_FAILED;
        CFRunLoopWakeUp(CFRunLoopGetCurrent());
  }];

  while (result == RESULT_NONE) {
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0, true);
  }

  seteuid(_uid);
  setegid(_gid);

  return result == RESULT_ALLOWED ? PAM_SUCCESS : PAM_AUTH_ERR;
}


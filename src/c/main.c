#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#if defined _WIN32 || defined _WIN64
#    include "libdemo_windows.h"
#elif defined __APPLE__ || defined __MACH__
#    include "libdemo_darwin.h"
#elif defined unix || defined __unix__ || defined __unix
#    include "libdemo_linux.h"
#endif

//  convert str to GoString
void str2GoString(char *str, GoString *gostr)
{
    gostr->p         = str;
    gostr->n         = strlen(str);
}

//  convert GoString to str
void GoString2str(GoString *gostr, char* cstr)
{
    memcpy(cstr, gostr->p, gostr->n);
    cstr[gostr->n]   = '\0';
}

int main()
{
    // Define parameters
    unsigned char p0 = 1 == 0;
    int p1           = 128;
    float p2         = 128.256;
    double p3        = 128.2565121024;
    GoString p4;
    str2GoString("Test of string.", &p4);

    // Print massage
    printf("#########################################\n");
    printf("### C/C++ Calling Golang Shared-C lib ###\n");
    printf("#########################################\n");

    // Call the external functions
    //   Function "Test" to print "Test of the demo"
    Test();
    //   Function "TestBoolean" to print the bool parameter (unsigned char)
    TestBoolean(p0);
    //   Function "TestInt" to print the int parameter
    TestInt(p1);
    //   Function "TestFloat" to print the float parameter
    TestFloat(p2);
    //   Function "TestDouble" to print the double parameter
    TestDouble(p3);
    //   Function "TestString" to print the string parameter (GoString)
    TestString(p4);
    //   Function "GetString" with an int parameter
    GoString gostr = GetString(1);

    // Convert to char* end with '\0'
    char* cstr = (char*)malloc(gostr.n + 1);
    if (cstr) {
        GoString2str(&gostr, cstr);
        printf("%s\n", cstr);
        free(cstr);
    }

    return 0;
}
#include <stdio.h>

int main(int argc, char *argv[])
{
    if (argc == 1)
        fprintf(stderr,"Missing args:\n");
    
    int i = 1;
    while(i++ < argc){
        printf("Arg: [%03d]:%s\n",i,*++argv);
    }
    
    int c;

    while( (c = getchar()) != EOF){
        putchar(c);
    }
    printf("\n");

    return 0;
}
#include <stdio.h>     /* for printf */
#include <stdlib.h>    /* for exit */
#include <unistd.h>    /* for getopt */
#include <string.h>

main(argc, argv)
int argc; char *argv[];
{

     int i;
     for (i = 1; i < argc; ) {
    /*  in printf: % + another character means write to stdout 
     *	the 's' in this example is the specifier, denotes the data type
	(s)tring, (f)loat, (d)ecimal or (i)nt, (c)har, (p)ointer addr
     */     
	printf("%s", argv[i]);
          if (++i < argc)
               putchar(' ');
     }

     putchar('\n');
     exit(0);
}


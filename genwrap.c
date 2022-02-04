/*

	The following configuration options are useful:

	-DALLOWFLAGS	Include if you want '-' to specify flags
	-DLEGALCHARS=\"string\"	Characters to allow in addition to letters/numbers
	-DMAXARGS=#	Maximum number of arguments
	-DMINARGS=#	Number of required arguments
	-DPATH=\"path\"	Full pathname to execute
	-DUSAGE=\"string\"	Description of arguments
	-DUSAGEOPTS=\"string\",\"string2\"...	Send these options to PATH instead of compiled in message
	-DUSERARG	Include the caller's username as the first arg

*/

#include <ctype.h>
#include <errno.h>
#include <memory.h>
#include <pwd.h>
#include <stdio.h>
#include <string.h>
#include <syslog.h>
#include <unistd.h>

#ifndef LEGALCHARS
#define LEGALCHARS ""
#endif

#ifndef MINARGS
#define MINARGS 1
#endif

#ifndef MAXARGS
#define MAXARGS MINARGS
#endif

#ifndef USAGE
#define USAGE "-flags arg1 arg2 etc"
#endif

int main(argc, argv)
	int argc;
	char *argv[];
{ char **arg,
       *l,
       *errmsg="",
       commandline[808]="";
  int err=0,
      suberr=0,
      len=0;
  struct passwd *pw;
  static char *e[] = { "PATH=/usr/bin:/usr/ucb","IFS=","SHELL=/bin/sh",NULL };
  char **execvect=argv;

#ifdef USAGEOPTS
  char *helpvect[] = { *argv, USAGEOPTS, NULL };
#endif

#ifdef USERARG
  char *argvect[argc+1];

  execvect=argvect;
  memcpy(argvect+2,argv+1,argc*sizeof(*argv));
  *argvect=*argv;

  if((pw=getpwuid(getuid())))
    argvect[1]=pw->pw_name;
  else
    argvect[1]="";
#else
  pw=getpwuid(getuid());
#endif

  if(!pw||!pw->pw_name)
  { err=5;
    errmsg="No password entry";
    suberr=getuid();
    execvect=NULL;
    fprintf(stderr,"I don't know who you are.\n");
  }

  if(!err&&strlen(pw->pw_name)>8)
  { err=6;
    errmsg="Username too long";
    suberr=strlen(pw->pw_name);
    execvect=NULL;
    pw=NULL;
    fprintf(stderr,"You are not a real user.\n");
  }

  if (!err&&--argc==1&&*argv[1]=='-'&&argv[1][1]=='h'&&!argv[1][2])
  { execvect=NULL;
    errmsg="Usage query";
    err=-1;
  }

  if (!err&&(argc<MINARGS||argc>MAXARGS))
  { execvect=NULL;
    fprintf(stderr,"Bad Usage.\n");
    errmsg="Illegal number of arguments";
    err=1;
    suberr=argc;
  }

  for(arg=execvect+1;!err&&*arg;arg++)
  { if((len+strlen(*arg))<799)
    { commandline[len]=' ';
      strcpy(commandline+len+1,*arg);
      len+=strlen(*arg)+1;
    } else if(len!=1025)
    { strcpy(commandline+len," ...");
      len=1025;
    }
    
#ifndef ALLOWFLAGS
      if(**arg=='-')
      { fprintf(stderr,"Flags are not allowed.\n");
        err=2;
        errmsg="Flags not allowed";
        suberr=(*arg)[1];
        execvect=NULL;
      }
#endif

    for(l=*arg;!err&&*l;l++)
      if(!isalnum((int)*l)&&!strchr(LEGALCHARS, (int) *l))
      { fprintf(stderr,"Character %02X is not allowed.\n", *l);
        err=3;
        suberr=*l;
        errmsg="Illegal Character";
        execvect=NULL;
      }
  }

  openlog(*argv,LOG_PID,LOG_AUTH);

  if(err&&pw)
    syslog(LOG_NOTICE,"User %s, %s (%d):%s",pw->pw_name,errmsg,suberr,commandline);

  if(err&&!pw)
    syslog(LOG_WARNING,"%s (%d):%s",errmsg,suberr,commandline);

  if(!execvect)
#ifndef USAGEOPTS
    fprintf(stderr, "Usage: %s %s\n",*argv,USAGE);
#else
    execvect=helpvect;
#endif

  if(execvect)
  { syslog(LOG_INFO,"User %s:%s",pw->pw_name,commandline);
#ifndef EFFECTIVE_ID_ONLY
    /* No work needed if we just want effective;
       kernel took care of that for us via set*id bits */
    setreuid(geteuid(),geteuid());
    setregid(getegid(),getegid());
#endif
    /*
	Please leave this commented out.  If is useful for debugging.  Just
	uncomment and rebuild to use.
    syslog(LOG_INFO,"User %s:%s uid: %d gid: %d",pw->pw_name,commandline,geteuid(),getegid()); */
    execve(PATH,execvect,e);

    fprintf(stderr,"Error executing script %s.  Contact support@shore.net\n",PATH);
#ifdef USERARG
    syslog(LOG_ERR,"Error executing script (%d, %m): uid %d gid %d: %s %s%s",errno,getuid(),getgid(),PATH,pw->pw_name,commandline);
#else
    syslog(LOG_ERR,"Error executing script (%d, %m): uid %d gid %d: %s%s",errno,getuid(),getgid(),PATH,commandline);
#endif
    exit(4);
  }

  exit(err);
}

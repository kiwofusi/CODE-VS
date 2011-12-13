
/**
 * CodeVS c sample
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(){
	int map,level,i,j;
	char buf[1024];

	fgets(buf,1024,stdin);
	map=atoi(buf);
	for(i=0;i<map;i++){
		char tmp[1024];
		while(1){
			fgets(tmp,1024,stdin);
			if(strcmp(tmp,"END\n")==0){
				level=atoi(buf);
				break;
			}else{
				strcpy(buf,tmp);
			}
		}
		for(j=0;j<level;j++){
			while(1){
				fgets(buf,1024,stdin);
				if(strcmp(buf,"END\n")==0){
					puts("0");
					fflush(stdout);
					break;
				}
			}
		}
	}
	return 0;
}

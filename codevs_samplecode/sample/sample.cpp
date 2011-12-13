
/**
 * CodeVS cpp sample
 */

#include <iostream>
#include <string>
#include <cstdlib>

using namespace std;

int main(){
	int map,level;
	string buf;
	getline(cin,buf);
	map=atoi(buf.c_str());
	for(int i=0;i<map;i++){
		while(true){
			string tmp;
			getline(cin,tmp);
			if(tmp=="END"){
				level=atoi(buf.c_str());
				break;
			}else{
				buf=tmp;
			}
		}
		for(int j=0;j<level;j++){
			while(true){
				getline(cin,buf);
				if(buf=="END"){
					cout << "0" << endl;
					cout.flush();
					break;
				}
			}
		}
	}
	return 0;
}
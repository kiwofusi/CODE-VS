
import java.util.Scanner;

public class Sample {
	public static void main(String[] arg){
		Scanner scan  = new Scanner(System.in);
		String buf=scan.nextLine();
		int map,level;
		map = Integer.parseInt(buf);
		for(int i=0;i<map;i++){
			while(true){
				String tmp=scan.nextLine();
				if(tmp.equals("END")){
					level = Integer.parseInt(buf);
					break;
				}else{
					buf=tmp;
				}
			}
			for(int j=0;j<level;j++){
				while(true){
					buf=scan.nextLine();
					if(buf.equals("END")){
						System.out.println("0");
						break;
					}
				}
			}
		}
	}
}

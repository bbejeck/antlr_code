package bbejeck.antlr.fql;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.antlr.runtime.ANTLRStringStream;
import org.antlr.runtime.CharStream;
import org.antlr.runtime.CommonTokenStream;
import org.antlr.runtime.TokenStream;


public class FQLTester {

	/**
	 * @param args
	 */
	public static void main(String[] args) throws Exception{
		BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
		String line = null;
		System.out.println("Enter your search:");
		while((line = reader.readLine())!= null){
			if(line.equalsIgnoreCase("quit")){
				System.exit(0);
			}
			CharStream charstream = new ANTLRStringStream(line);
			FQLLexer lexer = new FQLLexer(charstream);
			
			TokenStream tokenStream = new CommonTokenStream(lexer);
			FQLParser parser = new FQLParser(tokenStream);
			
			String parsed = null;
			try{
				parsed = parser.evaluate();
				System.out.println("parsed query is ["+parsed+"]");
				Process process = Runtime.getRuntime().exec(new String[]{"sh","-c",parsed});
				InputStream input = process.getInputStream();
				BufferedReader procReader = new BufferedReader(new InputStreamReader(input));
				String searchResults = null;
				while((searchResults=procReader.readLine())!=null){
					System.out.println(searchResults);
				}
			}catch(Exception e){
				e.printStackTrace();
			}
			
			System.out.println("Enter your search:");
		}
	}

}

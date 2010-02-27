The src directory contains the grammar and the test harness code.  The lexer and 
parser source are not included because those files can be generated. In the dist
directory the fqlTester.jar file contains everything needed to run the test harness.

This will only work on OS X/Linux or Cygwin.


If you modify the grammar you will need to regenerate the parser and lexer code.
To do that you can
  1. Install the antlr-eclipse plugin then modify and save the grammar and the lexer and parser will be generated.
  2. Install the ANTLRWks tool, then open the grammar, make your changes and then run generate
  3. Make changes to the grammar then run antlr from the command line.

To run the test code
  1. Downloand antlr-3.2.jar and place it somewhere on your system.
  2. Then run java -cp  path-to-antlr-3.2.jar -jar fqlTester.jar
  3. Then you should see "enter your search:" enter your sql and hit enter.
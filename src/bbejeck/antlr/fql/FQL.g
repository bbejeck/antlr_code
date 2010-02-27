grammar FQL;

options {
  language = Java;
}

@header {
  package bbejeck.antlr.fql;
}

@members {
  private StringBuilder findBuilder = new StringBuilder("find ");
  
  private StringBuilder filter = new StringBuilder();
  
  private void addString(String s){
    if(s!=null){
        findBuilder.append(s);
     }
  }
  
  private String buildTimeArg(String s, String snum, String sign){
       StringBuilder timeBuilder = new StringBuilder();
       int num = Integer.parseInt(snum);
       
       if(s.equals("days")){
           return timeBuilder.append(" -mtime ").append(sign).append(num).toString();
       }
       if(s.equals("hours")){
           return timeBuilder.append(" -mmin ").append(sign).append((num*60)).toString();
       }
       
       return timeBuilder.append(" -mmin ").append(sign).append(num).toString();
  }
  
  protected void mismatch(IntStream input, int ttype, BitSet follow) throws RecognitionException{
        throw new MismatchedTokenException(ttype,input);
  }
  
  public Object recoverFromMismatchedSet(IntStream input, RecognitionException e, BitSet follow) throws RecognitionException{
     throw e;
  }
  
}

@rulecatch{
  catch (RecognitionException e){
     throw e;
  }
}

@lexer::header {
  package bbejeck.antlr.fql;
}

evaluate returns [String query]
     :  query';' {$query = findBuilder.toString() + filter.toString() ;}
     ;

query 
     :   select_stmt where_stmt 
     ;

select_stmt 
     :  'select' '*' 'from' directory
     
     ;
     
directory
     : (p='.'{addString($p.text);} | (p='/'?{addString($p.text);}IDENT{addString($IDENT.text);})+ )
     ;
     
where_stmt 
     :  ('where' clause ('and' clause)* ) ?
     ;
    
clause 
     : file_name
     | pattern
     | modified
     ;
     
file_name
     : 'file' ':' STRING_LITERAL
        {addString(" -name ");addString($STRING_LITERAL.text);}
     ;

pattern
     :   'pattern' ':' STRING_LITERAL
        { filter.append(" | xargs grep ").append($STRING_LITERAL.text); }
     ;
   
modified
     :  modified_less
     |  modified_more
     |  modified_between
     ;
     
modified_less 
     :   'modified' '<' INTEGER time_span 
         { addString(buildTimeArg($time_span.text,$INTEGER.text,"-")); }
     ;
     
modified_more 
     :   'modified' '>' INTEGER time_span 
         { addString(buildTimeArg($time_span.text,$INTEGER.text,"+")); }
     ;
     
modified_between 
     :   'modified' 'between' int1=INTEGER 'and' int2=INTEGER time_span
         { addString(buildTimeArg($time_span.text,$int1.text,"+")); }
         { addString(buildTimeArg($time_span.text,$int2.text,"-")); }
     ;
     
time_span 
     :   'days'
     |   'minutes'
     |   'hours'
     ;
     
fragment DIGIT : '0'..'9';
fragment LETTER : 'a'..'z'|'A'..'Z' ;

STRING_LITERAL : '\''.*'\'';
INTEGER : DIGIT+ ;
IDENT : LETTER(LETTER | DIGIT)* ;
WS : (' ' | '\t' | '\n' | '\r' | '\f')+  {$channel=HIDDEN;};

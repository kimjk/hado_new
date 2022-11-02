package ftc.util;
import java.text.DecimalFormat;
import java.text.FieldPosition;

public class StringUtil {
	public static String nullToZero(String str){
		String sReturnStr = "";
		
		if(str == null){
			sReturnStr="0";
		}else{
			sReturnStr=str.trim();
		}	
		return sReturnStr ;
	}
	
	public static String checkNull(String str){
		String sReturnStr = "";
		
		if(str == null){
			sReturnStr="";
		}else{
			sReturnStr=str.trim();
		}	
		return sReturnStr ;
	}
	
    public static String replace( String str, String fromStr, String toStr ) {
    	if( str == null ) {
    		return null;
    	} else if( fromStr == null || "".equals( fromStr ) ) {
    		return str;
    	} else if( toStr == null ) {
    		return str;
    	}

    	int index = -1;

    	index = str.indexOf( fromStr );
    	if( index < 1 ) {
    		return str;
    	}

    	StringBuffer sb = new StringBuffer();
    	sb.append( str.substring( 0, index ) );
    	sb.append( toStr );

    	while( true ) {
    		index = index + fromStr.length();
    		str = str.substring( index );
    		index = str.indexOf( fromStr );
    		if( index < 1 ) {
    			sb.append( str );
    			break;
    		} else {
    			sb.append( str.substring( 0, index ) );
    			sb.append( toStr );
    		}
    	}

    	return sb.toString();
    }
    
	
	public static String selDeptCode(String str){
		String sReturnStr = "";
		
		if(str.equals("������´�")){
			sReturnStr = "H";
		}else if(str.equals("����繫��")){
			sReturnStr = "S";
		}else if(str.equals("�뱸�繫��")){
			sReturnStr = "K";
		}else if(str.equals("�����繫��")){
			sReturnStr = "J";
		}else if(str.equals("���ֻ繫��")){
			sReturnStr = "G";
		}else if(str.equals("�λ�繫��")){
			sReturnStr = "B";
		}else{
			sReturnStr = "";
		}
		
		return sReturnStr ;
	}

	public static String statusf(String str){
		String sReturnStr = "";
		
		if(str == null){
			sReturnStr = "&nbsp;";
			return sReturnStr;
		}
		
		if(str.equals("1")){
			sReturnStr="���󿵾�";
		}else if(str.equals("2")){
			sReturnStr="ȸ���������� ������";
		}else if(str.equals("3")){
			sReturnStr="ȭ������ ������";
		}else if(str.equals("4")){
			sReturnStr="��������۾�(work-out) ������";
		}else if(str.equals("5")){
			sReturnStr="�ε�";
		}else if(str.equals("6")){
			sReturnStr="�����ߴ� �Ǵ� ���";
		}else if(str.equals("7")){
			sReturnStr="����պ�";
		}else{
			sReturnStr="&nbsp;";
		}
		
		return sReturnStr ;
	}

	public static String returnf(String str){
		String sReturnStr = "";
		
		if(str!= null && str.equals("1")){
			sReturnStr="�ݼ�";
		}else{
			sReturnStr="&nbsp;";
		}	
		return sReturnStr ;
	}

	public static String resendf(String str){
		String sReturnStr = "";
		
		if(str!= null && str.equals("1")){
			sReturnStr="��߼�";
		}else{
			sReturnStr="&nbsp;";
		}
		
		return sReturnStr ;
	}

	public static String astatusf(String str){
		String sReturnStr = "";
		
		if(str!= null && str.equals("1")){
			sReturnStr="����Ҵ�";
		}else if(str!= null && str.equals("2")){
			sReturnStr="����ȸ��";
		}else if(str!= null && str.equals("3")){
			sReturnStr="������ڿ�Ǿȵ�";
		}else{
			sReturnStr=str;
		}
		
		return sReturnStr ;
	}

	//�Ҽ���
	public static String sale99f(String aa , String bb){
		String sReturnStr = "0";
		
		if(aa!=null && !aa.equals("")){
			sReturnStr=aa;
		}else{
			if(bb!=null && !bb.equals("")){
				sReturnStr=bb;
			}else{
				sReturnStr="0";
			}
		}
		
		return sReturnStr ;
	}

	public static String ostatusf(String str){
		String sReturnStr = "";
		
		if(str!= null && str.equals("1")){
			sReturnStr="����";
		}else{
			sReturnStr="&nbsp;";
		}	
		return sReturnStr ;
	}
	
	//procflagf
	public static String procflagf(String str){
		String sReturnStr = "";
		
		if(str!= null && str.equals("1")){
			sReturnStr="<font color=blue>ó��</font>";
		}else if(str!= null && str.equals("2")){
			sReturnStr="<font color=red>��ó��</font>";
		}else if(str!= null && str.equals("3")){
			sReturnStr="<font color=purple>��ó�����</font>";
			sReturnStr="&nbsp;";
		}else{
			sReturnStr="&nbsp;";
		}
		return sReturnStr ;
	}
	
	public static  String fDeptIndex(String str){
		String sReturnStr = "";
		
		if(str!= null && str.equals("������´�")){
			sReturnStr="1";
		}else if(str!= null && str.equals("����繫��")){
			sReturnStr="2";
		}else if(str!= null && str.equals("�λ�繫��")){
			sReturnStr="3";
		}else if(str!= null && str.equals("���ֻ繫��")){
			sReturnStr="4";
		}else if(str!= null && str.equals("�����繫��")){
			sReturnStr="5";
		}else if(str!= null && str.equals("�뱸�繫��")){
			sReturnStr="6";
		}else{
			sReturnStr="0";
		}
		
		return sReturnStr ;
	}
	
	public static  String isSelected(String f_sStr1, String f_sStr2){
		String isSelected = "";
		String fisSelected = "";
		if(!f_sStr1.trim().equals("") && !f_sStr2.trim().equals("")){
			if(f_sStr1 == f_sStr2){
				fisSelected = " selected";
			}else{
				fisSelected = "";
			}
		}else{
			fisSelected = "";
		}
		isSelected = fisSelected;
		
		return isSelected;
	}
	
	public static  String gbf(String str){
		String gbf = "";
		
		String sReturnStr = "";
		
		if(str!= null && str.equals("1")){
			gbf="����";
		}else if(str!= null && str.equals("2")){
			gbf="�Ǽ�";
		}else if(str!= null && str.equals("3")){
			gbf="�뿪";
		}else{
			gbf="&nbsp;";
		}
		
		return gbf ;
	}
	
	public static  long Round(long lcount , int icount){
		long rcount = 0;	
		int q = 0;
		
		q = 10^icount;
		rcount = Math.round(lcount*q)/q; 
	
		return rcount;
	}
	
	public static float Round(float lcount , int icount){
		float rcount = 0;
		int q = 0;
		
		q = 10^icount;
		rcount = Math.round(lcount*q)/q;
	
		return rcount;
	}
	 

	public static String formatNumber(long number) {
		  DecimalFormat formatter = new DecimalFormat("#,###");
		  StringBuffer formattingNumber = new StringBuffer();
		  formatter.format(number, formattingNumber, new FieldPosition(1));
		  
		  return formattingNumber.toString();
	}
	
	public static String formatNumber(float number) {
		  long number1 = 0;
		  number1 = (long)number;
		  number = number1;
		  DecimalFormat formatter = new DecimalFormat("#,###");
		  StringBuffer formattingNumber = new StringBuffer();
		  formatter.format(number, formattingNumber, new FieldPosition(1));
		  
		  return formattingNumber.toString();
	}
	
	public static String www2(String w){
		String www2 = "";
		if (w == null || w.trim().equals("") || w.equals("0")){
			www2="0";
		}else{
			//w = w.substring(0,w.length()-5);

			int ttt = 0;
			ttt=Integer.parseInt(w);

			float xxx = 0;

			xxx = ttt;
			xxx = xxx*1000;

			www2=StringUtil.formatNumber(xxx);		
		}
		return www2;
	}
	
	public static String oxff(String o){
		String oxff = "";
		if(o.equals("1")){
		   oxff="�������� �Ϸ�";
		}else if(o.equals("2")){
		   oxff="�Ϻν���";
		}else if(o.equals("3")){
		   oxff="���� �̽���";
		}else if(o.equals("4")){
		   oxff="������";
		}else if(o.equals("5")){
                   oxff="�ε�,����Ҹ��";
		}else if(o.equals("6")){
		   oxff="����+������";
		}else{
		   oxff="&nbsp;";
		}

		return oxff;
	}
	
	public static String actionf(String a){
		String actionf= "";
		if(a.trim().equals("1")){
			actionf="���";
		}else if(a.trim().equals("2")){
			actionf="��¡��";
		}else if(a.trim().equals("3")){
			actionf="�������";
		}else if(a.trim().equals("4")){
			actionf="���";
		}else if(a.trim().equals("5")){
			actionf="������";
		}else if(a.trim().equals("6")){
			actionf="����";
		}else if(a.trim().equals("7")){
			actionf="�����˱�";
		}else if(a.trim().equals("8")){
			actionf="�߰� ��������";
		}else if(a.trim().equals("9")){
			actionf="��������";
		}else{
			actionf="&nbsp;";
		}
		return actionf;
	}
	
	public static String oxf(String o){
		String oxf= "";
		if(!o.trim().equals("") && o != null){
			oxf="�Է¿Ϸ�";
		}else{
			oxf="&nbsp;";
		}
		return oxf;
	}
	
	public static String ischecked(String ss,String cc){
		String ischecked = "";
		if(!ss.trim().equals("") && ss != null){
			if(ss.trim().equals(cc.trim())){
				ischecked=" checked";
			}
		}
		return ischecked;
	}
	
	public static String NullToNBSP(String val){
		String NullToNBSP = "";
		if (val == null || val.equals("")){
			NullToNBSP = "&nbsp;";
		}else{
			NullToNBSP = val;
		}
		return NullToNBSP;
	}


}

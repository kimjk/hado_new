package ftc.dao;

import ftc.db.ConnectionResource;
import ftc.db.ConnectionResource2;
import ftc.util.StringUtil;
import ftc.vo.SessionVo;
import ftc.vo.WonVo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class WonDao {
	public WonVo getWonInfo(SessionVo sessionVo){
		WonVo wonVo = new WonVo();
		ConnectionResource resource = null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ConnectionResource2 resource2 = null;
		Connection conn2 = null;

		String sql = "";
				
		long gesu = 0;
		long pagesu  = 0;
		long lastpg = 0;

		ArrayList dcode = null;
		ArrayList dname = null;
		ArrayList ccode = null;
		ArrayList cname = null;
		ArrayList srvcode = null;
		ArrayList srvname = null;

		ArrayList oentseq = null;
		ArrayList oentgb = null;
		ArrayList oname = null;
		ArrayList ocaptine = null;
		ArrayList omngno = null;
		ArrayList opwdno = null;
		ArrayList ozipcode = null;
		ArrayList oaddress = null;
		ArrayList ocstatus = null;
		ArrayList oreturngb = null;
		ArrayList oresend = null;
		ArrayList otel = null;
		ArrayList owtel = null;
		ArrayList w = null;
		ArrayList ofax = null;
		ArrayList sale99 = null;
		ArrayList sale00 = null;
		ArrayList oempcnt = null;
		ArrayList scnt = null;
		ArrayList oconamt = null;
		ArrayList ostatus = null;
		ArrayList sale_gb1 = null;
		ArrayList sale_gb2 = null;
		ArrayList astatus = null;
		ArrayList postno1 = null;
		ArrayList postno2 = null;

		ArrayList aDeptSeq = null;
		ArrayList aDeptCode = null;
		ArrayList aDamName = null;
		
		try {
			resource = new ConnectionResource();
			conn = resource.getConnection();
			
			resource2 = new ConnectionResource2();
			conn2 = resource2.getConnection();
			
			sql = " select * from fairtrade.common_cd where addon_gb='1' ";
			
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();	  
			
			int i=0;  
			
			dcode = new ArrayList();
			dname = new ArrayList();
			
			while(rs.next()) {
				//System.out.println(rs.getString("common_cd"));		
				//System.out.println(rs.getString("common_nm"));
				dcode.add(i,(String)rs.getString("common_cd"));
				dname.add(i,(String)rs.getString("common_nm"));
				i++;
			}
			dcode.add(i,"end");
			rs.close();
			
			sql = " select * from fairtrade.common_cd where addon_gb='2' ";
			
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();	  
			
			i=0;  
			
			ccode = new ArrayList();
			cname = new ArrayList();
			
			while(rs.next()) {
				//System.out.println(rs.getString("common_cd"));		
				//System.out.println(rs.getString("common_nm"));
				ccode.add(i,(String)rs.getString("common_cd"));
				cname.add(i,(String)rs.getString("common_nm"));
				i++;
			}
			ccode.add(i,"end");
			rs.close();
			
			sql = " select * from fairtrade.common_cd where addon_gb='3' ";
			
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();	  
			
			i=0;  
			
			srvcode = new ArrayList();
			srvname = new ArrayList();
			
			while(rs.next()) {
				//System.out.println(rs.getString("common_cd"));		
				//System.out.println(rs.getString("common_nm"));
				srvcode.add(i,(String)rs.getString("common_cd"));
				srvname.add(i,(String)rs.getString("common_nm"));
				i++;
			}
			srvcode.add(i,"end");
			rs.close();
			
			if(sessionVo.getCpage() != null && !sessionVo.getCpage().equals("")){
				//cpage=request("page")
			}else{
				//cpage ="1";
				sessionVo.setCpage("1");
			}
			
			System.out.println("44444444444444444");
			
			int pagesize=20 ;
			
			String sqlswhere = "";
			
			System.out.println("sessionVo.getTt()="+sessionVo.getTt());
			
			if(sessionVo.getTt() ==null || !"start".equals(sessionVo.getTt())){
				sql="select  * from vt_oent";
				if(!sessionVo.getWgb().equals("")){
					sqlswhere=" and oent_gb="+sessionVo.getWgb();
				}
				
				if(!sessionVo.getSgb().equals("")){
					sqlswhere=sqlswhere+" and oent_type='"+sessionVo.getSgb()+"'";
				}
				
				if(!sessionVo.getScomp().equals("")){
					sqlswhere=sqlswhere+" and replace(oent_name,' ','') like '%"+sessionVo.getScomp()+"%'";
				}
				
				System.out.println("sessionVo.getCstatus()="+sessionVo.getCstatus());
				
				if(!sessionVo.getCstatus().equals("")){
					sqlswhere=sqlswhere+" and comp_status='"+sessionVo.getCstatus()+"'";
				}
				
				if(!sessionVo.getAstatus().equals("")){
					sqlswhere=sqlswhere+" and addr_status='"+sessionVo.getAstatus()+"'";
				}		
				
				if(!sessionVo.getReturngb().equals("")){
					sqlswhere=sqlswhere+" and return_gb='"+sessionVo.getReturngb()+"'";
				}
				
				if(!sessionVo.getOstatus().equals("")){
					if(!sessionVo.getOstatus().equals("0")){
						sqlswhere=sqlswhere+" and (case when oent_status='1' then '1' else '0' end) = '0' ";
						sqlswhere=sqlswhere+" and (case when addr_status='1' or addr_status='2' or addr_status='3' then addr_status else '0' end) = '0' ";
					}else if(!sessionVo.getOstatus().equals("2")){
						sqlswhere=sqlswhere+" and (case when oent_status='1' then '1' else '0' end) = '1' ";
						sqlswhere=sqlswhere+" and (case when addr_status='1' or addr_status='2' or addr_status='3' then addr_status else '0' end) <> '2' ";
					}else{
						sqlswhere=sqlswhere+" and (case when oent_status='1' then '1' else '0' end)='"+sessionVo.getOstatus()+"'";
					}
				}
				
				if(!sessionVo.getCsid().equals("")){
					sqlswhere=sqlswhere+" and mng_no>='"+sessionVo.getCsid()+"'";
				}
				
				if(!sessionVo.getCeid().equals("")){
					sqlswhere=sqlswhere+" and mng_no<='"+sessionVo.getCeid()+"'";
				}
				
				if(!sessionVo.getStype().equals("")){
					sqlswhere=sqlswhere+" and subcon_type='"+sessionVo.getStype()+"'";
				}
				
				String local = (String)sessionVo.getLocal();
				
				System.out.println("555555555555");
				System.out.println("local="+local);
				if(local != null && !local.trim().equals("")){
					switch(Integer.parseInt(local)){
						case 0 :
							sqlswhere=sqlswhere;	
							break;
						case 1 :
							sqlswhere=sqlswhere+" and oent_address like '%����%'";
							break;
						case 2 :
							sqlswhere=sqlswhere+" and oent_address like '%���%'";
							break;
						case 3 :
							sqlswhere=sqlswhere+" and (oent_address like '%��󳲵�%' or oent_address like '%�泲 %')";
							break;
						case 4 :
							sqlswhere=sqlswhere+" and (oent_address like '%���ϵ�%' or oent_address like '%��� %')";
							break;
						case 5 :
							sqlswhere=sqlswhere+" and oent_address like '%����%'";
							break;
						case 6 :
							sqlswhere=sqlswhere+" and oent_address like '%�뱸%'";
							break;
						case 7 :
							sqlswhere=sqlswhere+" and oent_address like '%����%'";
							break;
						case 8 :
							sqlswhere=sqlswhere+" and oent_address like '%�λ�%'";
							break;
						case 9 :
							sqlswhere=sqlswhere+" and oent_address like '%����%'";
							break;
						case 10 :
							sqlswhere=sqlswhere+" and oent_address like '%���%'";
							break;
						case 11 :
							sqlswhere=sqlswhere+" and oent_address like '%��õ%'";
							break;
						case 12 :
							sqlswhere=sqlswhere+" and (oent_address like '%���󳲵�%' or oent_address like '%���� %')";
							break;
						case 13 :
							sqlswhere=sqlswhere+" and (oent_address like '%����ϵ�%' or oent_address like '%���� %')";
							break;
						case 14 :
							sqlswhere=sqlswhere+" and oent_address like '%����%'";
							break;
						case 15 :
							sqlswhere=sqlswhere+" and (oent_address like '%��û����%' or oent_address like '%�泲 %')";
							break;
						case 16 :
							sqlswhere=sqlswhere+" and (oent_address like '%��û�ϵ�%' or oent_address like '%��� %')";
							break;
					}
				}
				// 2005-04-13 pcxman
				if(!sessionVo.getOlast().equals("")){
					sqlswhere=sqlswhere+" AND RIGHT(RTRIM(Mng_No), 1) = '"+sessionVo.getOlast()+"'";
				}
				// 2007-06-15 pcxman
				if(!sessionVo.getOareacode().equals("")){
					sqlswhere=sqlswhere+" AND Area_Code = '"+sessionVo.getOareacode()+"'";
				}
				// 2007-06-19 pcxman
				if(!sessionVo.getOdeptname().equals("")){
					sqlswhere=sqlswhere+" AND Dept_Seq = "+sessionVo.getOdeptname();
				}
				
				//sql = sql+" where (oent_seq>0) and (oent_yyyy='"+CStr(Application("CYear"))+"') "+sqlswhere;
				sql = sql+" where (oent_seq>0) and (oent_yyyy='"+"2007"+"') "+sqlswhere;
				
				if(sessionVo.getSsort().equals("1")){
					sql = sql+" order by replace(oent_name,'(','')";
				}
				if(sessionVo.getSsort().equals("2")){
					sql = sql+" order by oent_assets desc";
				}
				if(sessionVo.getSsort().equals("3")){
					sql = sql+" order by mng_no";
				}
				if(sessionVo.getSsort().equals("4")){
					sql =sql+" order by oent_sale04 desc";
				}
				
				
				System.out.println("sql="+sql);
				
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();	  
//				if(rs.next()) {
//					gesu = rs.getRow();
//					pagesu  = Math.round(gesu/pagesize+0.4999999);
//					lastpg = pagesu;
//				}
				
				oentseq = new ArrayList();
				oentgb = new ArrayList();
				oname = new ArrayList();
				ocaptine = new ArrayList();
				omngno = new ArrayList();
				opwdno = new ArrayList();
				ozipcode = new ArrayList();
				oaddress = new ArrayList();
				ocstatus = new ArrayList();
				oreturngb = new ArrayList();
				oresend = new ArrayList();
				otel = new ArrayList();
				owtel = new ArrayList();
				w = new ArrayList();
				ofax = new ArrayList();
				sale99 = new ArrayList();
				sale00 = new ArrayList();
				oempcnt = new ArrayList();
				scnt = new ArrayList();
				oconamt = new ArrayList();
				ostatus = new ArrayList();
				sale_gb1 = new ArrayList();
				sale_gb2 = new ArrayList();
				astatus = new ArrayList();
				postno1 = new ArrayList();
				postno2 = new ArrayList();
				
				i=0;
				System.out.println("66666666666666666");
				System.out.println("pagesize="+pagesize);
				while(rs.next()  && pagesize>0) {
					System.out.println("7777777777777777");
					gesu = rs.getRow();
					pagesu  = Math.round(gesu/pagesize+0.4999999);
					lastpg = pagesu;
					

					oentseq.add(i,(String)rs.getString("oent_seq"));
					oentgb.add(i,(String)rs.getString("oent_gb"));
					oname.add(i,(String)rs.getString("oent_name"));
					ocaptine.add(i,(String)rs.getString("oent_captine"));
					ozipcode.add(i,(String)rs.getString("zip_code"));
					oaddress.add(i,(String)rs.getString("oent_address"));
					otel.add(i,(String)rs.getString("oent_tel"));
					ofax.add(i,(String)rs.getString("oent_fax"));
					
					sale99.add(i,(String)rs.getString("oent_sale04"));
					if(sale99.get(i) == null){
						sale99.add(i,"0");
					}
					sale00.add(i,(String)rs.getString("oent_sale05"));
					if(sale00.get(i) == null){
						sale00.add(i,"0");
					}
					oconamt.add(i,(String)rs.getString("oent_con_amt"));
					oempcnt.add(i,(String)rs.getString("oent_emp_cnt"));
					w.add(i,(String)rs.getString("writer"));
					owtel.add(i,(String)rs.getString("writer_tel"));
					ofax.add(i,(String)rs.getString("writer_fax"));
					omngno.add(i,(String)rs.getString("mng_no"));
					opwdno.add(i,(String)rs.getString("pwd_no"));
					oreturngb.add(i,(String)rs.getString("return_gb"));
					oresend.add(i,(String)rs.getString("re_send"));
					ocstatus.add(i,(String)rs.getString("comp_status"));
					scnt.add(i,(String)rs.getString("subcon_cnt"));
					ostatus.add(i,(String)rs.getString("oent_status"));
					astatus.add(i,(String)rs.getString("addr_status"));
					
					if(sessionVo.getWgb().equals("1")){
						sale_gb1.add(i,(String)rs.getString("oent_sale_gb1"));
						sale_gb2.add(i,(String)rs.getString("oent_sale_gb2"));
					}
					
					postno1.add(i,(String)rs.getString("Post_No1"));
					postno2.add(i,(String)rs.getString("Post_No2"));
					
					i=i+1 ;
					pagesize=pagesize-1;
				}
				
				rs.close();
				
				//����ں� �迭 ����
				aDeptSeq = new ArrayList();
				aDeptCode = new ArrayList();
				aDamName = new ArrayList();
				
				sql = 	"SELECT Dept_Seq, Center_Name, User_Name FROM TB_FTC_User WHERE Dept_Seq <> 50 " +
							"ORDER BY Center_Name, User_Name" ;
				
				pstmt = conn2.prepareStatement(sql);
				rs = pstmt.executeQuery();	
				
				i = 0;
				
				System.out.println("pagesize="+pagesize);
				
				//while(rs.next()  && pagesize>0) {
				while(rs.next()) {	
					aDeptSeq.add(i,(String)rs.getString("Dept_Seq"));
					aDeptCode.add(i,StringUtil.selDeptCode((String)rs.getString("Center_Name")));
					aDamName.add(i,(String)rs.getString("User_Name"));
				}
				
				System.out.println("aDeptSeq.size()="+aDeptSeq.size());
				
				rs.close();
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally {
			if ( rs != null ) try{rs.close();}catch(Exception e){}
		  	if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}
		  	if ( conn != null ) try{conn.close();}catch(Exception e){}
		  	if ( conn2 != null ) try{conn2.close();}catch(Exception e){}
		  	if ( resource != null ) resource.release();
		  	if ( resource2 != null ) resource2.release();
		}
		
		wonVo.setDcode(dcode); 
		wonVo.setDname(dname);
		wonVo.setCcode(ccode);  
		wonVo.setCname(cname); 
		wonVo.setSrvcode(srvcode);     
		wonVo.setSrvname(srvname);    
		  
		wonVo.setOentseq(oentseq);     
		wonVo.setOentgb(oentgb);
		wonVo.setOname(oname);
		wonVo.setOcaptine(ocaptine);    
		wonVo.setOmngno(omngno);    
		wonVo.setOpwdno(opwdno);    
		wonVo.setOzipcode(ozipcode);   
		wonVo.setOaddress(oaddress);   
		wonVo.setOcstatus(ocstatus);    
		wonVo.setOreturngb(oreturngb);  
		wonVo.setOresend(oresend);     
		wonVo.setOtel(otel);    
		wonVo.setOwtel(owtel);  
		wonVo.setW(w); 
		wonVo.setOfax(ofax);    
		wonVo.setSale99(sale99); 
		wonVo.setSale00(sale00); 
		wonVo.setOempcnt(oempcnt);    
		wonVo.setScnt(scnt);    
		wonVo.setOconamt(oconamt);    
		wonVo.setOstatus(ostatus);
		wonVo.setSale_gb1(sale_gb1);    
		wonVo.setSale_gb2(sale_gb2);    
		wonVo.setAstatus(astatus);
		wonVo.setPostno1(postno1);    
		wonVo.setPostno2(postno2);    
		
		wonVo.setADeptSeq(aDeptSeq);  
		wonVo.setADeptCode(aDeptCode);
		wonVo.setADamName(aDamName);
		
		return wonVo;
	}
}

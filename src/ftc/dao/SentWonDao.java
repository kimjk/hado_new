package ftc.dao;

import ftc.db.ConnectionResource;
import ftc.db.ConnectionResource2;
import ftc.vo.SessionVo;
import ftc.vo.WonVo;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class SentWonDao {
	public WonVo getSoEntInfo(SessionVo sessionVo){
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
		ArrayList area_cd = null;
		ArrayList area_nm = null;
		
		ArrayList oentseq = null;
		ArrayList oentgb = null;
		ArrayList oname = null;
		ArrayList omngno = null;
		ArrayList opwdno = null;
		ArrayList sentno = null;
		ArrayList sentnm = null;
		ArrayList sentcap = null;
		ArrayList sentamt = null;
		ArrayList smngno = null;
		ArrayList spwdno = null;
		ArrayList szipcode = null;
		ArrayList oaddress = null;
		ArrayList sentmail = null;
		ArrayList senttel = null;
		ArrayList sentfax = null;
		ArrayList sreturngb = null;
		ArrayList sresend = null;
		ArrayList sstatus = null;
		ArrayList astatus = null;
		ArrayList selgb = null;
		ArrayList ocaptine = null;
		ArrayList ozipcode = null;
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
		ArrayList postno = null;
		ArrayList dlogin = null;
		
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
				srvcode.add(i,(String)rs.getString("common_cd"));
				srvname.add(i,(String)rs.getString("common_nm"));
				i++;
			}
			ccode.add(i,"end");
			rs.close();

			sql = " select * from fairtrade.common_cd where common_gb = '003' ";
			
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();	  
			
			i=0;  
			
			area_cd = new ArrayList();
			area_nm = new ArrayList();
			
			while(rs.next()) {
				area_cd.add(i,(String)rs.getString("common_cd"));
				area_nm.add(i,(String)rs.getString("common_nm"));
				i++;
			}
			area_cd.add(i,"end");
			rs.close();

			if(sessionVo.getCpage() != null && !sessionVo.getCpage().equals("")){
				//cpage=request("page")
			}else{
				//cpage ="1";
				sessionVo.setCpage("1");
			}
			
			System.out.println("SoEnt common_cd (after Query)....");
			
			int pagesize=20 ;
			
			String sqls = "";
			String sqlswhere = "";
			if(sessionVo.getTt() ==null || !"start".equals(sessionVo.getTt())){
				sqls="select tb_oent.oent_name, tb_oent.mng_no oent_mng_no, tb_oent.pwd_no oent_pwd_no, tb_security.mng_no,tb_security.pwd_no,tb_subcon.oent_seq, tb_subcon.oent_gb, tb_subcon.sent_no, ";
				    sqls= sqls + "tb_subcon.sent_nm, tb_subcon.sent_cap, tb_subcon.sent_amt, tb_subcon.zip_code, tb_subcon.address, ";
				    sqls= sqls + "tb_subcon.email_id, tb_subcon.sent_tel, tb_subcon.sent_fax, ";
					sqls= sqls + "tb_subcon.return_gb, tb_subcon.resend_gb, tb_subcon.addr_status, tb_subcon.sel_gb, tb_subcon.sent_status, tb_security.Dont_Login from tb_oent, tb_subcon, tb_security ";
					sqls= sqls + "WHERE ( tb_oent.oent_seq = tb_subcon.oent_seq ) and ( tb_oent.oent_yyyy = tb_subcon.oent_yyyy ) and ";
				    sqls= sqls + "( tb_oent.oent_gb = tb_subcon.oent_gb ) and ( tb_subcon.oent_seq = tb_security.oent_seq ) and ";
					sqls= sqls + "( tb_subcon.oent_yyyy = tb_security.oent_yyyy ) and ( tb_subcon.oent_gb = tb_security.oent_gb ) and ";
					sqls= sqls + "( tb_subcon.sent_no = tb_security.sent_no ) ";
	
					if(!sessionVo.getWgb().equals("")){
						sqlswhere=sqlswhere+" and tb_subcon.oent_gb='"+sessionVo.getWgb()+"'";
					}
					
					if(!sessionVo.getSgb().equals("")){
						sqlswhere=sqlswhere+" and tb_oent.oent_type='"+sessionVo.getSgb()+"'";
					}
					
					if(!sessionVo.getScomp().equals("")){
						sqlswhere=sqlswhere+" and replace(tb_oent.oent_name,' ','') like '%"+sessionVo.getScomp()+"%'";
					}

					if(!sessionVo.getSubcomp().equals("")){
						sqlswhere=sqlswhere+" and replace(sent_nm,' ','') like '%"+sessionVo.getSubcomp()+"%'";
					}			

					if(!sessionVo.getSelgb().equals("")){
						sqlswhere=sqlswhere+" and sel_gb='"+sessionVo.getSelgb()+"'";
					}

					if(!sessionVo.getArea().equals("")){
						sqlswhere=sqlswhere+" and left(tb_subcon.address,2)='"+sessionVo.getArea()+"'";
					}
					
					if(!sessionVo.getAstatus().equals("")){
						sqlswhere=sqlswhere+" and tb_subcon.addr_status='"+sessionVo.getAstatus()+"'";
					}		
					
					if(!sessionVo.getReturngb().equals("")){
						sqlswhere=sqlswhere+" and tb_subcon.return_gb='"+sessionVo.getReturngb()+"'";
					}
					
					if(!sessionVo.getOstatus().equals("")){
						if(!sessionVo.getOstatus().equals("0")){
							sqlswhere=sqlswhere+" and ((tb_subcon.addr_status is null or tb_subcon.addr_status = '') and (tb_subcon.sent_status is null or tb_subcon.sent_status <> '1')) ";
						}else{
							sqlswhere=sqlswhere+" and tb_subcon.sent_status='"+sessionVo.getOstatus()+"'";
						}
					}	
					
					if(!sessionVo.getCsid().equals("")){
						sqlswhere=sqlswhere+" and tb_security.mng_no>='"+sessionVo.getCsid()+"'";
					}
					
					if(!sessionVo.getCeid().equals("")){
						sqlswhere=sqlswhere+" and tb_security.mng_no<='"+sessionVo.getCeid()+"'";
					}

					if(!sessionVo.getCtid().equals("")){
						sqlswhere=sqlswhere+" and tb_security.mng_no='"+sessionVo.getCtid()+"'";
					}
					
					//sqlswhere=sqlswhere+" and tb_oent.oent_yyyy='"+cstr(Application("cYear"))+"' "
					sql = sqls+" and (tb_oent.oent_yyyy='"+"2007"+"') "+sqlswhere;
					
					if(sessionVo.getSsort().equals("1")){
						sql=sql+" order by tb_oent.oent_name";
					}
					if(sessionVo.getSsort().equals("2")){
						sql=sql+" order by oent_sale_gb1 desc, oent_con_amt desc";
					}
					if(sessionVo.getSsort().equals("3")){
						sql=sql+" order by tb_security.mng_no";
					}				
					
					System.out.println("sql="+sql);			
					//sqlsgesu=replace(sqls," order by oent_name","")
					//sqlsgesu=replace(sqlsgesu,"order by oent_sale_gb1 desc, oent_con_amt desc","")
					//sqlsgesu=replace(sqlsgesu,"order by tb_security.mng_no","")
					//sqlsgesu="select count(*) cnt from ("+sqlsgesu+") aa"
					//gesu=RS.RecordCount
					//pagesu=round(gesu/pagesize+0.4999999)
					//lastpg=pagesu
					//gesu=gesu
					//if not RS.eof then
						//RS.PageSize = pagesize
						//RS.AbsolutePage = cint(cpage)
					//end if
					
					oentseq = new ArrayList();
					oentgb = new ArrayList();
					oname = new ArrayList();
					omngno = new ArrayList();
					opwdno = new ArrayList();
					oaddress = new ArrayList();
					smngno = new ArrayList();
					spwdno = new ArrayList();
					sentno = new ArrayList();
					sentnm = new ArrayList();
					sentcap = new ArrayList();
					sentamt = new ArrayList();
					szipcode = new ArrayList();
					oaddress = new ArrayList();
					sentmail = new ArrayList();
					senttel = new ArrayList();
					sentfax = new ArrayList();
					sreturngb = new ArrayList();
					sresend = new ArrayList();
					astatus = new ArrayList();
					selgb = new ArrayList();
					sstatus = new ArrayList();
					dlogin = new ArrayList();				
					
					i=0;
					System.out.println("pagesize="+pagesize);
					while(rs.next()  && pagesize>0) {
						System.out.println("7777777777777777");
						gesu = rs.getRow();
						pagesu  = Math.round(gesu/pagesize+0.4999999);
						lastpg = pagesu;
																	
						oname.add(i,(String)rs.getString(1));	
						omngno.add(i,(String)rs.getString(2));
						opwdno.add(i,(String)rs.getString(3));
						smngno.add(i, (String)rs.getString(4));
						spwdno.add(i, (String)rs.getString(5));
						oentseq.add(i,(String)rs.getString(6));
						oentgb.add(i,(String)rs.getString(7));
						sentno.add(i,(String)rs.getString(8));
						sentnm.add(i,(String)rs.getString(9));
						sentcap.add(i,(String)rs.getString(10));
						sentamt.add(i,(String)rs.getString(11));
						szipcode.add(i,(String)rs.getString(12));
						oaddress.add(i,(String)rs.getString(13));
						sentmail.add(i,(String)rs.getString(14));
						senttel.add(i,(String)rs.getString(15));
						sentfax.add(i,(String)rs.getString(16));	
						sreturngb.add(i,(String)rs.getString(17));
						sresend.add(i,(String)rs.getString(18));
						astatus.add(i,(String)rs.getString(19));	
						selgb.add(i,(String)rs.getString(20));	
						sstatus.add(i,(String)rs.getString(21));
						dlogin.add(i,(String)rs.getString("dont_login"));
				
						i=i+1 ;
						pagesize=pagesize-1;
					}
					oname.add(i,"end");
					rs.close();
			}
			else
				lastpg = 0;
		}//End Of Try		
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
		wonVo.setPostno(postno);    
		wonVo.setDlogin(dlogin);
		
		return wonVo;
	}
	
	public WonVo getSentWonInfo(SessionVo sessionVo){
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
		ArrayList postno = null;
		ArrayList dlogin = null;
		
		//ArrayList aDeptSeq = null;
		//ArrayList aDeptCode = null;
		//ArrayList aDamName = null;
		
		try {
			resource = new ConnectionResource();
			conn = resource.getConnection();
			
			resource2 = new ConnectionResource2();
			conn2 = resource2.getConnection();
					
			sql = " select * from fairtrade.common_cd where addon_gb='4' ";
			
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();	  
			
			int i=0;  
			
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
			
			if(sessionVo.getCpage() != null && !sessionVo.getCpage().equals("")){
				//cpage=request("page")
			}else{
				//cpage ="1";
				sessionVo.setCpage("1");
			}
			
			System.out.println("SentWon common_cd (after Query)....");
			
			int pagesize=20 ;
			
			String sqlswhere = "";
			
			System.out.println("sessionVo.getTt()="+sessionVo.getTt());
			
			if(sessionVo.getTt() ==null || !"start".equals(sessionVo.getTt())){
				sql="select  * from vt_sent"; 
				if(!sessionVo.getSgb().equals("")){
					sqlswhere=sqlswhere+" and sent_type='"+sessionVo.getSgb()+"'";
				}
				
				if(!sessionVo.getScomp().equals("")){
					sqlswhere=sqlswhere+" and replace(sent_name,' ','') like '%"+sessionVo.getScomp()+"%'";
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
							
				if(!sessionVo.getCsid().equals("")){
					sqlswhere=sqlswhere+" and mng_no>='"+sessionVo.getCsid()+"'";
				}
				
				if(!sessionVo.getCeid().equals("")){
					sqlswhere=sqlswhere+" and mng_no<='"+sessionVo.getCeid()+"'";
				}

				if(!sessionVo.getCtid().equals("")){
					sqlswhere=sqlswhere+" and mng_no='"+sessionVo.getCtid()+"'";
				}
				
				if(!sessionVo.getStype().equals("")){
					sqlswhere=sqlswhere+" and subcon_type='"+sessionVo.getStype()+"'";
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
				
				//sql = sql+" where (sent_no>0) and (sent_yyyy='"+CStr(Application("CYear"))+"') "+sqlswhere;
				//sql = sql+" where (sent_no>0) and (sent_yyyy='"+"2007"+"') "+sqlswhere; where ���� üũ �ʿ�.....
				sql = sql+" where (sent_no>0) and (sent_yyyy='"+"2007"+"') "+sqlswhere;
				
				if(sessionVo.getSsort().equals("1")){
					sql = sql+" order by replace(sent_nm,'(','')";
				}
				if(sessionVo.getSsort().equals("2")){
					sql = sql+" order by con_amt desc";
				}
				if(sessionVo.getSsort().equals("3")){
					sql = sql+" order by mng_no";
				}
				if(sessionVo.getSsort().equals("4")){
					sql =sql+" order by sent_sale desc";
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
				postno = new ArrayList();
				dlogin = new ArrayList();
				
				i=0;
				System.out.println("66666666666666666");
				System.out.println("pagesize="+pagesize);
				while(rs.next()  && pagesize>0) {
					System.out.println("7777777777777777");
					gesu = rs.getRow();
					pagesu  = Math.round(gesu/pagesize+0.4999999);
					lastpg = pagesu;
					

					oentseq.add(i,(String)rs.getString("sent_no"));
					oentgb.add(i,(String)rs.getString("sent_gb"));
					oname.add(i,(String)rs.getString("sent_nm"));
					ocaptine.add(i,(String)rs.getString("sent_captine"));
					ozipcode.add(i,(String)rs.getString("zip_code"));
					oaddress.add(i,(String)rs.getString("address"));
					otel.add(i,(String)rs.getString("sent_tel"));
					ofax.add(i,(String)rs.getString("sent_fax"));
					
					sale00.add(i,(String)rs.getString("sent_sale"));
					if(sale00.get(i) == null){
						sale00.add(i,"0");
					}
					//sale00.add(i,(String)rs.getString("oent_sale05"));
					//if(sale00.get(i) == null){
					//	sale00.add(i,"0");
					//}
					oconamt.add(i,(String)rs.getString("con_amt"));
					oempcnt.add(i,(String)rs.getString("emp_cnt"));
					w.add(i,(String)rs.getString("writer"));
					owtel.add(i,(String)rs.getString("writer_tel"));
					ofax.add(i,(String)rs.getString("writer_fax"));
					omngno.add(i,(String)rs.getString("mng_no"));
					opwdno.add(i,(String)rs.getString("pwd_no"));
					oreturngb.add(i,(String)rs.getString("return_gb"));
					oresend.add(i,(String)rs.getString("re_send"));
					ocstatus.add(i,(String)rs.getString("comp_status"));
					scnt.add(i,(String)rs.getString("Rel_Oent_cnt"));
					ostatus.add(i,(String)rs.getString("sent_status"));
					astatus.add(i,(String)rs.getString("addr_status"));
					
					postno.add(i,(String)rs.getString("zip_code"));
					dlogin.add(i,(String)rs.getString("dont_login"));
					i=i+1 ;
					pagesize=pagesize-1;
				}
				
				rs.close();
			}
			else
				lastpg = 0;
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
		wonVo.setPostno(postno);    
		wonVo.setDlogin(dlogin);
		
		return wonVo;
	}
}

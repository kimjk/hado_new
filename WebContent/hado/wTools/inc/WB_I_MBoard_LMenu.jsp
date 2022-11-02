<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="ftc.util.*"%>

<%
/* -- Product Notice ----------------------------------------------------------------------------------*/
/*  1. ������Ʈ�� : ������������ȸ �ϵ��ްŷ� �������ǽ�������					                       */
/*  2. ��ü���� :																					   */
/*     - ��ü�� : (��)��Ƽ������																	   */
/*	   - Project Manamger : ������ ���� (pcxman99@naver.com)										   */
/*     - ����ó : T) 031-902-9188 F) 031-902-9189 H) 010-8329-9909									   */
/*  3. ���� : 2009�� 5��																			   */
/*  4. �����ۼ��� �� ���� : (��)��Ƽ������ ������ / 2011-10-18										   */
/*  5. ������Ʈ���� (���� / ����)																	   */
/*  6. ���																							   */
/*		1) �������� ������ / 2011-10-18																   */
/*-----------------------------------------------------------------------------------------------------*/

					String nSelLMenu = StringUtil.checkNull(request.getParameter("sel")).trim();

					ArrayList arrLMenuContent = new ArrayList();
					ArrayList arrLMenuType = new ArrayList();
					ArrayList arrLMenuHref = new ArrayList();
					ArrayList arrLMenuTarget = new ArrayList();
					ArrayList arrLMenuPermision = new ArrayList();

					String ckPermision = session.getAttribute("ckPermision") + "";
					int nPermision = 1;
					if( ckPermision.equals("T") ) {
						nPermision = 4;
					} else if( ckPermision.equals("M") ) {
						nPermision = 3;
					} else if( ckPermision.equals("V") ) {
						nPermision = 2;
					}
					int tmpPermision = 1;

					/* ���Ѽ������
					1: �Ϲݵ�� (P)
					2: ��ȸ��� (V)
					3: ������� (M)
					4: �ý��۰������ (T) */

					arrLMenuType.add("F");	arrLMenuContent.add("��������"); arrLMenuHref.add("#"); arrLMenuTarget.add(""); arrLMenuPermision.add("1");
					arrLMenuType.add("C");	arrLMenuContent.add("��������"); arrLMenuHref.add("/hado/hado/wTools/siteMng/index.jsp"); arrLMenuTarget.add(""); arrLMenuPermision.add("1");
				%>
				<div id="menu_v" class="menu_v">
					<ul>
		<%for(int lmj=0; lmj<arrLMenuType.size(); lmj++ ) {
			if( arrLMenuType.get(lmj).equals("F") ) {
				if( lmj>1 ) {%>
						</ul><%}%>
						<li><a href="<%=arrLMenuHref.get(lmj)%>"><span><%=arrLMenuContent.get(lmj)%></span></a>
						<ul>
			<%} else {%>
						<% tmpPermision = Integer.parseInt(arrLMenuPermision.get(lmj)+"");
						if( tmpPermision <= nPermision ) {%>
							<li <%if( lmj==Integer.parseInt(nSelLMenu) ) {%>class="active"<%}%>><a href="<%=arrLMenuHref.get(lmj)%>" <%if(  !arrLMenuTarget.get(lmj).equals("") ) {%> target="<%= arrLMenuTarget.get(lmj)%>"<%}%>><span><%=arrLMenuContent.get(lmj)%></span></a></li>
						<%}%>
			<%}
		}%>
						</ul>
					</ul>
				</div>
				<script type="text/javascript" src="/hado/hado/wTools/inc/jquery.js"></script>
				<script type="text/javascript">
				jQuery(function($){
					
					// Side Menu
					var menu_v = $('div.menu_v');
					var sItem = menu_v.find('>ul>li');
					var ssItem = menu_v.find('>ul>li>ul>li');
					var lastEvent = null;
					
					sItem.find('>ul').css('display','none');
					menu_v.find('>ul>li>ul>li[class=active]').parents('li').attr('class','active');
					menu_v.find('>ul>li[class=active]').find('>ul').css('display','block');

					function menu_vToggle(event){
						var t = $(this);
						
						if (this == lastEvent) return false;
						lastEvent = this;
						setTimeout(function(){ lastEvent=null }, 200);
						
						if (t.next('ul').is(':hidden')) {
							sItem.find('>ul').slideUp(100);
							t.next('ul').slideDown(100);
						} else if(!t.next('ul').length) {
							sItem.find('>ul').slideUp(100);
						} else {
							t.next('ul').slideUp(100);
						}
						
						if (t.parent('li').hasClass('active')){
							t.parent('li').removeClass('active');
						} else {
							sItem.removeClass('active');
							t.parent('li').addClass('active');
						}
					}
					sItem.find('>a').click(menu_vToggle).focus(menu_vToggle);
					
					function subMenuActive(){
						ssItem.removeClass('active');
						$(this).parent(ssItem).addClass('active');
					}; 
					ssItem.find('>a').click(subMenuActive).focus(subMenuActive);
					
					//icon
					menu_v.find('>ul>li>ul').prev('a').append('<span class="i"></span>');
				});
				</script>
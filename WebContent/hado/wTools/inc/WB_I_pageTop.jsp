<%@ page session="true" language="java" contentType="text/html; charset=euc-kr" pageEncoding="euc-kr"%><%/*** 프로젝트명	: 하도급거래 서면실태조사 지원을 위한 개발용역 사업* 프로그램명	: WB_I_pageTop.jsp* 프로그램설명	: 내부관리툴 상단 인쿨루드* 프로그램버전	: 1.0.1* 최초작성일자	: 2009년 05월* 작 성 이 력       :*=========================================================*	작성일자		작성자명				내용*=========================================================*	2009-05-00	정광식       최초작성*	2015-12-30	정광식	DB변경으로 인한 인코딩 변경*/%>				<div id="header">			<div id="titleimg">				<a href="/hado/hado/wTools/index.jsp" onfocus="this.blur()"><img src="/hado/hado/wTools/img/main_title.gif" /></a>			</div>			<div id="logininfo">				<ul class="fr">					<li class="lt fl pdtop2"><img src="/hado/hado/wTools/img/icon_user.gif" ></li>					<li class="lt fl pdtop5">[</li>					<li class="lt mngcolor fl" style="padding-top: 5px;"><%						String tmpPermision = ""+session.getAttribute("ckPermision");						if( tmpPermision.equals("T") ) { out.print("시스템관리자"); }						else if( tmpPermision.equals("M") ) { out.print("관리자"); }						else if( tmpPermision.equals("V") ) { out.print("조회권한"); }						else { out.print("일반사용자"); }						%>					</li>					<li class="lt fl pdtop5">] </li>					<li class="lt fl mngtcolor pdtop5">						<%=session.getAttribute("ckCenterName").toString()%> / <%=session.getAttribute("ckDeptName").toString()%> / <%=session.getAttribute("ckUserName").toString()%>					</li>				</ul>			</div>			<div id="tcbutton" style="padding-top:2px;">				<a href="javascript:self.close();" class="closebutton">&nbsp;</a>			</div>		</div>
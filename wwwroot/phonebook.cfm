<cfsetting enablecfoutputonly="no" showdebugoutput="yes" requesttimeout="120"><cfprocessingdirective pageencoding="utf-8" suppresswhitespace="yes"><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Telephone book</title>
<style type="text/css">
input {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 16px;
	background-color: #E8E8E8;
	vertical-align: middle;
	color: #0B4580;
	/*height: 2em;*/
	padding: 4px;
}

.ResultTable 
{
	white-space:nowrap;
}

.ResultCaption
{
	font-size:larger;
	font-weight:normal;
	color:white;
	background-color:#39F;
	padding: 6px;
	border-bottom-width: medium;
	border-bottom-color: #FFF;
	margin-bottom:2px;
}
.ResultCapRow
{
	color:white;
	text-align:left;	
	background-color:#39F;
}
.ResultCapColumn
{
}
.ResultRow0
{
}
.ResultRow1
{
	background-color:#C1D3D5;
}
.ResultCapColumnPlace
{
 	padding: 4px;
}
.ResultCapColumnName
{
	color:white;
 	padding: 4px;
}
.ResultCapColumnPhone
{
	color:white;
 	padding: 4px;
}
.ResultCapColumnBrand
{
	color:white;
 	padding: 4px;
}
.ResultCapColumnModel
{
	color:white;
 	padding: 4px;
}


.ResultColumnPlace
{
}
.ResultColumnName
{
	font-weight:bold;
}
.ResultColumnPhone
{
}
.ResultColumnBrand
{
	/*color: #D11414;
	text-align: right;
	font-weight:bold;*/
}
.ResultColumnModel
{
}
.PBokField
{
	width: 50pix;
}

</style>
</head>

<body>
<cfset request.CBDB="bankdb">
<cfparam name="FORM.pagesize" type="integer" default="10">
<cfparam name="FORM.firstrec" type="integer" default="0">
<cfparam name="FORM.f_phone" type="string" default="">
<cfparam name="FORM.f_lname" type="string" default="">
<cfparam name="FORM.f_name" type="string" default="">
<cfparam name="FORM.f_employer" type="string" default="">
<cfparam name="FORM.f_mobilephone" type="string" default="">
<cfparam name="FORM.f_email" type="string" default="">
<cfparam name="FORM.f_birthday" type="string" default="">	
<cfparam name="FORM.f_userpost" type="string" default="">
<cfparam name="FORM.f_workaddress" type="string" default="">
	
	<!--- <cfdump label="Form" var="#Form#"/> --->

<cfif Len(FORM.f_lname) GT 0>
  <cfset WhereText="
        WHERE A.lastname LIKE('%#FORM.f_lname#%')"/>
<cfelse >
    <cfset WhereText=""/>
</cfif>
	
<cfif Len(FORM.f_name) GT 0>
  <cfset WhereText= Len(WhereText) GT 0? "#WhereText# AND A.name LIKE('%#FORM.f_name#%')" :" WHERE A.name LIKE('%#FORM.f_name#%')"/>
</cfif>	
	
<cfif Len(FORM.f_phone) GT 0>
  <cfset WhereText= Len(WhereText)? "#WhereText# AND A.phone LIKE('#FORM.f_phone#%')" :" WHERE A.phone LIKE('#FORM.f_phone#%')"/>
</cfif>
	
<cfif Len(FORM.f_mobilephone) GT 0>
  <cfset WhereText= Len(WhereText)? "#WhereText# AND A.mobilephone LIKE('#FORM.f_mobilephone#%')" :" WHERE A.mobilephone LIKE('#FORM.f_mobilephone#%')"/>
</cfif>

<cfif Len(FORM.f_email) GT 0>
  <cfset WhereText= Len(WhereText)? "#WhereText# AND A.email LIKE('#FORM.f_email#%')" :" WHERE A.email LIKE('#FORM.f_email#%')"/>
</cfif>
	
<cfif Len(FORM.f_employer) GT 0>
  <cfset WhereText= Len(WhereText) GT 0? "#WhereText# AND B.employer LIKE('%#FORM.f_employer#%')" :" WHERE B.employer LIKE('%#FORM.f_employer#%')"/>
</cfif>	

<cfif Len(FORM.f_userpost) GT 0>
  <cfset WhereText= Len(WhereText) GT 0? "#WhereText# AND B.userpost LIKE('%#FORM.f_userpost#%')" :" WHERE B.userpost LIKE('%#FORM.f_userpost#%')"/>
</cfif>	
	
<cfif Len(FORM.f_workaddress) GT 0>
  <cfset WhereText= Len(WhereText) GT 0? "#WhereText# AND B.workaddress LIKE('%#FORM.f_workaddress#%')" :" WHERE B.workaddress LIKE('%#FORM.f_workaddress#%')"/>
</cfif>	


	<!--- <cfdump label="WhereText" var="#WhereText#"/>
	<cfdump label="URL" var="#URL#"/> --->
<cfif isDefined("URL.action")>
  <cfif CGI.REQUEST_METHOD IS "GET" AND URL.action IS "del" AND Len(URL.id)>
      <cfquery name="mReq" datasource="#request.CBDB#">
        delete from phonedata.cbusers
          where id = <cfqueryparam cfsqltype="CF_SQL_BIGINT" value="#URL.id#"/>
      </cfquery>
      <cfoutput>
        <div>Запись #URL.id# удалена</div>
      </cfoutput>
  </cfif>	
</cfif>
	
<p>Телефонная книга с поиском</p>
<form action="phonebook.cfm" method="post" enctype="application/x-www-form-urlencoded">
  <div style="padding:4px">
    <cfquery name="mReq" datasource="#request.CBDB#">
      select A.id, A.lastname, A.name, A.phone, A.mobilephone, A.email, A.birthday, B.employer, B.userpost, B.workaddress
		from phonedata.cbusers A
		left join phonedata.workplace B 
		on A.id = B.user
		#PreserveSingleQuotes(WhereText)# 
		order by A.lastname, A.name, B.employer
		limit #Form.pagesize# offset #Form.firstrec#
    </cfquery>
  <p>
	  <p>Параметры поиска:</p>
	  <cfoutput>
		<span style="{padding: 10em}">Фамилия:</span><span style="{widt: 4em}"/>
	    <input type="text" value= "#FORM.f_lname#" name="f_lname" id="f_lname" style="{margin: 10em}"/>
		<span style="{padding: 10em}">Имя:</span><span style="{widt: 4em}"/>
	    <input type="text" value= "#FORM.f_name#" name="f_name" id="f_name" style="{margin: 10em}"/>
		<span>Рабочий телефон:</span>
		<input type="text" value= "#FORM.f_phone#" name="f_phone" id="f_phone" size="15" maxlength="15"/>
		<span>Мобильный телефон:</span>
		<input type="text" value= "#FORM.f_mobilephone#" name="f_mobilephone" id="f_mobilephone" size="15" maxlength="15"/> 
		<span>E-mail:</span>
		<input type="text" value= "#FORM.f_email#" name="f_email" id="f_email" /> 
		<span style="{padding: 10em}">Место работы:</span><span style="{widt: 4em}"/>
	    <input type="text" value= "#FORM.f_employer#" name="f_employer" id="f_employer" style="{margin: 10em}"/>
		<span style="{padding: 10em}">Должность:</span><span style="{widt: 4em}"/>
	    <input type="text" value= "#FORM.f_userpost#" name="f_userpost" id="f_userpost" style="{margin: 10em}"/>
		<span style="{padding: 10em}">Адрес:</span><span style="{widt: 4em}"/>
	    <input type="text" value= "#FORM.f_workaddress#" name="f_workaddress" id="f_workaddress" style="{margin: 10em}"/>
			   </cfoutput>
	  <input type="submit" id="search" value="Искать" />
    <input type="hidden" name="action" value="find_user" />
  </p>
	  
    <p>Информация о сотрудниках:</p>
	  
    <p>
	<cfset seq_num=0>
		<cfoutput>
		<table  class="ResultTable" cellspacing="0" border="0" cellpadding="4">
        <cfloop query="mReq">
            <cfset seq_num=IncrementValue(seq_num)>
            <cfset row_style=BitAnd(seq_num,1)>
			<cfoutput>
            <tr class="ResultRow#row_style#">
              <!--- <td class="ResultColumnPlace" nowrap="nowrap" scope="col">#id#</td> --->
              <td class="ResultColumnName" nowrap="nowrap" scope="col"><a href="phonebook.cfm?action=del&id=#id#">Удалить</a></td>
              <td class="ResultColumnName" nowrap="nowrap" scope="col">#lastname#</td>
              <td class="ResultColumnName" nowrap="nowrap" scope="col">#name#</td>
              <td class="ResultColumnAmount" nowrap="nowrap" scope="col">#phone#</td>
              <td class="ResultColumnName" nowrap="nowrap" scope="col">#mobilephone#</td>
              <td class="ResultColumnName" nowrap="nowrap" scope="col">#email#</td>
              <td class="ResultColumnName" nowrap="nowrap" scope="col">#DateFormat(birthday,'yyyy.mm.dd')#</td>
              <td class="ResultColumnTime" nowrap="nowrap" scope="col">#employer#</td>
              <td class="ResultColumnTime" nowrap="nowrap" scope="col">#userpost#</td>
              <td class="ResultColumnTime" nowrap="nowrap" scope="col">#workaddress#</td>
            </tr>
			</cfoutput>
        </cfloop>
		</table>
    </cfoutput></p>
  </div>
</form>

</body>
</html></cfprocessingdirective>
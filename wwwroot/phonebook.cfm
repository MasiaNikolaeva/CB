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
<cfparam name="FORM.phone" type="string" default="">
<cfparam name="FORM.f_lname" type="string" default="">
	
	<!--- <cfdump label="Form" var="#Form#"/> --->

<cfif Len(FORM.f_lname) GT 0>
  <cfset WhereText="
        WHERE A.lastname LIKE('%#FORM.f_lname#%')"/>
<cfelse >
    <cfset WhereText=""/>
</cfif>	

	<!--- <cfdump label="WhereText" var="#WhereText#"/> --->

<p>Телефонная книга с поиском</p>
<form action="phonebook.cfm" method="post" enctype="application/x-www-form-urlencoded">
  <div style="padding:4px">
    <cfquery name="mReq" datasource="#request.CBDB#">
      select A.*, B.* 
		from phonedata.cbusers A
		left join phonedata.workplace B 
		on A.id = B.user
		#PreserveSingleQuotes(WhereText)# 
		order by A.lastname, A.name, B.employer
		limit #Form.pagesize# offset #Form.firstrec#
    </cfquery>
  <p>
	  <p>Параметр поиска:</p>
	  <cfoutput>
	    <input type="text" value= "#FORM.f_lname#" name="f_lname" id="f_lname"/>
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
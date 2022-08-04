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
<cfparam name="FORM.action" type="string" default="nothing">
<cfparam name="FORM.pagesize" type="integer" default="10">
<cfparam name="FORM.firstrec" type="integer" default="0">
<cfparam name="FORM.f_phone" type="string" default="">
<cfparam name="FORM.f_lname" type="string" default="">
<cfparam name="FORM.f_employer" type="string" default="">
<cfparam name="FORM.f_name" type="string" default="">
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
	
<cfif Len(FORM.f_phone) GT 0>
  <cfset WhereText= Len(WhereText)? "#WhereText# AND A.phone LIKE('#FORM.f_phone#%')" :" WHERE A.phone LIKE('#FORM.f_phone#%')"/>
</cfif>
	
<cfif Len(FORM.f_employer) GT 0>
  <cfset WhereText= Len(WhereText) GT 0? "#WhereText# AND B.employer LIKE('%#FORM.f_employer#%')" :" WHERE B.employer LIKE('%#FORM.f_employer#%')"/>
</cfif>	

	<!--- <cfdump label="WhereText" var="#WhereText#"/> --->
	
<cfif FORM.action EQUAL "add_user">
	<cfif Len(FORM.f_lname) LTE 1> 
      <div>Поле фамилия должно быть заполнено!</div>
	<cfelseif Len(FORM.f_name) LTE 1>
      <div>Поле имя должно быть заполнено!</div>
	<cfelseif Len(FORM.f_phone) LT 11>
      <div>Поле рабочий телефон должно быть заполнено!</div>
	<cfelseif Len(FORM.f_mobilephone) LT 11 >
		<div>Поле мобильный телефон должно быть заполнено!</div>
	<cfelseif Len(FORM.f_email) LTE 1 >
		<div>Поле e-mail должно быть заполнено!</div>
	<cfelseif Len(FORM.f_birthday) NEQ 10 >
		<div>Поле дата рождения должно быть заполнено!</div>
	<cfelse> 
        <cfquery name="AddReq" datasource="#request.CBDB#" result="addResult">
          insert into phonedata.cbusers
            (lastname, name, phone, mobilephone, email, birthday)
            values(
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.f_lname#"/>,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.f_name#"/>,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.f_phone#"/>,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.f_mobilephone#"/>,
            <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.f_email#"/>,
            <cfqueryparam cfsqltype="CF_SQL_DATE" value="#LsParseDateTime(FORM.f_birthday,'en','dd.MM.yyyy')#"/>
            )
        </cfquery>
		<div>Данные успешно сохранены!</div>
		<!--- <cfdump label="reqResult" var="#AddReq#"/> --->
		<!--- <cfdump label="addResult" var="#addResult#"/> --->
		<cfset newUserId=addResult.id>
			<cfset whereText="WHERE A.id=#addResult.id#"/>
		<cfif Len(#FORM.f_employer#) or Len(#FORM.f_userpost#) or Len(#FORM.f_workaddress#)>
            <cfquery name="AddReq" datasource="#request.CBDB#" result="addResult">
              insert into phonedata.workplace
                (employer, userpost, workaddress, "user")
                values(
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.f_employer#"/>,
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.f_userpost#"/>,
                <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#FORM.f_workaddress#"/>,
                <cfqueryparam cfsqltype="CF_SQL_BIGINT" value="#addResult.id#"/>

                )
            </cfquery>
		</cfif>
	</cfif>
</cfif>

  <form action="Usercard.cfm" method="post" enctype="application/x-www-form-urlencoded">
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
      
      <p>Добавление/изменение записи в телефонной книге:</p>
		<cfif isDefined("newUserId")>
		  <cfoutput>
		    <input type="hidden" name="f_userid" value="#newUserId#"/>
	      </cfoutput>
		</cfif>
		
		<input type="hidden" name="workid"/>
        <table width="200" border="0">
          <tbody>
            <tr>
              <td><span style="{padding: 10em}">Фамилия:</span></td>
              <td><cfoutput>
                <input type="text" value= "#FORM.f_lname#" name="f_lname" id="f_lname" style="{margin: 10em}" maxlength="100"/>
              </cfoutput></td>
            </tr>
            <tr>
              <td><span style="{padding: 10em}">Имя:</span><span style="{widt: 4em}"/></td>
              <td><cfoutput>
                <input type="text" value= "#FORM.f_name#" name="f_name" id="f_name" style="{margin: 10em}" maxlength="100"/>
              </cfoutput></td>
            </tr>
            <tr>
              <td><div><span>Рабочий телефон:</span></div></td>
              <td><cfoutput>
                <input type="text" value= "#FORM.f_phone#" name="f_phone" id="f_phone"  maxlength="15"/>
              </cfoutput></td>
            </tr>
            <tr>
              <td><div><span style="{padding: 10em}">Мобильный телефон:</span><span style="{widt: 4em}"/></div></td>
              <td><cfoutput>
                <input type="text" value= "#FORM.f_mobilephone#" name="f_mobilephone" id="f_mobilephone" style="{margin: 10em}" maxlength="15"/>
              </cfoutput></td>
            </tr>
            <tr>
              <td><div><span style="{padding: 10em}">E-mail:</span><span style="{widt: 4em}"/></span></div></td>
              <td><cfoutput>
                <input type="text" value= "#FORM.f_email#" name="f_email" id="f_email" style="{margin: 10em}" maxlength="256"/>
              </cfoutput></td>
            </tr>
            <tr>
              <td><div><span style="{padding: 10em}">Дата рождения (dd.mm.yyyy):</span><span style="{widt: 4em}"/></span></div></td>
              <td><cfoutput>
                <input type="text" value= "#FORM.f_birthday#" name="f_birthday" id="f_birthday" style="{margin: 10em}" maxlength="16"/>
              </cfoutput></td>
            </tr>
            <tr>
              <td>&nbsp;</td>
              <td><span style="{vertical-align: middle}">
                <input type="submit" id="save" value="Сохранить" />
              </span></td>
            </tr>
          </tbody>
        </table>
	<hr/>
        <table width="200" border="0">
          <tbody>
            <tr>
              <td><div><span style="{padding: 10em}">Место работы:</span><span style="{widt: 4em}"/></div></td>
              <td><cfoutput>
                <input type="text" value= "#FORM.f_employer#" name="f_employer" id="f_employer" style="{margin: 10em}" maxlength="200"/>
              </cfoutput></td>
            </tr>
            <tr>
              <td><div><span style="{padding: 10em}">Должность:</span><span style="{widt: 4em}"/></div></td>
              <td><cfoutput>
                <input type="text" value= "#FORM.f_userpost#" name="f_userpost" id="f_userpost" style="{margin: 10em}" maxlength="200"/>
              </cfoutput></td>
            </tr>
            <tr>
              <td><span style="{padding: 10em}">Адрес места работы:</span><span style="{widt: 4em}"/></td>
              <td><cfoutput>
                <input type="text" value= "#FORM.f_workaddress#" name="f_workaddress" id="f_workaddress" style="{margin: 10em}" maxlength="1000"/>
              </cfoutput></td>
            </tr>
          </tbody>
        </table>
        <p>&nbsp;</p>
      
		<div style="{vertical-align: middle}">
      <div>
        <div>
        </div>
      </div>
      <input type="hidden" name="action" value="add_user" />
      </div>
      
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
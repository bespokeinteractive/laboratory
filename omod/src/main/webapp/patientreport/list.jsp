<%@ include file="/WEB-INF/template/include.jsp" %>
<%@ include file="/WEB-INF/template/header.jsp" %>
<%@ include file="../includes/js_css.jsp" %>
<br/>
<openmrs:require privilege="Manage Laboratory Patient Report" otherwise="/login.htm" redirect="/module/laboratory/patientReport.form" />
<openmrs:globalProperty key="hospitalcore.hospitalName" defaultValue="ddu" var="hospitalName"/>
<%@ include file="../localHeader.jsp" %>
<script type="text/javascript">

	jQuery(document).ready(function() {
		jQuery('#date').datepicker({yearRange:'c-30:c+30', dateFormat: 'dd/mm/yy', changeMonth: true, changeYear: true});
		jQuery("#searchbox").showPatientSearchBox({		
			searchBoxView: "${hospitalName}/default",			
			resultView: "/module/laboratory/patientsearch/${hospitalName}/patientreport",		
			target: "#patientResult",
			beforeNewSearch: function(){
				jQuery("#patientSearchResultSection").hide();
			},
			success: function(data){
				jQuery("#patientSearchResultSection").show();
			}
		});	
    });
	
	// Get patient test by patient identifier
	function getPatientReport(patientId){
		var date = jQuery("#date").val();
		jQuery.ajax({
			type : "GET",
			url : getContextPath() + "/module/laboratory/searchPatientReport.form",
			data : ({
				date			 : date,
				patientId: patientId
			}), 
			success : function(data) {				
				jQuery("#tests").html(data);
				insertTestInfo(patientId);
				jQuery("#patientSearchResultSection").hide();
				jQuery('#showPatientResult').show();
			},
			error : function(xhr, ajaxOptions, thrownError) {
				alert(thrownError);
			}
		});
	}
	
	// Insert test information
	function insertTestInfo(patientId){		
		
		jQuery.ajax({
			type : "GET",
			url : getContextPath() + "/module/laboratory/ajax/showTestInfo.htm",
			data : ({
				patientId	: patientId
			}),
			success : function(data) {
				jQuery("#patientReportTestInfo").html(data);	
				jQuery("#printAreaTestInfo").html(data);	
			},
			error : function(xhr, ajaxOptions, thrownError) {
				alert(thrownError);
			}
		});
	}
	
	// Show patient report form
	function showForm(radiologyTestId, type){		
		type=escape(type);
		url = getContextPath() + "/module/laboratory/showForm.form?mode=view&height=600&width=800&radiologyTestId=" + radiologyTestId + "&type=" + type;
		tb_show("Patient report", url);	
	}
	
	function printPatientReport(){
		jQuery("#patientReportPrintArea").printArea({
			mode : "popup",
			popClose : true
		});
	}
</script> 

<div class="boxHeader"> 
	<strong>See patient List by choosing lab</strong>
</div>
<div class="box">
	<table>
		<tr>
			<td>
				Date:
				<input id="date" value="${currentDate}" style="text-align:right;"/>
			</td>
			<td>
				<div id="searchbox"></div>	
			</td>
			<td>
				<input type="button" value="Print" onClick="printPatientReport();"/>
			</td>
			<td>
				<a href="#" id='showPatientResult' style='display:none;' onclick="jQuery('#patientSearchResultSection').show(); jQuery('#showPatientResult').hide();">Show patients</a>
			</td>
		</tr>
	</table>
</div>

<br/>

<div id="patientSearchResultSection" style="display:none;">
	<div class="boxHeader">Found Patients</div>
	<div class="box" id="patientResult"></div>
</div>

<div id="tests">
</div>

<%@ include file="/WEB-INF/template/footer.jsp" %>  
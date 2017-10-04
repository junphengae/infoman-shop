// common.js
// Specify highlight behavior. "TD" to highlight table cells, "TR" to highlight the entire row:
var highlightbehavior = "TR"
var ns6 = document.getElementById && !document.all
var ie = document.all

function changeSelect(e, highlightcolor) {
	source = ie ? event.srcElement : e.target
	if (source.tagName == "TABLE") {
		return
	}

	// find a table element
	tableSource = source;	
	while (tableSource.tagName != "TABLE") {
		tableSource = ns6 ? tableSource.parentNode : tableSource.parentElement;
	}
	
	// clear all color for each rows in the table
	var row = tableSource.getElementsByTagName("TR");
	for (var i = 0; i < row.length; i++) {
		row[i].style.backgroundColor = "white";		
	}

	while(source.tagName != highlightbehavior && source.tagName != "HTML") {
		source = ns6 ? source.parentNode : source.parentElement
	}

	if (source.style.backgroundColor != highlightcolor && source.id != "ignore") {
		source.style.backgroundColor = highlightcolor
	}
}

function openPopup(page, queryString) {
	window.open(page + ".jsp?" + queryString, "", 
		"menubar=no,resizable=no,toolbar=no,scrollbars=yes,width=750,height=450,status=yes,left=" 
		+ (screen.availWidth - 600) / 2 + ",top=" + (screen.availHeight - 500) / 2);	
}

function openPopupForJSF(page, formName, queryString) {
	var tk = queryString.split("&amp;");
	if(tk.length == 1 && tk[0].split("=").length > 2)
		tk = queryString.split("&");
	
	var hasFormParam = false;
	for(var i = 0; i < tk.length; i++) {
		var t = tk[i].split("=");
		if(t.length != 2)
			continue;
		
		if(t[0] == "form")
			hasFormParam = true;
		
		tk[i] = t[0] + "=" + formName + ":" + t[1];
	}

	var qStr = "";
	for(var i = 0; i < tk.length; i++) {
		if(i > 0)
			qStr += "&amp;" + tk[i];
		else qStr = tk[i];
	}
	
	if(!hasFormParam && qStr != "")
		qStr += "&amp;form=" + formName;
	
	window.open(page + ".jsp?" + qStr, "", 
		"menubar=no,resizable=no,toolbar=no,width=750,height=450,status=yes,left=" 
		+ (screen.availWidth - 600) / 2 + ",top=" + (screen.availHeight - 500) / 2);	
}

function getCVInfoAuto(contextPath,cvCodeId,DocDateId,cvDescId){	
	
	var cvCodeField = document.getElementById(cvCodeId);
	if(!cvCodeField.readOnly){		
			if(cvCodeField.value == ""){
					var field = document.getElementById(cvDescId);
					field.value = "";
					return true;
			}
			var DocDateField = document.getElementById(DocDateId);
			
			var url = contextPath+"/common/COM0010_auto.jsp?docDate="+DocDateField.value+"&cvCode="+cvCodeField.value+"&cvDescId="+cvDescId+"&cvCodeId=" + cvCodeId;		
			
			var popup = window.open(encodeURI(url), 'hiddenFrame','status = 0, height =0, width =0, resizable=0' );		
	}
	return true;
}

function getCreditInfoAuto(contextPath,groupId,cvDescId,group){	
	
	var url = contextPath+"/common/COM0020_auto.jsp?groupID="+groupId+"&cvDescId=" + cvDescId+"&group=" + group;
	var popup = window.open(encodeURI(url), 'hiddenFrame','status = 0, height =0, width =0, resizable=0' );		
	
	return true;
}

function getCvOrBankInfoAuto(contextPath,cvCodeId,DocDateId,cvDescId){	
	
	var cvCodeField = document.getElementById(cvCodeId);
	if(!cvCodeField.readOnly){		
			if(cvCodeField.value == ""){
					var field = document.getElementById(cvDescId);
					field.value = "";
					return true;
			}
			var DocDateField = document.getElementById(DocDateId);
			
			var url = contextPath+"/common/COM0018_auto.jsp?docDate="+DocDateField.value+"&cvCode="+cvCodeField.value+"&cvDescId="+cvDescId+"&cvCodeId=" + cvCodeId;		
			
			var popup = window.open(encodeURI(url), 'hiddenFrame','status = 0, height =0, width =0, resizable=0' );		
	}
	return true;
}

function getBranchInfoAuto(contextPath,branchCodeId,DocDateId,branchDescId){	
	var branchCodeField = document.getElementById(branchCodeId);
	if(!branchCodeField.readOnly){		
			if(branchCodeField.value == ""){
					var branchDescField = document.getElementById(branchDescId);					
					branchDescField.value = "";
					var branchCodeField = document.getElementById(branchCodeId);					
					setStyleValid(branchCodeField);
					return true;
			}		
			var DocDateField = document.getElementById(DocDateId);
			
			var url = contextPath+"/common/COM0011_auto.jsp?docDate="+DocDateField.value+"&branchCode="+branchCodeField.value+"&branchDescId="+branchDescId;		
			url = url+"&branchCodeId="+branchCodeId;			
			var popup = window.open(encodeURI(url), 'hiddenFrame','status = 0, height =0, width =0, resizable=0' );		
	}
	return true;
}

function getProductInfoAuto(contextPath, 
							branchCodeId,
							docDateId,
							productCodeId,
							pmaCodeId,							 												
							productDescId,
							isSiiId,
							isSupplyUsedId,
							costPerCaseId,
							costPerUnitId,
							vatRateId,
							packSizeId,
							retailPackSizeId,
							retailPerPackId,
							retailPerUnitId,
							isAssortmentId,
							fromPage){	

	var branchCodeField = document.getElementById(branchCodeId);
	var docDateField = document.getElementById(docDateId);
	var productCodeField = document.getElementById(productCodeId);
	
	if (productCodeField.length != 7) {
		alert('\u0E23\u0E2B\u0E31\u0E2A\u0E2A\u0E34\u0E19\u0E04\u0E49\u0E32\u0E15\u0E49\u0E2D\u0E07\u0E40\u0E1B\u0E47\u0E19 7 \u0E2B\u0E25\u0E31\u0E01');
		productCodeField.value = "";
		return false;
	}
	
	var aWindow = null;
	if(!productCodeField.readOnly){						
			
			var url = contextPath+"/common/COM0017_auto.jsp?docDate="+docDateField.value;
			url = url + "&amp;productCode=" + productCodeField.value;
			url = url + "&amp;branchCode=" + branchCodeField.value;
			url = url + "&amp;productCodeId="+productCodeId;
			url = url + "&amp;pmaCodeId="+pmaCodeId;
			url = url + "&amp;productDescId="+productDescId;
			url = url + "&amp;isSiiId="+isSiiId;
			url = url + "&amp;isSupplyUsedId="+isSupplyUsedId;
			url = url + "&amp;costPerCaseId="+costPerCaseId;
			url = url + "&amp;costPerUnitId="+costPerUnitId;
			url = url + "&amp;vatRateId="+vatRateId;
			url = url + "&amp;packSizeId="+packSizeId;
			url = url + "&amp;retailPackSizeId="+retailPackSizeId;
			url = url + "&amp;retailPerPackId="+retailPerPackId;
			url = url + "&amp;retailPerUnitId="+retailPerUnitId;
			url = url + "&amp;isAssortmentId="+isAssortmentId;
			url = url + "&amp;fromPage="+fromPage;
			aWindow = window.open(encodeURI(url), 'hiddenFrame','status = 0, height =0, width =0, resizable=0' );		
	}
	
	return aWindow;
}

function getRowIndex(thisObj, thisEvent, tableId) {
	var table = document.getElementById(tableId);
	
	rows = table.rows;
	
	var index = -1;
	for(var i=0; i<rows.length; i++){
		row = rows[i];			
		if(row.contains(thisObj)){				
			index = i;
		}
	}
	
	return index;
}

function getRowIndex2(thisObj, thisEvent, tableId, parentWindow) {
	var table = parentWindow.document.getElementById(tableId);
	
	rows = table.rows;
	
	var index = -1;
	for(var i=0; i<rows.length; i++){
		row = rows[i];			
		if(row.contains(thisObj)){				
			index = i;
		}
	}
	
	return index;
}

function formatDateDDMMBBWithSlash(field,aEvent){
	//alert("field.value : "+field.value);
	//alert("keyCode : "+aEvent.keyCode);
	var value = field.value;
	if(value.length == 2){
		if(aEvent != null && aEvent.keyCode != 47 && aEvent.keyCode != 13 ){
			field.value = field.value+"/";
			return true;
		}
	}else if(value.length == 5){
		if(aEvent != null && aEvent.keyCode != 47 && aEvent.keyCode != 13){
			//alert("5 value : "+field.value);
			field.value = field.value+"/";
			return true;
		}
	}
	return true;
}

function displaytime(){

	var datestring = "";
	var timestring = "";
	
	var calendar = new Date();

	var day = calendar.getDay();
	var month = calendar.getMonth();
	var date = calendar.getDate();
	var year = calendar.getYear();

	if (year < 1000)
	year+=1900
	cent = parseInt(year/100);
	g = year % 19;
	k = parseInt((cent - 17)/25);
	i = (cent - parseInt(cent/4) - parseInt((cent - k)/3) + 19*g + 15) % 30;
	i = i - parseInt(i/28)*(1 - parseInt(i/28)*parseInt(29/(i+1))*parseInt((21-g)/11));
	j = (year + parseInt(year/4) + i + 2 - cent + parseInt(cent/4)) % 7;
	l = i - j;
	emonth = 3 + parseInt((l + 40)/44);
	edate = l + 28 - 31*parseInt((emonth/4));
	emonth--;

	//var dayname = new Array ("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday");
	//var dayname = new Array ("วันอาทิตย์", "วันจันทร์", "วันอังคาร", "วันพุทธ", "วันพฤหัสบดี", "วันศุกร์", "วันเสาร์");
	//var monthname = new Array ("January","February","March","April","May","June","July","August","September","October","November","December" );
	var monthname = new Array ("มกราคม","กุมภาพันธ์","มีนาคม","เมษายน","พฤษภาคม","มิถุนายน","กรกฎาคม","สิงหาคม","กันยายน","ตุลาคม","พฤศจิกายน","ธันวาคม" );
	
	
	// datestring = datestring + dayname[day] + ", "; // For day.
	if (date< 10){
		datestring = datestring + "0" + date + " ";
	}else{
		datestring = datestring + date + " ";
	}

	datestring = datestring + monthname[month] + " "; // For month word.

	/*
	if(month < 10){
		datestring = datestring + "0" + month + "/";
	}else{
		datestring = datestring + month + "/";
	}
	*/
	datestring = datestring + (parseInt(year)+543);
	

	/**
	 * Get current time.
	 **/	
	var hours=calendar.getHours()
	var minutes=calendar.getMinutes()
	var seconds=calendar.getSeconds()
	var hh = hours < 10 ? "0"+hours :""+hours;
	var mm = minutes < 10 ? "0"+minutes :""+minutes;
	var ss = seconds < 10 ? "0"+seconds :""+seconds;

	timestring = hh +":"+mm+":"+ss;
	
	document.getElementById("myTime").innerHTML= datestring+" "+timestring;
	
}



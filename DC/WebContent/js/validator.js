var validClassName = 'inputText';
var invalidClassName = 'bgValidateError';
var requireClassName = 'inputTextRequire';
var requireErrorClassName = 'bgRequireError';


function setStyleValid(field){
	if(field.className == invalidClassName){
		field.className = validClassName;
	}else if(field.className == requireErrorClassName){
		field.className = requireClassName;
	}
}

function setStyleInvalid(field){
	if(field.className == validClassName){
		field.className = invalidClassName;
	}else if(field.className == requireClassName){
		field.className = requireErrorClassName;
	}
}

function isCurrency(elm) {
	var nNum = 0;			// Total numbers for currency value.
	var nDecimal = 0;		// Total times a decimal point occurs.
	var nCommas = 0;		// Total times a comma occurs.
	var txtLen;				// Length of string passed.
	var xTxt;				// Assigned object passed.
	var sDollarVal;			// Assigned dollar amount with or without commas.
	var bComma;				
	var decPos = 0;			// Assigned value of numbers or positions after decimal point.
	var nNumCount = 0;		// Total number between commas.
	var i;					// For forloop indexing.
	var x;					// Assigned each indivual character in string.

	// Set the xTxt variable to the object passed to this function.
	// Assign the length of the string to txtLen.
	xTxt = elm;
	txtLen = xTxt.value.length

	for(i = 0; i < txtLen; i++) {
		// Assign charater in substring to x.
		x = xTxt.value.substr(i, 1);
		
		if(x == ".") {
			nDecimal = nDecimal + 1; // Sum total times decimal point occurs.
		} else if(x == ",") {
			nCommas = nCommas + 1; // Sum total times comma occurs.
		} else if (x == "-") {
			if (i != 0) {
				
				return false;
			}
		} else if(parseInt(x) >= 0 || parseInt(x) <= 9) {
			nNum = nNum + 1; // If the character is a number sum total times a number occurs.
		} else {
		
			// Error occurs if any other character value is in the string
			// other then the valid characters.
//			alert("You have entered an illegal value.");
			return false;
		}
	}
	
	
	
	// check number of decimal point
	if(nDecimal > 1) {
//		alert("You have entered more then one decimal point.");
		return false;
	}

	// check position of decimal point
	if(nDecimal == 1) {
		// Get the number of numbers after the decimal point in
		// the string if there is a decimal point present
		decPos = (txtLen - 1) - xTxt.value.indexOf(".");
		
		// Floating point cannot be more then two.
		// Valid format after decimal point.
		/**********************************/
		/*   #.##, #.#, .#, .##  */
		/**********************************/
		if(decPos == 0 || decPos > 2) {
//			alert("The decimal point you entered is not in the correct position.");
			return false;
		}
	}
	
	if(nCommas == 0) {
		// If no commas are present value is a valid currency.
		return true;
	} else {
		// Get total number of dollar number(s), removing floating point numbers or cents.
		nNum = nNum - decPos;
		
		sDollarVal = xTxt.value.substr(0, (nNum + nCommas));
		
		// Determine if a zero is the first number or if a
		// comma is the first or last character in the string.
		if(sDollarVal.lastIndexOf("0", 0) == 0 ) {
//			alert("You cannot start the amount out with a zero.");
			return false;
		} else if(sDollarVal.lastIndexOf(",", 0) == 0) {
//			alert("You cannot start the amount out with a comma.");
			return false;
		} else {
			// Initialize bComma indicating a comma has not been occured yet.
			bComma = false;
			for(i = 0; i < sDollarVal.length; i++) {
				// Assign charater in substring to x.
				x = sDollarVal.substr(i, 1);
				if(parseInt(x) >= 0 || parseInt(x) <= 9) {
					// If x is a number add one to the number counter.
					nNumCount = nNumCount + 1;

					// Sense comma(s) are present number counter cannot be more then three before the first or next comma.
					if(nNumCount > 3) {
//						alert("You have a mis-placed comma.");
						return false;
					}
				} else {
					// If the number counter is less then three and
					// the comma indicator is true the comma is either
					// mis-placed or there are not enough values.

					if(nNumCount != 3 && bComma) {
//						alert("You have a mis-placed comma.");
						return false;
					}

					// Reset the number counter back to zero.
					nNumCount = 0;

					// Set the comma indicator to true indicating
					// that the first comma has been found and that
					// there now MUST be three numbers after each
					// comma until the loop hits the end.
					bComma = true;
				}
			}

			// Determine if after the loop ended that there
			// was a total of three final numbers after the
			// last comma.
			if(nNumCount != 3 && bComma) {
//				alert("You have a mis-placed comma.");
				return false;
			}
		}
	}

	// Return true indicating that the value is a valid
	// currency.
	return true;
}

function isCurrencyWithNegative(elm) {
	var value = elm.value;
	
	if(value != null && value != ""){
		var firstDigit = value.substring(0,1);
		
		if(firstDigit == "-"){ // Negative
			// var temp = value;
			elm.value = value.substring(1,value.length);
			var isValid = isCurrency(elm);
			elm.value = value;
			return isValid;
		}else{ // Positive
			return isCurrency(elm);
		}	
	}
	return true;
}

function validateCurrencyWithNegative(elm,message){
	if(isCurrencyWithNegative(elm)){
		setStyleValid(elm);
		return true;
	}else{
		setStyleInvalid(elm);
		alert(message);
		elm.focus();
		return false;
	}
}

function isCurrencyChangeAble(elm) {
	var nNum = 0;			// Total numbers for currency value.
	var nSign = 0;			// Total numbers for sign.
	var nDecimal = 0;		// Total times a decimal point occurs.
	var nCommas = 0;		// Total times a comma occurs.
	var txtLen;				// Length of string passed.
	var xTxt;				// Assigned object passed.
	var sDollarVal;			// Assigned dollar amount with or without commas.
	var bComma;				
	var decPos = 0;			// Assigned value of numbers or positions after decimal point.
	var nNumCount = 0;		// Total number between commas.
	var i;					// For forloop indexing.
	var x;					// Assigned each indivual character in string.

	// Set the xTxt variable to the object passed to this function.
	// Assign the length of the string to txtLen.
	xTxt = elm;
	txtLen = xTxt.value.length

	for(i = 0; i < txtLen; i++) {
		// Assign charater in substring to x.
		x = xTxt.value.substr(i, 1);
		
		if(x == ".") {
			nDecimal = nDecimal + 1; // Sum total times decimal point occurs.
		} else if(x == ",") {
			nCommas = nCommas + 1; // Sum total times comma occurs.
		} else if(parseInt(x) >= 0 || parseInt(x) <= 9) {
			nNum = nNum + 1; // If the character is a number sum total times a number occurs.
		} else if (x == "-") {
			nSign = nSign + 1;
		} else {
			// Error occurs if any other character value is in the string
			// other then the valid characters.
//			alert("You have entered an illegal value.");
			return false;
		}
	}
	
	if (nSign > 1) {
		return false;
	}

	// check number of decimal point
	if(nDecimal > 1) {
//		alert("You have entered more then one decimal point.");
		return false;
	}

	// check position of decimal point
	if(nDecimal == 1) {
		// Get the number of numbers after the decimal point in
		// the string if there is a decimal point present
		decPos = (txtLen - 1) - xTxt.value.indexOf(".");
		
		// Floating point cannot be more then two.
		// Valid format after decimal point.
		/**********************************/
		/*   #.##, #.#, .#, .##  */
		/**********************************/
		
		if(decPos == 0 || decPos > 2) {
//			alert("The decimal point you entered is not in the correct position.");
			return false;
		}
		
		var decPoint = xTxt.value.substr(xTxt.value.indexOf(".") + 1, txtLen);
		if (!(decPoint == 00 ||
			decPoint == 0 ||
			decPoint == 25 ||
			decPoint == 50 ||
			decPoint == 5 ||
			decPoint == 75)) {
			
			return false;		
		}
		
	}

	if(nCommas == 0) {
		// If no commas are present value is a valid currency.
		return true;
	} else {
		// Get total number of dollar number(s), removing floating point numbers or cents.
		nNum = nNum - decPos;
		
		sDollarVal = xTxt.value.substr(0, (nNum + nCommas));
		
		// Determine if a zero is the first number or if a
		// comma is the first or last character in the string.
		if(sDollarVal.lastIndexOf("0", 0) == 0 ) {
//			alert("You cannot start the amount out with a zero.");
			return false;
		} else if(sDollarVal.lastIndexOf(",", 0) == 0) {
//			alert("You cannot start the amount out with a comma.");
			return false;
		} else {
			// Initialize bComma indicating a comma has not been occured yet.
			bComma = false;
			for(i = 0; i < sDollarVal.length; i++) {
				// Assign charater in substring to x.
				x = sDollarVal.substr(i, 1);
				if(parseInt(x) >= 0 || parseInt(x) <= 9) {
					// If x is a number add one to the number counter.
					nNumCount = nNumCount + 1;

					// Sense comma(s) are present number counter cannot be more then three before the first or next comma.
					if(nNumCount > 3) {
//						alert("You have a mis-placed comma.");
						return false;
					}
				} else {
					// If the number counter is less then three and
					// the comma indicator is true the comma is either
					// mis-placed or there are not enough values.

					if(nNumCount != 3 && bComma) {
//						alert("You have a mis-placed comma.");
						return false;
					}

					// Reset the number counter back to zero.
					nNumCount = 0;

					// Set the comma indicator to true indicating
					// that the first comma has been found and that
					// there now MUST be three numbers after each
					// comma until the loop hits the end.
					bComma = true;
				}
			}

			// Determine if after the loop ended that there
			// was a total of three final numbers after the
			// last comma.
			if(nNumCount != 3 && bComma) {
//				alert("You have a mis-placed comma.");
				return false;
			}
		}
	}

	// Return true indicating that the value is a valid
	// currency.
	return true;
}
function isIntegerWithcommaAndNegative(elm){
	if(isCurrencyWithNegative(elm)){		
		xTxt = elm;
		txtLen = xTxt.value.length
		var valid = true;
		for(i = 0; i < txtLen; i++) {
			// Assign charater in substring to x.
			var x = xTxt.value.substr(i, 1);
			if(x == "."){
				valid = false;
				break;
			}
		}

		return valid;

	}else{	    
		return false;
	}
}
function validateIntegerWithCommaAndNeg(elm,message){
	if(isIntegerWithcommaAndNegative(elm)){
		setStyleValid(elm);
		return true;
	}else{
		setStyleInvalid(elm);
		alert(message);
		elm.focus();
		return false;
	}
}
/**
 * Check input in element is a integer or integer with comma.
 * elm - Element to be checked.
 *
 */
function isIntegerWithcomma(elm){
	if(isCurrency(elm)){
		xTxt = elm;
		txtLen = xTxt.value.length
		var valid = true;
		for(i = 0; i < txtLen; i++) {
			// Assign charater in substring to x.
			var x = xTxt.value.substr(i, 1);
			if(x == "."){
				valid = false;
				break;
			}
		}

		return valid;

	}else{
		return false;
	}
}

/**
 * Convert currency format to number.
 * num - currency format to be converted
 *
 */
function currencyToNumber(num) {
	var result = "";
	
	for(i = 0; i < num.length; i++) {
		var x = num.substr(i, 1);
		
		if(parseInt(x) >= 0 || parseInt(x) <= 9 || x == "." || x == "-") {	
			result = result + x;
		}
	}
	
	return result;	
}

function formatCurrency(num) {
	num = num.toString().replace(/\$|\,/g,'');
	
	if(isNaN(num)) num = "0";
	
	sign = (num == (num = Math.abs(num)));
	num = Math.floor(num * 100+0.50000000001);
	cents = num % 100;
	num = Math.floor(num / 100).toString();
	
	if(cents < 10) cents = "0" + cents;
	
	for(var i = 0; i < Math.floor((num.length - (1 + i)) / 3); i++)
		//num = num.substring(0, num.length - (4 * i + 3)) + ',' + num.substring(num.length - (4 * i + 3));
		num = num.substring(0, num.length - (4 * i + 3)) + '' + num.substring(num.length - (4 * i + 3));
	
	return (((sign) ? '' : '-') + num + '.' + cents);
}


function formatCurrencyWithDecimalPoint(num, point) {
	num = num.toString().replace(/\$|\,/g,'');
	
	if(isNaN(num)) num = "0";
	
	var numSys = Math.pow(10, point);
	sign = (num == (num = Math.abs(num)));
	num = Math.floor(num * numSys + 0.50000000001);
	cents = num % numSys;
	num = Math.floor(num / numSys).toString();
	
	var x = Math.pow(10, point-1);
	if (cents < x) {
		var padding = '';
		var clen = cents.toString().length;
		for (var z = 0; z < point-clen; z++) {
			padding += '0';
		}
		cents = padding + cents;
	}
	
	for (var i = 0; i < Math.floor((num.length - (1 + i)) / 3); i++) {
		num = num.substring(0, num.length - (4 * i + 3)) + ',' + num.substring(num.length - (4 * i + 3));	
	}

	return (((sign) ? '' : '-') + num + '.' + cents);
}

/**
 * Format to integer with comma such as 1,000.
 *
 */
function formatIntegerWithComma(num) {	
	var result = "";
	num = formatCurrency(num);
	var index = num.indexOf(".");
	
	if(index != -1){
		num = num.substring(0,index);
	}
	
	return num;
}

//  select checkbox before click button
function validateCheckbox(element,form) {
	var lenCheckbox = element.length; 
	if (lenCheckbox == null) {
		if(element.checked) {
			form.submit();
			return true; 
		}
	} else
		for (var j = 0; j < lenCheckbox; j++) {	   
			if (element[j].checked) {
				form.submit();
				return true; 	 
			}//if 
		}//for
		
		alert("��س����͡���ҧ���� 1 ��¡��");					
		return false;
}	

/**
 * Check amount.
 * value - a value to be checked. 
 */
function CheckAmount(value) {
	var s = true;
	for (var a = 0; a < value.length; a++) {
		var c = value.substring(a, a+1);
		if (c < "0" || c > "9") {
			if (c == ".") {
				s = true
			} else {
				s = false
				break;
			}
		}
	}
	if (s == true) {
		return true;
	} else {
		return false;
	}
}

/**
 * Validate decimal field with alert message.
 * Use only text field. 
 * field - text field to be validated.
 * message -message to be alerted to user, when invalid decimal.
 */
function validateDecimal(field,message){
	var nDecimal=0;
	var txtLen = field.value.length;
	for(i = 0; i < txtLen; i++) {
		// Assign charater in substring to x.
		x = field.value.substr(i, 1);		
		if(x == ".") {
			nDecimal = nDecimal + 1; 
		}				
	}
	
	if(nDecimal >= 2){
		setStyleInvalid(field);
		alert(message);		
		field.focus();
		return false;
	}
	if(CheckAmount(field.value)){
		setStyleValid(field);
		return true;
	}else{
		setStyleInvalid(field);		
		alert(message);		
		field.focus();
	}
	return false;
}//end isValidDecimal

function isInteger(field) {
	var txtLen = field.value.length;
	var isValid = true;
	
	for(i = 0; i < txtLen; i++) {
		// Assign charater in substring to x.			
		x = field.value.substr(i, 1);		
		if ( x < "0" || x > "9" ) {
			isValid = false;
		}		
	}
	
	return isValid;
}
/**
 * Validate value in text-field is integer only such as 123, 456 .
 * field - text field to be validated.
 * message -message to be alerted to user, when value is not integer. 
 */
function validateInteger(field ,message){
	var txtLen = field.value.length;
	var isValid = true;
	
	for(i = 0; i < txtLen; i++) {
		// Assign charater in substring to x.			
		x = field.value.substr(i, 1);		
		if ( x < "0" || x > "9" ) {
			isValid = false;
		}		
	}
	
	if(isValid){
		setStyleValid(field);
		return true;
	}else{
		setStyleInvalid(field);
		alert(message);		
		field.focus();
	}
	return false;
}
/**
 * Validate value is integer only such as 123, 456 .
 *  
 */
function validateInteger2(value){
	
	var txtLen = value.length;	
	var isValid = true;
	
	for(i = 0; i < txtLen; i++) {
		// Assign charater in substring to x.				
		x = value.substr(i, 1);		
		if ( x < "0" || x > "9" ) {
			isValid = false;
		}		
	}
	
	return isValid;
}

function validateIntegerWithcommaAndNegative(field,message){
	var valid = false;
	if(isIntegerWithcommaAndNegative(field)){
		valid = true;
	}else{		
		valid = false;
	}

	if(valid){
		setStyleValid(field);
		return true;
	}else{
		setStyleInvalid(field);
		alert(message);		
		field.focus();
	}
}

/**
 * Validate input is a integer or integer with comma such as 123, 1,000, 12,121.
 * field - Field to be validated input. 
 * message - Message to alert if invalid.
 */
function validateIntegerWithcomma(field,message){
	var valid = false;
	if(isIntegerWithcomma(field)){
		valid = true;
	}else{		
		valid = false;
	}

	if(valid){
		setStyleValid(field);
		return true;
	}else{
		setStyleInvalid(field);
		alert(message);		
		field.focus();
	}
}	

/**
 * Change style class of text field to normal style.
 * field - text field to be changed style class.
 */
function changeToValidStyleTextField(field){	
	setStyleValid(field);
	return;
}

/**
 * Change style class of combo box to normal style.
 * select - combo box to be changed style class.
 */
function changeToValidStyleComboBox(select){
	select.className='';
	return;
}

/**
 * Validate currency field.
 * field - text field to be validated.
 * message - message to be alerted to user, when invalid currency format.
 */
function validateCurrency(field,message){	
	
	if(isCurrency(field)){
		setStyleValid(field);
		return true;
	}else{		
		setStyleInvalid(field);
		field.focus();
		alert(message);
	}
	return false;
}

function validateCurrencyWithNegative(field,message){	
	
	if(isCurrencyWithNegative(field)){
		setStyleValid(field);
		return true;
	}else{		
		setStyleInvalid(field);
		field.focus();
		alert(message);
	}
	return false;
}

function validateCurrencyWithChangeAble(field,message){	
	
	if(isCurrencyChangeAble(field)){
		setStyleValid(field);
		return true;
	}else{		
		setStyleInvalid(field);
		field.focus();
		alert(message);
	}
	return false;
}

/**
 * Highlight text field on click.
 * field - text field to be highlighten.
 */
function highlightText(elmId){
	var field = document.getElementById(elmId);
	field.select();
}

function resetTextField(form,val){
	var len = form.elements.length; 
	
	for (var i = 0; i < len; i++) {
		if (form.elements[i].type == "text") {
			form.elements[i].value = val;
		}				
	}	
	return true;	
}

/**
 * Reset all field except hidden, button
 * form - form
 *
 */
function resetAll(form){
	var len = form.elements.length;
	
	for (var i = 0; i < len; i++) {
		// input type text
		if (form.elements[i].type == "text") {
			form.elements[i].value = "";
		} 
		// input type radio
		else if (form.elements[i].type == "radio") {
			var elm = document.getElementsByName(form.elements[i].name);
			elm[0].checked = true;
			i = i + elm.length - 1;
		}
		// input type password
		else if (form.elements[i].type == "password") {
			form.elements[i].value = "";
		}
		// input type textarea
		else if (form.elements[i].type == "textarea") {
			form.elements[i].value = "";
		}
		// input type select-one
		else if (form.elements[i].type == "select-one") {
			var elm = form.elements[i].options;
			elm[0].selected = true;
		}
		// input type hidden
		else if (form.elements[i].type == "hidden") {
		
		}
	}	
	
	return true;	
}

/**
 * Validate text field is percent format between 0 and 100.
 * elm - text field to be validated.
 * msg1 message to be alerted to user, when value is not a number.
 * msg2 message to be alerted to user, when value is not btween 0 and 100.
 */
function validatePercent(elm,msg1,msg2){
	var x = 0;
	
	if (validDecimal(elmId, msg1)) {
		x = elm.value;		
		if (!isNaN(x)) {
			if (x >= 0 && x <= 100) {
				return true;
			} else {
				setStyleInvalid(elm);
				alert(msg2);				
				elm.focus();
			}
		}
	}
	
	return false;
}

function CheckBlank(element) {
	var e = element;
	if (e.type == "text" || e.type == "password" || e.type == "textarea" || e.type == "file") {
		while ('' + e.value.charAt(0) == ' ') {
			e.value = e.value.substring(1, e.value.length);
		}
		while ('' + e.value.charAt(e.value.length-1) == ' ') {
			e.value = e.value.substring(0, e.value.length-1);
		}
		if (e.value == null || e.value == "" || e.value == ' ' || e.value.length == 0) {
			return true;
		} else {
			return false;
		}
	}
	//Gf2: Check if select boxed is selected.
	if (e.type == "select-one" || e.type == "select-multiple") {
		//if (e.value == "" || e.value == '' || e.value == null || e.value == "none" || e.value == "any") {
		if (e.selectedIndex ==0 || e.selectedIndex == "none" || e.selectedIndex ==-1 )   {
			return true;
		} else {
			return false;
		}
	}
	//Gf3: Check if radio is checked
	if (e.type == "radio" || e.type == "checkbox") {
		var status = true;
		if (!e.checked) {
			return true;
		} else {
			return false;
		}
	}
}

/**
 * Validate  Form
 * form - the specific form object.	
 */
function validateForm(form){
			
	var status = true;
	
	var len = form.elements.length ; 
	for (var i = 0; i < len; i++) {
		var elm = form.elements[i];
		var name = form.elements[i].name;
		var type = form.elements[i].type;	
		if (form.elements[i].type == "hidden") {	
		    // check require input text field
	    	if (form.elements[i].value == "require") {				
				if (CheckBlank(form.elements[i-1])) {
					status = false;					
					setStyleInvalid(form.elements[i-1]);
				} else {					
					setStyleValid(form.elements[i-1]);
				}// End check  require
			// check phone
			}else if (form.elements[i].value== "phone") {
			    if (CheckBlank(form.elements[i-1])) {
					if (form.elements[i].faq == "1") {
						setStyleValid(form.elements[i-1]);
					} else {
                       	status = false;
					    setStyleInvalid(form.elements[i-1]);
					}
				} else {
					if (CheckTel(form.elements[i-1].value)) {
					 	form.elements[i-1].className = validClassName;
					} else {
						status = false;
						form.elements[i-1].className = invalidClassName;
					}	
				}// End Check  phone
            // check digit				
			}else if (form.elements[i].value== "digit") {
				if (CheckBlank(form.elements[i-1])) {
					if (form.elements[i].faq == "1") {
						form.elements[i-1].className = validClassName;
					} else {
                        status = false;
						form.elements[i-1].className = invalidClassName;  
					}
				} else {
					if (CheckDigit(form.elements[i-1].value)) {
						form.elements[i-1].className = validClassName;
						if(form.elements[i-1].value.indexOf(",")) {
							form.elements[i-1].className = validClassName;
						}
					} else {
						status = false;
						form.elements[i-1].className = invalidClassName;
					}
				}// End Check digit
            // check digit	
            } else if (form.elements[i].value== "amount") {
				if (CheckBlank(form.elements[i-1])) {
					if (form.elements[i].faq == "1") {
						form.elements[i-1].className = validClassName;
					} else {
                        status = false;
						form.elements[i-1].className = invalidClassName;  
					}
				} else {
					if (CheckAmount(form.elements[i-1].value)) {
						form.elements[i-1].className = validClassName;
						if(form.elements[i-1].value.indexOf(",")) {
							form.elements[i-1].className = validClassName;
						}
					} else {
						status = false;
						form.elements[i-1].className = invalidClassName;
					}
				}// End Check Amount
				// check currency
            } else if (form.elements[i].value== "currency") {
				if (CheckBlank(form.elements[i-1])) {
					if (form.elements[i].faq == "1") {
						form.elements[i-1].className = validClassName;
					} else {
                        status = false;
						form.elements[i-1].className = invalidClassName;  
					}
				} else {
					if (CheckCurrency(form.elements[i-1].value)) {
						form.elements[i-1].className = validClassName;
						if(form.elements[i-1].value.indexOf(",")) {
							form.elements[i-1].className = validClassName;
						}
					} else {
						status = false;
						form.elements[i-1].className = invalidClassName;
					}
				}// End Check currency
			// check amount
			} else if (form.elements[i].value== "dateFormat") {
				if (CheckBlank(form.elements[i-1])) {
					status = false;
					form.elements[i-1].className = invalidClassName;
				} else {
					if (CheckDate(form.elements[i-1].value)) {
						form.elements[i-1].className = validClassName;
					} else {
						status = false;
						form.elements[i-1].className = invalidClassName;
					}
				}// End Check dateFormat
			// check email format or blank				
			} else if (form.elements[i].value=="email") {
				if (CheckBlank(form.elements[i-1])) {
					if (form.elements[i].faq == "1") {
						form.elements[i-1].className = validClassName;
					} else {
                        status = false;
						form.elements[i-1].className = invalidClassName;  
					}
				} else {
					if (form.elements[i-1].value.match(/([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9._-]+)/gi) ) {
						form.elements[i-1].className = validClassName;
					} else {
						status = false;
						form.elements[i-1].className = invalidClassName;
					}
				}//End check Email
			//check password. Please put <input type="hidden" name="password"> between password and repassword!!!!!!				
			} else if (form.elements[i].value == "password") {
				if (CheckBlank(form.elements[i-1]) && CheckBlank(form.elements[i+1])){
					status = false;
					form.elements[i-1].className = invalidClassName;
					form.elements[i+1].className = invalidClassName;
				} else {
					if (form.elements[i-1].value != form.elements[i+1].value) {
						status = false;
						form.elements[i-1].className = validClassName;
						form.elements[i+1].className = invalidClassName;							
					} else {
						form.elements[i-1].className = validClassName;
						form.elements[i+1].className = validClassName;							
					}
				}
			}
      	} // if hidden       	
	} // for
	
	if (status) {
		return true;
	}
	return false;
} // end func

function validateDateFormatddmmBB(dateField,errorMessage){
	if(!validateInteger(dateField,errorMessage)){
			return false;
	}
	
	if(dateField.value != "" && dateField.value.length != 6){
		setStyleInvalid(dateField);
		alert(errorMessage);		
		dateField.focus();
		return false;
	}
	
	setStyleValid(dateField);
	return true;
}

function validateDateFormatddmmBBWithSlash(dateField,errorMessage){
		
	if(dateField.value != "" && dateField.value.length != 8){
		setStyleInvalid(dateField);
		alert(errorMessage);		
		dateField.focus();
		return false;
	}
	
	var dd = dateField.value.substring(0,2);
	var mm = dateField.value.substring(3,5);
	var BB = dateField.value.substring(6);
	
	if(!validateInteger2(dd)){
		setStyleInvalid(dateField);
		alert(errorMessage);		
		dateField.focus();
		return false;
	}
	if(!validateInteger2(mm)){
		setStyleInvalid(dateField);
		alert(errorMessage);		
		dateField.focus();
		return false;
	}
	if(!validateInteger2(BB)){
		setStyleInvalid(dateField);
		alert(errorMessage);		
		dateField.focus();
		return false;
	}
	dd = (dd.substring(0,1) == "0")?dd.substring(1,2) :dd;
	mm = (mm.substring(0,1) == "0")?mm.substring(1,2) :mm;
		
	var intDD = parseInt(dd);
	var intMM = parseInt(mm);
	var intBB = parseInt(BB);
	
	if(intDD < 1 || intDD > 31){
		setStyleInvalid(dateField);
		alert(errorMessage);		
		dateField.focus();
		return false;
	}
	if(intMM < 1 || intMM > 12){
		setStyleInvalid(dateField);
		alert(errorMessage);		
		dateField.focus();
		return false;
	}	
	
	setStyleValid(dateField);
	return true;
}

// Removes leading and ending whitespaces
function trim(value) {
	return LTrim(RTrim(value));
}
// Removes start whitespaces
function LTrim(value) {
	var re = /\s*((\S+\s*)*)/;
	return value.replace(re, "$1");
}

// Removes ending whitespaces
function RTrim( value ) {
	var re = /((\s*\S+)*)\s*/;
	return value.replace(re, "$1");
}
/**
  toNum(value)
  Desc : convert to Number   
  parameter : 12,000.45 -> 12000.45
                 -1,200 -> -1200
*/
function toNum(s) {
	return Number((''+s).replace(/,/g, ''))  // remove all ',' seperator
}

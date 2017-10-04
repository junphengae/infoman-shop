/*
 * numeric.js
 *
 * Authur : Offen
 */


/**
 * allow to press the number 0-9
 * @usage            : onkeypress="allowNumberOnly( alert('Invalid') )"
 * @param callbackFn : the function you want to execute when the validation is invalid
 */
function allowNumberOnly(callbackFn) {
	//	0 => 48
	//	9 => 57
	if( window.event.keyCode > 57 || window.event.keyCode < 48 ) {
		window.event.returnValue = false;
		callbackFn;
	}
}

/**
 * allow to press the number 0-9, minus(-), comma(,) and dot(.)
 * @usage            : onkeypress="allowRealNumberOnly( alert('Invalid') )"
 * @param callbackFn : the function you want to execute when the validation is invalid
 */
function allowRealNumberOnly(callbackFn) {
	//	0 => 48
	//	9 => 57
	//	, => 44
	//	- => 45
	//	. => 46
	if( window.event.keyCode > 57 || window.event.keyCode < 44 || window.event.keyCode == 47 ) {
		window.event.returnValue = false;
		callbackFn;
	}
}

/**
 * allow to press the number 0-9, comma(,) and dot(.)
 * @usage            : onkeypress="allowPositiveNumberOnly( alert('Invalid') )"
 * @param callbackFn : the function you want to execute when the validation is invalid
 */
function allowPositiveNumberOnly(callbackFn) {
	//	0 => 48
	//	9 => 57
	//	, => 44
	//	. => 46
	if( window.event.keyCode > 57 || window.event.keyCode < 44 || window.event.keyCode == 47 || window.event.keyCode == 45 ) {
		window.event.returnValue = false;
		callbackFn;
	}
}

/**
 * Formatting the number, can set scale, adding commas
 * @usage        : onblur="this.value = formatNumber(this.value, 2)"
 * @param number : the input number
 * @param scale  : the number of the decimal point
 */
function formatNumber(number, scale) {
	decimal = setDecimalPoint( number, scale );
	if( isNaN( decimal ) )
		return '';
	return addCommas( decimal );
}

/**
 * For rounding decimals
 * @usage        : setDecimalPoint( 1234.567, 2 ) => 1234.57
 * @param number : the number to be converted
 * @param scale  : the number of the decimal point
 */
function setDecimalPoint(number, scale) {
	return toNumber( number ).toFixed( scale );
}

/**
 * @usage        : toNumber( 1,234.00 ) => 1234.00
 * @param numStr : the string to convert
 */
function toNumber(numStr) {
	return parseFloat( removeCommas( numStr ) );
}

/**
 * add commas to the number
 * @usage        : addCommas( 12345.6 ) => 12,345.6
 * @param number : integer or float
 */
function addCommas(number)
{
	nStr = '' + number;
	x = nStr.split('.');
	x1 = x[0];
	x2 = x.length > 1 ? '.' + x[1] : '';
	var rgx = /(\d+)(\d{3})/;
	while( rgx.test( x1 ) ) {
		x1 = x1.replace( rgx, '$1,$2' );
	}
	return x1 + x2;
}

/**
 * remove commas from the string number
 * @usage           : removeCommas( 123,456,789 ) => 123456789
 * @param numberStr : the string in the number format
 */
function removeCommas(numberStr) {
	var num = '' + numberStr;
	while( num.indexOf(',') != -1 ) {
		num = num.replace( ',', '' );
	}
	return num;
}
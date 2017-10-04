function Decimal(number){
	var num = ''+number;
	var split_number = '';
	var result = '';
	split_number = num.split('.');
	if( split_number.length > 1 ){
		if( split_number[1].length > 2 ){
			split_number[1] = split_number[1].substring(0,2);
		}
		result = ( split_number[0]+'.'+split_number[1] );
	}else{
		result = ( parseFloat(num).toFixed(2) );
	}
	return result;
}
function comma(number){ 
	var num = ''+uncomma(number);
	var split_number = '';
	var result = '';
	split_number = num.split('.');
	if( split_number.length > 1 ){
		if( split_number[1].length > 2 ){
			split_number[1] = split_number[1].substring(0,2);
		}
	}else{
		split_number[1] = "00";
	}
	if( split_number[0] == '' ){
		result = "0.00";
	}else{
		result = split_number[0].toString().replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,")+"."+split_number[1];
	}
    return result; 
}

function uncomma(number){
	var num = ''+number;
	var split_number = '';
	var result = '';
	split_number = num.split(',');
	var i = 0;
	if( split_number.length > 1 ){
		while( i < split_number.length ){
			result = result+""+split_number[i];
			i++;
		}
	}else{
		result = num;
	}
	return result;
}

function DecimalNumber(number,poin){
	var num = ''+number;
	var split_number = '';
	var result = '';
	split_number = num.split('.');
	if( split_number.length > 1 ){
		if( split_number[1].length > poin ){
			split_number[1] = split_number[1].substring(0,poin);
		}
		result = ( split_number[0]+'.'+split_number[1] );
	}else{
		result = ( parseFloat(num).toFixed(poin) );
	}
	return result;
}

function IntegerNum(number){
	var num = ''+number;
	var split_number = '';
	var result = '';
	split_number = num.split('.');
	if( split_number.length > 1 ){
		if( parseInt( split_number[1] ) > 0 ){
			result =  parseFloat( parseFloat( split_number[0] ) + 1 ).toFixed(2);
		}
	}else{
		result = ( parseFloat(num).toFixed(2) );
	}
	return result;
}
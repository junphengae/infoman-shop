function  RoundUpPointValue( value ){
		var temp =  parseFloat(value).toFixed(2);
		var arrSplit = temp.split(".");
		if( arrSplit.length == 2){
			 // var tempAbsolute =   parseInt(arrSplit[0].replace(",","")) ;
			var tempAbsolute =   parseInt(arrSplit[0]) ;
			   var tempPoint  =   parseInt(arrSplit[1]) ;	
			   if( tempPoint > 75 ){
				   tempPoint = 0;
				   tempAbsolute++;
			   }else if ( tempPoint > 50){
				   tempPoint = 75;
			   }else if( tempPoint > 25){
				   tempPoint = 50;
			   }  else if( tempPoint >0 ){
			   		tempPoint = 25;
			   }else{
			   		tempPoint = 0;
			   }
			   
			   
			   temp = tempAbsolute +"."+ TwoDigitValue( tempPoint.toString());
			 //  alert("Satang : "+temp);
		}
		return temp;
	}
	
	function TwoDigitValue(num){
		if( num.length < 2){
			num+="0";
		}else if( num.length > 2){
			num = num.toFixed(2);
		}
		return num;
	}
	
	function CommaValue( numberVal){
		var temp = numberVal;
		temp = temp.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
		return temp;
	}
function popup(url){
	var Features = "menubar=0,resizable=1,location=0,toolbar=0,scrollbars=1,fullscreen=1,width=1024,height=650";
  	//alert("1");
	pop_window = window.open (url, 'open', Features);
  	pop_window.moveTo(50,50);
  	pop_window.focus();
  	
}

function popupSetWH(url,W,H){
	var Features = "menubar=0,resizable=0,location=0,toolbar=0,scrollbars=0,fullscreen=0,width="+W+",height="+H;
  	pop_window = window.open (url, 'open', Features);
	var winleft	=	(screen.width - W) / 2;
	var winup	=	(screen.height - H) / 2;
  	pop_window.moveTo(winleft,winup);
  	pop_window.focus();
  	
}

function popupReport(url,W,H){
	var Features = "menubar=0,resizable=0,location=0,toolbar=0,scrollbars=1,fullscreen=1,width="+W+",height="+H;
  	pop_window = window.open (url, 'open', Features);
	var winleft	=	(screen.width - W) / 2;
	var winup	=	(screen.height - H) / 2;
  	pop_window.moveTo(winleft,winup);
  	pop_window.focus();
  	
}

function popup(url,name){
	//alert("3");
	var Features = "menubar=0,resizable=1,location=0,toolbar=0,scrollbars=1,fullscreen=1,width=1024,height=650";
  	pop_window = window.open (url, name, Features);
  	pop_window.moveTo(50,50);
  	pop_window.focus();
}


function setSelected(per_id, per_pn, per_name, per_surname){
	window.opener.document.getElementById("KPI_CONTROL_ID_SEARCH").value = parseInt(per_id) + "";
	window.opener.document.getElementById("KPI_CONTROL_NAME_SEARCH").value = per_pn + per_name + " " + per_surname;
	window.close();
}

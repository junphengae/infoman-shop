<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

</head>
<script type="text/javascript">
function validateData() {

if(document.getElementById("nameId").value.trim() == ""){
    alert("Image Name is required");
    return false;
 }
      return true;

}
</script>              
<body>
	<div class="main">

       <div class="rounded_colhead message">${messages.upload}</div>
  
    <form id="imageUploadForm" action="UploadBrandImage" method="post" enctype="multipart/form-data">
                       
                        <fieldset>
        
                          
            <div class="form_row">
                        <label >Image Name</label>
                        <input type="text" class="text" name="order_id" id="nameId"/>
            </div>
          
            <div class="form_row">
                                    <label>Image File :</label>
                <input type="file"  name="fileName" displayName="File"/>
            </div>
                        <div class="form_row">
                        <label></label>
            <input type="submit" class="button" value="Upload"  onclick="return validateData()"/>
                            </div>
        </fieldset>         
            </form>  
 </div>
</body>
</html>
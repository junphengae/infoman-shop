
/**
 * DcMasterExceptionException.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.6.2  Built on : Apr 17, 2012 (05:33:49 IST)
 */

package ws;

public class DcMasterExceptionException extends java.lang.Exception{

    private static final long serialVersionUID = 1507115012307L;
    
    private ws.DcMasterStub.DcMasterException faultMessage;

    
        public DcMasterExceptionException() {
            super("DcMasterExceptionException");
        }

        public DcMasterExceptionException(java.lang.String s) {
           super(s);
        }

        public DcMasterExceptionException(java.lang.String s, java.lang.Throwable ex) {
          super(s, ex);
        }

        public DcMasterExceptionException(java.lang.Throwable cause) {
            super(cause);
        }
    

    public void setFaultMessage(ws.DcMasterStub.DcMasterException msg){
       faultMessage = msg;
    }
    
    public ws.DcMasterStub.DcMasterException getFaultMessage(){
       return faultMessage;
    }
}
    
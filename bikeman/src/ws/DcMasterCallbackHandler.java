
/**
 * DcMasterCallbackHandler.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis2 version: 1.6.2  Built on : Apr 17, 2012 (05:33:49 IST)
 */

    package ws;

    /**
     *  DcMasterCallbackHandler Callback class, Users can extend this class and implement
     *  their own receiveResult and receiveError methods.
     */
    public abstract class DcMasterCallbackHandler{



    protected Object clientData;

    /**
    * User can pass in any object that needs to be accessed once the NonBlocking
    * Web service call is finished and appropriate method of this CallBack is called.
    * @param clientData Object mechanism by which the user can pass in user data
    * that will be avilable at the time this callback is called.
    */
    public DcMasterCallbackHandler(Object clientData){
        this.clientData = clientData;
    }

    /**
    * Please use this constructor if you don't want to set any clientData
    */
    public DcMasterCallbackHandler(){
        this.clientData = null;
    }

    /**
     * Get the client data
     */

     public Object getClientData() {
        return clientData;
     }

        
           /**
            * auto generated Axis2 call back method for setPurchaseOrder method
            * override this method for handling normal response from setPurchaseOrder operation
            */
           public void receiveResultsetPurchaseOrder(
                    ws.DcMasterStub.SetPurchaseOrderResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from setPurchaseOrder operation
           */
            public void receiveErrorsetPurchaseOrder(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getBrandUpdate method
            * override this method for handling normal response from getBrandUpdate operation
            */
           public void receiveResultgetBrandUpdate(
                    ws.DcMasterStub.GetBrandUpdateResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getBrandUpdate operation
           */
            public void receiveErrorgetBrandUpdate(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getMasterUpdate method
            * override this method for handling normal response from getMasterUpdate operation
            */
           public void receiveResultgetMasterUpdate(
                    ws.DcMasterStub.GetMasterUpdateResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getMasterUpdate operation
           */
            public void receiveErrorgetMasterUpdate(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getInventoryPackings method
            * override this method for handling normal response from getInventoryPackings operation
            */
           public void receiveResultgetInventoryPackings(
                    ws.DcMasterStub.GetInventoryPackingsResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getInventoryPackings operation
           */
            public void receiveErrorgetInventoryPackings(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getPartCategoriesUpdate method
            * override this method for handling normal response from getPartCategoriesUpdate operation
            */
           public void receiveResultgetPartCategoriesUpdate(
                    ws.DcMasterStub.GetPartCategoriesUpdateResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getPartCategoriesUpdate operation
           */
            public void receiveErrorgetPartCategoriesUpdate(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for setServiceRepair method
            * override this method for handling normal response from setServiceRepair operation
            */
           public void receiveResultsetServiceRepair(
                    ws.DcMasterStub.SetServiceRepairResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from setServiceRepair operation
           */
            public void receiveErrorsetServiceRepair(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for setBranchStock method
            * override this method for handling normal response from setBranchStock operation
            */
           public void receiveResultsetBranchStock(
                    ws.DcMasterStub.SetBranchStockResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from setBranchStock operation
           */
            public void receiveErrorsetBranchStock(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getPartGroupsUpdate method
            * override this method for handling normal response from getPartGroupsUpdate operation
            */
           public void receiveResultgetPartGroupsUpdate(
                    ws.DcMasterStub.GetPartGroupsUpdateResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getPartGroupsUpdate operation
           */
            public void receiveErrorgetPartGroupsUpdate(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for setServiceSale method
            * override this method for handling normal response from setServiceSale operation
            */
           public void receiveResultsetServiceSale(
                    ws.DcMasterStub.SetServiceSaleResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from setServiceSale operation
           */
            public void receiveErrorsetServiceSale(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getUnitTypes method
            * override this method for handling normal response from getUnitTypes operation
            */
           public void receiveResultgetUnitTypes(
                    ws.DcMasterStub.GetUnitTypesResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getUnitTypes operation
           */
            public void receiveErrorgetUnitTypes(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getPartCategoriesSubUpdate method
            * override this method for handling normal response from getPartCategoriesSubUpdate operation
            */
           public void receiveResultgetPartCategoriesSubUpdate(
                    ws.DcMasterStub.GetPartCategoriesSubUpdateResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getPartCategoriesSubUpdate operation
           */
            public void receiveErrorgetPartCategoriesSubUpdate(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for setPurchaseRequest method
            * override this method for handling normal response from setPurchaseRequest operation
            */
           public void receiveResultsetPurchaseRequest(
                    ws.DcMasterStub.SetPurchaseRequestResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from setPurchaseRequest operation
           */
            public void receiveErrorsetPurchaseRequest(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for setServiceRepairDetail method
            * override this method for handling normal response from setServiceRepairDetail operation
            */
           public void receiveResultsetServiceRepairDetail(
                    ws.DcMasterStub.SetServiceRepairDetailResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from setServiceRepairDetail operation
           */
            public void receiveErrorsetServiceRepairDetail(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for setServiceOtherDetail method
            * override this method for handling normal response from setServiceOtherDetail operation
            */
           public void receiveResultsetServiceOtherDetail(
                    ws.DcMasterStub.SetServiceOtherDetailResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from setServiceOtherDetail operation
           */
            public void receiveErrorsetServiceOtherDetail(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getModelUpdate method
            * override this method for handling normal response from getModelUpdate operation
            */
           public void receiveResultgetModelUpdate(
                    ws.DcMasterStub.GetModelUpdateResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getModelUpdate operation
           */
            public void receiveErrorgetModelUpdate(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for setServicePartDetail method
            * override this method for handling normal response from setServicePartDetail operation
            */
           public void receiveResultsetServicePartDetail(
                    ws.DcMasterStub.SetServicePartDetailResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from setServicePartDetail operation
           */
            public void receiveErrorsetServicePartDetail(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for setWebServiceReport method
            * override this method for handling normal response from setWebServiceReport operation
            */
           public void receiveResultsetWebServiceReport(
                    ws.DcMasterStub.SetWebServiceReportResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from setWebServiceReport operation
           */
            public void receiveErrorsetWebServiceReport(java.lang.Exception e) {
            }
                
           /**
            * auto generated Axis2 call back method for getBranchMasterUpdate method
            * override this method for handling normal response from getBranchMasterUpdate operation
            */
           public void receiveResultgetBranchMasterUpdate(
                    ws.DcMasterStub.GetBranchMasterUpdateResponse result
                        ) {
           }

          /**
           * auto generated Axis2 Error handler
           * override this method for handling error response from getBranchMasterUpdate operation
           */
            public void receiveErrorgetBranchMasterUpdate(java.lang.Exception e) {
            }
                


    }
    
package com.bmp.web.service.client.sevrlet;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import com.bmp.web.service.bean.setSystemInfoBean;
import com.bmp.web.service.client.bean.getPaPartMasterBean;
import com.bmp.web.service.client.bean.getPurchaseOrderBean;
import com.bmp.web.service.client.bean.getPurchaseRequestBean;
import com.bmp.web.service.client.bean.getServiceOtherDetailBean;
import com.bmp.web.service.client.bean.getServicePartDetailBean;
import com.bmp.web.service.client.bean.getServiceRepairBean;
import com.bmp.web.service.client.bean.getServiceRepairDetailBean;
import com.bmp.web.service.client.bean.getServiceSaleBean;
import com.bmp.web.service.client.bean.getWebServiceUpDateBean;
import com.bmp.web.service.transaction.PartMasterTS;
import com.bmp.web.service.transaction.PurchaseOrderTS;
import com.bmp.web.service.transaction.PurchaseRequestTS;
import com.bmp.web.service.transaction.ServiceOtherDetailTS;
import com.bmp.web.service.transaction.ServicePartDetailTS;
import com.bmp.web.service.transaction.ServiceRepairDetailTS;
import com.bmp.web.service.transaction.ServiceRepairTS;
import com.bmp.web.service.transaction.ServiceSaleTS;
import com.bmp.web.service.transaction.WebServiceUpdateTS;
import com.google.gson.Gson;
import ws.DcMasterStub;
import ws.DcMasterStub.SetBranchStock;
import ws.DcMasterStub.SetBranchStockResponse;
import ws.DcMasterStub.SetPurchaseOrder;
import ws.DcMasterStub.SetPurchaseOrderResponse;
import ws.DcMasterStub.SetPurchaseRequest;
import ws.DcMasterStub.SetPurchaseRequestResponse;
import ws.DcMasterStub.SetServiceOtherDetail;
import ws.DcMasterStub.SetServiceOtherDetailResponse;
import ws.DcMasterStub.SetServicePartDetail;
import ws.DcMasterStub.SetServicePartDetailResponse;
import ws.DcMasterStub.SetServiceRepair;
import ws.DcMasterStub.SetServiceRepairDetail;
import ws.DcMasterStub.SetServiceRepairDetailResponse;
import ws.DcMasterStub.SetServiceRepairResponse;
import ws.DcMasterStub.SetServiceSale;
import ws.DcMasterStub.SetServiceSaleResponse;
import ws.DcMasterStub.SetWebServiceReport;
import ws.DcMasterStub.SetWebServiceReportResponse;

public class CallWebServiceSet {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO New Web Service 07-01-2557 CallWebServiceSet

	}

	public static String serviceSale_WSUpdate(Connection conn,Date dd) throws Exception{
		String status = "Error";
		////System.out.println("serviceSale_dd"+dd);
		try {			
			DcMasterStub stub = new DcMasterStub();
			
			setSystemInfoBean branch = new setSystemInfoBean();
			branch.setId("1");
			branch.select(conn, branch);
			
			SetServiceSale setSale = SetServiceSale.class.newInstance();
			
			List<getServiceSaleBean> listSale = new ArrayList<getServiceSaleBean>();			
			listSale = ServiceSaleTS.getServiceSaleUpdate(conn, dd);
			setSale.setJson(new Gson().toJson(listSale));
		    
			setSale.setBranch_code(branch.getBranch_code());
		
			SetServiceSaleResponse res = stub.setServiceSale(setSale);
		    status = res.get_return();
		    		
		} catch (Exception e) {			
			status = e.getMessage();
			throw new Exception(e.getMessage());
		}
		return status; 
	}
	
	
	public static String SR_WSUpdate(Connection conn,Date dd) throws Exception{
		String status = "Error";
		try {			
			DcMasterStub stub = new DcMasterStub();
			
			setSystemInfoBean branch = new setSystemInfoBean();
			branch.setId("1");
			branch.select(conn, branch);
			
			
			SetServiceRepair setSR = SetServiceRepair.class.newInstance();
			
			List<getServiceRepairBean> listSR =new ArrayList<getServiceRepairBean>();
			
			listSR = ServiceRepairTS.getServiceRepair(conn,dd);
			setSR.setJson(new Gson().toJson(listSR));
		    
			setSR.setBranch_code(branch.getBranch_code());
			
			SetServiceRepairResponse res = stub.setServiceRepair(setSR);
		    status = res.get_return();
		    			
		} catch (Exception e) {
			status = e.getMessage();
			throw new Exception(e.getMessage());
		}
		return status; 
	}
	
	public static String SPD_WSUpdate(Connection conn,Date dd) throws Exception{
		String status = "Error";
		try {
				
				DcMasterStub stub = new DcMasterStub();
				
				setSystemInfoBean branch = new setSystemInfoBean();
				branch.setId("1");
				branch.select(conn, branch);
				
				SetServicePartDetail setSPD = SetServicePartDetail.class.newInstance();
				
				List<getServicePartDetailBean> listSPD = new ArrayList<getServicePartDetailBean>();
				
				listSPD = ServicePartDetailTS.getServicePartDetailUpdate(conn,dd);
				setSPD.setJson(new Gson().toJson(listSPD));
			    
				setSPD.setBranch_code(branch.getBranch_code());

				SetServicePartDetailResponse res = stub.setServicePartDetail(setSPD);
			    status = res.get_return();
			    		
		} catch (Exception e) {			
			status = e.getMessage();
			throw new Exception(e.getMessage());
			
		}
		return status; 
	}
	
	public static String SRD_WSUpdate(Connection conn,Date dd) throws Exception{
		String status = "Error";
		try {
				
				DcMasterStub stub = new DcMasterStub();
				
				setSystemInfoBean branch = new setSystemInfoBean();
				branch.setId("1");
				branch.select(conn, branch);
				
				SetServiceRepairDetail setSRD = SetServiceRepairDetail.class.newInstance();
				
				List<getServiceRepairDetailBean> listSRD =new ArrayList<getServiceRepairDetailBean>();
				
				listSRD = ServiceRepairDetailTS.getServiceRepairDetailUpdate(conn,dd);
				setSRD.setJson(new Gson().toJson(listSRD));
			    
				setSRD.setBranch_code(branch.getBranch_code());
			
				SetServiceRepairDetailResponse res = stub.setServiceRepairDetail(setSRD);
			    status = res.get_return();
			  
		} catch (Exception e) {			
			status = e.getMessage();
			throw new Exception(e.getMessage());
		}
		return status; 
	}
	
	public static String SOD_WSUpdate(Connection conn,Date dd) throws Exception{
		String status = "Error";
		try {
			
			DcMasterStub stub = new DcMasterStub();
			
			setSystemInfoBean branch = new setSystemInfoBean();
			branch.setId("1");
			branch.select(conn, branch);
			
			SetServiceOtherDetail setSOD = SetServiceOtherDetail.class.newInstance();
			
			List<getServiceOtherDetailBean> listSOD =new ArrayList<getServiceOtherDetailBean>();
			
			listSOD = ServiceOtherDetailTS.getServiceOtherDetailUpdate(conn, dd);
			setSOD.setJson(new Gson().toJson(listSOD));
		    
			setSOD.setBranch_code(branch.getBranch_code());
			SetServiceOtherDetailResponse res = stub.setServiceOtherDetail(setSOD);
		    status = res.get_return();		    
		    			
		} catch (Exception e) {			
			status = e.getMessage();
			throw new Exception(e.getMessage());			
		}
		return status; 
	}
	
	
	/**
	 * By Jack
	 * @param conn
	 * @param dd
	 * @return
	 * @throws Exception 
	 */
	public static String partPO_WSUpdate(Connection conn, Date dd) throws Exception {
		
		String status = "Error";
		try {
			DcMasterStub stub = new DcMasterStub();
			
			setSystemInfoBean br = new setSystemInfoBean();
			br.setId("1");
			br.select(conn, br);
			
			SetPurchaseOrder setPo = SetPurchaseOrder.class.newInstance();
			
			List<getPurchaseOrderBean> listPo = new ArrayList<getPurchaseOrderBean>();
		    listPo = PurchaseOrderTS.getPurchaseOrderUpdate(conn,dd);
			    setPo.setJson(new Gson().toJson(listPo));
		    
		    setPo.setBranch_code(br.getBranch_code());
		
		    SetPurchaseOrderResponse res = stub.setPurchaseOrder(setPo);
		    status = res.get_return();
		    
		} catch (Exception e) {		
			status = "Error : "+e.getMessage();
			throw new Exception(e.getMessage());
		}
		return status;
	}

	/**
	 * By Jack
	 * new 28-03-2557
	 * @param conn
	 * @param dd
	 * @return
	 * @throws Exception 
	 */
	public static String partPO_WSUpdate(Connection conn, Date dd,String PO) throws Exception {
		
		String status = "Error";
		try {
			DcMasterStub stub = new DcMasterStub();
			
			setSystemInfoBean br = new setSystemInfoBean();
			br.setId("1");
			br.select(conn, br);
			
			SetPurchaseOrder setPo = SetPurchaseOrder.class.newInstance();
			
			List<getPurchaseOrderBean> listPo = new ArrayList<getPurchaseOrderBean>();
		    listPo = PurchaseOrderTS.getPurchaseOrderUpdate(conn,dd,PO);
			    setPo.setJson(new Gson().toJson(listPo));
		    
		    setPo.setBranch_code(br.getBranch_code());
		
		    SetPurchaseOrderResponse res = stub.setPurchaseOrder(setPo);
		    status = res.get_return();
		    
		} catch (Exception e) {		
			status = "Error : "+e.getMessage();
			throw new Exception(e.getMessage());
		}
		return status;
	}
	
	/**
	 * By Jack
	 * @param conn
	 * @param dd
	 * @return
	 * @throws Exception
	 */
	public static String partPR_WSUpdate(Connection conn,Date dd) throws Exception{
		String status = "Error";
		try {

			DcMasterStub stub = new DcMasterStub();
			
			setSystemInfoBean  branch = new setSystemInfoBean();
			branch.setId("1");
			branch.select(conn, branch);
			
			SetPurchaseRequest setPr = SetPurchaseRequest.class.newInstance();
			
			List<getPurchaseRequestBean> listPr = new ArrayList<getPurchaseRequestBean>();
			listPr = PurchaseRequestTS.getPurchaseRequesUpdate(conn,dd);
			setPr.setJson(new Gson().toJson(listPr));
		    
		    setPr.setBranch_code(branch.getBranch_code());
		
		    SetPurchaseRequestResponse res = stub.setPurchaseRequest(setPr);
		    status = res.get_return();
		    		     
		    			
		} catch (Exception e) {			
			status = "Error : "+e.getMessage();
			throw new Exception(e.getMessage());
		}
		return status; 
	}
	/**
	 * By Jack
	 * 28-03-2557
	 * @param conn
	 * @param dd
	 * @return
	 * @throws Exception
	 */
	public static String partPR_WSUpdate(Connection conn,Date dd,String PO) throws Exception{
		String status = "Error";
		try {

			DcMasterStub stub = new DcMasterStub();
			
			setSystemInfoBean  branch = new setSystemInfoBean();
			branch.setId("1");
			branch.select(conn, branch);
			
			SetPurchaseRequest setPr = SetPurchaseRequest.class.newInstance();
			
			List<getPurchaseRequestBean> listPr = new ArrayList<getPurchaseRequestBean>();
			listPr = PurchaseRequestTS.getPurchaseRequesUpdate(conn,dd,PO);
			setPr.setJson(new Gson().toJson(listPr));
		    
		    setPr.setBranch_code(branch.getBranch_code());
		
		    SetPurchaseRequestResponse res = stub.setPurchaseRequest(setPr);
		    status = res.get_return();
		    		     
		    			
		} catch (Exception e) {			
			status = "Error : "+e.getMessage();
			throw new Exception(e.getMessage());
		}
		return status; 
	}

	/**
	 * SetBranchStock 
	 */
	public static String BS_WSUpdate(Connection conn, Date dd) throws Exception {
		String status = "Error";
		try {
			
			DcMasterStub stub = new DcMasterStub();
			
			setSystemInfoBean branch = new setSystemInfoBean();
			branch.setId("1");
			branch.select(conn, branch);
		
			SetBranchStock setBS = SetBranchStock.class.newInstance();
			List<getPaPartMasterBean> listBS =new ArrayList<getPaPartMasterBean>();
			listBS = PartMasterTS.getBranchStockUpdate(conn, dd);
			
			setBS.setJson(new Gson().toJson(listBS));
			
			setBS.setBranch_code(branch.getBranch_code());
			
			SetBranchStockResponse re = stub.setBranchStock(setBS);
			
			status = re.get_return();
						
		} catch (Exception e) {
			status = "Error :"+e.getMessage();
			throw new Exception(e.getMessage());
		}
		return status;
	}
	
	public static String WS_Report_UpDate(Connection conn) throws Exception{
		String status = "Error";
		
		try {			
			DcMasterStub stub = new DcMasterStub();
			
			setSystemInfoBean branch = new setSystemInfoBean();
			branch.setId("1");
			branch.select(conn, branch);
			
			SetWebServiceReport setWS = SetWebServiceReport.class.newInstance();
			
			List<getWebServiceUpDateBean> listWS = new ArrayList<getWebServiceUpDateBean>();			
			listWS = WebServiceUpdateTS.getWebServiceUpDate(conn);
			
			setWS.setJson(new Gson().toJson(listWS));
		    
			setWS.setBranch_code(branch.getBranch_code());
		
			SetWebServiceReportResponse res = stub.setWebServiceReport(setWS);
		    status = res.get_return();
		    //System.out.println(" WS Report :"+status);		
		} catch (Exception e) {			
			status = e.getMessage();
			throw new Exception(e.getMessage());
		}
		return status; 
	}
}

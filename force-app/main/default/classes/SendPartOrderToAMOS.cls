public with sharing class SendPartOrderToAMOS {
    
    private static final String CONSTANT_AMOSENDPOINT = 'AMOS';
    private static final String CONSTANT_INTERFACENAME = 'IF_EU_CXP_AMOS_0001';
    private static String strTrackingId;
    private static Id partsOrderId;
    private static Map<String, String> partNoIdMap;   

    @AuraEnabled(cacheable=true)
    public static Parts_Order__c getProductRequestForAMOSCallout(Id productRequestId) { 
        Parts_Order__c prodRequest = [ 
            SELECT Id, CreatedDate, Department__r.Cost_Center_Code__c, Department__r.Department_Code__c, AMOSMOBIS_Suffix__c, Name, OrderRefNo__c, Order_Type__c, 
            Description__c, Flag__c, Department__r.DistCode__c, Department__r.DealerCode__c, Department__r.MobisSuffix__c, DepartmentCode__c, Dealer_Code__c, 
            (SELECT Id, Ordered_Product__r.ProductCode, Ordered_Product__r.Id, Order_Line_No__c, Quantity_Requested__c, Free_Home_Delivery__c, Description__c FROM Parts_Order_Line_Item__r)
            FROM Parts_Order__c
            WHERE Id =: productRequestId
        ];

        partNoIdMap = new Map<String, String>();
        for(Parts_Order_Line_Item__c po : prodRequest.Parts_Order_Line_Item__r) { 
            partNoIdMap.put(po.Ordered_Product__r.ProductCode, po.Ordered_Product__r.Id);
        }

        return prodRequest;
    }

    public static ResultWrapper sendProdReqToAMOS(List<Id> productRequestIdList) {
        ResultWrapper result = new ResultWrapper();
        Id productRequestId = productRequestIdList.get(0);
        partsOrderId = productRequestId;

        HttpRequest req = new HttpRequest();
        DIH__c obj = DIH__c.getInstance('Integration');
        String endpoint = obj.Endpoint__c;
        String username = obj.Username__c;
        String password = obj.Password__c;
//
        Blob headerValue = Blob.valueOf(username + ':' + password);
        String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
        req.setHeader('Authorization', authorizationHeader);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');
        req.setEndpoint(endpoint);

        // Authentication needs to be done for the callout
        req.setMethod('POST');
        String body = generateBody(productRequestId);
        System.debug('req body : ' + body);
        req.setBody(body);
        req.setTimeout(120000);

        //System.enqueueJob(new SendPartOrderToAMOS_qu(req, partsOrderId, partNoIdMap));
        //result.resultStatus = true;
        //result.resultMessage = 'Request Complete';

        Http http = new Http();
        HttpResponse res = http.send(req);
        //Update based on response
        if (res.getBody() != null) {
            System.debug('res.getBody() : ' + res.getBody());
            result = updateProductRequest(res.getBody());
        } else {
            result.resultStatus = false;
            result.resultMessage = 'body => null';
        }

        System.debug('result : ' + JSON.serializePretty(result));
        return result;
    }

    @AuraEnabled(cacheable=true)
    public static String generateBody(Id productRequestId) { 
        Parts_Order__c prodRequest = getProductRequestForAMOSCallout(productRequestId);

        CXP_AMOS_RestAPICalloutWrapper.T_DATA tData = new CXP_AMOS_RestAPICalloutWrapper.T_DATA();

        tData.DistributeCode = prodRequest.DepartmentCode__c;
        tData.DealerCode = prodRequest.Dealer_Code__c;
        tData.AMOSMOBISSuffix = prodRequest.Department__r.MobisSuffix__c;
        tData.ProductRequestNumber = prodRequest.Name;
        tData.OrderRefNo = prodRequest.OrderRefNo__c;
        tData.OrderType = prodRequest.Order_Type__c;
        tData.Description = prodRequest.Description__c;
        tData.Flag = 'Y';

        List<CXP_AMOS_RestAPICalloutWrapper.T_ITEM> tItemList = new List<CXP_AMOS_RestAPICalloutWrapper.T_ITEM>();
        for (Parts_Order_Line_Item__c prodReqLineItem : prodRequest.Parts_Order_Line_Item__r) { 
            CXP_AMOS_RestAPICalloutWrapper.T_ITEM tItem = new CXP_AMOS_RestAPICalloutWrapper.T_ITEM();
            tItem.DistributeCode = tData.DistributeCode;
            tItem.DealerCode = tData.DealerCode;
            tItem.AMOSMOBISSuffix = tData.AMOSMOBISSuffix;
            tItem.ProductRequestNumber = tData.ProductRequestNumber;
            tItem.OrderPartNo = prodReqLineItem.Ordered_Product__r.ProductCode;
            tItem.ProductRequestLineItemNumber = prodReqLineItem.Order_Line_No__c;
            tItem.QuantityRequested = string.valueOf(prodReqLineItem.Quantity_Requested__c);
            tItem.FreeHomeDelivery = '0';
            tItem.Description = prodReqLineItem.Description__c;
            tItemList.add(tItem);
        }

        CXP_AMOS_RestAPICalloutWrapper.Payload payload = new CXP_AMOS_RestAPICalloutWrapper.Payload();
        
        payload.T_DATA = tData;
        payload.T_ITEM = tItemList;

        CXP_AMOS_RestAPICalloutWrapper.Request request = new CXP_AMOS_RestAPICalloutWrapper.Request();
        request.payload = payload;

        CXP_AMOS_RestAPICalloutWrapper wrap = new CXP_AMOS_RestAPICalloutWrapper();
        wrap.request = request;

        strTrackingId = request.header.ifTrackingId;

        String json = JSON.serialize(wrap);
        return json;

    }

    public static ResultWrapper updateProductRequest(String jsonString) { 
        ResultWrapper result = new ResultWrapper();
        Schema.SObjectField externalIdProdReqLineItem = Parts_Order_Line_Item__c.fields.ExternalID__c;

        List<Parts_Order__c> productRequestListToUpdate = new List<Parts_Order__c>();
        List<Parts_Order_Line_Item__c> productRequestItemListToUpdate = new List<Parts_Order_Line_Item__c>();

        String trimStr = jsonString.replaceAll('\\\\', '');
        trimStr = trimStr.replaceAll('\n', '');
        trimStr = trimStr.replaceAll('\r', '');
        trimStr = trimStr.replaceAll('\t', '');

        CXP_AMOS_RestAPIWrapper wrapperList = (CXP_AMOS_RestAPIWrapper) System.JSON.deserialize(trimStr, CXP_AMOS_RestAPIWrapper.class);

        if (wrapperList.response.payload != null && wrapperList.response.payload.ES_DATA != null) { 
            CXP_AMOS_RestAPIWrapper.ES_DATA wrapper = wrapperList.response.payload.ES_DATA;

            Parts_Order__c pRequest = new Parts_Order__c();
            pRequest.Id = partsOrderId;

            pRequest.IsOrderRequested__c = wrapperList.response.header.ifResult == 'S' ? true : false;
            if(!pRequest.IsOrderRequested__c) { 
                update pRequest;
                result.resultStatus = false;
                result.resultMessage = wrapperList.response.header.ifFailMsg;
                return result;
            }
            result.orderNo = wrapperList.response.payload.ES_DATA.AMOSOrderNo;

            pRequest.AMOS_Order_No__c = wrapper.AMOSOrderNo;
            pRequest.AMOSDealerCode__c = wrapper.AMOSDealerCode;
            // if (String.isNotBlank(wrapper.OrderRecieveDate)) {
            //     Date jsonDateConverted = CXP_AMOS_PartsShipping.customDateConverter(wrapper.OrderRecieveDate);
            //     if (jsonDateConverted != null) {
            //         pRequest.OrderRecieveDate__c = jsonDateConverted;
            //     }
            // }
            pRequest.Order_Type__c = wrapper.OrderType;
            pRequest.OrderRefNo__c = wrapper.OrderRefNo;
            pRequest.Description__c = wrapper.Description;
            pRequest.Flag__c = wrapper.Flag == 'Y' ? true : false;
            // if (String.isNotBlank(wrapper.CoDate)) {
            //     Date jsonDateConverted = CXP_AMOS_PartsShipping.customDateConverter(wrapper.CoDate);
            //     if (jsonDateConverted != null) {
            //         pRequest.CoDate__c = jsonDateConverted;
            //     }
            // }
            // pRequest.ConfirmedDate__c = CXP_AMOS_PartsShipping.customDateConverter(wrapper.OrderRecieveDate);
            productRequestListToUpdate.add(pRequest);

            if (wrapperList.response.payload.ES_ITEM != null) { 
                for (CXP_AMOS_RestAPIWrapper.ES_ITEM pReqLineItemWrapper : wrapperList.response.payload.ES_ITEM) { 

                    String ExteranlKeypRequestLineItemLineItem;
                    ExteranlKeypRequestLineItemLineItem = partsOrderId + '_' + partNoIdMap.get(pReqLineItemWrapper.OrderedPartNo);

                    Parts_Order_Line_Item__c pRequestLineItem = new Parts_Order_Line_Item__c();
                    pRequestLineItem.ExternalID__c = ExteranlKeypRequestLineItemLineItem;

                    pRequestLineItem.Confirmed_Product__c = partNoIdMap.get(pReqLineItemWrapper.AMOSConfirmPartNo);
                    pRequestLineItem.Confirmed_Quantity__c = Integer.valueOf(pReqLineItemWrapper.AMOSConfirmQty);
                    if(pReqLineItemWrapper.AMOSDelAcceptYn == '1') pRequestLineItem.AMOSDelAcceptYn__c = true; else pRequestLineItem.AMOSDelAcceptYn__c = false;
                    pRequestLineItem.AMOSDiscountCode__c = pReqLineItemWrapper.AMOSDiscountCode;
                    pRequestLineItem.Confirmed_Price__c = Decimal.valueOf(pReqLineItemWrapper.UnitPrice);
                    pRequestLineItem.Description__c = pReqLineItemWrapper.Description;
                    pRequestLineItem.AMOSOrderNo__c = pReqLineItemWrapper.AMOSOrderNo;
                    pRequestLineItem.CancelCode__c = pReqLineItemWrapper.CancelCode;
                    pRequestLineItem.CancelDescription__c = pReqLineItemWrapper.CancelDescription;

                    productRequestItemListToUpdate.add(pRequestLineItem);


                }
            }
        } else {
            result.resultStatus = false;
            result.resultMessage = wrapperList.response.header.ifFailMsg;
            return result;
        }

        //DML Update
        try {
            if (!productRequestListToUpdate.isEmpty()) {
                update productRequestListToUpdate;
            }
            if (!productRequestItemListToUpdate.isEmpty()) {
                Database.upsert(productRequestItemListToUpdate, externalIdProdReqLineItem, true);
            }

            result.resultStatus = true;
            return result;

        } catch(Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage() + ', ' + e.getStackTraceString());

            result.resultStatus = false;
            result.resultMessage = e.getMessage() + ', ' + e.getStackTraceString();
            return result;
        }
    }
    
    public class ResultWrapper {
        @AuraEnabled
        public String orderNo;
        @AuraEnabled
        public String gmeOrderNo;
        @AuraEnabled
        public Boolean resultStatus;
        @AuraEnabled
        public String resultMessage;

    }
    
}

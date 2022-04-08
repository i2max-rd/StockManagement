public with sharing class SendPartOrderToAMOS {
    private static Map<String, String> partNoIdMap;
    @AuraEnabled
    public static Parts_Order__c getProductRequestForAMOSCallout(Id productRequestId) {
        Parts_Order__c prodRequest = [
                SELECT Id, CreatedDate, Department__r.Cost_Center_Code__c, Department__r.NSC_Department__r.Department_Code__c, AMOSMOBISSuffix__c, Name, OrderRefNo__c, OrderType__c, Description__c, Flag__c, Department__r.DistributeCode__c, Department__r.DealerCode__c, Department__r.MobisSuffix__c, DepartmentCode__c, DealerCode__c,
                (SELECT Id, OrderedProduct__r.AMOSProductCode__c, OrderedProduct__r.Id, Parts_Order_Line_Item_Number__c, QuantityRequested__c, FreeHomeDelivery__c, Description__c FROM Parts_Order_Line_Item__r)
                FROM Parts_Order__c
                WHERE Id = :productRequestId
        ];

        partNoIdMap = new Map<String, String>();
        for(Parts_Order_Line_Item__c po : prodRequest.Parts_Order_Line_Item__r) {
            partNoIdMap.put(po.OrderedProduct__r.AMOSProductCode__c, po.OrderedProduct__r.Id);
        }

        return prodRequest;
    }

    // request에서 필요한 거 : 인증정보 (header), endpoint (header), body
    @AuraEnabled
    public static ResultWrapper sendProdReqToAMOS(Id productRequestId) {
        ResultWrapper result = new ResultWrapper();

        HttpRequest req = new HttpRequest();
        // custom settings로 인증하는 방식 (named credential도 있음)
           DIH__c obj = DIH__c.getInstance('Integration');
           String endpoint = obj.Endpoint__c;
           String username = obj.Username__c;
           String password = obj.Password__c;
           Blob headerValue = Blob.valueOf(username + ':' + password);
           String authorizationHeader = 'BASIC ' + EncodingUtil.base64Encode(headerValue);
           req.setHeader('Authorization', authorizationHeader);
           req.setHeader('Content-Type', 'application/json'); // 어떤 형식으로 보낼지 (json)
           req.setHeader('Accept', 'application/json'); // 어떤 형식으로 받을지 (json)
           req.setEndpoint(endpoint);
           req.setMethod('POST');

        String body = generateBody(productRequestId);
        System.debug('req body : ' + body);
        req.setBody(body);
        req.setTimeout(120000);

        Http http = new Http();
        HttpResponse res = http.send(req); // 데이터 보내는 거

        if (res.getBody() != null) {
            System.debug('res.getBody() : ' + res.getBody());
            result = updateProductRequest(res.getBody(), productRequestId); // dml실행
        } else {
            result.resultStatus = false;
            result.resultMessage = 'body => null';
        }
        System.debug('result : ' + JSON.serializePretty(result)); //json형식으로 보이게 할때
        return result;
    }


    @AuraEnabled
    public static String generateBody(Id productRequestId) {

        Parts_Order__c prodRequest = getProductRequestForAMOSCallout(productRequestId);

        System.debug(prodRequest);
    
        CXP_AMOS_RestAPICalloutWrapper.T_DATA tData = new CXP_AMOS_RestAPICalloutWrapper.T_DATA();
        tData.DistributeCode = prodRequest.DepartmentCode__c;
        tData.DealerCode = prodRequest.DealerCode__c;
        tData.AMOSMOBISSuffix = prodRequest.Department__r.MobisSuffix__c; 
        tData.ProductRequestNumber = prodRequest.Name; 
        tData.OrderRefNo = prodRequest.OrderRefNo__c; 
        tData.OrderType = prodRequest.OrderType__c; 
        tData.Description = prodRequest.Description__c; 
        tData.Flag = 'Y';
    
        List<Parts_Order_Line_Item__c> partsOrderItems = prodRequest.Parts_Order_Line_Item__r;
        List<CXP_AMOS_RestAPICalloutWrapper.T_ITEM> tItemList = new List<CXP_AMOS_RestAPICalloutWrapper.T_ITEM> ();
        for (Parts_Order_Line_Item__c prodReqLineItem : partsOrderItems) {
            CXP_AMOS_RestAPICalloutWrapper.T_ITEM tItem = new CXP_AMOS_RestAPICalloutWrapper.T_ITEM();
            tItem.DistributeCode = tData.DistributeCode;
            tItem.DealerCode = tData.DealerCode;
            tItem.AMOSMOBISSuffix = tData.AMOSMOBISSuffix;
            tItem.ProductRequestNumber = tData.ProductRequestNumber;
            tItem.OrderPartNo = prodReqLineItem.OrderedProduct__r.AMOSProductCode__c;
            tItem.ProductRequestLineItemNumber = prodReqLineItem.Parts_Order_Line_Item_Number__c;
            tItem.QuantityRequested = String.valueOf(prodReqLineItem.QuantityRequested__c);
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

        String strTrackingId = request.header.ifTrackingId;


        String json = JSON.serialize(wrap);
        return json;
    }

    public static ResultWrapper updateProductRequest(String jsonString, Id productRequestId) {
        ResultWrapper result = new ResultWrapper();
        Schema.SObjectField externalIdProdReqLineItem = Parts_Order_Line_Item__c.fields.ExternalID__c;

        List<Parts_Order__c> productRequestListToUpdate = new List<Parts_Order__c> ();
        List<Parts_Order_Line_Item__c> productRequestItemListToUpdate = new List<Parts_Order_Line_Item__c> ();

        // csv에서 공백 인식 x- > 공백 없애주기
        String trimStr = jsonString.replaceAll('\\\\', '');
        trimStr = trimStr.replaceAll('\n','');
        trimStr = trimStr.replaceAll('\r','');
        trimStr = trimStr.replaceAll('\t', '');
                                                                                            // json -> class 변환
        CXP_AMOS_RestAPIResponseWrapper bodyWrapper = (CXP_AMOS_RestAPIResponseWrapper) System.JSON.deserialize(trimStr, CXP_AMOS_RestAPIResponseWrapper.class);
        
        if (bodyWrapper.response.payload.ES_DATA != null) {
            CXP_AMOS_RestAPIResponseWrapper.ES_DATA bodyItem = bodyWrapper.response.payload.ES_DATA;

            Parts_Order__c pRequest = new Parts_Order__c();
            pRequest.Id = productRequestId;
            pRequest.IsOrderRequested__c = bodyWrapper.response.header.ifResult == 'S' ? true : false;
            if(!pRequest.IsOrderRequested__c) {
                update pRequest;
                result.resultStatus = false;
                result.resultMessage =  bodyWrapper.response.header.ifFailMsg;
                return result;  // IsOrderRequested__c가 false일 때 return. 밑에 코드는 실행x.
            }

            result.orderNo = bodyWrapper.response.payload.ES_DATA.AMOSOrderNo;
            pRequest.AMOSOrderNo__c = bodyItem.AMOSOrderNo;
            pRequest.AMOSDealerCode__c = bodyItem.AMOSDealerCode;
            // if (String.isNotBlank(bodyItem.OrderRecieveDate)) {
            //     Date jsonDateConverted = CXP_AMOS_PartsShipping.customDateConverter(bodyItem.OrderRecieveDate);
            //     if (jsonDateConverted != null) {
            //         pRequest.OrderRecieveDate__c = jsonDateConverted;
            //     }
            // }
            pRequest.OrderType__c = bodyItem.OrderType;
            pRequest.OrderRefNo__c = bodyItem.OrderRefNo;
            pRequest.Description__c = bodyItem.Description;
            if (bodyItem.Flag == 'Y') {
                bodyItem.Flag = 'true';
            } else {
                bodyItem.Flag = 'false';
            }
            pRequest.Flag__c = String.valueOf(bodyItem.Flag);
            // pRequest.Flag__c = bodyItem.Flag == 'Y' ? true : false;
            // if (String.isNotBlank(bodyItem.CoDate)) {
            //     Date jsonDateConverted = CXP_AMOS_PartsShipping.customDateConverter(bodyItem.CoDate);
            //     if (jsonDateConverted != null) {
            //         pRequest.CoDate__c = jsonDateConverted;
            //     }
            // }
            // pRequest.ConfirmedDate__c = CXP_AMOS_PartsShipping.customDateConverter(bodyItem.OrderRecieveDate);
            productRequestListToUpdate.add(pRequest);
            if(bodyWrapper.response.payload.ES_ITEM != null){
                    for (CXP_AMOS_RestAPIResponseWrapper.ES_ITEM pReqLineItemBody : bodyWrapper.response.payload.ES_ITEM) {
                        
                        String ExternalKeypRequestLineItemLineItem;
                        if (String.isNotBlank(pReqLineItemBody.OrderNumberCXP) || String.isNotBlank(pReqLineItemBody.OrderLineNoCXP)) {
                            ExternalKeypRequestLineItemLineItem = productRequestId + '_' + partNoIdMap.get(pReqLineItemBody.OrderedPartNo);
                        }
                        Parts_Order_Line_Item__c pRequestLineItem = new Parts_Order_Line_Item__c();
                        pRequestLineItem.ExternalID__c = ExternalKeypRequestLineItemLineItem;

                        pRequestLineItem.Confirmed_Product__c = partNoIdMap.get(pReqLineItemBody.AMOSConfirmPartNo);
                        pRequestLineItem.Confirmed_Quantity__c = Integer.valueOf(pReqLineItemBody.AMOSConfirmQty);
                        if (pReqLineItemBody.AMOSDelAcceptYn == '1') {
                            pReqLineItemBody.AMOSDelAcceptYn = 'true';
                        } else {
                            pReqLineItemBody.AMOSDelAcceptYn = 'false';
                        }
                        pRequestLineItem.AMOSDelAcceptYn__c = String.valueOf(pReqLineItemBody.AMOSDelAcceptYn);
                        pRequestLineItem.AMOSDiscountCode__c = pReqLineItemBody.AMOSDiscountCode;
                        pRequestLineItem.Confirmed_Price__c = Decimal.valueOf(pReqLineItemBody.UnitPrice);
                        pRequestLineItem.Description__c = pReqLineItemBody.Description;
                        pRequestLineItem.AMOSOrderNo__c = pReqLineItemBody.AMOSOrderNo;
                        pRequestLineItem.CancelCode__c = pReqLineItemBody.CancelCode;
                        pRequestLineItem.CancelDescription__c = pReqLineItemBody.CancelDescription;

                        productRequestItemListToUpdate.add(pRequestLineItem);
                    }
                }
        }
        else {
            result.resultStatus = false;
            result.resultMessage = bodyWrapper.response.header.ifFailMsg;
            return result;
        }

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
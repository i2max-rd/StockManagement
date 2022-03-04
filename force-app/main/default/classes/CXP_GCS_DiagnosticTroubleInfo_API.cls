@RestResource(urlMapping='/CXP_GCS_DiagnosticTroubleInfo/*')
global with sharing class CXP_GCS_DiagnosticTroubleInfo_API {
    @HttpPost
    global static void upsertDiagnosticTroubleInfo() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;

        CXP_GCS_DiagnosticTroubleInfo_APIWrapper bodyWrapper = CXP_GCS_DiagnosticTroubleInfo_APIWrapper.parse(request.requestBody.toString());
        CXP_GCS_DiagnosticTroubleInfo_APIWrapper.Response responseInstance = new CXP_GCS_DiagnosticTroubleInfo_APIWrapper.Response(
            bodyWrapper.request.header.ifTotCnt,   
            bodyWrapper.request.header.ifTrackingId  
        );
        

        Map<String, Diagnostic_Trouble_Info__c> diagnosticTroubleInfoMap = new Map<String, Diagnostic_Trouble_Info__c>();
        Diagnostic_Trouble_Info__c diagnosticTroubleInfo = new Diagnostic_Trouble_Info__c();
        for (CXP_GCS_DiagnosticTroubleInfo_APIWrapper.T_DATA bodyItem : bodyWrapper.request.payload.T_DATA) {
            if (String.isBlank(bodyItem.VIN)) {
                populateResponseErrorMessage(responseInstance, 'E', ' ', 'VIN value is empty');
                break;
            }
            diagnosticTroubleInfo.VIN__c = bodyItem.VIN;
            diagnosticTroubleInfo.Diagnostics_Detailed_Sequence_No__c = bodyItem.DGN_DTL_SEQ;
            diagnosticTroubleInfo.Diagnostics_Code__c = bodyItem.DTC_CD; 
            if(bodyItem.ACVT_DTC_YN == 'Y'){
                bodyItem.ACVT_DTC_YN = 'true';
            }else{
                bodyItem.ACVT_DTC_YN = 'false';
            }
            diagnosticTroubleInfo.Is_Activity_Diagnostics__c = Boolean.valueOf(bodyItem.ACVT_DTC_YN);
            diagnosticTroubleInfo.Fuel_Kind_Code__c = bodyItem.FUEL_K_CD;
            String dtme = bodyItem.DGN_OCCU_YMD  + bodyItem.DGN_OCCU_CTMS;
            Datetime dt = Datetime.newInstance(Integer.valueOf(dtme.substring(0,4)), Integer.valueOf(dtme.substring(4,6)), Integer.valueOf(dtme.substring(6,8)), Integer.valueOf(dtme.substring(8,10)), Integer.valueOf(dtme.substring(10,12)), Integer.valueOf(dtme.substring(12,14)));
            diagnosticTroubleInfo.Occurrence_Datetime__c = Datetime.valueOf(dt);
            diagnosticTroubleInfo.Description__c = bodyItem.ET_BKDW_EXPL;
            diagnosticTroubleInfo.External_Key__c = bodyItem.VIN + bodyItem.DGN_DTL_SEQ;
            diagnosticTroubleInfoMap.put(diagnosticTroubleInfo.VIN__c, diagnosticTroubleInfo);
        }
 
        List<Asset> assetList = [SELECT Id, VIN__c FROM Asset WHERE VIN__c IN :diagnosticTroubleInfoMap.keySet()];
        for (Asset a : assetList) {
                diagnosticTroubleInfo.Vehicle__c = a.Id;
                diagnosticTroubleInfo.VIN__c = a.VIN__c;
                diagnosticTroubleInfoMap.put(diagnosticTroubleInfo.VIN__c, diagnosticTroubleInfo);
            }

        if (String.isBlank(responseInstance.response.payload.ErrorMsg)) {
            List<Database.SaveResult> insertResults = Database.insert(diagnosticTroubleInfoMap.values(), true);
            responseInstance.response.payload.ResultCode = 'Z';
            responseInstance.response.payload.ErrorCode = ' ';
            responseInstance.response.payload.ErrorMsg = ' ';
        }
        String responseJson = System.JSON.serialize(responseInstance, false);
        response.responseBody = Blob.valueOf(responseJson);
    }

    private static void populateResponseErrorMessage(
        CXP_GCS_DiagnosticTroubleInfo_APIWrapper.Response response,
        String resultCode,
        String errorCode,
        String errorMsg
    ) {
        response.response.payload.ResultCode = resultCode;
        response.response.payload.ErrorCode = errorCode;
        response.response.payload.ErrorMsg = errorMsg;
    }
 }




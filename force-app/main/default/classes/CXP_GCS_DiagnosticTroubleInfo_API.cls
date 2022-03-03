/**
 * @description         : DiagnosticTroubleInfo web service from the GSC Source
 * @author              : chaewon
 * @last modified on    : 03-03-2022 
 * @last modified by    : chaewon
 */

 @RestResource(urlMapping='/CXP_GCS_DiagnosticTroubleInfo/*')
 @SuppressWarnings('PMD.ExcessiveParameterList')
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

         Map<String, Diagnostic_Trouble_Info__c> diagnosticMap = new Map<String, Diagnostic_Trouble_Info__c>();
         for (CXP_GCS_DiagnosticTroubleInfo_APIWrapper.T_DATA bodyItem : bodyWrapper.request.payload.T_DATA) {
             Diagnostic_Trouble_Info__c diagnosticItem = new Diagnostic_Trouble_Info__c();
             if (String.isBlank(bodyItem.VIN)) {
                populateResponseErrorMessage(responseInstance, 'E', ' ', 'VIN value is empty');
                break;
             }
             diagnosticItem.VIN__c = bodyItem.VIN;
             diagnosticItem.Diagnostics_Detailed_Sequence_No__c = bodyItem.DGN_DTL_SEQ;
             diagnosticItem.Diagnostics_Code__c = bodyItem.DTC_CD;
             diagnosticItem.Fuel_Kind_Code__c = bodyItem.FUEL_K_CD;
             diagnosticItem.Is_Activity_Diagnostics__c = bodyItem.ACVT_DTC_YN == 'Y' ? true : false;
             diagnosticItem.Occurrence_Datetime__c = Datetime.valueOf(bodyItem.DGN_OCCU_YMD + '' + bodyItem.DGN_OCCU_CTMS);
             diagnosticItem.Description__c = bodyItem.ET_BKDW_EXPL;
             diagnosticItem.External_Key__c = bodyItem.VIN + bodyItem.DGN_DTL_SEQ;
             diagnosticMap.put(diagnosticItem.VIN__c, diagnosticItem);
         }

        
         List<Asset> assetList = [SELECT Id, VIN__c FROM Asset WHERE VIN__c IN :diagnosticMap.keySet()];
         for (Asset a : assetList) {
             Diagnostic_Trouble_Info__c diagnosticTroubleInfo = new Diagnostic_Trouble_Info__c();
             diagnosticTroubleInfo.Vehicle__c = a.Id;
             diagnosticMap.put(a.VIN__c, diagnosticTroubleInfo);
         }
         
        if (String.isBlank(responseInstance.response.payload.ErrorMsg)) {
            List<Database.SaveResult> updateResults = Database.update(diagnosticMap.values(), true);

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
 
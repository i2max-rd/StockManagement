/** 
 * @description         : Test class for CXP_GCS_DiagnosticTroubleInfo_API
 * @author              : Chaewon Kwak
 * @last modified on    : 03-18-2022
 * @last modified by    :
 */
@isTest
public class CXP_GCS_DiagnosticTroubleInfo_API_Test {
    @TestSetup
    static void setup(){
        Diagnostic_Trouble_Info__c diagnosticTroubleInfo = new Diagnostic_Trouble_Info__c(Name = 'Test diagnosticTrouble', Diagnostics_Code__c = 'DTC TEST01', VIN__c = 'KR0123', Vehicle__c = '02i0p000003tmhfAAA');
        insert diagnosticTroubleInfo;
    }

    @isTest 
    static void testupsertDiagnosticTroubleInfo() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.httpMethod = 'POST';
        request.requestURI = '/CXP_GCS_DiagnosticTroubleInfo/';

        String jsonRequest = '';
        jsonRequest += '{';
        jsonRequest += '    "request": {';
        jsonRequest += '        "header": {';
        jsonRequest += '            "ifId" : "IF_EU_GCS_CXP_0002",';
        jsonRequest += '            "ifVer" : "v001",';
        jsonRequest += '            "ifSenderGp" : "EU",';
        jsonRequest += '            "ifSender" : "GCS",';
        jsonRequest += '            "ifReceiverGp" : "EU",';
        jsonRequest += '            "ifReceiver" : "CXP",';
        jsonRequest += '            "ifTrackingId" : "sample",';
        jsonRequest += '            "ifDateTime" : "20211021010101",';
        jsonRequest += '            "ifTotCnt": 1';
        jsonRequest += '        },';
        jsonRequest += '        "payload" : {';
        jsonRequest += '            "T_DATA" : [';
        jsonRequest += '                {';
        jsonRequest += '                  "TSTMP": "123456789",';
        jsonRequest += '                  "DGN_DTL_SEQ": 34404,';
        jsonRequest += '                  "VIN": "KR0123",';
        jsonRequest += '                  "DTC_CD": "DTC001",';
        jsonRequest += '                  "ACVT_DTC_YN": "Y",';
        jsonRequest += '                  "FUEL_K_CD": "A95",';
        jsonRequest += '                  "DGN_OCCU_YMD": "20210101",';
        jsonRequest += '                  "DGN_OCCU_CTMS": "090101",';
        jsonRequest += '                  "ET_BKDW_EXPL": "OIL CHANGE PERIOD OVER DUE"';
        jsonRequest += '                }';
        jsonRequest += '            ]';
        jsonRequest += '        }';
        jsonRequest += '    }';
        jsonRequest += '}';
        request.requestBody = Blob.valueOf(jsonRequest);

        Test.startTest();

        RestContext.request = request;
        RestContext.response = response;

        CXP_GCS_DiagnosticTroubleInfo_API.upsertDiagnosticTroubleInfo();

        CXP_GCS_DiagnosticTroubleInfo_APIWrapper.Response output = (CXP_GCS_DiagnosticTroubleInfo_APIWrapper.Response) JSON.deserializeStrict(
            RestContext.response.responseBody.toString(), 
            CXP_GCS_DiagnosticTroubleInfo_APIWrapper.Response.class
        );

        System.assertEquals('Z', output.response.payload.ResultCode, 'ResultCode should be Z');

        Test.stopTest();
    }

    @isTest 
    static void testupsertDiagnosticTroubleInfoVINEmpty() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.httpMethod = 'POST';
        request.requestURI = '/CXP_GCS_DiagnosticTroubleInfo/';

        String jsonRequest = '';
        jsonRequest += '{';
        jsonRequest += '    "request": {';
        jsonRequest += '        "header": {';
        jsonRequest += '            "ifId" : "IF_EU_GCS_CXP_0002",';
        jsonRequest += '            "ifVer" : "v001",';
        jsonRequest += '            "ifSenderGp" : "EU",';
        jsonRequest += '            "ifSender" : "GCS",';
        jsonRequest += '            "ifReceiverGp" : "EU",';
        jsonRequest += '            "ifReceiver" : "CXP",';
        jsonRequest += '            "ifTrackingId" : "sample",';
        jsonRequest += '            "ifDateTime" : "20211021010101",';
        jsonRequest += '            "ifTotCnt": 1';
        jsonRequest += '        },';
        jsonRequest += '        "payload" : {';
        jsonRequest += '            "T_DATA" : [';
        jsonRequest += '                {';
        jsonRequest += '                  "TSTMP": "123456789",';
        jsonRequest += '                  "DGN_DTL_SEQ": 34404,';
        jsonRequest += '                  "VIN": "",';
        jsonRequest += '                  "DTC_CD": "DTC001",';
        jsonRequest += '                  "ACVT_DTC_YN": "Y",';
        jsonRequest += '                  "FUEL_K_CD": "A95",';
        jsonRequest += '                  "DGN_OCCU_YMD": "20210101",';
        jsonRequest += '                  "DGN_OCCU_CTMS": "090101",';
        jsonRequest += '                  "ET_BKDW_EXPL": "OIL CHANGE PERIOD OVER DUE"';
        jsonRequest += '                }';
        jsonRequest += '            ]';
        jsonRequest += '        }';
        jsonRequest += '    }';
        jsonRequest += '}';
        request.requestBody = Blob.valueOf(jsonRequest);

        Test.startTest();

        RestContext.request = request;
        RestContext.response = response;

        CXP_GCS_DiagnosticTroubleInfo_API.upsertDiagnosticTroubleInfo();

        CXP_GCS_DiagnosticTroubleInfo_APIWrapper.Response output = (CXP_GCS_DiagnosticTroubleInfo_APIWrapper.Response) JSON.deserializeStrict(
            RestContext.response.responseBody.toString(), 
            CXP_GCS_DiagnosticTroubleInfo_APIWrapper.Response.class
        );

        System.assertEquals('VIN value is empty', output.response.payload.ErrorMsg);

        Test.stopTest();    

    }
}
    

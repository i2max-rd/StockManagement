@isTest

public class CXP_GCS_DiagnosticTroubleInfo_API_Test {
    @TestSetup
    static void makeData(){
        Asset asset = new Asset(Name = 'Test Asset', VIN__c = 'KR0123', AccountId = '001N0000025WLjrIAG', ContactId=  '003N000001tddpnIAA');
        insert asset;

        Diagnostic_Trouble_Info__c diagnosticTroubleInfo = new Diagnostic_Trouble_Info__c(Name = 'Test diagnosticTroubleInfo', VIN__c = 'KR0123');
        insert diagnosticTroubleInfo;
    }

    @isTest
    static void testUpsertDiagnosticTroubleInfo() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.httpMethod = 'POST';
        request.requestURI = '/CXP_GCS_DiagnosticTroubleInfo/';

        String jsonRequest = '';
        jsonRequest += '{';
        jsonRequest += '    "request": {';
        jsonRequest += '        "header": {';
        jsonRequest += '            "ifId": "IF_EU_GCS_CXP_0002",';
        jsonRequest += '            "ifVer": "v001",';
        jsonRequest += '            "ifSenderGp": "EU",';
        jsonRequest += '            "ifSender": "GCS",';
        jsonRequest += '            "ifReceiverGp": "EU",';
        jsonRequest += '            "ifReceiver": "CXP",';
        jsonRequest += '            "ifDateTime": "20211021010101",';
        jsonRequest += '            "ifTrackingId": "sample",';
        jsonRequest += '            "ifTotCnt": 1';
        jsonRequest += '        },';
        jsonRequest += '        "payload": {';
        jsonRequest += '            "T_DATA": [';
        jsonRequest += '                {';
        jsonRequest += '                    "TSTMP": "123456789",';
        jsonRequest += '                    "DGN_DTL_SEQ": "34404",';
        jsonRequest += '                    "VIN": "KR0123",';
        jsonRequest += '                    "DTC_CD": "DTC001",';
        jsonRequest += '                    "ACVT_DTC_YN": "Y",';
        jsonRequest += '                    "FUEL_K_CD": "A95",';
        jsonRequest += '                    "DGN_OCCU_YMD": "20210101",';
        jsonRequest += '                    "DGN_OCCU_CTMS": "090101",';
        jsonRequest += '                    "ET_BKDW_EXPL": "OIL CHANGE PERIOD OVER DUE"';
        jsonRequest += '                },';
        jsonRequest += '                {';
        jsonRequest += '                    "TSTMP": "123456789",';
        jsonRequest += '                    "DGN_DTL_SEQ": "34404",';
        jsonRequest += '                    "VIN": "KR0123",';
        jsonRequest += '                    "DTC_CD": "DTC001",';
        jsonRequest += '                    "ACVT_DTC_YN": "N",';
        jsonRequest += '                    "FUEL_K_CD": "A95",';
        jsonRequest += '                    "DGN_OCCU_YMD": "20210101",';
        jsonRequest += '                    "DGN_OCCU_CTMS": "090101",';
        jsonRequest += '                    "ET_BKDW_EXPL": "OIL CHANGE PERIOD OVER DUE"';
        jsonRequest += '                }';
        jsonRequest += '            ]';
        jsonRequest += '        }';
        jsonRequest += '    }';
        jsonRequest += '}';

        request.requestBody = Blob.valueOf(jsonRequest);

        Test.startTest();

        RestContext.request = request;
        Restcontext.response = response;

        CXP_GCS_DiagnosticTroubleInfo_API.upsertDiagnosticTroubleInfo();

        CXP_GCS_DiagnosticTroubleInfo_APIWrapper.Response output = (CXP_GCS_DiagnosticTroubleInfo_APIWrapper.Response) JSON.deserializeStrict(
            RestContext.response.responseBody.toString(),
            CXP_GCS_DiagnosticTroubleInfo_APIWrapper.Response.class
        );

        System.assertEquals('Z', output.response.payload.ResultCode, 'ResultCode should be Z');

        Test.stopTest();
    }


    @isTest
    static void testUpsertDiagnosticTroubleInfoVINEmpty() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.httpMethod = 'POST';
        request.requestURI = '/CXP_GCS_DiagnosticTroubleInfo/';

        String jsonRequest = '';
        jsonRequest += '{';
        jsonRequest += '    "request": {';
        jsonRequest += '        "header": {';
        jsonRequest += '            "ifId": "IF_EU_GCS_CXP_0002",';
        jsonRequest += '            "ifVer": "v001",';
        jsonRequest += '            "ifSenderGp": "EU",';
        jsonRequest += '            "ifSender": "GCS",';
        jsonRequest += '            "ifReceiverGp": "EU",';
        jsonRequest += '            "ifReceiver": "CXP",';
        jsonRequest += '            "ifDateTime": "20211021010101",';
        jsonRequest += '            "ifTrackingId": "sample",';
        jsonRequest += '            "ifTotCnt": 1';
        jsonRequest += '        },';
        jsonRequest += '        "payload": {';
        jsonRequest += '            "T_DATA": [';
        jsonRequest += '                {';
        jsonRequest += '                    "TSTMP": "123456789",';
        jsonRequest += '                    "DGN_DTL_SEQ": "34404",';
        jsonRequest += '                    "VIN": " ",';
        jsonRequest += '                    "DTC_CD": "DTC001",';
        jsonRequest += '                    "ACVT_DTC_YN": "Y",';
        jsonRequest += '                    "FUEL_K_CD": "A95",';
        jsonRequest += '                    "DGN_OCCU_YMD": "20210101",';
        jsonRequest += '                    "DGN_OCCU_CTMS": "090101",';
        jsonRequest += '                    "ET_BKDW_EXPL": "OIL CHANGE PERIOD OVER DUE"';
        jsonRequest += '                }';
        jsonRequest += '            ]';
        jsonRequest += '        }';
        jsonRequest += '    }';
        jsonRequest += '}';

        request.requestBody = Blob.valueOf(jsonRequest);

        Test.startTest();

        RestContext.request = request;
        Restcontext.response = response;

        CXP_GCS_DiagnosticTroubleInfo_API.upsertDiagnosticTroubleInfo();

        CXP_GCS_DiagnosticTroubleInfo_APIWrapper.Response output = (CXP_GCS_DiagnosticTroubleInfo_APIWrapper.Response) JSON.deserializeStrict(
            RestContext.response.responseBody.toString(),
            CXP_GCS_DiagnosticTroubleInfo_APIWrapper.Response.class
        );

        System.assertEquals('VIN value is empty', output.response.payload.ErrorMsg);

        Test.stopTest();
    }

}



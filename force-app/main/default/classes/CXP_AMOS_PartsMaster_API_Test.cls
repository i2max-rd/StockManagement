@isTest

public class CXP_AMOS_PartsMaster_API_Test {
    @TestSetup
    static void makeData(){
        Id RecordTypeId = Schema.SObjectType.Department__c.getRecordTypeInfosByName().get('NSC Department').getRecordTypeId();
        Department__c department = new Department__c(Name = 'Test Department', Department_Code__c = 'C19GA', RecordTypeId = RecordTypeId);
        insert department;


    }

    @isTest
    static void testInsertParts() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.httpMethod = 'POST';
        request.requestURI = '/CXP_AMOS_PartsMaster/';

        String jsonRequest = '';
        jsonRequest += '{';
        jsonRequest += '    "request": {';
        jsonRequest += '        "header": {';
        jsonRequest += '            "ifId": "IF_EU_AMOS_CXP_0006",';
        jsonRequest += '            "ifVer": "v002",';
        jsonRequest += '            "ifSenderGrp": "EU",';
        jsonRequest += '            "ifSender": "AMOS",';
        jsonRequest += '            "ifReceiverGrp": "EU",';
        jsonRequest += '            "ifReceiver": "CXP",';
        jsonRequest += '            "ifDateTime": "20211022092924",';
        jsonRequest += '            "ifTrackingId": "321873c3-151a-4e81-9b63-9c7864846a9e"';
        jsonRequest += '        },';
        jsonRequest += '        "payload": {';
        jsonRequest += '            "T_DATA": [';
        jsonRequest += '                {';
        jsonRequest += '                    "AMOSCompanyKindCode": "C19GA",';
        jsonRequest += '                    "AMOSProductCode": "TEST100",';
        jsonRequest += '                    "AMOSPartNameNative": "SENSOR-OIL LEVEL",';
        jsonRequest += '                    "AMOSPartName": "SENSOR-OIL LEVEL",';
        jsonRequest += '                    "AMOSProductCodeNEW": " ",';
        jsonRequest += '                    "AMOSProductCodeOLD": "215902A100",';
        jsonRequest += '                    "ProductType": "P",';
        jsonRequest += '                    "AMOSDisposableClass": "A",';
        jsonRequest += '                    "AMOSPackagingunit": 1,';
        jsonRequest += '                    "AMOSDimensionalMeasurement": "mm",';
        jsonRequest += '                    "AMOSWeightMeasurement": "kg",';
        jsonRequest += '                    "Width": "70",';
        jsonRequest += '                    "Length": "110",';
        jsonRequest += '                    "Height": "90",';
        jsonRequest += '                    "Weight": ".060",';
        jsonRequest += '                    "CurrencyIsoCode": "CHF",';
        jsonRequest += '                    "ProductPriceRetail": 511.28,';
        jsonRequest += '                    "ProductPriceBasic": 78.2,';
        jsonRequest += '                    "ProductPriceMSRP": 200.28,';
        jsonRequest += '                    "ProductDealerPriceVOR": 511.28,';
        jsonRequest += '                    "ProductDealerPriceDLY": 511.28,';
        jsonRequest += '                    "ProductDealerPriceStk": 511.28,';
        jsonRequest += '                    "AMOSDiscountGroup": " ",';
        jsonRequest += '                    "ProductDiscountRateVOR": 0,';
        jsonRequest += '                    "ProductDiscountRateDLY": 0,';
        jsonRequest += '                    "ProductDiscountRateSTK": 0,';
        jsonRequest += '                    "AMOSLargeGroup": " ",';
        jsonRequest += '                    "AMOSDistributorSegment": " ",';
        jsonRequest += '                    "DAOSMinimumOrderQuantity": 0,';
        jsonRequest += '                    "AMOSCertificateOfOrigin": "CN",';
        jsonRequest += '                    "AMOSRemanufacturePartCode": " ",';
        jsonRequest += '                    "AMOSCompanyCode": "H",';
        jsonRequest += '                    "AMOSLegalCode": " ",';
        jsonRequest += '                    "AMOSHSCode": "902580",';
        jsonRequest += '                    "AMOSLAC": " ",';
        jsonRequest += '                    "AMOSMAC": " ",';
        jsonRequest += '                    "AMOSSAC": "20d",';
        jsonRequest += '                    "AMOSProductTypeCode": "PT",';
        jsonRequest += '                    "AMOSProductCategoryCode": "D",';
        jsonRequest += '                    "AMOSCharAnalysisCode": " ",';
        jsonRequest += '                    "StartDate": "20061001",';
        jsonRequest += '                    "EndDate": " "';
        jsonRequest += '                }';
        jsonRequest += '            ]';
        jsonRequest += '        }';
        jsonRequest += '    }';
        jsonRequest += '}';

        request.requestBody = Blob.valueOf(jsonRequest);

        Test.startTest();

        RestContext.request = request;
        Restcontext.response = response;

        CXP_AMOS_PartsMaster_API.insertParts();

        CXP_AMOS_PartsMaster_APIWrapper.Response output = (CXP_AMOS_PartsMaster_APIWrapper.Response) JSON.deserializeStrict(
            RestContext.response.responseBody.toString(),
            CXP_AMOS_PartsMaster_APIWrapper.Response.class
        );

        System.assertEquals('Z', output.response.payload.ResultCode, 'ResultCode should be Z');

        Test.stopTest();
    }


    @isTest
    static void testInsertPartsProductCodeEmpty() {
        RestRequest request = new RestRequest();
        RestResponse response = new RestResponse();
        request.httpMethod = 'POST';
        request.requestURI = '/CXP_AMOS_PartsMaster/';


        String jsonRequest = '';
        jsonRequest += '{';
        jsonRequest += '    "request": {';
        jsonRequest += '        "header": {';
        jsonRequest += '            "ifId": "IF_EU_AMOS_CXP_0006",';
        jsonRequest += '            "ifVer": "v002",';
        jsonRequest += '            "ifSenderGrp": "EU",';
        jsonRequest += '            "ifSender": "AMOS",';
        jsonRequest += '            "ifReceiverGrp": "EU",';
        jsonRequest += '            "ifReceiver": "CXP",';
        jsonRequest += '            "ifDateTime": "20211022092924",';
        jsonRequest += '            "ifTrackingId": "321873c3-151a-4e81-9b63-9c7864846a9e"';
        jsonRequest += '        },';
        jsonRequest += '        "payload": {';
        jsonRequest += '            "T_DATA": [';
        jsonRequest += '                {';
        jsonRequest += '                    "AMOSCompanyKindCode": "C19GA",';
        jsonRequest += '                    "AMOSProductCode": "",';
        jsonRequest += '                    "AMOSPartNameNative": "SENSOR-OIL LEVEL",';
        jsonRequest += '                    "AMOSPartName": "SENSOR-OIL LEVEL",';
        jsonRequest += '                    "AMOSProductCodeNEW": " ",';
        jsonRequest += '                    "AMOSProductCodeOLD": "215902A100",';
        jsonRequest += '                    "ProductType": "P",';
        jsonRequest += '                    "AMOSDisposableClass": "A",';
        jsonRequest += '                    "AMOSPackagingunit": 1,';
        jsonRequest += '                    "AMOSDimensionalMeasurement": "mm",';
        jsonRequest += '                    "AMOSWeightMeasurement": "kg",';
        jsonRequest += '                    "Width": "70",';
        jsonRequest += '                    "Length": "110",';
        jsonRequest += '                    "Height": "90",';
        jsonRequest += '                    "Weight": ".060",';
        jsonRequest += '                    "CurrencyIsoCode": "CHF",';
        jsonRequest += '                    "ProductPriceRetail": 511.28,';
        jsonRequest += '                    "ProductPriceBasic": 78.2,';
        jsonRequest += '                    "ProductPriceMSRP": 200.28,';
        jsonRequest += '                    "ProductDealerPriceVOR": 511.28,';
        jsonRequest += '                    "ProductDealerPriceDLY": 511.28,';
        jsonRequest += '                    "ProductDealerPriceStk": 511.28,';
        jsonRequest += '                    "AMOSDiscountGroup": " ",';
        jsonRequest += '                    "ProductDiscountRateVOR": 0,';
        jsonRequest += '                    "ProductDiscountRateDLY": 0,';
        jsonRequest += '                    "ProductDiscountRateSTK": 0,';
        jsonRequest += '                    "AMOSLargeGroup": " ",';
        jsonRequest += '                    "AMOSDistributorSegment": " ",';
        jsonRequest += '                    "DAOSMinimumOrderQuantity": 0,';
        jsonRequest += '                    "AMOSCertificateOfOrigin": "CN",';
        jsonRequest += '                    "AMOSRemanufacturePartCode": " ",';
        jsonRequest += '                    "AMOSCompanyCode": "H",';
        jsonRequest += '                    "AMOSLegalCode": " ",';
        jsonRequest += '                    "AMOSHSCode": "902580",';
        jsonRequest += '                    "AMOSLAC": " ",';
        jsonRequest += '                    "AMOSMAC": " ",';
        jsonRequest += '                    "AMOSSAC": "20d",';
        jsonRequest += '                    "AMOSProductTypeCode": "PT",';
        jsonRequest += '                    "AMOSProductCategoryCode": "D",';
        jsonRequest += '                    "AMOSCharAnalysisCode": " ",';
        jsonRequest += '                    "StartDate": "20061001",';
        jsonRequest += '                    "EndDate": " "';
        jsonRequest += '                }';
        jsonRequest += '            ]';
        jsonRequest += '        }';
        jsonRequest += '    }';
        jsonRequest += '}';

        request.requestBody = Blob.valueOf(jsonRequest);

        Test.startTest();

        RestContext.request = request;
        Restcontext.response = response;

        CXP_AMOS_PartsMaster_API.insertParts();

        CXP_AMOS_PartsMaster_APIWrapper.Response output = (CXP_AMOS_PartsMaster_APIWrapper.Response) JSON.deserializeStrict(
            RestContext.response.responseBody.toString(),
            CXP_AMOS_PartsMaster_APIWrapper.Response.class
        );

        System.assertEquals('Product Code is empty', output.response.payload.ErrorMsg);

        Test.stopTest();
    }

}



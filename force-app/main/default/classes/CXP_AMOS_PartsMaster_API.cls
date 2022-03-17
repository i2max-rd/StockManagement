
@RestResource(urlMapping='/CXP_AMOS_PartsMaster/*')
global with sharing class CXP_AMOS_PartsMaster_API {
    @HttpPost
    global static void partsInsert() {
        RestRequest  request = RestContext.request;
        RestResponse response = RestContext.response;

        CXP_AMOS_PartsMaster_APIWrapper bodyWrapper = CXP_AMOS_PartsMaster_APIWrapper.parse(request.requestBody.toString());
        CXP_AMOS_PartsMaster_APIWrapper.Response responseInstance = new CXP_AMOS_PartsMaster_APIWrapper.Response(
            bodyWrapper.request.header.ifTrackingId
        );

        Schema.SObjectField externalId = Product2.Fields.External_Key__c;
        Map<String, Id> departmentCodeMap = new Map<String, Id>();
        List<Department__c> departmentList = [
            SELECT Id, Department_Code__c
            FROM Department__c
            WHERE RecordType.Name = 'NSC Department'
        ];
        for (Department__c department : departmentList) {
            departmentCodeMap.put(department.Department_Code__c, department.Id);
        }

        Map<String, Product2> productMap = new Map<String, Product2>();
        for (CXP_AMOS_PartsMaster_APIWrapper.T_DATA bodyItem : bodyWrapper.request.payload.T_DATA) {
            Product2 product = new Product2();
            if (String.isBlank(bodyItem.AMOSProductCode)) {
                populateResponseErrorMessage(responseInstance, 'E', ' ', 'VIN value is empty');
                break;
            }
            product.Name = bodyItem.AMOSPartName;
            product.AMOSCompanyKindCode__c	= bodyItem.AMOSCompanyKindCode;
            product.AMOSProductCode__c = bodyItem.AMOSProductCode;
            product.AMOSPartNameNative__c = bodyItem.AMOSPartNameNative;
            product.AMOSPartName__c = bodyItem.AMOSPartName;
            product.AMOSProductCodeNEW__c = bodyItem.AMOSProductCodeNEW;
            product.AMOSProductCodeOLD__c = bodyItem.AMOSProductCodeOLD;
            product.ProductType__c = bodyItem.ProductType;
            product.AMOSDisposableClass__c = bodyItem.AMOSDisposableClass;
            product.AMOSPackagingunit__c = bodyItem.AMOSPackagingunit;
            product.AMOSDimensionalMeasurement__c = bodyItem.AMOSDimensionalMeasurement;
            product.AMOSWeightMeasurement__c = bodyItem.AMOSWeightMeasurement;
            product.Width__c = bodyItem.Width;
            product.Length__c = bodyItem.Length;
            product.Height__c = bodyItem.Height;
            product.Weight__c = bodyItem.Weight;
            product.CurrencyIsoCode__c = bodyItem.CurrencyIsoCode;
            product.ProductPriceRetail__c = bodyItem.ProductPriceRetail;
            product.ProductPriceBasic__c = bodyItem.ProductPriceBasic;
            product.MSRP__c = bodyItem.ProductPriceMSRP;
            product.ProductDealerPriceVOR__c = bodyItem.ProductDealerPriceVOR;
            product.ProductDealerPriceDLY__c = bodyItem.ProductDealerPriceDLY;
            product.ProductDealerPriceStk__c = bodyItem.ProductDealerPriceStk;
            product.AMOSDiscountGroup__c = bodyItem.AMOSDiscountGroup;
            product.ProductDiscountRateVOR__c = bodyItem.ProductDiscountRateVOR;
            product.ProductDiscountRateDLY__c = bodyItem.ProductDiscountRateDLY;
            product.ProductDiscountRateSTK__c = bodyItem.ProductDiscountRateSTK;
            product.AMOSLargeGroup__c = bodyItem.AMOSLargeGroup;
            product.AMOSDistributorSegment__c = bodyItem.AMOSDistributorSegment;
            product.DAOSMinimumOrderQuantity__c = bodyItem.DAOSMinimumOrderQuantity;
            product.AMOSCertificateOfOrigin__c = bodyItem.AMOSCertificateOfOrigin;
            product.AMOSRemanufacturePartCode__c = bodyItem.AMOSRemanufacturePartCode;
            product.AMOSCompanyCode__c = bodyItem.AMOSCompanyCode;
            product.AMOSLegalCode__c = bodyItem.AMOSLegalCode;
            product.AMOSHSCode__c = bodyItem.AMOSHSCode;
            product.AMOSLAC__c = bodyItem.AMOSLAC;
            product.AMOSMAC__c = bodyItem.AMOSMAC;
            product.AMOSSAC__c = bodyItem.AMOSSAC;
            product.AMOSProductTypeCode__c = bodyItem.AMOSProductTypeCode;
            product.AMOSProductCategoryCode__c = bodyItem.AMOSProductCategoryCode;
            product.AMOSCharAnalysisCode__c = bodyItem.AMOSCharAnalysisCode;
            product.StartDate__c = bodyItem.StartDate;
            product.EndDate__c = bodyItem.EndDate;
            product.External_Key__c = bodyItem.AMOSCompanyKindCode + bodyItem.AMOSProductCode;
            product.NSC_Department__c = departmentCodeMap.get(product.AMOSCompanyKindCode__c);
            productMap.put(product.External_Key__c, product);
        }

        if (String.isBlank(responseInstance.response.payload.ErrorMsg)) {
            Database.upsert(productMap.values(), externalId, true);
            responseInstance.response.payload.ResultCode = 'Z';
            responseInstance.response.payload.ErrorCode = ' ';
            responseInstance.response.payload.ErrorMsg = ' ';
        }

        String responseJson = System.JSON.serialize(responseInstance, false);
        response.responseBody = Blob.valueOf(responseJson);
    }

    private static void populateResponseErrorMessage(
        CXP_AMOS_PartsMaster_APIWrapper.Response response,
        String resultCode,
        String errorCode,
        String errorMsg
    ) {
        response.response.payload.ResultCode = resultCode;
        response.response.payload.ErrorCode = errorCode;
        response.response.payload.ErrorMsg = errorMsg;
    }
}
//
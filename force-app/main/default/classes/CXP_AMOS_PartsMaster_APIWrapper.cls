public with sharing class CXP_AMOS_PartsMaster_APIWrapper {
    public Request request;

    public class Header {
        public String ifId;
        public String ifVer;
        public String ifSenderGrp;
        public String ifSender;
        public String ifReceiverGrp;
        public String ifReceiver;
        public String ifDateTime;
        public String ifTrackingId;
    }

    public class T_DATA {
        public String AMOSCompanyKindCode;
        public String AMOSProductCode;
        public String AMOSPartNameNative;
        public String AMOSPartName;
        public String AMOSProductCodeNEW;
        public String AMOSProductCodeOLD;
        public String ProductType;
        public String AMOSDisposableClass;
        public Decimal AMOSPackagingunit;
        public String AMOSDimensionalMeasurement;
        public String AMOSWeightMeasurement;
        public String Width;
        public String Length;
        public String Height;
        public String Weight;
        public String CurrencyIsoCode;
        public Decimal ProductPriceRetail;
        public Decimal ProductPriceBasic;
        public Decimal ProductPriceMSRP;
        public Decimal ProductDealerPriceVOR;
        public Decimal ProductDealerPriceDLY;
        public Decimal ProductDealerPriceStk;
        public String AMOSDiscountGroup;
        public Decimal ProductDiscountRateVOR;
        public Decimal ProductDiscountRateDLY;
        public Decimal ProductDiscountRateSTK;
        public String AMOSLargeGroup;
        public String AMOSDistributorSegment;
        public Decimal DAOSMinimumOrderQuantity;
        public String AMOSCertificateOfOrigin;
        public String AMOSRemanufacturePartCode;
        public String AMOSCompanyCode;
        public String AMOSLegalCode;
        public String AMOSHSCode;
        public String AMOSLAC;
        public String AMOSMAC;
        public String AMOSSAC;
        public String AMOSProductTypeCode;
        public String AMOSProductCategoryCode;
        public String AMOSCharAnalysisCode;
        public String StartDate;
        public String EndDate;
    }

    public class Request {
        public Header header;
        public Payload payload;
    }

    public class Payload {
        public List<T_DATA> T_DATA;
    }

    public static CXP_AMOS_PartsMaster_APIWrapper parse(String json) {
        return (CXP_AMOS_PartsMaster_APIWrapper) System.JSON.deserializeStrict(json, CXP_AMOS_PartsMaster_APIWrapper.class);
    }

    public class Response {
        public ResponseWrapper response;
        public Response(String ifTrackingId) {
            response = new ResponseWrapper(ifTrackingId);
        }
    }

    public class ResponseWrapper {
        public responseHeaderWrapper header;
        public responseBodyWrapper payload;

        public responseWrapper(String ifTrackingId) {
            header = new ResponseHeaderWrapper('IF_EU_AMOS_CXP_0006', 'EU', 'AMOS', 'EU', 'CXP', ifTrackingId);
            payload = new ResponseBodyWrapper();
        }
    }

    public class ResponseHeaderWrapper {
        public String ifId;
        public String ifSenderGrp;
        public String ifSender;
        public String ifReceiverGrp;
        public String ifReceiver;
        public String ifTrackingId;
        public String ifDateTime = System.now().format('yyyyMMddkkmmss');

        public ResponseHeaderWrapper(
            String ifId,
            String ifSenderGrp,
            String ifSender,
            String ifReceiverGrp,
            String ifReceiver,
            String ifTrackingId
        ) {
            this.ifId = ifId;
            this.ifSenderGrp = ifSenderGrp;
            this.ifSender = ifSender;
            this.ifReceiverGrp = ifReceiverGrp;
            this.ifReceiver = ifReceiver;
            this.ifTrackingId = ifTrackingId;
        }
    }

    public class ResponseBodyWrapper {
        public String ResultCode;
        public String ErrorMsg;
        public String ErrorCode;
    }
}
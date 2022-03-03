/**
 * @description         : Support wrapper class for DiagnosticTroubleInfo web service from the GSC Source
 * @author              : chaewon
 * @last modified on    : 03-03-2022 
 * @last modified by    : chaewon
 */
@SuppressWarnings('PMD.VariableNamingConventions,PMD.ExcessiveParameterList,PMD.ExcessivePublicCount')
public with sharing class CXP_GCS_DiagnosticTroubleInfo_APIWrapper {
   public Request request;

   public class Header {
       public String ifId;
       public String ifVer;
       public String ifSenderGrp;
       public String ifSender;
       public String ifReceiverGrp;
       public String ifReceiver;
       public String ifTrackingId;
       public Decimal ifTotCnt;
   }

   public class T_DATA {
       public String TSTMP;
       public String VIN;
       public String DTC_CD;
       public String ACVT_DTC_YN;
       public String FUEL_K_CD;
       public String DGN_OCCU_YMD;
       public String DGN_OCCU_CTMS;
       public String ET_BKDW_EXPL;
       public Decimal DGN_DTL_SEQ;
   }

   public class Request {
       public Header header;
       public Payload payload;
   }

   public class Payload {
       public List<T_DATA> T_DATA;
   }

   public static CXP_GCS_DiagnosticTroubleInfo_APIWrapper parse(String json) {
       return (CXP_GCS_DiagnosticTroubleInfo_APIWrapper) System.JSON.deserializeStrict(json, CXP_GCS_DiagnosticTroubleInfo_APIWrapper.class);
   }

   public class Response {
       public ResponseWrapper response;
       public Response(Decimal ifTotCnt, String ifTrackingId) {
            response = new ResponseWrapper(ifTotCnt, ifTrackingId);
       }
   }

   public class ResponseWrapper {
       public responseHeaderWrapper header;
       public responseBodyWrapper payload;

       public responseWrapper(Decimal ifTotCnt, String ifTrackingId) {
           header = new ResponseHeaderWrapper('IF_EU_GCS_CXP_0002', 'EU', 'GCS', 'EU', 'CXP', ifTotCnt, ifTrackingId);
           payload = new responseBodyWrapper();
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
    public Decimal ifTotCnt;

    public ResponseHeaderWrapper(
        String ifId,
        String ifSenderGrp,
        String ifSender,
        String ifReceiverGrp,
        String ifReceiver,
        Decimal ifTotCnt,
        String ifTrackingId
    ) {
        this.ifId = ifId;
        this.ifSenderGrp = ifSenderGrp;
        this.ifSender = ifSender;
        this.ifReceiverGrp = ifReceiverGrp;
        this.ifReceiver = ifReceiver;
        this.ifTotCnt = ifTotCnt;
        this.ifTrackingId = ifTrackingId;
    }
}

public class ResponseBodyWrapper {
    public String ResultCode;
    public String ErrorMsg;
    public String ErrorCode;
}
}

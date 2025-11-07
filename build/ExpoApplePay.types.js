export var MerchantCapability;
(function (MerchantCapability) {
    MerchantCapability["3DS"] = "supports3DS";
    MerchantCapability["EMV"] = "supportsEMV";
    MerchantCapability["Credit"] = "supportsCredit";
    MerchantCapability["Debit"] = "supportsDebit";
})(MerchantCapability || (MerchantCapability = {}));
export var PaymentNetwork;
(function (PaymentNetwork) {
    PaymentNetwork["JCB"] = "JCB";
    PaymentNetwork["amex"] = "amex";
    PaymentNetwork["cartesBancaires"] = "cartesBancaires";
    PaymentNetwork["chinaUnionPay"] = "chinaUnionPay";
    PaymentNetwork["discover"] = "discover";
    PaymentNetwork["eftpos"] = "eftpos";
    PaymentNetwork["electron"] = "electron";
    PaymentNetwork["elo"] = "elo";
    PaymentNetwork["idCredit"] = "idCredit";
    PaymentNetwork["interac"] = "interac";
    PaymentNetwork["mada"] = "mada";
    PaymentNetwork["maestro"] = "maestro";
    PaymentNetwork["masterCard"] = "masterCard";
    PaymentNetwork["privateLabel"] = "privateLabel";
    PaymentNetwork["quicPay"] = "quicPay";
    PaymentNetwork["suica"] = "suica";
    PaymentNetwork["vPay"] = "vPay";
    PaymentNetwork["visa"] = "visa";
    PaymentNetwork["barcode"] = "barcode";
    PaymentNetwork["girocard"] = "girocard";
    PaymentNetwork["mir"] = "mir";
    PaymentNetwork["nanaco"] = "nanaco";
    PaymentNetwork["waon"] = "waon";
    PaymentNetwork["dankort"] = "dankort";
    PaymentNetwork["bancomat"] = "bancomat";
    PaymentNetwork["bancontact"] = "bancontact";
    PaymentNetwork["postFinance"] = "postFinance";
})(PaymentNetwork || (PaymentNetwork = {}));
export var CompleteStatus;
(function (CompleteStatus) {
    CompleteStatus[CompleteStatus["success"] = 0] = "success";
    CompleteStatus[CompleteStatus["failure"] = 1] = "failure";
})(CompleteStatus || (CompleteStatus = {}));
//# sourceMappingURL=ExpoApplePay.types.js.map
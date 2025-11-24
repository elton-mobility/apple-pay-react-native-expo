import ExpoModulesCore
import PassKit

struct PaymentRequestItemData: Record {
    @Field
    var label: String
    
    @Field
    var amount: String
}

struct PaymentRequestData: Record {
    @Field
    var merchantIdentifier: String
    
    @Field
    var countryCode: String
    
    @Field
    var currencyCode: String
    
    @Field
    var merchantCapabilities: [String] = ["supports3DS"]
    
    @Field
    var supportedNetworks: [String]
    
    @Field
    var paymentSummaryItems: [PaymentRequestItemData]
}

typealias PaymentCompletionHandler = (PKPaymentAuthorizationResult) -> Void

class PaymentHandler: NSObject  {
    var paymentController: PKPaymentAuthorizationController?
    var promise: Promise!
    var handleCompletion: PaymentCompletionHandler?
    
    public func show(data: PaymentRequestData, promise: Promise) {
        self.promise = promise;
        
        let paymentRequest = PKPaymentRequest()
        paymentRequest.paymentSummaryItems = data.paymentSummaryItems.map {
            PKPaymentSummaryItem(label: $0.label, amount: NSDecimalNumber(string: $0.amount), type: .final)
        }
        
        paymentRequest.merchantIdentifier = data.merchantIdentifier
        paymentRequest.merchantCapabilities = getMerchantCapabilitiesFromData(jsMerchantCapabilities: data.merchantCapabilities)
        paymentRequest.countryCode = data.countryCode
        paymentRequest.currencyCode = data.currencyCode
        paymentRequest.supportedNetworks = getSupportedNetworksFromData(jsSupportedNetworks: data.supportedNetworks)
        
        //        paymentRequest.shippingType = .delivery
        //        paymentRequest.shippingMethods = shippingMethodCalculator()
        //        paymentRequest.requiredShippingContactFields = [.name, .postalAddress]
        
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController!.delegate = self
        paymentController!.present(completion: { (presented: Bool) in
            if presented {
            } else {
                self.promise.reject("no_show", "Failed to present")
                self.promise = nil
            }
        })
    }
    
    public func complete(status: PKPaymentAuthorizationStatus) {
        handleCompletion?(PKPaymentAuthorizationResult(status: status, errors: [Error]()))
    }
    
    public func dismiss() {
        paymentController?.dismiss()
    }
    
    private func getMerchantCapabilitiesFromData(jsMerchantCapabilities: [String]) -> PKMerchantCapability {
        var PKMerchantCapabilityMap = [String: PKMerchantCapability]()
        
        PKMerchantCapabilityMap["supports3DS"] = PKMerchantCapability.threeDSecure
        PKMerchantCapabilityMap["supportsCredit"] = PKMerchantCapability.credit
        PKMerchantCapabilityMap["supportsDebit"] = PKMerchantCapability.debit
        PKMerchantCapabilityMap["supportsEMV"] = PKMerchantCapability.emv
        
        var merchantCapabilities: PKMerchantCapability = [];
        for jsMerchantCapability in jsMerchantCapabilities {
            if (PKMerchantCapabilityMap[jsMerchantCapability] != nil) {
                merchantCapabilities.insert(PKMerchantCapabilityMap[jsMerchantCapability]!)
            }
        }
        
        return merchantCapabilities;
    }
    
    private func getSupportedNetworksFromData(jsSupportedNetworks: [String]) -> [PKPaymentNetwork] {
        var PKPaymentNetworkMap = [String: PKPaymentNetwork]()
        
        PKPaymentNetworkMap["JCB"] = PKPaymentNetwork.JCB
        PKPaymentNetworkMap["amex"] = PKPaymentNetwork.amex
        PKPaymentNetworkMap["cartesBancaires"] = PKPaymentNetwork.cartesBancaires
        PKPaymentNetworkMap["chinaUnionPay"] = PKPaymentNetwork.chinaUnionPay
        PKPaymentNetworkMap["discover"] = PKPaymentNetwork.discover
        PKPaymentNetworkMap["eftpos"] = PKPaymentNetwork.eftpos
        PKPaymentNetworkMap["electron"] = PKPaymentNetwork.electron
        PKPaymentNetworkMap["elo"] = PKPaymentNetwork.elo
        PKPaymentNetworkMap["idCredit"] = PKPaymentNetwork.idCredit
        PKPaymentNetworkMap["interac"] = PKPaymentNetwork.interac
        PKPaymentNetworkMap["mada"] = PKPaymentNetwork.mada
        PKPaymentNetworkMap["maestro"] = PKPaymentNetwork.maestro
        PKPaymentNetworkMap["masterCard"] = PKPaymentNetwork.masterCard
        PKPaymentNetworkMap["privateLabel"] = PKPaymentNetwork.privateLabel
        PKPaymentNetworkMap["quicPay"] = PKPaymentNetwork.quicPay
        PKPaymentNetworkMap["suica"] = PKPaymentNetwork.suica
        PKPaymentNetworkMap["vPay"] = PKPaymentNetwork.vPay
        PKPaymentNetworkMap["visa"] = PKPaymentNetwork.visa
        
        if #available(iOS 14.0, *) {
            PKPaymentNetworkMap["barcode"] = PKPaymentNetwork.barcode
            PKPaymentNetworkMap["girocard"] = PKPaymentNetwork.girocard
        }
        if #available(iOS 14.5, *) {
            PKPaymentNetworkMap["mir"] = PKPaymentNetwork.mir
        }
        if #available(iOS 15.0, *) {
            PKPaymentNetworkMap["nanaco"] = PKPaymentNetwork.nanaco
            PKPaymentNetworkMap["waon"] = PKPaymentNetwork.waon
        }
        if #available(iOS 15.1, *) {
            PKPaymentNetworkMap["dankort"] = PKPaymentNetwork.dankort
        }
        if #available(iOS 16.0, *) {
            PKPaymentNetworkMap["bancomat"] = PKPaymentNetwork.bancomat
            PKPaymentNetworkMap["bancontact"] = PKPaymentNetwork.bancontact
        }
        if #available(iOS 16.4, *) {
            PKPaymentNetworkMap["postFinance"] = PKPaymentNetwork.postFinance
        }
        
        var supportedNetworks: [PKPaymentNetwork] = [];
        
        for supportedNetwork in jsSupportedNetworks {
            if (PKPaymentNetworkMap[supportedNetwork] != nil) {
                supportedNetworks.append(PKPaymentNetworkMap[supportedNetwork]!)
            }
        }
        
        return supportedNetworks;
    }
}

extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {
    private func convertNetworkToDinteroFormat(_ network: String) -> String {
        // Convert network names to uppercase format expected by Dintero
        // iOS returns "Visa", "MasterCard" etc., but Dintero expects "VISA", "MASTERCARD"
        let networkMap: [String: String] = [
            "Visa": "VISA",
            "MasterCard": "MASTERCARD",
            "Amex": "AMEX",
            "Discover": "DISCOVER",
            "JCB": "JCB",
            "ChinaUnionPay": "CHINAUNIONPAY",
            "Interac": "INTERAC",
            "PrivateLabel": "PRIVATELABEL",
            "Suica": "SUICA",
            "VPay": "VPAY",
            "Electron": "ELECTRON",
            "Maestro": "MAESTRO",
            "CartesBancaires": "CARTESBANCAIRES",
            "Eftpos": "EFTPOS",
            "Elo": "ELO",
            "IdCredit": "IDCREDIT",
            "Mada": "MADA",
            "QuicPay": "QUICPAY"
        ]
        return networkMap[network] ?? network.uppercased()
    }
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        handleCompletion = completion
        do {
            // Parse the payment data
            let paymentData: [String : Any]? = try JSONSerialization.jsonObject(with: payment.token.paymentData, options: []) as? [String: Any]
            
            // Build payment method object
            var paymentMethodDict: [String: Any] = [:]
            if let network = payment.token.paymentMethod.network?.rawValue {
                // Convert network to uppercase format expected by Dintero
                paymentMethodDict["network"] = convertNetworkToDinteroFormat(network)
            }
            if let displayName = payment.token.paymentMethod.displayName {
                paymentMethodDict["displayName"] = displayName
            }
            
            switch payment.token.paymentMethod.type {
            case .debit:
                paymentMethodDict["type"] = "debit"
            case .credit:
                paymentMethodDict["type"] = "credit"
            case .prepaid:
                paymentMethodDict["type"] = "prepaid"
            case .store:
                paymentMethodDict["type"] = "store"
            case .eMoney:
                paymentMethodDict["type"] = "eMoney"
            default:
                paymentMethodDict["type"] = "unknown"
            }
            
            // Build the full payment token structure
            let tokenData: [String: Any] = [
                "paymentData": paymentData as Any,
                "transactionIdentifier": payment.token.transactionIdentifier,
                "paymentMethod": paymentMethodDict
            ]
            
            let paymentObject: [String: Any] = [
                "payment": [
                    "token": tokenData
                ]
            ]
            
            promise?.resolve(paymentObject)
            promise = nil
        } catch {
            promise?.reject("payment_data_json", "failed to parse")
            promise = nil
        }
    }
    
    public func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss()
        promise?.reject("dismiss", "closed")
        promise = nil
    }
}

import { MerchantCapability, PaymentNetwork, CompleteStatus, PaymentData } from "./ExpoApplePay.types";
declare const _default: {
    show: (data: {
        merchantIdentifier: string;
        countryCode: string;
        currencyCode: string;
        merchantCapabilities: MerchantCapability[];
        supportedNetworks: PaymentNetwork[];
        paymentSummaryItems: {
            label: string;
            amount: number;
        }[];
    }) => Promise<PaymentData>;
    dismiss: () => void;
    complete: (status: CompleteStatus) => void;
};
export default _default;
export { MerchantCapability, PaymentNetwork, CompleteStatus };
//# sourceMappingURL=index.d.ts.map
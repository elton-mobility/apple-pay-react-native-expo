import { MerchantCapability, PaymentNetwork, CompleteStatus } from "./ExpoApplePay.types";
import ExpoApplePayModule from "./ExpoApplePayModule";
export default {
    show: (data) => {
        return ExpoApplePayModule.show({
            ...data,
            paymentSummaryItems: data.paymentSummaryItems.map((item) => ({
                label: item.label,
                amount: item.amount.toString(),
            })),
        });
    },
    dismiss: () => {
        ExpoApplePayModule.dismiss();
    },
    complete: (status) => {
        ExpoApplePayModule.complete(status);
    },
};
export { MerchantCapability, PaymentNetwork, CompleteStatus };
//# sourceMappingURL=index.js.map
"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const config_plugins_1 = require("expo/config-plugins");
function setApplePayEntitlement(merchantIdentifiers, entitlements) {
    const key = "com.apple.developer.in-app-payments";
    const merchants = (entitlements[key] ?? []);
    if (!Array.isArray(merchantIdentifiers)) {
        merchantIdentifiers = [merchantIdentifiers];
    }
    for (const id of merchantIdentifiers) {
        if (id && !merchants.includes(id)) {
            merchants.push(id);
        }
    }
    if (merchants.length) {
        entitlements[key] = merchants;
    }
    return entitlements;
}
const withExpoApplePay = (config, { merchantIdentifiers }) => {
    return (0, config_plugins_1.withEntitlementsPlist)(config, (mod) => {
        mod.modResults = setApplePayEntitlement(merchantIdentifiers, mod.modResults);
        return mod;
    });
};
exports.default = withExpoApplePay;

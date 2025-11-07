import { ConfigPlugin } from "expo/config-plugins";
declare const withExpoApplePay: ConfigPlugin<{
    merchantIdentifiers: string | string[];
}>;
export default withExpoApplePay;

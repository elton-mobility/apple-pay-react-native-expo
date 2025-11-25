export enum MerchantCapability {
	"3DS" = "supports3DS",
	EMV = "supportsEMV",
	Credit = "supportsCredit",
	Debit = "supportsDebit",
}

export enum PaymentNetwork {
	JCB = "JCB",
	amex = "amex",
	cartesBancaires = "cartesBancaires",
	chinaUnionPay = "chinaUnionPay",
	discover = "discover",
	eftpos = "eftpos",
	electron = "electron",
	elo = "elo",
	idCredit = "idCredit",
	interac = "interac",
	mada = "mada",
	maestro = "maestro",
	masterCard = "masterCard",
	privateLabel = "privateLabel",
	quicPay = "quicPay",
	suica = "suica",
	vPay = "vPay",
	visa = "visa",
	barcode = "barcode",
	girocard = "girocard",
	mir = "mir",
	nanaco = "nanaco",
	waon = "waon",
	dankort = "dankort",
	bancomat = "bancomat",
	bancontact = "bancontact",
	postFinance = "postFinance",
}

export enum CompleteStatus {
	success = 0, // Merchant auth'd (or expects to auth) the transaction successfully.
	failure = 1, // Merchant failed to auth the transaction.
}

export type PaymentData = {
	data: string;
	header: {
		ephemeralPublicKey: string;
		publicKeyHash: string;
		transactionId: string;
	};
	signature: string;
	version: string;
};

export type PaymentMethod = {
	type: "debit" | "credit" | "prepaid" | "store" | "eMoney" | "unknown";
	displayName: string;
	network: string;
};

export type PaymentToken = {
	paymentData: PaymentData;
	transactionIdentifier: string;
	paymentMethod: PaymentMethod;
};

export type FullPaymentData = {
	payment: {
		token: PaymentToken;
	};
};

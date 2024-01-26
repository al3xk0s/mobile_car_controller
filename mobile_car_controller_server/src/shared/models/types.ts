export type TypeOfReturn = "string" | "number" | "bigint" | "boolean" | "symbol" | "undefined" | "object" | "function";
export type KeyOf<T> = keyof T;
export type ValueOf<T> = T[KeyOf<T>];

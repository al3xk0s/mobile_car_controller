export const ActionMessagePayloadEncoder = {
  encode: (values: any[]) => values.join(','),
  decode: (rawValue: string) => rawValue.split(','),
}

export const ActionMessageEncoder = {
  encode: (values: any[]) => values.join('|'),
  decode: (rawValue: string) => rawValue.split('|') as [string, string, string],
}

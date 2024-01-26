import { KeyOf, TypeOfReturn, ValueOf } from "./types";

export interface IEnumUtils<V> {
  keys<T extends object>(obj: T) : KeyOf<T>[];
  values<T extends object>(obj: T) : ValueOf<T>[];
}

const EnumUtils = <V>(targetValueType: Exclude<TypeOfReturn, 'string'>) : IEnumUtils<V> => {
  return {
      keys: <T extends object>(obj: T) => Object.values(obj).filter(v => typeof v === 'string') as KeyOf<T>[],
      values: <T extends object>(obj: T) => Object.values(obj).filter(v => typeof v === targetValueType) as ValueOf<T>[],
  }
}

interface IEnumParser<E extends object, V> {    
  get keys(): KeyOf<E>[];
  get values(): (E[keyof E])[];

  keyAt(value: ValueOf<E>) : KeyOf<E>;

  parse(rawValue: V, values?: ValueOf<E>[]) : ValueOf<E>;
  tryParse(rawValue: V, values?: ValueOf<E>[]) : ValueOf<E> | undefined;
}

export const EnumParser = <E extends object, V>(utils: IEnumUtils<V>, obj: E, orElse?: ValueOf<E>) : IEnumParser<E, V> => {
  const keys = utils.keys(obj);
  const values = utils.values(obj);

  const withoutReserve = orElse == null ? values : values.filter(v => v !== orElse);

  const tryParse = (rawValue: V, targetValues?: ValueOf<E>[]) => {
      const value = (targetValues ?? withoutReserve).find(v => v === rawValue);

      return value == null && orElse != null ?
          orElse :
          value;
  }
      

  return {
      keys,
      values,
      keyAt: (value) => obj[value as KeyOf<E>] as KeyOf<E>,
      tryParse,
      parse: (rawValue, targetValues) => {
          const value = tryParse(rawValue, targetValues);
          if(value == null) throw Error(`Enum parsing error. Value '${rawValue} is not match enum value with keys [${keys.join(', ')}]'`);

          return value;
      },

  }
}

export const NumberEnumUtils = EnumUtils<number>('number');
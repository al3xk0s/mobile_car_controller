import { ActionAxisMessage, AxisType } from "../../action_message";

export type IAsixValueConverter = (axis: ActionAxisMessage) => number;

const _maxValue = 100000;
const _minValue = 0;
const _halfValue = (_maxValue + _minValue) / 2;

const convertXInputSingle = (value: number) =>  value / _maxValue;
const convertXInputSingleReverse = (value: number) => -convertXInputSingle(value);

const convertXInpuiDouble = (value: number) => {
  const offseted = value - _halfValue;
  return offseted / _halfValue;
}

export const AsixValueConverterSet : { xInput: IAsixValueConverter } = {
  xInput: (axis) : number => {
    if(axis.axisType === AxisType.double) return convertXInpuiDouble(axis.value);
    if(axis.axisType === AxisType.single) return convertXInputSingle(axis.value);
    if(axis.axisType === AxisType.singleReverse) return convertXInputSingleReverse(axis.value);

    throw Error(`Unsupported axis type ${AxisType[axis.axisType]}`);
  }
}

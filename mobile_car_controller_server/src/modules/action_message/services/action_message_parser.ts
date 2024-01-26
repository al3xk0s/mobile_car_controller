import { EnumParser, NumberEnumUtils } from "../../../shared/models/enum_parser";
import { ActionAxisMessage, ActionButtonMessage } from "../models/action_message";
import { ActionType } from "../models/action_type";
import { AxisType } from "../models/axis_type";
import { ActionMessageEncoder, ActionMessagePayloadEncoder } from "./action_message_encoder";

const ActionTypeParser = EnumParser(NumberEnumUtils, ActionType);
const AxisTypeParser = EnumParser(NumberEnumUtils, AxisType);


type OneOfActionTypes = ActionAxisMessage | ActionButtonMessage;

const parseButtonMessage = (id: string, payload: string) => {
  const [rawValue] = ActionMessagePayloadEncoder.decode(payload);
  if(rawValue == null) return;

  return new ActionButtonMessage(id, rawValue === '1');
}

const parseAsixMessage = (id: string, payload: string) => {
  const [rawAsixType, value] = ActionMessagePayloadEncoder.decode(payload);

  if(rawAsixType == null || value == null) return;

  const axisType = AxisTypeParser.tryParse(Number.parseInt(rawAsixType));
  if(axisType == null) return;

  return new ActionAxisMessage(id, axisType, Number.parseInt(value));
}

export const parseActionMessage = (rawMessage: string) : OneOfActionTypes | undefined => {
  const [rawType, id, payload] = ActionMessageEncoder.decode(rawMessage);
  const type = ActionTypeParser.tryParse(Number.parseInt(rawType));

  if(type == null || payload == null) return;

  if(type === ActionType.axis) return parseAsixMessage(id, payload);
  if(type === ActionType.button) return parseButtonMessage(id, payload);

  return;
}
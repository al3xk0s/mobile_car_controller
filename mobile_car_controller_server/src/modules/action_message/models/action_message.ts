import { ActionMessageEncoder, ActionMessagePayloadEncoder } from "../services/action_message_encoder";
import { ActionType } from "./action_type";
import { AxisType } from "./axis_type";

export abstract class ActionMessage {
  constructor(
    public readonly type: ActionType,
    public readonly id: string,
  ) {}

  isEquals(other: ActionMessage) : boolean {
    return this.id === other.id && this.type === other.type;
  }

  encode() : string | undefined {
    const values = [this.type, this.id]
    const payload = this._encodePayload();

    if(payload) values.push(payload);

    return ActionMessageEncoder.encode(values);
  }

  protected _encodePayload() : string { return '' }
}

export class ActionAxisMessage extends ActionMessage {
  constructor(
    id: string,
    public readonly axisType: AxisType,
    public readonly value: number,
  ) { super(ActionType.axis, id); }

  protected _encodePayload() {
    return ActionMessagePayloadEncoder.encode([this.axisType, this.value]);
  }

  isEquals(other: ActionMessage): boolean {
    return other instanceof ActionAxisMessage &&
      super.isEquals(other) &&
      this.axisType === other.axisType &&
      this.value === other.value;
  }
}

export class ActionButtonMessage extends ActionMessage {
  constructor(
    public id: string,
    public readonly isPressed: boolean,
  ) { super(ActionType.button, id); }

  protected _encodePayload(): string {
    return ActionMessagePayloadEncoder.encode([this.isPressed ? 1 : 0])        
  }
}

// Format

// type: int
// id: int
// axisType | isPressed
// value
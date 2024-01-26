import {WebSocket} from 'ws';
import {createSocket} from 'node:dgram';
import ViGEmClient from 'vigemclient';
import { ActionAxisMessage, ActionID, ActionType, parseActionMessage } from './modules/action_message';
import { InputAxis } from 'vigemclient/lib/InputAxis';
import { X360Controller } from 'vigemclient/lib/X360Controller';
import { AsixValueConverterSet } from './modules/axis';

const client = new ViGEmClient()
client.connect();

const controller = client.createX360Controller();
controller.connect();

const axisBindings : Record<string, InputAxis<X360Controller> | undefined>  = {
  [ActionID.wheelAxis]: controller.axis.leftX,
  [ActionID.clutchAxis]: controller.axis.leftY,
  [ActionID.breakAxis]: controller.axis.leftTrigger,
  [ActionID.throttleAxis]: controller.axis.rightTrigger,
}

const handleAsix = (message: ActionAxisMessage) => {
  const controllerAxis = axisBindings[message.id];
  if(controllerAxis == null) return;

  controllerAxis.setValue(AsixValueConverterSet.xInput(message));
}

const handleMessage = (message: string) => {
  for(const current of JSON.parse(message)) {
    const action = parseActionMessage(current);
    if(action == null) return;
    new Promise<void>((r) => {
      if(action.type === ActionType.axis) return handleAsix(action as ActionAxisMessage);
      r();
    })
    
  }
}

const PORT = 13000;

// const server = new WebSocket.Server({port: 13000});

// server.on('connection', (client) => {
//   client.on('message', (message) => {
//     handleMessage(message.toString());
//   })
// });

const server = createSocket('udp4');

server.on('message', (message) => {
  handleMessage(message.toString());
});

server.on('listening', () => console.log('server started'))

server.bind(PORT);
import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";


const HopeModule = buildModule("HopeModule", (m) => {

  const lock = m.contract("Hope", [], {});

  return { lock };
});

export default HopeModule;

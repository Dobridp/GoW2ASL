//cheat engine search: 300000000-341FFFFFF
state("rpcs3")
{
}
/*
startup
{
  settings.Add("IGT for Challenges", false);
}
*/
init
{
  vars.pointerEU = (IntPtr)0x300671168; //EU version pointer
  vars.pointermsEU = (IntPtr)0x30067268C; //EU ms pointer
  vars.pauseEU = (IntPtr)0x3006727A8; //EU pause pointer (13 == paused)
  vars.pointerUS = (IntPtr)0x300589368; //US version pointer
  vars.pointermsUS = (IntPtr)0x30058A88C; //US ms pointer
  vars.pauseUS = (IntPtr)0x30058A9C0; //US pause pointer (12 == paused)
  vars.pointerJP = (IntPtr)0x3005CB968; //JP version pointer
  vars.pauseJP = (IntPtr)0x3005CCF48; //JP pause pointer (12 == paused)
  vars.pointer = IntPtr.Zero;
  vars.pointerms = IntPtr.Zero;
  vars.pause = IntPtr.Zero;
  vars.igt = 0.0f;
  vars.igtMS = 0.0f;
  vars.previgt = 0.0f;
  vars.igtAux = 0.0f;
  vars.isJP = false;
  vars.isEU = false;
}

update
{
// Determining the game version
  bool gameFound = false;
  var bytesEU = new byte[4] {0, 0, 0, 0};
  var bytesUS = new byte[4] {0, 0, 0, 0};
  var bytesJP = new byte[4] {0, 0, 0, 0};

  if (!gameFound)
  {
    if (memory.ReadBytes((IntPtr)vars.pointerEU, 4, out bytesEU))
    {
      Array.Reverse(bytesEU);
      if (BitConverter.ToInt32(bytesEU, 0) >= 1 && BitConverter.ToInt32(bytesEU, 0) < 1000000)
      {
        gameFound = true;
        vars.pointer = vars.pointerEU;
        vars.pointerms = vars.pointermsEU;
        vars.isEU = true;
        vars.pause = vars.pauseEU;
      }
    }
    if (memory.ReadBytes((IntPtr)vars.pointerUS, 4, out bytesUS))
    {
      Array.Reverse(bytesUS);
      if (BitConverter.ToInt32(bytesUS, 0) >= 1 && BitConverter.ToInt32(bytesUS, 0) < 1000000)
      {
        gameFound = true;
        vars.pointer = vars.pointerUS;
        vars.pointerms = vars.pointermsUS;
        vars.pause = vars.pauseUS;
      }
    }
    if (memory.ReadBytes((IntPtr)vars.pointerJP, 4, out bytesJP))
    {
      Array.Reverse(bytesJP);
      if (BitConverter.ToInt32(bytesJP, 0) >= 1 && BitConverter.ToInt32(bytesJP, 0) < 1000000)
      {
        gameFound = true;
        vars.isJP = true;
        vars.pointer = vars.pointerJP;
        vars.pause = vars.pauseJP;
      }
    }
  }

  var bytesPause = new byte[4] {0, 0, 0, 0};
  if (memory.ReadBytes((IntPtr)vars.pause, 4, out bytesPause))
  {
    Array.Reverse(bytesPause); // PS3 is big endian
    vars.isPaused = BitConverter.ToInt32(bytesPause, 0);
  }
/*
  var bytes = new byte[4] {0, 0, 0, 0};
  if (memory.ReadBytes((IntPtr)vars.pointer, 4, out bytes))
  {
    Array.Reverse(bytes); // PS3 is big endian
    vars.igt = BitConverter.ToInt32(bytes, 0);
    var bytes2 = new byte[4] {0, 0, 0, 0};
    if (!vars.isJP && memory.ReadBytes((IntPtr)vars.pointerms, 4, out bytes2))
    {
      Array.Reverse(bytes2); // PS3 is big endian
      vars.igtMS = BitConverter.ToSingle(bytes2, 0);
    }
    if (settings["IGT for Challenges"]) //Makes IGT never go back
    {
      if (vars.igt > vars.previgt)
      {
      vars.igtAux += vars.igt - vars.previgt;
      vars.previgt = vars.igt;
      }
    else
      {
      vars.previgt = vars.igt;
      }
    }
  }
*/
}

isLoading
{
  if (vars.isPaused == 13 && vars.isEU)
  {
    return true;
  }
  else if (vars.isPaused == 12 && !vars.isEU)
  {
    return true;
  }
  else
  {
    return false;
  }
}
/*
start
{
  // Overflow autostart protection
  if (vars.igt > -1 && vars.igt < 1000000)
  {
    if (settings["IGT for Challenges"])
    {
      if (vars.igt == 0)
      {
        return true;
      }
    }
    else
    {
      if (vars.igt == 0 && vars.previgt > 0)
      {
        return true;
      }
      else
      {
        vars.previgt = vars.igt;
      }
    }
  }
}

onStart
{
  vars.igtAux = 0;
}

isLoading
{
  return true;
}

gameTime
{
  // IGT is in seconds
  if (settings["IGT for Challenges"])
  {
    return TimeSpan.FromSeconds(vars.igtAux+vars.igtMS);
  }
  else
  {
    return TimeSpan.FromSeconds(vars.igt+vars.igtMS);
  }
}
*/

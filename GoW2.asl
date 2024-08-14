//cheat engine search: 300000000-341FFFFFF
state("rpcs3")
{
}

startup
{
  settings.Add("IGT for Challenges", false);
}

init
{
  vars.pointerEU = (IntPtr)0x300671168; //EU version pointer
  vars.pointerUS = (IntPtr)0x300589368; //US version pointer
  vars.pointer = IntPtr.Zero;
  vars.igt = 0;
  vars.previgt = 0;
  vars.igtAux = 0;

  // Determining the game version
  var bytesEU = new byte[4] {0, 0, 0, 0};
  var bytesUS = new byte[4] {0, 0, 0, 0};
  bool isEU = false;
  bool isUS = false;

  while (!isEU && !isUS)
  {
    if (memory.ReadBytes((IntPtr)vars.pointerEU, 4, out bytesEU) && BitConverter.ToInt32(bytesEU, 0) != 0)
    {
      isEU = true;
      vars.pointer = vars.pointerEU;
    }
    else if (memory.ReadBytes((IntPtr)vars.pointerUS, 4, out bytesUS) && BitConverter.ToInt32(bytesUS, 0) < 1000000)
    {
      isUS = true;
      vars.pointer = vars.pointerUS;
    }
    Thread.Sleep(500);
  }
}

update
{
  var bytes = new byte[4] {0, 0, 0, 0};
  if (memory.ReadBytes((IntPtr)vars.pointer, 4, out bytes))
  {
    Array.Reverse(bytes); // PS3 is big endian
    vars.igt = BitConverter.ToInt32(bytes, 0);
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
}

start
{
  // Overflow autostart protection
  if (vars.igt >= int.MinValue && vars.igt <= int.MaxValue)
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
  // vars.ms = (int)(DateTime.Now.TimeOfDay.TotalMilliseconds % 1000);
  // IGT is in seconds
  if (settings["IGT for Challenges"])
  {
    return TimeSpan.FromSeconds(vars.igtAux);
  }
  else
  {
    return TimeSpan.FromSeconds(vars.igt);
  }
}

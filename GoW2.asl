//cheat engine search: 300000000-341FFFFFF
state("rpcs3")
{
}

init
{
  vars.pointerEU = (IntPtr)0x300671168; //EU version pointer
  vars.pointerUS = (IntPtr)0x300589368; //US version pointer
  vars.pointer = IntPtr.Zero;
  vars.igt = 0;
  vars.previgt = 0;

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
    }
    else if (memory.ReadBytes((IntPtr)vars.pointerUS, 4, out bytesUS) && BitConverter.ToInt32(bytesUS, 0) < 1000000)
    {
      isUS = true;
    }
    Thread.Sleep(1000);
  }
  if (isEU)
  {
    vars.pointer = vars.pointerEU;
  }
  else if (isUS)
  {
    vars.pointer = vars.pointerUS;
  }
}

update
{
  var bytes = new byte[4] {0, 0, 0, 0};
  if (memory.ReadBytes((IntPtr)vars.pointer, 4, out bytes)) 
  {
    Array.Reverse(bytes); // PS3 is big endian
    vars.igt = BitConverter.ToInt32(bytes, 0);
  }
}


start
{
  // Overflow autostart protection
  if (vars.igt >= int.MinValue && vars.igt <= int.MaxValue)
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

isLoading
{
  return true;
}

gameTime
{
  // IGT is in seconds
  return TimeSpan.FromSeconds(vars.igt);
}

using System;

namespace FPG.Interfaces
{
    public interface ICroppingAlgorithm
    {
        String Crop(String input, Int32 length);
    }
}
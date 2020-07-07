using System;
using System.Collections.Generic;

namespace FPG.Interfaces
{
    public interface ISaltingAlgorithm
    {
        String Salt(IEnumerable<String> inputs, IEnumerable<String> salts);
    }
}
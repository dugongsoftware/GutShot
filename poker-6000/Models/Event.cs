using System;

namespace poker6000.Models
{
    public class Event
    {
        public String GameType { get; set; }
        
        public Int32 Stack { get; set; }
        
        public DateTime StartTime { get; set; }
        
        public TimeSpan BlindLevels { get; set; }

        public Event()
        {
        }
    }
}

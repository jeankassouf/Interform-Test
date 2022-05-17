using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace events.Models
{
    public class EventFile
    {
        [Key]
        public Int32 Id { get; set; }
        public Int32 EventId { get; set; }
        public Event Event { get; set; }
        public String Name { get; set; }
        public String Path { get; set; }
        public String Type { get; set; }

    }
}

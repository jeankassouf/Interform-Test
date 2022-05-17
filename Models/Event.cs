using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace events.Models
{
    public class Event
    {
        [Key]
        public Int32 Id { get; set; }
        [StringLength(100)]
        [Display(Name = "Title")]
        [Required]
        public String Title { get; set; }
        public DateTime Date
        {
            get
            {
                return this.dateCreated.HasValue ? this.dateCreated.Value : DateTime.Now;
            }
            set { this.dateCreated = value; }
        }

        public DateTime? dateCreated = null;
        
        [Display(Name = "Event Date")]
        [Required]
        [DataType(DataType.DateTime)]
        public DateTime EventDate { get; set; }
        public List<EventFile> EventFiles { get; set; }

    }
}

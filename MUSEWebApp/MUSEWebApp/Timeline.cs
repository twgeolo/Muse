//------------------------------------------------------------------------------
// <auto-generated>
//    This code was generated from a template.
//
//    Manual changes to this file may cause unexpected behavior in your application.
//    Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace MUSEWebApp
{
    using System;
    using System.Collections.Generic;
    
    public partial class Timeline
    {
        public int TimelineID { get; set; }
        public int UserID { get; set; }
        public Nullable<int> MusicID { get; set; }
        public int Privacy { get; set; }
        public string Content { get; set; }
        public Nullable<int> Likes { get; set; }
        public string Comments { get; set; }
    }
}

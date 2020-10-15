using System;

using Xlfdll.Configuration;

namespace FPG.Configuration
{
    public class GeneralSettings : ApplicationSettings
    {
        public GeneralSettings(ApplicationConfiguration appConfiguration)
            : base(appConfiguration)
        {
            this.Provider.Current.TryAddValue("General", "AutoCopyPassword", Boolean.TrueString);
            this.Provider.Current.TryAddValue("General", "SaveLastUserSalt", Boolean.TrueString);
        }

        public Boolean AutoCopyPassword
        {
            get { return Boolean.Parse(this.Provider.Current["General"]["AutoCopyPassword"]); }
            set { this.Provider.Current["General"]["AutoCopyPassword"] = value.ToString(); }
        }
        public Boolean SaveLastUserSalt
        {
            get { return Boolean.Parse(this.Provider.Current["General"]["SaveLastUserSalt"]); }
            set { this.Provider.Current["General"]["SaveLastUserSalt"] = value.ToString(); }
        }
    }
}
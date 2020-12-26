using System;

using Xlfdll.Configuration;

namespace FPG.Configuration
{
    public class GeneralSettings : ApplicationSettings
    {
        public GeneralSettings(ApplicationConfiguration appConfiguration)
            : base(appConfiguration)
        {
            this.Provider.Current.TryAddValue(GeneralSettings.SectionName, nameof(this.AutoCopyPassword), Boolean.TrueString);
            this.Provider.Current.TryAddValue(GeneralSettings.SectionName, nameof(this.SaveLastUserSalt), Boolean.TrueString);
        }

        public Boolean AutoCopyPassword
        {
            get { return Boolean.Parse(this.Provider.Current[GeneralSettings.SectionName][nameof(this.AutoCopyPassword)]); }
            set { this.Provider.Current[GeneralSettings.SectionName][nameof(this.AutoCopyPassword)] = value.ToString(); }
        }
        public Boolean SaveLastUserSalt
        {
            get { return Boolean.Parse(this.Provider.Current[GeneralSettings.SectionName][nameof(this.SaveLastUserSalt)]); }
            set { this.Provider.Current[GeneralSettings.SectionName][nameof(this.SaveLastUserSalt)] = value.ToString(); }
        }

        private const String SectionName = "General";
    }
}
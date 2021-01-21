using System;

using Xlfdll.Configuration;

using FPG.Configuration;

namespace FPG
{
    public class Settings
    {
        public Settings(ApplicationConfiguration appConfiguration)
        {
            this.Provider = appConfiguration;

            this.General = new GeneralSettings(appConfiguration);
            this.Password = new PasswordSettings(appConfiguration);
        }

        private ApplicationConfiguration Provider { get; }

        public GeneralSettings General { get; }
        public PasswordSettings Password { get; }

        public Boolean Check()
        {
            return this.Provider.Check();
        }

        public void Save()
        {
            this.Provider.Save();
        }
    }
}
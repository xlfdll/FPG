using Xlfdll.Core;

using FPG.Configuration;

namespace FPG
{
    public class Settings
    {
        public Settings(ApplicationConfiguration appConfiguration)
        {
            this.General = new GeneralSettings(appConfiguration);
            this.Password = new PasswordSettings(appConfiguration);
        }

        public GeneralSettings General { get; }
        public PasswordSettings Password { get; }
    }
}
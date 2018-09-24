using System;

using Xlfdll.Configuration;

using FPG.Helpers;

namespace FPG.Configuration
{
    public class PasswordSettings : ApplicationSettings
    {
        public PasswordSettings(ApplicationConfiguration appConfiguration)
            : base(appConfiguration)
        {
            this.Provider.Current.TryAddValue("Password", "PasswordLength", "16");
            this.Provider.Current.TryAddValue("Password", "UserSalt", String.Empty);
            this.Provider.Current.TryAddValue("Password", "RandomSalt", PasswordHelper.GenerateSalt(PasswordHelper.RandomSaltLength));
        }

        public Decimal PasswordLength
        {
            get { return Convert.ToDecimal(this.Provider.Current["Password"]["PasswordLength"]); }
            set { this.Provider.Current["Password"]["PasswordLength"] = value.ToString(); }
        }
        public String UserSalt
        {
            get { return this.Provider.Current["Password"]["UserSalt"]; }
            set { this.Provider.Current["Password"]["UserSalt"] = value; }
        }
        public String RandomSalt
        {
            get { return this.Provider.Current["Password"]["RandomSalt"]; }
            set { this.Provider.Current["Password"]["RandomSalt"] = value; }
        }
    }
}
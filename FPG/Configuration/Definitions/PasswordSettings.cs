using System;

using Xlfdll.Configuration;

namespace FPG.Configuration
{
    public class PasswordSettings : ApplicationSettings
    {
        public PasswordSettings(ApplicationConfiguration appConfiguration)
            : base(appConfiguration)
        {
            this.Provider.Current.TryAddValue("Password", "PasswordLength", "16");
            this.Provider.Current.TryAddValue("Password", "InsertSpecialSymbols", "true");
            this.Provider.Current.TryAddValue("Password", "SpecialSymbols", Helper.DefaultSpecialSymbols);
            this.Provider.Current.TryAddValue("Password", "UserSalt", String.Empty);
            this.Provider.Current.TryAddValue("Password", "RandomSalt", App.AlgorithmSet.SaltGeneration.Generate());
        }

        public Decimal PasswordLength
        {
            get { return Convert.ToDecimal(this.Provider.Current["Password"]["PasswordLength"]); }
            set { this.Provider.Current["Password"]["PasswordLength"] = value.ToString(); }
        }
        public Boolean InsertSpecialSymbols
        {
            get { return Boolean.Parse(this.Provider.Current["Password"]["InsertSpecialSymbols"]); }
            set { this.Provider.Current["Password"]["InsertSpecialSymbols"] = value.ToString(); }
        }
        public String SpecialSymbols
        {
            get { return this.Provider.Current["Password"]["SpecialSymbols"]; }
            set { this.Provider.Current["Password"]["SpecialSymbols"] = value; }
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
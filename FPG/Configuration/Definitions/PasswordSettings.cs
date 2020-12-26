using System;

using Xlfdll.Configuration;

namespace FPG.Configuration
{
    public class PasswordSettings : ApplicationSettings
    {
        public PasswordSettings(ApplicationConfiguration appConfiguration)
            : base(appConfiguration)
        {
            this.Provider.Current.TryAddValue(PasswordSettings.SectionName, nameof(this.PasswordLength), "16");
            this.Provider.Current.TryAddValue(PasswordSettings.SectionName, nameof(this.InsertSpecialSymbols), Boolean.TrueString);
            this.Provider.Current.TryAddValue(PasswordSettings.SectionName, nameof(this.SpecialSymbols), Helper.DefaultSpecialSymbols);
            this.Provider.Current.TryAddValue(PasswordSettings.SectionName, nameof(this.UserSalt), String.Empty);
            this.Provider.Current.TryAddValue(PasswordSettings.SectionName, nameof(this.RandomSalt), App.AlgorithmSet.SaltGeneration.Generate());
        }

        public Decimal PasswordLength
        {
            get { return Convert.ToDecimal(this.Provider.Current[PasswordSettings.SectionName][nameof(this.PasswordLength)]); }
            set { this.Provider.Current[PasswordSettings.SectionName][nameof(this.PasswordLength)] = value.ToString(); }
        }
        public Boolean InsertSpecialSymbols
        {
            get { return Boolean.Parse(this.Provider.Current[PasswordSettings.SectionName][nameof(this.InsertSpecialSymbols)]); }
            set { this.Provider.Current[PasswordSettings.SectionName][nameof(this.InsertSpecialSymbols)] = value.ToString(); }
        }
        public String SpecialSymbols
        {
            get { return this.Provider.Current[PasswordSettings.SectionName][nameof(this.SpecialSymbols)]; }
            set { this.Provider.Current[PasswordSettings.SectionName][nameof(this.SpecialSymbols)] = value; }
        }
        public String UserSalt
        {
            get { return this.Provider.Current[PasswordSettings.SectionName][nameof(this.UserSalt)]; }
            set { this.Provider.Current[PasswordSettings.SectionName][nameof(this.UserSalt)] = value; }
        }
        public String RandomSalt
        {
            get { return this.Provider.Current[PasswordSettings.SectionName][nameof(this.RandomSalt)]; }
            set { this.Provider.Current[PasswordSettings.SectionName][nameof(this.RandomSalt)] = value; }
        }

        private const String SectionName = "Password";
    }
}
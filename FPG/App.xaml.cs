using System.Windows;

using Xlfdll.Configuration;
using Xlfdll.Diagnostics;
using Xlfdll.Windows.Configuration;

using FPG.Windows;

namespace FPG
{
    /// <summary>
    /// App.xaml の相互作用ロジック
    /// </summary>
    public partial class App : Application
    {
        private void Application_Startup(object sender, StartupEventArgs e)
        {
            ApplicationConfiguration appConfiguration = new ApplicationConfiguration
                (new RegistryConfigurationProcessor(@"Xlfdll\NB\FPG", RegistryConfigurationScope.User));
            App.Settings = new Settings(appConfiguration);
        }

        private void Application_Exit(object sender, ExitEventArgs e)
        {
            App.Settings.Save();
        }

        public static Settings Settings { get; private set; }

        public static AssemblyMetadata Metadata => AssemblyMetadata.EntryAssemblyMetadata;
        public static new MainWindow MainWindow => Application.Current.MainWindow as MainWindow;

        public static AlgorithmSet AlgorithmSet => AlgorithmSet.Create("Default");
    }
}
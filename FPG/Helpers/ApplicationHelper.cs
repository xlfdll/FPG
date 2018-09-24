using System.Reflection;
using System.Windows;

using Xlfdll.Configuration;
using Xlfdll.Diagnostics;
using Xlfdll.Windows.Configuration;

using FPG.Windows;

namespace FPG.Helpers
{
    public static class ApplicationHelper
    {
        static ApplicationHelper()
        {
            ApplicationHelper.Metadata = new AssemblyMetadata(Assembly.GetExecutingAssembly());
            ApplicationHelper.Configuration = new ApplicationConfiguration(new RegistryConfigurationProcessor(@"Xlfdll\NB\FPG", RegistryConfigurationScope.User));
            ApplicationHelper.Settings = new Settings(ApplicationHelper.Configuration);
        }

        public static AssemblyMetadata Metadata { get; }
        public static ApplicationConfiguration Configuration { get; }
        public static Settings Settings { get; }

        public static MainWindow MainWindow => Application.Current.MainWindow as MainWindow;
    }
}
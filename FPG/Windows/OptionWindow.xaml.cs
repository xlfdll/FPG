using System;
using System.IO;
using System.Windows;
using System.Windows.Controls;

using Xlfdll.Collections;
using Xlfdll.Windows.Presentation;

namespace FPG.Windows
{
    /// <summary>
    /// OptionWindow.xaml の相互作用ロジック
    /// </summary>
    public partial class OptionWindow : Window
    {
        public OptionWindow()
        {
            InitializeComponent();
        }

        private void OptionWindow_Loaded(object sender, RoutedEventArgs e)
        {
            this.DataContext = App.Settings;

            this.DisableMinimizeBox();
        }

        private void RestoreDefaultSymbolsButton_Click(object sender, RoutedEventArgs e)
        {
            SpecialSymbolTextBox.SetCurrentValue(TextBox.TextProperty, PasswordHelper.DefaultSpecialSymbols);
        }

        private void GenerateRandomSaltButton_Click(object sender, RoutedEventArgs e)
        {
            RandomSaltTextBox.SetCurrentValue(TextBox.TextProperty, App.AlgorithmSet.SaltGeneration.Generate());
        }

        private void BackupCriticalSettingsButton_Click(object sender, RoutedEventArgs e)
        {
            RandomSaltTextBox.GetBindingExpression(TextBox.TextProperty).UpdateTarget();
            SpecialSymbolTextBox.GetBindingExpression(TextBox.TextProperty).UpdateTarget();

            PasswordHelper.SaveCriticalSettings();

            MessageBox.Show(this, "Critical settings (random salt and symbol candidates) has been saved to "
                + PasswordHelper.CriticalSettingsBackupFileName,
                App.Metadata.AssemblyTitle, MessageBoxButton.OK, MessageBoxImage.Information);
        }

        private void RestoreCriticalSettingsButton_Click(object sender, RoutedEventArgs e)
        {
            if (File.Exists(PasswordHelper.CriticalSettingsBackupFileName))
            {
                String[] criticalSettings = PasswordHelper.LoadCriticalSettings();

                RandomSaltTextBox.SetCurrentValue(TextBox.TextProperty, criticalSettings[0]);
                SpecialSymbolTextBox.SetCurrentValue(TextBox.TextProperty, criticalSettings[1]);

                MessageBox.Show(this, String.Format("Critical settings (random salt and symbol candidates) has been restored from {0}{1}{1}Click OK button to save them.",
                    PasswordHelper.CriticalSettingsBackupFileName, Environment.NewLine),
                    App.Metadata.AssemblyTitle, MessageBoxButton.OK, MessageBoxImage.Information);
            }
            else
            {
                MessageBox.Show(this, String.Format("Backup file {0} does not exist.", PasswordHelper.CriticalSettingsBackupFileName),
                    App.Metadata.AssemblyTitle, MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void OKButton_Click(object sender, RoutedEventArgs e)
        {
            GeneralStackPanel.Children.ForEach
            (
                (CheckBox element) =>
                {
                    element.GetBindingExpression(CheckBox.IsCheckedProperty).UpdateSource();
                }
            );

            RandomSaltTextBox.GetBindingExpression(TextBox.TextProperty).UpdateSource();
            SpecialSymbolTextBox.GetBindingExpression(TextBox.TextProperty).UpdateSource();

            App.Configuration.Save();

            this.Close();
        }
    }
}
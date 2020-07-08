using System;
using System.Windows;
using System.Windows.Input;

using WinForms = System.Windows.Forms;

using Xlfdll.Windows.Presentation;
using Xlfdll.Windows.Presentation.Dialogs;

namespace FPG.Windows
{
    /// <summary>
    /// MainWindow.xaml の相互作用ロジック
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void MainWindow_Loaded(object sender, RoutedEventArgs e)
        {
            if (!App.Configuration.Check())
            {
                this.Hide();

                MessageBox.Show(this,
                    String.Format("Welcome! This is your first time to use this program.{0}{0}"
                                + "A new random salt has been created for you.{0}{0}"
                                + "It is highly recommended to backup your new random salt "
                                + "or restore your existing one in Options dialog as soon as possible "
                                + "to avoid losing access to your passwords.",
                                Environment.NewLine),
                    this.Title, MessageBoxButton.OK, MessageBoxImage.Information);

                App.Configuration.Save();

                this.Show();
            }

            SaltPasswordBox.Password = App.Settings.Password.UserSalt;
        }

        private void WindowsFormsHost_Loaded(object sender, RoutedEventArgs e)
        {
            WinForms.Application.EnableVisualStyles();

            PasswordLengthNumericUpDown.Value = App.Settings.Password.PasswordLength;
            SymbolCheckBox.IsChecked = App.Settings.Password.InsertSpecialSymbols;
        }

        private void KeywordTextBox_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
            {
                GenerateButton.PerformClick();

                e.Handled = true;
            }
        }

        private void GenerateButton_Click(object sender, RoutedEventArgs e)
        {
            if (String.IsNullOrEmpty(KeywordTextBox.Text.Trim()))
            {
                MessageBox.Show(this, "Keyword is empty.", this.Title, MessageBoxButton.OK, MessageBoxImage.Error);

                return;
            }

            if (String.IsNullOrEmpty(SaltPasswordBox.Password))
            {
                MessageBox.Show(this, "Salt is empty.", this.Title, MessageBoxButton.OK, MessageBoxImage.Error);

                return;
            }

            PasswordTextBox.Text = Helper.GeneratePassword
                (KeywordTextBox.Text.Trim(),
                SaltPasswordBox.Password,
                Convert.ToInt32(PasswordLengthNumericUpDown.Value),
                SymbolCheckBox.IsChecked == true);

            if (App.Settings.General.AutoCopyPassword)
            {
                try
                {
                    Clipboard.SetText(PasswordTextBox.Text);
                }
                catch { }
            }

            App.Settings.Password.UserSalt = App.Settings.General.SaveLastUserSalt ? SaltPasswordBox.Password : String.Empty;
            App.Settings.Password.PasswordLength = PasswordLengthNumericUpDown.Value;
            App.Settings.Password.InsertSpecialSymbols = (SymbolCheckBox.IsChecked == true);

            App.Configuration.Save();
        }

        private void OptionButton_Click(object sender, RoutedEventArgs e)
        {
            OptionWindow optionWindow = new OptionWindow()
            {
                Owner = this
            };

            optionWindow.ShowDialog();
        }

        private void AboutButton_Click(object sender, RoutedEventArgs e)
        {
            AboutWindow aboutWindow = new AboutWindow
                    (App.MainWindow,
                    App.Metadata,
                    new ApplicationPackUri("/Images/NB.png"));

            aboutWindow.ShowDialog();
        }
    }
}
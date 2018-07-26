using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using WinForms = System.Windows.Forms;

using Xlfdll.Windows.Presentation;
using Xlfdll.Windows.Presentation.Dialogs;

using FPG.Helpers;

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
            if (!ApplicationHelper.Configuration.Check())
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

                ApplicationHelper.Configuration.Save();

                this.Show();
            }

            SaltPasswordBox.Password = ApplicationHelper.Settings.Password.UserSalt;
        }

        private void WindowsFormsHost_Loaded(object sender, RoutedEventArgs e)
        {
            WinForms.Application.EnableVisualStyles();

            PasswordLengthNumericUpDown.Value = ApplicationHelper.Settings.Password.PasswordLength;
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

            PasswordTextBox.Text = PasswordHelper.GeneratePassword(KeywordTextBox.Text.Trim(), SaltPasswordBox.Password, Convert.ToInt32(PasswordLengthNumericUpDown.Value));

            if (ApplicationHelper.Settings.General.AutoCopyPassword)
            {
                try
                {
                    Clipboard.SetText(PasswordTextBox.Text);
                }
                catch { }
            }

            ApplicationHelper.Settings.Password.UserSalt = ApplicationHelper.Settings.General.SaveLastUserSalt ? SaltPasswordBox.Password : String.Empty;
            ApplicationHelper.Settings.Password.PasswordLength = PasswordLengthNumericUpDown.Value;

            ApplicationHelper.Configuration.Save();
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
                    (ApplicationHelper.MainWindow,
                    ApplicationHelper.Metadata,
                    new ApplicationPackUri("/Images/NB.png"));

            aboutWindow.ShowDialog();
        }
    }
}
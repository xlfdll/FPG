using System;
using System.IO;
using System.Windows;
using System.Windows.Controls;

using Xlfdll.Core.Collections;
using Xlfdll.Windows.Presentation;

using FPG.Helpers;

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
			this.DataContext = ApplicationHelper.Settings;

			this.DisableMinimizeBox();
		}

		private void GenerateRandomSaltButton_Click(object sender, RoutedEventArgs e)
		{
			RandomSaltTextBox.Text = PasswordHelper.GenerateSalt(PasswordHelper.RandomSaltLength);
		}

		private void BackupRandomSaltButton_Click(object sender, RoutedEventArgs e)
		{
			RandomSaltTextBox.GetBindingExpression(TextBox.TextProperty).UpdateTarget();

			PasswordHelper.SaveRandomSalt(ApplicationHelper.Settings.Password.RandomSalt);

			MessageBox.Show(this, "The random salt has been saved to " + PasswordHelper.RandomSaltBackupDataFileName,
				ApplicationHelper.Metadata.AssemblyTitle, MessageBoxButton.OK, MessageBoxImage.Information);
		}

		private void RestoreRandomSaltButton_Click(object sender, RoutedEventArgs e)
		{
			if (File.Exists(PasswordHelper.RandomSaltBackupDataFileName))
			{
				RandomSaltTextBox.Text = PasswordHelper.LoadRandomSalt();

				MessageBox.Show(this, String.Format("The random salt has been restored from {0}{1}{1}Click OK button to save the new salt data.",
					PasswordHelper.RandomSaltBackupDataFileName, Environment.NewLine),
					ApplicationHelper.Metadata.AssemblyTitle, MessageBoxButton.OK, MessageBoxImage.Information);
			}
			else
			{
				MessageBox.Show(this, String.Format("Backup file {0} does not exist.", PasswordHelper.RandomSaltBackupDataFileName),
					ApplicationHelper.Metadata.AssemblyTitle, MessageBoxButton.OK, MessageBoxImage.Error);
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

			ApplicationHelper.Configuration.Save();

			this.Close();
		}
	}
}
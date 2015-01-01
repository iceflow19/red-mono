using System;
using Gtk;
using System.Runtime.InteropServices;

public partial class MainWindow: Gtk.Window
{
	public MainWindow () : base (Gtk.WindowType.Toplevel)
	{
		Build ();
	}

	protected void OnDeleteEvent (object sender, DeleteEventArgs a)
	{
		System.Diagnostics.Process.GetCurrentProcess ().Kill ();
		a.RetVal = true;
	}
}

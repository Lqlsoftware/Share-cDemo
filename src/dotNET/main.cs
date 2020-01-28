using System;
using System.Runtime.InteropServices;
using System.Text;

namespace dotNET
{
    unsafe class main
    {
        // shared library.
        struct GoString
        {
            public IntPtr p;
            public Int64 n;
        }

        static void Main(string[] args)
        {
            // CGO checks
            // Go code may not store a Go pointer in C memory.
            // C code may store Go pointers in C memory,
            // subject to the rule above: it must stop storing the Go pointer when
            // the C function returns.
            Environment.SetEnvironmentVariable("GODEBUG", "cgocheck=2");

            // define parameters
            bool p0      = false;
            int p1       = 128;
            float p2     = 128.256f;
            double p3    = 128.2565121024;

            // Allocate unmanaged memory for GoString
            string msg   = "Test of string.";
            GoString p4  = new GoString
            {
                p        = Marshal.StringToHGlobalAnsi(msg),
                n        = msg.Length
            };

            // Print massage
            Console.WriteLine(
                "#########################################\n" +
                "### .NET Calling Golang Shared-C lib  ###\n" +
                "#########################################"
            );

            // Call the external functions
            GoDemo.Test();
            GoDemo.TestBoolean(p0);
            GoDemo.TestInt(p1);
            GoDemo.TestFloat(p2);
            GoDemo.TestDouble(p3);
            GoDemo.TestString(p4);
            GoString str = GoDemo.GetString(1);
            Console.WriteLine(GoStringToString(str));
        }

        // Convert GoString to string
        private static string GoStringToString(GoString gostr)
        {
            byte[] bytes = new byte[gostr.n];
            for (int i = 0; i < gostr.n; i++)
            {
                bytes[i] = Marshal.ReadByte(gostr.p, i);
            }
            return Encoding.UTF8.GetString(bytes);
         }

        static class GoDemo
        {
            [DllImport("libdemo_windows.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall, SetLastError = true)]
            public static extern void Test();

            [DllImport("libdemo_windows.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall, SetLastError = true)]
            public static extern void TestBoolean(bool parameter);

            [DllImport("libdemo_windows.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall, SetLastError = true)]
            public static extern void TestInt(int parameter);

            [DllImport("libdemo_windows.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall, SetLastError = true)]
            public static extern void TestFloat(float parameter);

            [DllImport("libdemo_windows.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall, SetLastError = true)]
            public static extern void TestDouble(double parameter);

            [DllImport("libdemo_windows.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall, SetLastError = true)]
            public static extern void TestString(GoString parameter);

            [DllImport("libdemo_windows.dll", CharSet = CharSet.Unicode, CallingConvention = CallingConvention.StdCall, SetLastError = true)]
            public static extern GoString GetString(int index);

        }
    }
}
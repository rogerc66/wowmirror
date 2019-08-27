using System;
using System.Runtime.InteropServices;
using System.Text;
using System.Windows.Forms;  
using System.ComponentModel;


namespace WindowsFormsApplication1
{
    public partial class Form1 : Form
    {
        //uint[] wbaddr;
        //UInt64[] wbint;
        uint microaddr;
        uint tbddr;

        byte[] buf_one;
        byte[] buf_2;

        int calcID;
        IntPtr calcProcess;
        uint readByte;

        IntPtr hwnd = IntPtr.Zero;

        int step;
        public Form1()
        {
            InitializeComponent();
        }

        [DllImport("kernel32.dll ")]
        static extern bool ReadProcessMemory(IntPtr hProcess, uint lpBaseAddress, byte[] lpBuffer, uint nSize, out uint lpNumberOfBytesRead);

        [DllImport("kernel32.dll " , SetLastError = true)]
        static extern bool WriteProcessMemory(IntPtr hProcess, uint lpBaseAddress, byte[] lpBuffer, uint nSize, out uint lpNumberOfBytesRead);
        
        [DllImport("user32.dll")]
        public static extern IntPtr FindWindow(String sClassName, String sAppName);

        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        public static extern int GetWindowThreadProcessId(IntPtr handle, out int processId);

        [DllImportAttribute("kernel32.dll", EntryPoint = "OpenProcess")]
        public static extern IntPtr OpenProcess(int dwDesiredAccess, bool bInheritHandle, int dwProcessId);

        [DllImport("user32.dll ", CharSet = CharSet.Unicode)]
        public static extern IntPtr SendMessage(IntPtr hwnd, int wMsg, int wParam, int lParam); 

        private unsafe void button1_Click(object sender, EventArgs e)
        {
            if (button1.Text == "断开")
            {
                timer1.Stop();
                Application.Exit();
                return;
            }
            step = 0;
            //for (int ii = 0; ii < 110; ii++) wbaddr[ii] = 0;
            hwnd = FindWindow(null, "魔兽世界");
            const int PROCESS_ALL_ACCESS = 0x1F0FFF;
            const int PROCESS_VM_READ = 0x0010;
            const int PROCESS_VM_WRITE = 0x0020;
            if (hwnd != IntPtr.Zero)
            {
                GetWindowThreadProcessId(hwnd, out calcID);
                calcProcess = OpenProcess(PROCESS_ALL_ACCESS | PROCESS_VM_READ | PROCESS_VM_WRITE, false, calcID);
 
                byte[] memptr;
                memptr = new byte[1024*1024 + 30];
                
                for (uint ii = 0x400000; ii < 0x7FFF0000; ii += 1024 * 1024)
                {
                    ReadProcessMemory(calcProcess, ii, memptr, 1024 * 1024 + 30, out readByte);
                    //System.Diagnostics.Trace.WriteLine("line:" + ii.ToString());
                    for (uint jj = 0; jj < 1024 * 1024 ; jj += 1)
                    {
                        bool b_out = false;
                        //080cb1ebh: 00 40 01 12 65 CA 63 42                         ; .@..e蔯B

                        if ( tbddr == 0 )
                        if ( ( memptr[jj] ==0x00 ) && ( memptr[jj+3] ==0x12 ) && ( memptr[jj+4] ==0x65 ) &&( memptr[jj+5] ==0xCA ) 
                            && (memptr[jj + 6] == 0x63) && (memptr[jj + 7] == 0x42))
                        {
                            for (int kk = 16; kk <= 16 * 6 ; kk+=16 )
                            {
                                if (!((memptr[jj + kk] == 0x00) && (memptr[jj + kk + 3] == 0x12) && (memptr[jj + 4] == 0x65) && (memptr[jj + 5] == 0xCA) 
                                    && (memptr[jj + 6] == 0x63) && (memptr[jj + 7] == 0x42)))
                                {
                                    b_out = true;
                                    break;
                                }                                
                            }
                            if (b_out) break;

                            double result;
                            fixed (byte* db = &memptr[jj])
                            {
                                double* ddb = (double*)db;
                                result = (*ddb);
                            }

                            System.Diagnostics.Trace.WriteLine(result.ToString() + " found " + (ii + jj).ToString("X"));
                            if (result == 680000000010)
                            {
                                tbddr = ii + jj;
                                //tb.Text += "table found " + tbddr.ToString("X") + "\r\n";
                            }


                            //System.Console.WriteLine("Value of x is: " + *pi);
                            /*
                            pos = (memptr[jj + 9] - 48) * 10 + (memptr[jj + 10] - 48);
                        
                            if (pos > 99 || pos <= 0) continue;
                            
                            System.Diagnostics.Trace.WriteLine(pos.ToString()+"found" + ( ii + jj ).ToString("X"));
                            wbaddr[pos] = ii + jj;
                           
                            temp = System.Text.Encoding.ASCII.GetString(memptr,(int)jj,12);
                            wbint[pos] = Convert.ToUInt64(temp);
                            tb.Text += pos.ToString() + " found " + (ii + jj).ToString("X") + " : "; tb.Text += temp + "\r\n";
                             */
                        }

                        //185e1680h: 2F 6D 61 63 72 6F 74 65 78 74 20 20 20 ; .../macrotext
                        if (microaddr == 0)
                        if ((memptr[jj] == 0x2f) && (memptr[jj + 1] == 0x6d) && (memptr[jj + 2] == 0x61) && (memptr[jj + 3] == 0x63)
                          && (memptr[jj + 4] == 0x72) && (memptr[jj + 5] == 0x6f) && (memptr[jj + 6] == 0x74) && (memptr[jj + 7] == 0x65)
                          && (memptr[jj + 8] == 0x78) && (memptr[jj + 9] == 0x74) && (memptr[jj + 10] == 0x20) && (memptr[jj + 11] == 0x20))
                        {
                            //tb.Text += "micro found " + (ii + jj).ToString("X") + "\r\n";
                            microaddr = ii + jj;

                        }
 
                    }
                    //System.IO.File.WriteAllBytes(@"c:\dump"+ii.ToString() +".dmp", memptr);
                    if (microaddr != 0 && tbddr != 0)
                    {
                        //搜索成功! 启动监控
                        button1.Text = "断开";
                        timer1.Start();
                        return;
                    }
                    
                }
                MessageBox.Show("连接失败!");
                return;

            }
            else
            {
                MessageBox.Show("没有找到窗口");
                return;
            }
         }

        private unsafe void timer1_Tick(object sender, EventArgs e)
        {
            string temp;
            UInt64 utemp;

            byte[] memptr;
            memptr = new byte[1700];

            
            //System.Diagnostics.Trace.WriteLine("timer");
            if (tbddr > 0)
            {
                if (step == 0)
                {
                    if (true == WriteProcessMemory(calcProcess, tbddr + 16 * 79, buf_one, 8, out readByte))
                    {

                    }
                    else
                    {
                        System.Diagnostics.Trace.WriteLine("write80->1 Fail");
                    }
                }
                if (step==1)
                {
                    if (true == WriteProcessMemory(calcProcess, tbddr + 16 * 79, buf_2, 8, out readByte))
                    {

                    }
                    else
                    {
                        System.Diagnostics.Trace.WriteLine("write80->2 Fail");
                    }
                    step=2;
                }

                if (step ==2)
                {
                    if (true == WriteProcessMemory(calcProcess, tbddr + 16 * 97, buf_one, 8, out readByte))
                    {
                       
                    }
                    else
                    {
                        System.Diagnostics.Trace.WriteLine("write98->2 Fail");
                    }
                }



                ReadProcessMemory(calcProcess, tbddr, memptr, 1700, out readByte);
                byte[] str = new byte[300];
                double result;
                uint po;
                double que;
                uint len = 0;
                fixed (byte* db = &memptr[16])
                {
                    double* ddb = (double*)db;
                    result = (*ddb);
                }
                po = 2;// (ii / 16 + 1);
                que = Convert.ToDouble("680000000" + po.ToString("D2") + "0");
                if (result != que)
                {
                    string[] sArray1=result.ToString("N").Split(new char[2]{'.',','});
                    if (po == 2)
                    {
                        if (sArray1.Length <= 5)
                        {
                            return; 
                        }
                        System.Diagnostics.Trace.WriteLine("name -> " + sArray1[3]);
                        System.Diagnostics.Trace.WriteLine("index -> " + sArray1[4]);

                        for (uint ii = 32; ii < 16 * 90; ii += 16)
                        {
                            fixed (byte* db = &memptr[ii])
                            {
                                double* ddb = (double*)db;
                                result = (*ddb);
                            }
                            po = (ii / 16) - 2;
                            if (result == 0)
                            {
                                len = 5 * po;
                                str[5 * po] = 0;
                                break;
                            }
                            System.Diagnostics.Trace.WriteLine("->" + result.ToString("N"));
                            

                            string[] sArray2 = result.ToString("N").Split(new char[2] { '.', ',' });
                            str[5 * po + 0] = Convert.ToByte(sArray2[0]);
                            if (str[5 * po + 0] == 0) { len = 5 * po; break; }
                            str[5 * po + 1] = Convert.ToByte(sArray2[1]);
                            if (str[5 * po + 1] == 0) { len = 5 * po+1; break; }
                            str[5 * po + 2] = Convert.ToByte(sArray2[2]);
                            if (str[5 * po + 2] == 0) { len = 5 * po+2; break; }
                            str[5 * po + 3] = Convert.ToByte(sArray2[3]);
                            if (str[5 * po + 3] == 0) { len = 5 * po+3; break; }
                            str[5 * po + 4] = Convert.ToByte(sArray2[4]);
                            if (str[5 * po + 4] == 0) { len = 5 * po+4; break; }
                            
                            
                        }
                        ASCIIEncoding encoding = new ASCIIEncoding();   
                        System.Diagnostics.Trace.WriteLine("txt -> " + encoding.GetString(str) + " ");
                        if (microaddr > 0)
                        {
                            if (true == WriteProcessMemory(calcProcess, microaddr, str, len + 1, out readByte))
                            {
                                step=1;
                                System.Diagnostics.Trace.WriteLine("write OK");
                                SendMessage(hwnd, 0x0100, 0x7B, 0);
                                SendMessage(hwnd, 0x0101, 0x7B, 0);
                            }
                            else
                            {

                                int errorCode = System.Runtime.InteropServices.Marshal.GetLastWin32Error();
                                Win32Exception exc = new Win32Exception(errorCode);
                                System.Diagnostics.Trace.WriteLine("write fail " + exc.Message);
                            }


                        }

                    }

                    //System.Diagnostics.Trace.WriteLine(que.ToString() + " -> " + result.ToString("N"));
                }

                //temp = System.Text.Encoding.ASCII.GetString(memptr, 0, 12);
                //utemp = Convert.ToUInt64(temp);
                //if (wbint[ii] != utemp)
                //{
                //    System.Diagnostics.Trace.WriteLine(ii.ToString() + "change:" + wbint[ii].ToString() + " - > " + utemp.ToString());
                //}
            }
            //for (int ii = 1; ii < 100; ii++)
            //{
            //    if (wbaddr[ii] > 0)
            //    {
            //        ReadProcessMemory(calcProcess, wbaddr[ii], memptr, 13, out readByte);
            //        temp = System.Text.Encoding.ASCII.GetString(memptr, 0, 12);
            //        utemp = Convert.ToUInt64(temp);
            //        if (wbint[ii] != utemp)
            //        {
            //            System.Diagnostics.Trace.WriteLine(ii.ToString() + "change:" + wbint[ii].ToString() + " - > " + utemp.ToString());
            //        }
            //    }
            //}
            /*
            if ( microaddr>0 )
            {
                ReadProcessMemory(calcProcess, microaddr, memptr, 10, out readByte);
                temp = System.Text.Encoding.ASCII.GetString(memptr, 0, 10);
                if ( temp.Substring(0,10) != "/macrotext" )
                {
                    System.Diagnostics.Trace.WriteLine(temp);
                }
            }
             */
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            //wbaddr = new uint[110];
            //wbint = new UInt64[110];
            buf_one = new byte[8]; //3FF0000000000000
            buf_one[0] = 0x00;
            buf_one[1] = 0x00;
            buf_one[2] = 0x00;
            buf_one[3] = 0x00;
            buf_one[4] = 0x00;
            buf_one[5] = 0x00;
            buf_one[6] = 0xF0;
            buf_one[7] = 0x3F;

            buf_2 = new byte[8]; //3FF0000000000000
            buf_2[0] = 0x00;
            buf_2[1] = 0x00;
            buf_2[2] = 0x00;
            buf_2[3] = 0x00;
            buf_2[4] = 0x00;
            buf_2[5] = 0x00;
            buf_2[6] = 0x00;
            buf_2[7] = 0x04;

            step = 0;

            microaddr = 0;
            tbddr = 0;
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }


    }
}

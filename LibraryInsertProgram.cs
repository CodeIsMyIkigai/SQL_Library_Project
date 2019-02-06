using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;

/*
 *  Program to insert some of the more lengthy table data in the Library Project
 *
 */


namespace LibraryDataBuilder
{
    class Program
    {
        static void Main(string[] args)
        {
            Random rnd = new Random();
            
            try
            {
                SqlConnection conn = new SqlConnection();
                conn.ConnectionString = @"Data Source=DESKTOP-763SS5P\SQLEXPRESS;Initial Catalog=db_cmt_library;Integrated Security=True";
                // open sql connection
                conn.Open();
                SqlCommand Cmd;

                // Book Copies Table
                int totalRows = 0;    
                for (int i = 1; i < 126; i++)
                {
                    for (int j = 1; j < 126; j++)
                    {
                        Cmd = new SqlCommand("INSERT INTO tbl_BookCopies " +
                            "(BookID, BranchID, Number_Of_Copies) " +
                            "VALUES(@BookID, @BranchID, @Number_Of_Copies)", conn);

                        // create your parameters
                        Cmd.Parameters.Add("@BookID", System.Data.SqlDbType.Int);
                        Cmd.Parameters.Add("@BranchID", System.Data.SqlDbType.Int);
                        Cmd.Parameters.Add("@Number_Of_Copies", System.Data.SqlDbType.Int);

                        // set values to parameters from textboxes
                        Cmd.Parameters["@BookID"].Value = i;
                        Cmd.Parameters["@BranchID"].Value = j;
                        Cmd.Parameters["@Number_Of_Copies"].Value = rnd.Next(2, 11);

                        // execute the query and return number of rows affected, should be one
                        int RowsAffected = Cmd.ExecuteNonQuery();
                        totalRows += RowsAffected;
                    }
                }
                Console.WriteLine("tbl_BookCopies - Rows Affected: " + totalRows);
                
                // Book Loans
                DateTime dateValue;
                totalRows = 0;    
                for(int CardNo = 1; CardNo < 100; CardNo++)
                {
                    int loans = rnd.Next(1,15);

                    for(int i = 0; i < loans; i++)
                    {
                        Cmd = new SqlCommand("INSERT INTO tbl_BookLoans " +
                                "(BookID, BranchID, CardNo, DateOut, DateDue) " +
                                "VALUES(@BookID, @BranchID, @CardNo, @DateOut, @DateDue)", conn);
                        // create your parameters
                        Cmd.Parameters.Add("@BookID", System.Data.SqlDbType.Int);
                        Cmd.Parameters.Add("@BranchID", System.Data.SqlDbType.Int);
                        Cmd.Parameters.Add("@CardNo", System.Data.SqlDbType.Int);
                        Cmd.Parameters.Add("@DateOut", System.Data.SqlDbType.DateTime);
                        Cmd.Parameters.Add("@DateDue", System.Data.SqlDbType.DateTime);

                        // set values to parameters from textboxes
                        Cmd.Parameters["@BookID"].Value = rnd.Next(1, 126);
                        Cmd.Parameters["@BranchID"].Value =  rnd.Next(1, 126);
                        Cmd.Parameters["@CardNo"].Value = CardNo;

                        dateValue = new DateTime(2018, 12, 18).AddDays(rnd.Next(1,45));
                        Cmd.Parameters["@DateOut"].Value = dateValue;

                        dateValue = dateValue.AddDays(20);
                        Cmd.Parameters["@DateDue"].Value = dateValue;

                        // execute the query and return number of rows affected, should be one
                        int RowsAffected = Cmd.ExecuteNonQuery();
                        totalRows += RowsAffected;
                    }
                }
                Console.WriteLine("tbl_BookLoans - Rows Affected: " + totalRows);
                
                // close connection when done
                conn.Close();
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw(e);
            }
        }
    }
}

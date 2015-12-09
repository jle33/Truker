using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using System.Xml;

namespace cecs521_website
{
    internal class db
    {

        private MySqlConnection connection;
        private string connectioniString = "Database=cecs521_db;Data Source=us-cdbr-azure-west-c.cloudapp.net;User Id=bad3c8f970d412;Password=197cee98";

        public db()
        {
            initialize();
        }

        private void initialize()
        {
            connection = new MySqlConnection(connectioniString);
        }

        //open connection to database
        private bool OpenConnection()
        {
            try
            {
                connection.Open();
                return true;
            }
            catch (MySqlException ex)
            {
                Console.WriteLine(ex);
                return false;
            }
        }

        //Close connection
        private bool CloseConnection()
        {
            try
            {
                connection.Close();
                return true;
            }
            catch (MySqlException ex)
            {
                Console.WriteLine(ex);
                return false;
            }
        }

        //Insert statement
        public void Insert()
        {
            /*
            string query = "INSERT INTO person (firstname, lastname, address, birthday, email) VALUES ('";
            string firstname = "James";
            string lastname = "Le";
            string address = "9526 De Adalena St. Rosemead, CA 91770";
            string birthday = "1991-08-18";
            string email = "dragoons18@gmail.com";
            query = query + firstname + "','" + lastname + "','" + address + "','" + birthday + "','" + email + "');";
            if (OpenConnection() == true)
            {
                MySqlCommand cmd = new MySqlCommand(query, connection);
                cmd.ExecuteNonQuery();
                CloseConnection();
            }*/

        }

        public List<string>[] SelectDriversFromDist(string myquery)
        {
            //Create a list to store the result
            List<string>[] list = new List<string>[5];
            list[0] = new List<string>();
            list[1] = new List<string>();
            list[2] = new List<string>();
            list[3] = new List<string>();
            list[4] = new List<string>();
            
            //Open connection
            if (this.OpenConnection() == true)
            {
                //Create Command
                MySqlCommand cmd = new MySqlCommand(myquery, connection);
                //Create a data reader and Execute the command
                MySqlDataReader dataReader = cmd.ExecuteReader();

                //Read the data and store them in the list
                while (dataReader.Read())
                {
                    list[0].Add(dataReader["firstname"] + "");
                    list[1].Add(dataReader["lastname"] + "");
                    list[2].Add(dataReader["email"] + "");
                    list[3].Add(dataReader["phone"] + "");
                    list[4].Add(dataReader["distance"] + "");
                }

                //close Data Reader
                dataReader.Close();

                //close Connection
                this.CloseConnection();

                //return list to be displayed
                return list;
            }
            else
            {
                return list;
            }

        }

        //XML Parse
        public void xmlWriteTo(List<string>[] list)
        {
            int size = list[0].Count;
            using (XmlWriter writer = XmlWriter.Create("locations.xml"))
            {
                writer.WriteStartDocument();
                writer.WriteStartElement("locations");
                for(int i = 0; i < size; i++)
                {
                    writer.WriteStartElement("location");

                    writer.WriteElementString("name", list[0][i] + " " + list[1][i]);
                    writer.WriteElementString("email", list[2][i]);
                    writer.WriteElementString("phone", list[3][i]);
                    writer.WriteElementString("distance", list[4][i]);

                    writer.WriteEndElement();
                }
                writer.WriteEndElement();
                writer.WriteEndDocument();
            }
        }

        //Update statement
        public void Update()
        {

        }

        //Delete statement
        public void Delete()
        {

        }


    }
}
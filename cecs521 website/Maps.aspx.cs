using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace cecs521_website
{
    public partial class maps : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            //refreshDriver.Attributes.Add("onclick", "return false;");
            if (!IsPostBack)
            {

            }
        }

        private string distanceFrom(double lat, double lng, int miles)
        {
            string query = "SELECT";
            query = query + " driverID, p_id, truck_size, latitude, longitude, (3959 * acos(cos(radians(" + lat + ")) * cos(radians(latitude)) * cos(radians(longitude) - radians(" + lng + ")) + sin(radians(" + lat + ")) * sin(radians(latitude)))) AS distance"
                + " FROM truck_driver HAVING distance < "+ miles;

            string query2 = "SELECT firstname, lastname, email, phone, truck_size, distance, latitude, longitude FROM person INNER JOIN (" + query + ") AS td ON id = td.p_id ORDER BY distance ASC";

            return query2;
        }

        protected void refreshDriver_Click(object sender, EventArgs e)
        {
            int distance = Convert.ToInt32(distanceBox.Text);
            string latitude = lat.Value;
            string longtitude = lon.Value;
            double lati = Convert.ToDouble(latitude);
            double longti = Convert.ToDouble(longtitude);
            // string myfunc = "javascript:codeAddress(" + "9526 De Adalena St." + ");";
            // string hw = "helloworld("+ "40" + ","+ "23"+");";
            // ClientScript.RegisterStartupScript(GetType(), "Javascript", hw, true);
            string query = distanceFrom(lati, longti, distance);
            SqlDataSource1.SelectCommand = query;
            db database = new db();
            List<string>[] list = database.SelectDriversFromDist(query);
            database.xmlWriteTo(list);



        }
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace MUSEWebApp.Controllers
{
    public class UserController : ApiController
    {
        MuseSQLEntities museEntities = null;

        // Registration
        public HttpResponseMessage GetRegistration(string first, string last, string profile, string country, int age, string password, int privacy)
        {
            museEntities = new MuseSQLEntities();

            try
            {
                museEntities.User.Add(new User()
                {
                    First = first,
                    Last = last,
                    Profile = profile,
                    Country = country,
                    Age = age,
                    Password = password,
                    Privacy = privacy,
                });

                museEntities.SaveChanges();

                var response = new HttpResponseMessage(HttpStatusCode.Created)
                {
                    Content = new StringContent("Success")
                };

                return response;
            }
            catch
            {
                var response = new HttpResponseMessage(HttpStatusCode.Created)
                {
                    Content = new StringContent("Failed")
                };

                return response;
            }
        }

        public HttpResponseMessage PostUpdatepicID([FromBody]string picture, int id)
        {
            museEntities = new MuseSQLEntities();

            try
            {
                User u = (from user in museEntities.User
                          where user.UserID == id
                          select user).First();
                u.Picture = picture;

                museEntities.SaveChanges();

                var response = new HttpResponseMessage(HttpStatusCode.Created)
                {
                    Content = new StringContent("Success")
                };
                return response;
            }
            catch
            {
                var response = new HttpResponseMessage(HttpStatusCode.Created)
                {
                    Content = new StringContent("Failed")
                };
                return response;
            }
        }

        public HttpResponseMessage PostUpdatepicPP([FromBody]string picture, [FromBody]string profile, [FromBody]string password)
        {
            museEntities = new MuseSQLEntities();
            
            try {
                User u = (from user in museEntities.User
                            where user.Profile.Equals(profile) && user.Password.Equals(password)
                            select user).First();
                u.Picture = picture;

                museEntities.SaveChanges();

                var response = new HttpResponseMessage(HttpStatusCode.Created) {
                    Content = new StringContent("Success")
                };
                return response;
            } catch {
                var response = new HttpResponseMessage(HttpStatusCode.Created)
                {
                    Content = new StringContent("Failed")
                };
                return response;
            }

        }

        // Login
        public List<UserInfo> GetLogin(string profile, string password)
        {
            museEntities = new MuseSQLEntities();

            var query = from user in museEntities.User
                        where user.Profile.Equals(profile) && user.Password.Equals(password) 
                        select new UserInfo()
                        {
                            UserId = user.UserID,
                            First = user.First,
                            Last = user.Last,
                            Profile = user.Profile,
                            Country = user.Country,
                            Age = (int)user.Age,
                            Picture = user.Picture,
                            Password = user.Password,
                            Privacy = (int)user.Privacy
                        };

            return query.ToList();
        }

        public class UserInfo {
            public int UserId { get; set; }
            public string First { get; set; }
            public string Last { get; set; }
            public string Profile { get; set; }
            public string Country { get; set; }
            public int Age { get; set; }
            public string Picture { get; set; }
            public string Password { get; set; }
            public int Privacy { get; set; }
        }
    }
}
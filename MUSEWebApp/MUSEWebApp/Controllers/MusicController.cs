using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace MUSEWebApp.Controllers
{
    public class MusicController : ApiController
    {
        MuseSQLEntities museEntities = null;

        public HttpResponseMessage PostUpload ([FromBody] string data, int userID, int count, string artist, string album, string name, string genre)
        {
            museEntities = new MuseSQLEntities();

            try
            {
                museEntities.Music.Add(new Music()
                {
                    UserID = userID,
                    Count = count,
                    Data = data,
                    Artist = artist,
                    Album = album,
                    Name = name,
                    Genre = genre,
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

        public string GetDownload(int userID, int musicID)
        {
            museEntities = new MuseSQLEntities();

            Music mus = (from music in museEntities.Music
                        where music.UserID == userID && music.MusicID == musicID
                        select music).First();

            return mus.Data;
        }

        public HttpResponseMessage GetUpdateRating (int musicID, int rating)
        {
            museEntities = new MuseSQLEntities();

            try {
                Music mus = (from music in museEntities.Music
                             where music.MusicID == musicID
                             select music).First();
                mus.Ratings = rating;
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

        public HttpResponseMessage GetUpdateLP (int musicID, string last_played)
        {
            museEntities = new MuseSQLEntities();

            try
            {
                Music mus = (from music in museEntities.Music
                             where music.MusicID == musicID
                             select music).First();
                mus.Last_Played = last_played;
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

        public HttpResponseMessage GetUpdateCount (int musicID, int addCount)
        {
            museEntities = new MuseSQLEntities();

            try
            {
                Music mus = (from music in museEntities.Music
                             where music.MusicID == musicID
                             select music).First();
                mus.Count += addCount;
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
    }
}

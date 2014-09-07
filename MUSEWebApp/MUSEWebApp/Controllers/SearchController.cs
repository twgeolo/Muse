using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace MUSEWebApp.Controllers
{
    public class SearchController : ApiController
    {
        MuseSQLEntities museEntities = null;

        public List<Music> GetSearchArtist(string artist)
        {
            museEntities = new MuseSQLEntities();

            var query = from music in museEntities.Music
                        where music.Artist.Contains(artist)
                        select music;

            return query.ToList();
        }

        public List<Music> GetSearchSong(string song)
        {
            museEntities = new MuseSQLEntities();

            var query = from music in museEntities.Music
                        where music.Name.Contains(song)
                        select music;

            return query.ToList();
        }

        public List<Music> GetSearchAlbum(string album)
        {
            museEntities = new MuseSQLEntities();

            var query = from music in museEntities.Music
                        where music.Album.Contains(album)
                        select music;

            return query.ToList();
        }

        public List<User> GetSearchUser(string userName)
        {
            museEntities = new MuseSQLEntities();

            var query = from user in museEntities.User
                        where user.Profile.Contains(userName) || user.First.Contains(userName) || user.Last.Contains(userName)
                        select user;

            return query.ToList();
        }

        public List<Music> GetSearchGenre(string genre)
        {
            museEntities = new MuseSQLEntities();

            var query = from music in museEntities.Music
                        where music.Genre.Contains(genre)
                        select music;

            return query.ToList();
        }
    }

}

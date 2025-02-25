extends GeneralItem
class_name MovieItem

const POSSIBLE_STATUS: Array[String] = ["completed", "watching", "on hold", "dropped"]
const POSSIBLE_GENRES = ["Shonen", "Shojo", "Seinen", "Josei", "Action", "Adventure", "Comedy", "Cyberpunk", "Drama", "Fantasy", "Horror", "Isekai", "Magic", "Mecha", "Military", "Mystery", "Psychological", "Romance", "Sci-Fi", "Slice of Life", "Sports", "Superhero", "Supernatural", "Thriller"]
var length: int  # Length of the movie in minutes
var status: String = POSSIBLE_STATUS[0]  # Default to completed

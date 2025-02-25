extends GeneralItem
class_name SeasonItem

const POSSIBLE_STATUS = ["completed", "watching", "on hold", "ongoing", "dropped"]
const POSSIBLE_GENRES = ["Shonen", "Shojo", "Seinen", "Josei", "Action", "Adventure", "Comedy", "Cyberpunk", "Drama", "Fantasy", "Horror", "Isekai", "Magic", "Mecha", "Military", "Mystery", "Psychological", "Romance", "Sci-Fi", "Slice of Life", "Sports", "Superhero", "Supernatural", "Thriller"]

var episodes: String  # E.g. "10/12"
var status: String = POSSIBLE_STATUS[0]  # Default to completed
var children: Array[GeneralItem]

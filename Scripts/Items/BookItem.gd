extends GeneralItem
class_name BookItem

const POSSIBLE_STATUS = ["completed", "reading", "on hold", "dropped"]
const POSSIBLE_GENRES = ["Classic", "Contemporary", "Crime", "Dystopian", "Fantasy", "Historical Fiction", "Horror", "Literary Fiction", "Mystery/Detective", "Non-Fiction", "Philosophical", "Poetry", "Political", "Romance", "Science Fiction", "Self-Help", "Suspense", "Thriller", "Young Adult"]

var pages: String  # E.g. "10/12"
var chapters: String  # E.g. "10/12"
var status: String = POSSIBLE_STATUS[0]  # Default to completed
var children: Array[GeneralItem]

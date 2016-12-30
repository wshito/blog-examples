library(XML)

inTracks <- FALSE
inEachTrack <- FALSE
inPlaylists <- FALSE
dictNum <- 0
inKey <- 1
inValue <- 2
out <- 0
state <- out

startElementHandler <- function (name, attr) {
    if (inTracks) {
        if (inEachTrack) {
            if (name == "key")
                state <<- inKey
        } else if (name == "dict") {
            dictNum <<- dictNum + 1
            if (dictNum == 2) {
                inEachTrack <<- TRUE
                cat("\n")
            }
        }
    }
}

endElementHandler <- function (name, attr) {
    if (state == inKey) {
        state <<- inValue
    } else if (state == inValue) {
        state <<- out
    } else if (inTracks && name == "dict") {
        dictNum <<- dictNum - 1
        if (dictNum == 1)
            inEachTrack <<- FALSE
    }
}

textHandler <- function (data) {
    if (!inTracks && data == "Tracks") {
        inTracks <<- TRUE
        return
    }
    if (state == inKey) {
        cat ("[", data, "], ", sep="")
    } else if (state == inValue) {
        cat (data, ", ", sep="")
    } else if (inTracks && data == "Playlists") {
        inTracks <<- FALSE
        inPlaylists <<- TRUE
    }
}

xmlEventParse ("~/Music/iTunes/iTunes Music Library.xml",
               list (startElement = startElementHandler,
                     endElement = endElementHandler,
                     text = textHandler))

# "~/Music/iTunes/iTunes Music Library.xml"

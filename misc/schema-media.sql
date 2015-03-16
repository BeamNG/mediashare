/* sqlite mode settings, WAL mode is important, otherwise the readers will lock each other */
pragma page_size=4096;
pragma default_cache_size=4000;
pragma journal_mode=WAL;
pragma synchronous=2;

create table files (
    id INTEGER PRIMARY KEY AUTOINCREMENT,

    /* the string that is used to access this entry */
    tag TEXT DEFAULT NULL,
    /* the string that is used to group entries */
    batchtag TEXT DEFAULT NULL,
    /* the string that is used to edit this entry */
    changetag TEXT DEFAULT NULL,

    /* the filename of the uploaded file */
    filename TEXT DEFAULT "",

    /* the size on disc */
    filesize INTEGER DEFAULT 0,

    /* when this database entry was created */
    date_created DATETIME DEFAULT CURRENT_TIMESTAMP,

    /* image information */
    imagewidth INTEGER DEFAULT 0,
    imageheight INTEGER DEFAULT 0,

    /* video information */
    videoinfo TEXT DEFAULT "",
    videosnapshottime INTEGER DEFAULT 10
);

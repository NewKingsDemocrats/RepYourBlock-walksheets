# Brooklyn Walksheets 2020
# Purpose: Process voter file to produce walksheets and maps for each ED within each AD
# in Brooklyn.
# Authors: Sara Hodges & Jonna Heldrich

# Files needed to run the script (in working directory)
## BOE voter file (Kings_20200127.txt)
## Headers file (vf headers.xlsx)
## Cleaned street names (corrected_streets_20200124.csv)

# Load packages needed to run the script
require(dplyr)
require(openxlsx)
library(stringr)
require(readr)

# Open the voter file and add headers
nyvoter <- read.table('Kings_20200127.txt',
                     sep=",",
                     fill=TRUE,
                     row.names = NULL)

voterheader <- c('lastname', 'firstname', 'middlename', 'namesuffix', 'addnumber', 'addfract', 'addapt', 'addpredirect', 'addstreet',
                 'addpostdirect', 'addcity', 'addzip5', 'addzip4', 'mailadd1', 'mailadd2', 'mailadd3', 'mailadd4', 'DOB',          
                 'gender', 'party', 'otherparty', 'county', 'ED', 'LegDist', 'towncity', 'ward', 'CD',
                 'SD', 'AD', 'lastvote', 'prevvote', 'prevcounty', 'prevaddr', 'prevname', 'countynum', 'regdate',      
                 'regsource', 'idreq', 'idmet', 'status', 'statusreason', 'inactdate', 'purgedate', 'ID', 'votehistory')

nyvoter2 <- nyvoter
names(nyvoter2) = voterheader

# Subset data for county of interest
# There are likely a variety of spellings used for each county, which need to be determined
nyvoter2 <- nyvoter2[grep("klyn|kltyn|kkyn|klym|olyn|kyln|kllyn|kl;yn|kln|kly|klyb|okyn|klybn|klyln|112",
                          nyvoter2$addcity,ignore.case=TRUE),]

# Subset voters who are Democrats
dems <- nyvoter2 %>%
  select(ID, lastname, firstname, addnumber, addfract, addpredirect, addstreet,
         addpostdirect, addapt, addcity, DOB, gender, party,
         ED, AD, LegDist, ward, CD, SD, status,
         votehistory,regdate) %>%
  filter(status=="ACTIVE") %>%
  filter(party=="DEM")

###########################################################
############ Start to clean street names ##################
###########################################################

cleaned_dems <- dems %>%
  mutate(clean_addstreet = trimws(gsub("\\s+", " ", addstreet)),
         clean_addstreet = gsub("`", "", clean_addstreet),
         clean_addstreet = gsub("HIMROAD", "HIMROD", clean_addstreet),
         clean_addstreet = gsub("HIMROS", "HIMROD", clean_addstreet),
         clean_addstreet = gsub("104 STREET", "EAST 104 STREET", clean_addstreet),
         clean_addstreet = gsub("STREEET", "STREET", clean_addstreet),
         clean_addstreet = gsub("SREET", "STREET", clean_addstreet),
         clean_addstreet = gsub("STRET", "STREET", clean_addstreet),
         clean_addstreet = gsub("STEEGT", "STREET", clean_addstreet),
         clean_addstreet = gsub("STREETE", "STREET", clean_addstreet),
         clean_addstreet = gsub("STREET1", "STREET", clean_addstreet),
         clean_addstreet = gsub("STREER", "STREET", clean_addstreet),
         clean_addstreet = gsub("STREETT", "STREET", clean_addstreet),
         clean_addstreet = gsub("STRETT", "STREET", clean_addstreet),
         clean_addstreet = gsub("SRETT", "STREET", clean_addstreet),
         clean_addstreet = gsub("SSTRETT", "STREET", clean_addstreet),
         clean_addstreet = gsub("STET", "STREET", clean_addstreet),
         clean_addstreet = gsub("STERET", "STREET", clean_addstreet),
         clean_addstreet = gsub("STRRETT", "STREET", clean_addstreet),
         clean_addstreet = gsub("STRREETT", "STREET", clean_addstreet),
         clean_addstreet = gsub("STTEET", "STREET", clean_addstreet),
         clean_addstreet = gsub("STERT", "STREET", clean_addstreet),
         clean_addstreet = gsub("STEE", "STREET", clean_addstreet),
         clean_addstreet = gsub("STERET", "STREET", clean_addstreet),
         clean_addstreet = gsub("ATREET", "STREET", clean_addstreet),
         clean_addstreet = gsub("DTREET", "STREET", clean_addstreet),
         clean_addstreet = gsub(" TREET", " STREET", clean_addstreet),
         clean_addstreet = gsub("ST3EET", "STREET", clean_addstreet),
         clean_addstreet = gsub("SEREET", "STREET", clean_addstreet),
         clean_addstreet = gsub("SST", "ST", clean_addstreet),
         clean_addstreet = gsub("STREET", "ST", clean_addstreet),
         clean_addstreet = gsub("FIRST", "1", clean_addstreet),
         clean_addstreet = gsub("SECOND", "2", clean_addstreet),
         clean_addstreet = gsub("THIRD", "3", clean_addstreet),
         clean_addstreet = gsub("FOURTH", "4", clean_addstreet),
         clean_addstreet = gsub("FIFTH", "5", clean_addstreet),
         clean_addstreet = gsub("SIXTH", "6", clean_addstreet),
         clean_addstreet = gsub("SEVENTH", "7", clean_addstreet),
         clean_addstreet = gsub("EIGHTH", "8", clean_addstreet),
         clean_addstreet = gsub("NINTH", "9", clean_addstreet),
         clean_addstreet = gsub("TENTH", "10", clean_addstreet),
         clean_addstreet = gsub("0TH", "0", clean_addstreet),
         clean_addstreet = gsub("1ST", "1", clean_addstreet),
         clean_addstreet = gsub("1STST", "1 ST", clean_addstreet),
         clean_addstreet = gsub("1TH", "1", clean_addstreet),
         clean_addstreet = gsub("2TH", "2", clean_addstreet),
         clean_addstreet = gsub("2ND", "2", clean_addstreet),
         clean_addstreet = gsub("3RD", "3", clean_addstreet),
         clean_addstreet = gsub("3TH", "3", clean_addstreet),
         clean_addstreet = gsub("4TH", "4", clean_addstreet),
         clean_addstreet = gsub("5TH", "5", clean_addstreet),
         clean_addstreet = gsub("6TH", "6", clean_addstreet),
         clean_addstreet = gsub("7TH", "7", clean_addstreet),
         clean_addstreet = gsub("8TH", "8", clean_addstreet),
         clean_addstreet = gsub("9TH", "9", clean_addstreet),
         clean_addstreet = gsub(" TH ", " ", clean_addstreet),
         clean_addstreet = gsub("STST", "ST ST", clean_addstreet),
         clean_addstreet = gsub("46TH ST6TH AVENUE", "46TH STREET", clean_addstreet),
         clean_addstreet = gsub("ST.", "ST", clean_addstreet),
         clean_addstreet = gsub("STST", "ST", clean_addstreet),
         clean_addstreet = gsub("STTEET", "ST", clean_addstreet),
         clean_addstreet = gsub("STEEGT", "ST", clean_addstreet),
         clean_addstreet = gsub("STRET", "ST", clean_addstreet),
         clean_addstreet = gsub("PLACE", "PL", clean_addstreet),
         clean_addstreet = gsub("PLACT", "PL", clean_addstreet),
         clean_addstreet = gsub("PLACR", "PL", clean_addstreet),
         clean_addstreet = gsub("PLAACE", "PL", clean_addstreet),
         clean_addstreet = gsub(" RD", " ROAD", clean_addstreet),
         clean_addstreet = gsub("BOULEVARD", "BLVD", clean_addstreet),
         clean_addstreet = gsub("WYKOFF", "WYCKOFF", clean_addstreet),
         clean_addstreet = gsub("WYKCOFF", "WYCKOFF", clean_addstreet),
         clean_addstreet = gsub("WHYTHE", "WYTHE", clean_addstreet),
         clean_addstreet = gsub("ADELHI", "ADELPHI", clean_addstreet),
         clean_addstreet = gsub("ADELPHIA", "ADELPHI", clean_addstreet),
         clean_addstreet = gsub("ADELPKI", "ADELPHI", clean_addstreet),
         clean_addstreet = gsub("WHYTHE", "ADELPHI", clean_addstreet),
         clean_addstreet = gsub("WEST", "WEST ", clean_addstreet),
         clean_addstreet = gsub("EAST", "EAST ", clean_addstreet),
         clean_addstreet = gsub("WEST ERN", "WESTERN", clean_addstreet),
         clean_addstreet = gsub("EAST ERN", "EASTERN", clean_addstreet),
         clean_addstreet = gsub("STWEST", "WEST", clean_addstreet),
         clean_addstreet = gsub("AVENUEE", "AVENUE", clean_addstreet),
         clean_addstreet = gsub("AVNUE", "AVENUE", clean_addstreet),
         clean_addstreet = gsub("BOKAE", "BOKEE", clean_addstreet),
         clean_addstreet = gsub("FLATBUSH AVE", "FLATBUSH AVENUE", clean_addstreet),
         clean_addstreet = gsub("MARTIN L K", "MARTIN LUTHER K", clean_addstreet),
         clean_addstreet = gsub("OCEAN AVE", "OCEAN AVENUE", clean_addstreet),
         clean_addstreet = gsub("MC DONALD", "MCDONALD", clean_addstreet),
         clean_addstreet = gsub("DE KALB", "DEKALB", clean_addstreet),
         clean_addstreet = gsub("DE GRAW", "DEGRAW", clean_addstreet),
         clean_addstreet = gsub("DESALES", "DE SALES", clean_addstreet),
         clean_addstreet = gsub("MC CLANCY", "MCCLANCY", clean_addstreet),  
         clean_addstreet = gsub("MC GUINESS", "MCGUINESS", clean_addstreet),
         clean_addstreet = gsub("MC KEEVER", "MCKEEVER", clean_addstreet),
         clean_addstreet = gsub("MC KIBBEN", "MCKIBBEN", clean_addstreet),
         clean_addstreet = gsub("MC KINLEY", "MCKINLEY", clean_addstreet),
         clean_addstreet = gsub("NOSTAND", "NOSTRAND", clean_addstreet),
         clean_addstreet = trimws(clean_addstreet))

#####################################
### explore the street name data ###
#####################################
streets <- cleaned_dems %>%
  group_by(clean_addstreet) %>%
  summarise(count = n(),
            ad_ed_list = first(AD))

bad_streets <- streets %>%
  filter(count < 10)

write.csv(bad_streets, "streets_to_correct.csv")

#### import corrected bad streets and add to cleaned dems

corrected_df <- read_csv("corrected_streets_20200210.csv") %>%
  select(og_name, corrected) %>%
  rename(clean_addstreet = og_name)

cleaned_dems <- cleaned_dems %>%
  left_join(corrected_df, by = "clean_addstreet") %>%
  mutate(clean_addstreet = case_when(is.na(corrected) ~ clean_addstreet,
                                     !is.na(corrected) ~ corrected)) %>%
  select(-corrected)

### check new list
streets <- cleaned_dems %>%
  group_by(clean_addstreet) %>%
  summarise(count = n(),
            ad_ed_list = first(AD))

bad_streets <- streets %>%
  filter(count < 10)  ### this is now 165 streets, all of which appear to be good streets with fewer than 10  registered dems

# write.csv(bad_streets, "streets_to_correct_2020.csv")

########################################
### END fixing the street name data ###
########################################

#### create ad_ed list from final addresses to match with the election district in the
#### election district shapefile
ad_ed_list <- cleaned_dems %>%
  mutate(ED = str_pad(ED, width = 3, pad = "0"),
         ad_ed = paste0(AD, ED)) %>%
  select(ad_ed) %>%
  distinct() %>%
  mutate(ad_ed = as.numeric(ad_ed))

write_csv(ad_ed_list, "ad_ed_list.csv")

# Organize the data into columns needed for sorting and 
# add categories needed for final spreatsheets
cleaned_dems_ <- cleaned_dems %>%
  mutate(name = str_to_title(as.character(paste(firstname, lastname))),
         address = str_to_title(as.character(paste(addnumber, addpredirect, clean_addstreet))),
         addnumber2 = gsub('\\b 1/2','',addnumber),
         buildingnum = as.numeric(gsub("[^0-9]", "", addnumber2)),
         aptnum = as.numeric(gsub("[^0-9]", "", addapt)),
         apt = gsub(" ","",addapt),
         last_voted = substr(votehistory, 0, 11),
         status = "",
         not_home = "",
         moved = "",
         inaccessible = "",
         refused = "",
         signed = "",
         email = "",
         notes = "",
         age = paste(2019 - as.numeric(substr(DOB, 0, 4))),
         streetside = if_else((as.numeric(as.character(buildingnum)) %% 2 == 0),'even','odd')
  ) %>%
  select(ID, name, address, apt, age, gender,
         ED, AD, last_voted, status, streetside,
         clean_addstreet, addnumber, buildingnum, aptnum, votehistory, regdate,
         not_home, signed, moved, inaccessible, refused, email, notes)  %>%
  rename(`M/F` = gender)

# Create a vector including all elections needed for categorizing voters
primaries=c("20180424 SP",
            "4-24-2018 Special Election",
            "SP 20180424",
            "SPECIAL ELECTION 2018",
            "Special Election, 2018",
            "2018 FEDERAL PRIMARY",
            "2018 Federal Primary Election",
            "20180626 PR",
            "2018CONGRESSIONAL PRIMARY",
            "FEDERAL OFFICES PRIMARY 2018",
            "FEDERAL PRIMARY 2018",
            "FEDERAL PRIMARY ELECTION 2018",
            "Federal Primary Election-Republican",
            "Federal Primary, 2018",
            "PR 20180626",
            "PRIMARY FEDERAL ELECTION 2018",
            "2018 AD 17 SPECIAL",
            "18 PRIMARY ELECTION",
            "2018 PRIMARY ELECTION",
            "2018 State & Local Primary Election",
            "2018 STATE PRIMARY ELECTION)",
            "20180913 PR",
            "PR 20180913",
            "PRIMARY 2018",
            "PRIMARY ELECTION 2018",
            "Primary Election, 2018",
            "20190226 SP",
            "SP 20190226",
            "20190514 SP",
            "SP 2019-05-",
              "SP 20190514",
            "20190625 PR",
            "PR 20190625")

### Voter status categories: 
###    NewReg="registered after Nov 2018", 
###    inactive='not voted since 2016',
###    active='voted since 2016'
###    primary='voted in primary since 2017'

# Use the "elections" vector to categorize voters
cleaned_dems2 <- cleaned_dems_ %>%
  mutate(status = ifelse(grepl(paste(primaries,collapse = "|"),votehistory)==TRUE,"primary",
                  ifelse(grepl('2017|2018|2019',votehistory)==TRUE,'active',
                  ifelse(regdate>20181100,'NewReg','inactive'))))

# Sort voters in a logical order for doorknocking
# We sort by: street_name, streetside (odd or even), house_num, aptnum, apt
ads = as.list(unique(cleaned_dems2$AD))
# ads = as.list(c(58, 50, 57, 54, 47, 45, 43, 42)) 
# ads = as.list(55) 
### second section to run after temp file error
edadlist = list()
for (i in ads) {
  ad_table <- cleaned_dems2 %>%
    filter(AD==i)
  eds = as.list(unique(ad_table$ED))
  print(i)
  edlist = list()
  for (j in eds) {
    ed_table <- ad_table %>%
      filter(ED==j)
    edlistj = ed_table[order(ed_table$clean_addstreet, ed_table$streetside,
                             ed_table$buildingnum,ed_table$addnumber,
                            ed_table$aptnum, ed_table$apt, decreasing = F),]
    edlist[[j]] = edlistj
  }
  edadlist[[i]] <- do.call(dplyr::bind_rows, edlist)
}

# Create workbooks to write walksheet data to
# One workbook for online version of walksheets and one for printed version
walklist <- createWorkbook()
addWorksheet(walklist, "Sheet 1")
walklistprint <- createWorkbook()
addWorksheet(walklistprint, "Sheet 1")

# Make folders and walksheet files for each AD/ED
dir.create("walksheets/")
for (i in ads) {
  edad_table <- edadlist[[i]]
  eds = as.list(unique(edad_table$ED))
  dir.create(paste0("walksheets/AD_",i))
  for (j in eds) {
    print(j)
    ed_table <- edad_table %>%
      filter(ED==j)
    adedname = paste0("ad_", i, "_ed_", j)
    dir.create(paste0("walksheets/AD_",i,"/",adedname))
    if (is.na(getTables(walklist, sheet = 1)[1]) == F) {
      removeTable(walklist, sheet = 1, table = getTables(walklist, sheet = 1)[1])
    }
    deleteData(walklist, sheet = 1, cols = 1:15, rows = 1:3000, gridExpand = TRUE)
    writeDataTable(walklist, sheet = 1, 
                   x = ed_table[,c("name","address","apt","age",
                                   "M/F","status","not_home","signed","moved", 
                                   "inaccessible", "refused","email","notes","ID")],
                   rowNames = T)
    setColWidths(walklist, sheet = 1, cols = 1, widths = 4)
    setColWidths(walklist, sheet = 1, cols = 2, widths = 30)
    setColWidths(walklist, sheet = 1, cols = 3, widths = 30)
    setColWidths(walklist, sheet = 1, cols = 4, widths = 7)
    setColWidths(walklist, sheet = 1, cols = 5, widths = 5)
    setColWidths(walklist, sheet = 1, cols = 6, widths = 5)
    setColWidths(walklist, sheet = 1, cols = 7, widths = 7)
    setColWidths(walklist, sheet = 1, cols = 8, widths = 9)
    setColWidths(walklist, sheet = 1, cols = 9:10, widths = 8)
    setColWidths(walklist, sheet = 1, cols = 11, widths = 12)
    setColWidths(walklist, sheet = 1, cols = 12, widths = 8)
    setColWidths(walklist, sheet = 1, cols = 13, widths = 12)
    setColWidths(walklist, sheet = 1, cols = 14, widths = 30)
    setColWidths(walklist, sheet = 1, cols = 15, widths = 10, hidden = rep(TRUE, length(cols)))
    freezePane(walklist, sheet = 1,firstRow = TRUE)
    saveWorkbook(walklist, paste0("walksheets/AD_",i,"/",adedname,"/",adedname,"_sheets.xlsx"),
                 overwrite = TRUE)
    if (is.na(getTables(walklistprint, sheet = 1)[1]) == F) {
      removeTable(walklistprint, sheet = 1, table = getTables(walklistprint, sheet = 1)[1])
    }
    deleteData(walklistprint, sheet = 1, cols = 1:8, rows = 1:3000, gridExpand = TRUE)
    writeDataTable(walklistprint, sheet = 1, tableStyle = "none",
                   x = ed_table[,c("name","address","apt","age",
                                   "M/F","status","notes","ID")],
                   rowNames = F)
    setColWidths(walklistprint, sheet = 1, cols = 1, widths = 25)
    setColWidths(walklistprint, sheet = 1, cols = 2, widths = 30)
    setColWidths(walklistprint, sheet = 1, cols = 3, widths = 7)
    setColWidths(walklistprint, sheet = 1, cols = 4, widths = 4)
    setColWidths(walklistprint, sheet = 1, cols = 5, widths = 4)
    setColWidths(walklistprint, sheet = 1, cols = 6, widths = 5)
    setColWidths(walklistprint, sheet = 1, cols = 7, widths = 10)
    setColWidths(walklistprint, sheet = 1, cols = 8, widths = 10, hidden = rep(TRUE, length(cols)))
    saveWorkbook(walklistprint, paste0("walksheets/AD_",i,"/",adedname,"/",adedname,"_printout.xlsx"),
                 overwrite = TRUE)
    
    
  }
}


library("dplyr")
library("data.table")
library("stringr")
library("muStat")

colsToKeep <- c("Health Service Area", "Facility Name", "Length of Stay",
                "APR MDC Description", "Emergency Department Indicator",
                "Total Charges")
colsToKeep2 <- c("Facility Name", "Waiting Time", "Recommend Hospital")
hosp <- fread("Hospital_2013.csv", select = colsToKeep)
hosp2 <- fread("hospital_name.csv", select = colsToKeep2)
mean_time <- mean(hosp2$`Waiting Time`[-(which.na(hosp2$`Waiting Time`))])
hosp2$`Waiting Time`[which.na(hosp2$`Waiting Time`)] <- as.integer(mean_time)
mean_recom <- mean(hosp2$`Recommend Hospital`[-(which.na(hosp2$`Recommend Hospital`))])
hosp2$`Recommend Hospital`[which.na(hosp2$`Recommend Hospital`)] <- as.integer(mean_recom)

hosp <- tbl_df(hosp) %>%
            na.omit() %>%
            filter(`Health Service Area` == "New York City")
hosp$`Total Charges` <- str_replace_all(hosp$`Total Charges`, "[^[:alnum:]]", "")
hosp$`Total Charges` <- as.numeric(hosp$`Total Charges`) / 100

save(hosp, file = "hosp.RData")
save(hosp, file = "hosp2.RData")

load("hosp.RData")
load("hosp2.RData")

#information of patient
patient <- data.frame(illness = "Mental Diseases and Disorders", Emergency = "Y",
             insurance = "N")

#names of hospital
if (patient$insurance == "N")
  hospital.list = hospital$`Facility Name`

#ranking list of cases
Data <- hosp %>%
        filter(`APR MDC Description` == patient$illness) %>%
        group_by(`Facility Name`) 
Data.ill <- Data %>%
            summarise(freq = n())
case <- data.frame(name = Data.ill$`Facility Name`, cases = Data.ill$freq, 
                  case_rank = sort(Data.ill$freq, index.return = T)$ix)

#ranking list of charges

Data.charge <- Data %>%
               summarise(charge = mean(`Total Charges`), freq = n())
charge <- data.frame(name = Data.charge$`Facility Name`, charge = Data.charge$charge,
                   charge_rank = sort(Data.charge$charge, index.return = T)$ix)

#ranking list of distance


#ranking list of recommendation
recom <- data.frame(name = hosp2$`Facility Name`, recom = hosp2$`Recommend Hospital`,
                    recom_rank = sort(hosp2$`Recommend Hospital`, index.return = T)$ix)

#ranking list of waiting time
wait <- data.frame(name = hosp2$`Facility Name`, wait = hosp2$`Waiting Time`,
                   wait_rank = sort(hosp2$`Waiting Time`, index.return = T)$ix)

#merge ranking list
rank <- merge(case, charge, all = TRUE, by = intersect(names(case), names(charge)))
rank <- merge(rank, recom, all = TRUE, by = intersect(names(rank), names(recom)))
rank <- merge(rank, wait, all = TRUE, by = intersect(names(rank), names(wait)))
rank <- na.omit(rank)



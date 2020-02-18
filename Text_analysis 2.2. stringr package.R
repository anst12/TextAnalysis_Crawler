#####
# 2강 stringr 패키지
# 2020. 2. 18.
# 안성태
#####

# 텍스트 데이터를 처리하는데 유용한 stringr package
# 장점: 1) base함수에 비해 직관적인 결과물을 얻을 수 있음 
#       2) 파이프(%>%) 사용 가능
# install.packages('stringr')
library('stringr')

# 1. str_extract(), str_extract_all(): 지정한 문자열 패턴 추출

# base 함수의 regmatches()와 유사함
# 함수명에 _all 이 붙지 않으면 지정한 패턴이 처음 등장한 값만 찾아내고,
# _all 이 붙어있으면 지정한 패턴이 등장한 모든 값을 찾아낸다.

R_Programming <- "R is a programming language and free software environment for statistical computing and graphics supported by the R Foundation for Statistical Computing. The R language is widely used among statisticians and data miners for developing statistical software and data analysis. Polls, data mining surveys, and studies of scholarly literature databases show substantial increases in popularity; as of January 2020, R ranks 18th in the TIOBE index, a measure of popularity of programming languages.
A GNU package, source code for the R software environment is written primarily in C, Fortran, and R itself and is freely available under the GNU General Public License. Pre-compiled binary versions are provided for various operating systems. Although R has a command line interface, there are several graphical user interfaces, such as RStudio, an integrated development environment."

# software environment 라는 표현을 추출
str_extract(R_Programming, "software environment")
# software environment 라는 표현을 모두 추출
str_extract_all(R_Programming, "software environment")  # 결과가 리스트로 반환된다.
str_extract_all(R_Programming, "software environment", simplify = TRUE)

# regex와 str_extract의 활용
# e.g 1) 첫 문자가 대문자로 시작하는 단어 찾기
# 어떤 조건을 갖춰야 할까?













capital <- str_extract_all(R_Programming, "[[:upper:]]{1}[[:alpha:]]*")
# 다음 패턴도 같은 결과를 낸다: "[[:upper:]]{1}[[:alpha]]{0, }"
capital

# 간단한 기술통계
table(capital)


# 2. str_locate(), str_locate_all() : 지정한 패턴이 시작하는 위치와 끝나는 위치
str_locate(R_Programming, "software environment")
str_locate_all(R_Programming, "software environment")

# 대문자로 시작하는 단어가 시작하는 위치와 끝나는 위치
upper_loc <- str_locate_all(R_Programming, "[[:upper:]]{1}[[:alpha:]]{0,}")
upper_loc
dim(upper_loc)  # 리스트 형태이므로 dimension을 알고자 하는 리스트를 인덱싱해야함.
dim(upper_loc[[1]])  # 대문자로 시작하는 단어 25개

# 지정한 패턴, 위치를 데이터프레임으로 구조화하기
upper_df <- data.frame(upper_loc[[1]])
upper_word <- str_extract_all(R_Programming, "[[:upper:]]{1}[[:alpha:]]*")[[1]]  # 리스트 형태로 반환되므로 인덱싱
upper_df$word <- upper_word
upper_df$length <- upper_df$end - upper_df$start + 1  # 단어의 길이
upper_df

# 파이프(%>%)를 사용한다면?
# install.packages("dplyr")
library(dplyr)
upper_df2 <- R_Programming %>% 
  str_locate_all("[[:upper:]]{1}[[:alpha:]]{0,}") %>%
  data.frame() %>%
  mutate(length = end - start + 1)
upper_df2$word <- upper_word
upper_df2


# 3. str_replace(), str_replace_all() : 지정한 패턴을 다른 패턴으로 교체
# base 함수의 sub(), gsub()과 유사함.
trump <- "President Trump knows how to play trump. President Trump visited casino Trump to play trump. The winner of the trump game was President Trump. President Trump built Daewoo Trump World at Yongsan"
trump
str_replace(trump, "President Trump", "President_Trump")
str_replace_all(trump, "President Trump", "President_Trump")

# 트럼프가 포함된 단어들을 정리하는 빈도표
table(str_extract_all(trump, "President_Trump|President|Trump|trump"))
trump_replace <- str_replace_all(trump, "President Trump", "President_Trump")
table(str_extract_all(trump_replace, "President_Trump|President|Trump|trump"))

# 단어에 의미를 부여하고 싶을 때
R_Programming
# R, C, Fortran 은 컴퓨터 프로그래밍 언어이므로
# R, C, Fortran 뒤에 부연설명을 위한 (computer.lang) 을 추가한다.
computer_lang <- R_Programming %>%
  str_replace_all("R\\b", "R(computer.lang)") %>%
  str_replace_all("C\\b", "C(computer.lang)") %>%
  str_replace_all("Fortran", "Fortran(computer.lang)")
computer_lang

# Quiz. (computer.lang)이 붙은 단어들의 빈도표
table(str_extract_all(computer_lang, ""))


# 4. str_split(), str_split_fixed() : 지정한 패턴으로 텍스트 자료를 나누기
# 1) str_split()은 기본함수의 strsplit() 과 유사하다.
# str_split()을 이용한 문단 구분
r_para <- str_split(R_Programming, "\n")
r_para

# str_split()을 이용한 문장 구분
r_sent <- str_split(r_para[[1]], "\\.\\s")
r_sent

# 2) str_split_fixed()
sent_5_6 <- unlist(r_sent)[c(5, 6)]
sent5_word <- length(unlist(str_split(sent_5_6[1], " ")))
sent6_word <- length(unlist(str_split(sent_5_6[2], " ")))
sent5_word; sent6_word

# 5번째 문장은 9단어, 6번째 문장은 20단어
sent_split_1 <- str_split_fixed(sent_5_6, " ", 9)
sent_split_1
sent_split_2 <- str_split_fixed(sent_5_6, " ", 20)
sent_split_2

# 문장X단어 matrix 구축: 가로줄(문장), 세로줄(단어)
# 먼저 각 문장의 길이(단어 수)를 구한다.
sent_length <- rep(NA, length(unlist(r_sent)))
sent_length
for(i in 1:length(sent_length)) {
  sent_length[i] <- length(unlist(str_split(unlist(r_sent)[i], " ")))
}
sent_length
sent_word_mat <- str_split_fixed(unlist(r_sent), " ", max(sent_length))
sent_word_df <- data.frame(sent_word_mat)
rownames(sent_word_df) <- paste('sent', 1:length(unlist(r_sent)), sep = '_')
colnames(sent_word_df) <- paste('word', 1:max(sent_length), sep = '_')
View(sent_word_df)

# 인덱싱을 통해 문장과 단어 위치 파악하기
sent_word_df[, 1]  # 첫번째 열: 각 문장의 첫 단어들
sent_word_df[1, ]  # 첫번째 행: 첫 번째 문장
sent_word_df[2, 3:10]  # 두번째 행의 3~10번째 단어들


# 5. str_count() : 지정한 패턴의 빈도 계산
str_count(R_Programming, "R")  # 문서전체에서 R이 등장한 횟수
str_count(r_para[[1]], "R")    # 각 문단에서 R이 등장한 횟수
str_count(unlist(r_sent), "R") # 각 문장에서 R이 등장한 횟수

# Quiz: 각 문장에서 R, stat 으로 시작하는 표현의 등장횟수


# 6. str_sub() : 원하는 위치에 있는 표현 추출
# 기본 함수의 substr() 함수와 유사함.
# 두 번째 문장의 1~15번째 위치의 텍스트 추출
str_sub(unlist(r_sent)[2], 1, 15)


# 7. str_dup() : 지정한 표현 반복
str_dup("R", 5)  # 지정한 표현을 5번 반복한 1개의 결과

# rep와 비교하면?
rep("R", 5)      # 지정한 표현을 반복한 5개의 결과

paste(rep("R", 5), collapse = "")
str_dup("R", 5) == paste(rep("R", 5), collapse = "")


# 8. str_length() : 지정한 표현의 글자 수 계산
# 기본함수의 nchar()
str_length(unlist(r_sent))
nchar(unlist(r_sent))


# 9. str_pad(), str_trim() : 공란으로 글자 수 맞추기, 공란 삭제하기

# str_pad() 지정 표현에 공란으로 완충(padding)을 덧댐
names <- c("Con", "Ryan", "Frodo", "Apeach", "Pengsoo")
money <- c("9₩", "99₩", "999₩", "9999₩", "99999₩")
goods <- data.frame(names, money)
goods

# 캐릭터 이름은 왼쪽 정렬, 굿즈 가격은 가운데 정렬
name_left <- str_pad(goods$names, width = 15, side = 'right', pad = ' ')
money_cent <- str_pad(goods$money, width = 15, side = 'both', pad = '_')
goods2 <- data.frame(name_left, money_cent)
goods2

str_length(goods$names[1])  # 3글자
str_length(goods2$name_left[1])  # 15글자 (지정한 너비만큼 공백포함됨)

# str_trim()으로 되돌리기
name_orig <- str_trim(goods2$name_left, side = 'right')
money_orig <- str_trim(str_replace_all(goods2$money_cent, '_', ' '), side = 'both')
goods3 <- data.frame(name_orig, money_orig)
goods3

all(goods == goods3)  # 비교


# str_c() = paste()
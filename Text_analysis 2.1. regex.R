#####
# 2강 정규표현(regex), 
# 2020. 2. 18.
# 안성태
#####

#####중요한것은 패턴 찾기!!#####
# 텍스트 분석에 적합한 형태로 텍스트에서 불필요한 내용을 제거하고,
# 문단, 문장, 단어, 형태소 형태로 구분하기 위해서
# 패턴을 발견하고 정규표현을 통해 텍스트를 정제하는 과정이 필수적이다.
# 정규표현이 많아보이지만, 실습을 통해 어렵지 않게 익힐 수 있다.

#------------------------------------------------------------#
# 1) 알파벳이나 숫자로 표시된 텍스트
# [:digit:]   : 숫자로 표시된 텍스트
# [:lower:]   : 소문자 알파벳으로 표시된 텍스트
# [:upper:]   : 대문자 알파벳으로 표시된 텍스트
# [:alpha:]   : 대,소문자 알파벳으로 표시된 텍스트
# [:alnum:]   : 숫자와 대,소문자로 표시된 텍스트
# [a-z]       : 알파벳 소문자 중 1개
# [A-Z]       : 알파벳 대문자 중 1개
# [0-9]       : 모든 숫자 중 1개
#------------------------------------------------------------#
# 2) 알파벳이나 숫자가 아닌 텍스트
# [:punct:]   : 구두점으로 표시된 텍스트 (쉼표(,), 마침표(.), )
# [:graph:]   : 가시적으로 표현된 텍스트 ([:alnum:] + [:punct:])
# [:blank:]   : 스페이스나 탭을 이용하여 공란으로 나타난 텍스트
# [:space:]   : 스페이스, 탭, 줄바꿈 등을 이용하여 공란으로 표현된 텍스트
# [:print:]   : 출력했을 때 확인할 수 있는 텍스트 ([:alnum:] + [:punct:] + [:space:])
#------------------------------------------------------------#
# 3) 경우에 따라 유용한 표현
# [:cntrl:]   : 제어문자(control character)로 표현된 텍스트
# [:xdigit:]  : 16진법을 따르는 텍스트
#------------------------------------------------------------#
# 4) 양화기호
#     ?       : 선행표현을 고려할 수도, 고려하지 않을 수도 있으며 최대 1회 매칭
#     *       : 선행 표현이 0회 혹은 그 이상 매칭 (최소한 0번 매칭)
#     +       : 선행 표현이 1회 혹은 그 이상 매칭 (최소한 1번 이상 매칭)
#     .       : 무엇이든 한 글자를 의미
#     ^       : 시작 문자 지정  e.g. [^abc] 는 a, b, c중 하나로 시작하는 패턴
#     $       : 끝 문자 지정    e.g. [def$] 는 d, e, f중 하나로 끝나는 패턴
#   {n}       : 선행표현이 정확히 n회 매칭
#   {n, }     : 선행표현이 n회 이상 매칭  cf. {1, } 은 +와 같은 표현
#   {n, m}    : 선행표현이 n회 이상 m회 미만 매칭
#------------------------------------------------------------#
#   \w        : 숫자 혹은 알파벳으로 표현된 모든 단어 ([:alnum:])
#   \W        : 숫자 혹은 알파벳으로 표현된 모든 단어 제외
#   \d        : 숫자로 표현된 모든 텍스트
#   \D        : 숫자로 표현된 모든 텍스트 제외
#   \s        : 공란으로 표현된 모든 텍스트
#   \S        : 공란으로 표현된 모든 텍스트 제외
#   \b        : 특정 표현으로 시작되거나 종결된 모든 텍스트
#   \B        : 특정 표현으로 시작되거나 종결되지 않은 모든 텍스트
#------------------------------------------------------------#

byron <- c("When we two parted in silence and tears",
           "half broken-hearted to sever for years")

past_pattern <- gregexpr("ed", byron)
regmatches(byron, past_pattern)

# 접미사(-ed)는 앞에 알파벳이 등장함 -> [[:alpha:]] 사용
past_pattern2 <- gregexpr("[[:alpha:]]{1, }(ed)", byron)  # [[:alpha:]]+ 사용 가능
regmatches(byron, past_pattern2)

# Wikipedia R 문장
R_Programming <- "R is a programming language and free software environment for statistical computing and graphics supported by the R Foundation for Statistical Computing. The R language is widely used among statisticians and data miners for developing statistical software and data analysis. Polls, data mining surveys, and studies of scholarly literature databases show substantial increases in popularity; as of January 2020, R ranks 18th in the TIOBE index, a measure of popularity of programming languages.
A GNU package, source code for the R software environment is written primarily in C, Fortran, and R itself and is freely available under the GNU General Public License. Pre-compiled binary versions are provided for various operating systems. Although R has a command line interface, there are several graphical user interfaces, such as RStudio, an integrated development environment."


# -ing 로 끝나는 단어
continue_pattern <- gregexpr('[[:alpha:]]+(ing)\\b', R_Programming)
words_ing <- regmatches(R_Programming, continue_pattern)
words_ing  
table(unlist(words_ing))  # 결과물이 list형태이므로 unlist() 함수 사용

# R은 대소문자를 구별하기 때문에 
# computing 과 Computing을 별개의 문자로 취급하였다.
# toupper() 또는 tolower() 를 통해 해결
words_ing2 <- regmatches(tolower(R_Programming), continue_pattern)
table(unlist(words_ing2))

# stat 으로 시작하는 단어
stat_words <- gregexpr('(stat)[[:alpha:]]+', tolower(R_Programming))
regmatches(tolower(R_Programming), stat_words)

# 몇 개의 대/소문자 알파벳이 사용되었는가?
# 대문자 [:upper:]
upper_pattern <- gregexpr('[[:upper:]]', R_Programming)
upper_char <- regmatches(R_Programming, upper_pattern)
table(unlist(upper_char))

# 소문자 [:lower:]
lower_pattern <- gregexpr('[[:lower:]]', R_Programming)
lower_char <- regmatches(R_Programming, lower_pattern)
table(unlist(lower_char))

# quiz
# 1) 대/소문자 구별 없이 사용된 알파벳들의 빈도수를 구해본다.
# 2) 대/소문자 구별 없이 총 몇가지 종류의 알파벳이 사용되었는가? 
#     hint: length() 함수 사용
# 3) 대/소문자 구별 없이 총 몇 개의 알파벳이 사용되었는가?
#     hint: sum() 함수 사용
















#####
# Q1.
alpha_pattern <- gregexpr('[[:upper:]]', toupper(R_Programming))
alpha_count <- regmatches(toupper(R_Programming), alpha_pattern)
alpha_table <- table(unlist(alpha_count))
# Q2.
length(alpha_table)
# Q3.
sum(alpha_table)

# visualization using ggplot2 
# install.packages('ggplot2')
library('ggplot2')
alpha_df <- data.frame(alpha_table)
alpha_df
alpha_bar <- ggplot(data = alpha_df, aes(x = Var1, y = Freq)) +
  geom_bar(stat = "identity") +
alpha_bar
#####






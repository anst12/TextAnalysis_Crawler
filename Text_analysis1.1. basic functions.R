#####
# 1강 R의 이해 및 텍스트 분석을 위한 기본 함수 (1)
# 2020. 2. 17.
# 안성태
#####

# 1. 패키지 설치와 부착

# 설치 함수: install.packages()
install.packages("tidyverse")

# 벡터를 이용해서 여러 패키지를 동시에 설치할 수 있음
install.packages(c("rvest", "urltools", "tm"))

# 패키지 부착: library() 또는 require()
# 패키지를 부착하지 않으면 함수 호출, 사용이 불가능함!
library("tidyverse")
library(c("rvest", "urltools", "tm"))  # 패키지는 한 개씩 부착 가능
library("rvest"); library("urltools"); library("tm") 


# 2. 기초 R 함수
# R은 객체 지향 프로그래밍 언어 (object-oriented programming)

# 값 할당 <-
a <- 1
b <- "hello world!"

# 작업 영역
ls()
objects()
rm(a)
ls()

# 디렉토리 설정
getwd()
setwd()

# 객체의 타입(Type)
# 1) 벡터 c()
num_vector <- c(1, 2, 3, 4:6)
num_vector

str_vector <- c("a", "b", "c")
str_vector

my_vector <- c(1:3, "a")
my_vector

# 객체의 구조를 확인하는 방법? str()
str(num_vector)
str(str_vector)
str(my_vector)

# 객체의 속성을 확인하는 방법
class(num_vector)
class(str_vector)
mode(num_vector)
mode(str_vector)

# 속성
logi <- c(TRUE, TRUE, FALSE, TRUE) ; logi
class(logi)
num <- c(1, 2, 5, 200, -300, 3.5) ; num
class(num)
intig <- c(1L, 0L, 200L, -300L, 3L) ; intig
class(intig)
cmplx <- c(1, 2+1i, 3-3i) ; cmplx
class(cmplx)
chr <- c("a", "가", "3", "3L", "1+3i") ; chr
class(chr)
raw <- charToRaw("hello, world!") ; raw
class(raw)


# 2) 리스트 list()
# 리스트 형태는 텍스트분석에서 매우 중요함.
# 텍스트 데이터는 말뭉치(corpus) -> 문서 -> 문단 -> 문장 -> 단어 -> 형태소 로
# 층화할 수 있는데, 이 형태를 리스트로 표현할 수 있기 때문

obj1 <- 1:5
obj2 <- 6:10
obj3 <- list(obj1, obj2)
list_in_list <- list(obj1, obj2, obj3)
list_in_list
str(list_in_list)

# 인덱싱: 오브젝트에서 원하는 관측치를 지정할 수 있다.
obj3
obj3[1]
obj3[[1]][2]
obj3[[2]][2]

list_in_list
list_in_list[[3]][[1]][2]

# unlist(): 리스트를 벡터로 
my_vec <- c(1:6, 'a')
my_list <- list(1:6, 'a')
unlist(my_list)
unlist(my_list) == my_vec

# unlist() 함수 사용시 유의사항
mean(my_list[[1]][1:6])
mean(unlist(my_list)[1:6])

# unlist() 함수를 유용하게 사용하기 
# 미국 대통령 이름 (문자에서 단어로)
first_name <- "George"
middle_name <- "W"
last_name <- "Bush"
name_space <- " "
bush <- list(first_name, name_space, middle_name, name_space, last_name)
unlist(bush)

# Matrix
my_matrix <- matrix(c('x', 'y', 'z', 1, 2, 3, 2, 4, 8), nrow = 3, ncol = 3)
my_matrix
my_matrix2 <- matrix(c(1, 2, 3, 2, 4, 8), nrow = 2, ncol = 3, byrow = TRUE,
                     dimnames = list(c("row1", "row2"), c("x", "y", "z")))
my_matrix2  # 옵션 byrow = FALSE 인 경우는?

# Array : 1차원부터 2차원, 3차원 이상을 가질 수 있다.
# (matrix 는 2차원의 array라고 생각할 수 있음)
my_array <- array(c(1:16), dim = c(2, 4, 2))
my_array

# attr() 오브젝트에 속성값 입력 또는 추출
# 메타데이터를 입력하는 방법
# gender 변수에 '응답자의 성별'이라는 속성을,
# 1의 값은 '남성', 2의 값은 '여성'이라는 속성(attribute)을 부여
name <- c("김대중", "노무현", "이명박", "박근혜", "문재인")
gender <- c(1, 1, 1, 2, 1)
president <- data.frame(name, gender)
attr(president$name, "what the variable means") <- "대통령의 이름"
president$name
attr(president$gender, "what the variable means") <- "대통령의 성별"
president$gender
myvalues <- gender
for (i in 1:length(gender)) {
  myvalues[i] <- ifelse(gender[i] == 1, "남성", "여성")
}
attr(president$gender, "what the value means") <- myvalues
attr(president$gender, "what the value means")
president$gender

# lapply(), sapply(), tapply() : list형식의 오브젝트에 사용하는 apply() 함수
# STATA 에서 egen, collapse 명령어와 유사한 기능
# 1) lapply()
mylist <- list(1:4, 6:10, list(1:4, 6:10))
mylist
lapply(mylist[[3]], FUN = mean)  # 세 번쨰 리스트 오브젝트의 평균값을 계산할 수 있다.

# -----
# 텍스트 분석에서 lapply() 함수의 활용 예시
# 10개의 문장으로 구성된 한 문단이 리스트 오브젝트로 있을 때,
# 각 문장이 단어들의 벡터로 구성되어 있다면
# lapply(x, FUN = sum) 을 통해 단어 수의 총합을 구할 수 있다.
# -----

# lapply() 함수 주의점: [[]][[]] 형식으로 인덱싱된 경우
lapply(mylist, FUN = mean)  # mylist[[3]]의 계산이 불가능함

lapply(mylist[c(1, 2, c(1, 2))], FUN = mean)  # 계산을 적용하는 리스트의 모양을 밝혀줄것

# 2) sapply()
# lapply() 함수의 결과에 unlist()를 적용한 것과 같음
sapply(mylist[c(1, 2, c(1, 2))], FUN = sum)

unlist(lapply(mylist[c(1, 2, c(1, 2))], FUN = sum))

# 3) tapply()
# 교차표 형식(table apply) 
word_list <- c("the", "is", "a", "the")
doc1_freq <- c(3, 4, 2, 4)
doc2_freq <- rep(1, 4)

tapply(doc1_freq, word_list, length)
tapply(doc2_freq, word_list, length)
tapply(doc1_freq, word_list, sum)
tapply(doc2_freq, word_list, sum)

# 세 문장에서 사용한 단어의 빈도
line1 <- c("to", "see", "a", "world", "in", "a", "grain", "of", "sand")
line2 <- c("and", "a", "heaven", "in", "a", "wild", "flower")
line3 <- c("hold", "infinity", "in", "the", "palm", "of", "your", "hand")
line4 <- c("and", "eternity", "in", "an", "hour")
line_freq <- c(rep(1, length(line1)), rep(1, length(line2)), rep(1, length(line3)), rep(1, length(line4)))
tapply(line_freq, c(line1, line2, line3, line4), sum)


# 반복문 for, while
# for 문 : 반복해야 하는 조건을 알 때 사용
for (i in 1:9) {
  print(i)
}

# 중첩도 가능 - 구구단 2단 ~ 9단
for (i in 2:9) {
  for (j in 1:9) {
    print(i * j)
  }
}

# while : 조건이 참일때만 시행 (대체로 반복해야 하는 조건을 모를때 사용)
k = 1
while (k < 10) {
  result <- 2 * k
  print(result)
  k <- k + 1
}
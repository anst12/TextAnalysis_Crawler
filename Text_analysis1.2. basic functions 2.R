#####
# 1강 텍스트 분석을 위한 기본 함수 (2)
# 2020. 2. 17.
# 안성태
#####

# 텍스트 처리를 위한 R의 베이스 함수

# letters[], LETTERS[]: 알파벳 출력함수
# letters[]: a에서 z까지 소문자 알파벳 출력
letters[3]
letters[1:26]
# LETTERS[]: A에서 Z까지 대문자 알파벳 출력
LETTERS[3]
LETTERS[1:26]

# tolower(), toupper(): 알파벳 대소문자 전환
tolower("Life Is So Cool")
toupper("life is so cool")
# 문제점?
tolower("President Trump knows how to play trump")  # Trump 대통령 vs. Trump 게임


# nchar(): 문자 수, 바이트 수 세기
nchar("Trump")
nchar("Trump", type = 'bytes')  
nchar("트럼프")
nchar("트럼프", type = 'bytes')  
# 공란은 몇 바이트?
nchar('PoliticalScience')
nchar('Political Science')

# 탭(고정폭), 줄바꿈은 어떻게 표현하는가?
# 이스케이프(\, 역슬래시)를 사용하여 표현!
nchar('Social Science,\tPolitical Science')  # 탭은 \t
nchar('Social Science,  Political Science')

nchar('Political\nScience')  # 줄바꿈은 \n
nchar('Political
      Science')


# strsplit(): 텍스트 오브젝트의 분할
str_obj <- "Text Analysis using R"
strsplit(str_obj, split = " ")  # 출력 결과가 리스트 형태

# 단어를 알파벳으로 쪼개려면? 
words_obj <- strsplit(str_obj, split = " ")
words_obj
# str_obj을 단어단위로 쪼갠 리스트에서 2번째 단어(Analysis) 인덱싱
strsplit(words_obj[[1]][2], split = "")

# str_obj의 모든 단어를 쪼개려면?
split_obj <- list(rep(NA, 4))
for(i in 1:4) {
  split_obj[i] <- strsplit(words_obj[[1]][i], split = "")
}
split_obj

# paste(): 벡터의 병합
paste(words_obj[[1]][2], collapse = "")

# 네 단어를 다시 하나의 문장으로 병합하기
str_obj2 <- paste(words_obj, collapse = " ")
str_obj2

#-----
# Challenge! '문서를 문단 -> 문장 -> 단어' 수준으로 구분할 수 있을까?
R_Programming <- "R is a programming language and free software environment for statistical computing and graphics supported by the R Foundation for Statistical Computing. The R language is widely used among statisticians and data miners for developing statistical software and data analysis. Polls, data mining surveys, and studies of scholarly literature databases show substantial increases in popularity; as of January 2020, R ranks 18th in the TIOBE index, a measure of popularity of programming languages.
A GNU package, source code for the R software environment is written primarily in C, Fortran, and R itself and is freely available under the GNU General Public License. Pre-compiled binary versions are provided for various operating systems. Although R has a command line interface, there are several graphical user interfaces, such as RStudio, an integrated development environment."

# 위 텍스트를 문단 단위로 분리하기
R_paragraph <- strsplit(R_Programming, split = "\n")
R_paragraph

# 문단을 문장으로 분리하기
R_sentence <- strsplit(R_paragraph[[1]], split = "\\. ")
R_sentence

# 문장을 단어로 분리하기
R_word <- list(NA, NA)
for(i in 1:2) {
  R_word[[i]] <- strsplit(R_sentence[[i]], split = " ")
}
R_word

# 두 번째 문단의 세 번째 분장에 나오는 두 번째 단어는?
R_word[[2]][[3]][2]
#-----


# 텍스트 데이터에서 특정 표현의 위치정보를 찾기: regexpr(), gregexpr(), regexec()
byron <- "When we two parted in silence and tears, half broken-hearted to sever for years"

# regexpr() : 지정된 패턴이 처음 등장하는 위치
regexpr('ed', byron)
regexpr('ears', byron)

# 원하는 표현이 시작되는 위치
exp_begin <- as.vector(regexpr('ed', byron))
exp_begin
exp_length <- as.vector(attr(regexpr('ed', byron), "match.length"))
exp_length
exp_end <- exp_begin + exp_length - 1
exp_end

# gregexpr() : 지정한 패턴이 텍스트 전체에서 나타나는 위치
# g는 global을 의미함.
gregexpr('ed', byron)
gregexpr('ears', byron)

# 원하는 표현이 전체 문장에서 몇 번 등장했는지 확인하려면?
length(gregexpr('ed', byron)[[1]])

# 패턴의 시작 위치
exps_begin <- as.vector(gregexpr('ed', byron)[[1]])
exps_begin

# 패턴의 길이
exps_length <- as.vector(attr(gregexpr('ed', byron)[[1]], "match.length"))
exps_length

# 패턴의 종료 위치
exps_end <- exps_begin + exps_length - 1
exps_end

# regexec() : 찾고자 하는 패턴이 복잡하고 여러가지일 때 유용함.
# 간단한 표현은 regexpr()함수와 비슷한 결과
regexec('parted', byron)
# 괄호를 사용하면 비슷한 패턴을 찾아내기 쉬울 수 있다.
# e.g. 'parted' 
regexec('part(ed)', byron)
# 괄호와 함께 특정 패턴을 함께 입력하면 원하는 패턴만을 찾을 수 있다.
# e.g. 'two parted' two로 시작하고 ed로 끝나는 표현
regexec('two part(ed)', byron)


# grep(), grepl(): 특정 표현이 텍스트 데이터에서 등장하는지 확인한다.
wiki_R <- unlist(R_sentence)

grep("software", wiki_R)
grepl("software", wiki_R)  # grepl()에서 l은 logical을 의미함.


# sub()과 gsub(): 특정 표현을 다른 표현으로 바꾸기
sub("ing", "ING", wiki_R[3])  # wiki_R의 3번째 문장
gsub("ing", "ING", wiki_R[3])

# 사용예시: 'Donald Trump'와 같은 고유명사를 처리할때 유용함
# gsub("Donald Trump", "Donald_Trump", x)

first_sentence <- wiki_R[1]
sub_first_sentence <- gsub("R Foundation for Statistical Computing",
                           "R_Foundation_for_Statistical_Computing",
                           first_sentence)
# 단어 수의 변화
sum(table(strsplit(first_sentence, split = ' ')))
sum(table(strsplit(sub_first_sentence, split = ' ')))

# 불필요한 단어 삭제
# 접속사, 관사 등 기능어(functional word)는 대개 텍스트 분석 시 의미를 가지지 않는다.
# 예시: 위의 문장에 gsub()함수를 이용하여 a, and, the, by, for를 지우는 방법
new_first_sentence <- gsub("a |and |the |by |for ", "", sub_first_sentence)
new_first_sentence 
sum(table(strsplit(new_first_sentence, split = " ")))


# regmatches() : 텍스트 자료에서 지정된 표현에 해당하는 표현을 추출
past <- regexpr('ed', byron)
regmatches(byron, past)

past <- gregexpr('ed', byron)
regmatches(byron, past)

# 지정된 표현을 제외한 나머지 텍스트만을 추출
past <- regexpr('ed', byron)
regmatches(byron, past, invert = TRUE)  # invert = TRUE 옵션을 사용

past <- gregexpr('ed', byron)
regmatches(byron, past, invert = TRUE)

# 다른 함수와의 차이점?
strsplit(byron, split = "ed")
gsub("ed", "", byron)


# substr() : 위치를 사용하여 지정된 위치에 어떤 표현이 사용되었는지 확인
substr(wiki_R, 1, 15)

#!/bin/bash
clear

export tries=0
export food=("БАНАН" "ПЮРЕ" "КАРТОФЕЛЬ" "КОНФЕТА" "ЯБЛОКО" "МЯСО" "АНАНАС" "МОРКОВЬ" "ОВОЩИ" "БАТОН" "БУЛЬОН" "ПИРОГ" "ОГУРЕЦ" "ОРЕХ" "ПОМИДОР" "ГОРОХ" "ЕЖЕВИКА" "САЛАТ" "САХАР" "УЖИН" "КАКАО" "ФАСОЛЬ" "КРЕВЕТКА" "КОФЕ" "ЧЕРНИКА" "ЛИМОН" "ШОКОЛАД" "ЧЕСНОК" "КОКТЕЙЛЬ" "МОЛОКО" "МАКАРОНЫ" "МАЛИНА" "ШАМПИНЬОН" "ЭСКИМО" "ЯГОДА" "ТУШЁНКА" "СЕЛЬДЕРЕЙ" "ВИНЕГРЕТ" "БОРЩ" "БАЗИЛИК" "СОЛЯНКА" "ЩИ" "ОКРОШКА" "ПОНЧИК" "ГАМБУРГЕР" "КЕТЧУП" "ШАШЛЫК" "ОЛИВКИ" "ПИРОЖОК" "КРУААСАН" "БАГЕТ")
export sport=("ВЕЛОСИПЕД" "МЯЧ" "КЛЮШКА" "ШАЙБА" "КОНЬКИ" "ФУТБОЛ" "БЕГ" "БАСКЕТБОЛ" "ЗДОРОВЬЕ" "СПОРТСМЕН" "СОРЕВНОВАНИЕ" "ХОККЕЙ" "ОЛИМПИАДА" "ТЕННИС" "ТРЕНЕР" "ПЛАВАНЬЕ" "ЛЫЖИ" "БОКС" "ПОБЕДА" "ТРЕНИРОВКА" "ПРЫЖКИ" "МЕДАЛЬ" "ШАХМАТЫ" "ТРАВМА" "МАТЧ" "ШТАНГА" "ГИМНАСТИКА" "СТАДИОН" "СПОРТЗАЛ" "СУДЬЯ" "КОМАНДА" "ФИЗКУЛЬТУРА" "ГОЛЬФ" "ТАНЦЫ" "ФИТНЕС" "БИАТЛОН" "РАКЕТКА" "РЕГБИ")
export it=("ПРОГРАММИСТ" "КОД" "ОТЛАДКА" "НОУТБУК" "БАГ" "ДОСТУП" "БАЙТ" "ВЫЧИСЛЕНИЕ" "КОНФИГУРАЦИЯ" "ДЕСТРУКТОР" "РАЗРАБОТЧИК" "ФУНКЦИЯ" "ХАКЕР" "ССЫЛКА" "КЛАВИАТУРА" "АУТСОРСИНГ" "БАТНИК" "ЛАМЕР" "НУБ" "ПАТЧ" "ДВИЖОК" "ПОДКАСТ" "ТИМЛИД" "ФИЧА" "ФАЙРВОЛ" "ХАКАТОН" "ЭНИКЕЙЩИК" "ФАКАП" "АНАЛИЗ" "УСТРОЙСТВО" "СЕРТИФИКАТ" "СОВМЕСТИМЫЙ" "СДЕЛКА" "ЭФФЕКТИВНЫЙ" "ОБОРУДОВАНИЕ" "ГАДЖЕТ" "УСТАНАВЛИВАТЬ" "ИНТЕГРИРОВАТЬ" "МАТРИЦА" "ПРОЦЕСС" "ВЕБИНАР" "ДОСТУП" "АЛГОРИТМ" "КЛАСС" "СВЕТОДИОД" "ИМПОРТ" "ЦИКЛ")
export bad_letters=()
export good_letters=()
export keyboard=("А" " " "Б" " " "В" " " "Г" " " "Д" " " "Е" " " "Ё"
 		 "Ж" " " "З" " " "И" " " "Й" " " "К" " " "Л" " " "М"
		 "Н" " " "О" " " "П" " " "Р" " " "С" " " "Т" " " "У"
		 "Ф" " " "Х" " " "Ц" " " "Ч" " " "Ш" " " "Щ" " " "Ъ"
		 " " " " "Ы" " " "Ь" " " "Э" " " "Ю" " " "Я" " " " ")
export playing_field_length=13
export playing_field_width=5
export category_str=""
export word="word"
quiet=false
die=0
export word_length=0
export arr_for_wrdlength=()

function check_letter() { # $1 = word; $2 = letter
local res=false
for (( i=0; i<${#1}; i++ )); do
	if [ "${1:$i:1}" = "$2" ]; then
		res=true
	fi
done
echo $res
}

#result=$(check_letter "planet" e)
#echo $result

function prnt_keyboard() {
for (( y=0; y<${playing_field_width}; y++ )); do
	for (( x=0; x<${playing_field_length}; x++ )); do
		let "curr_symbol=$y*$playing_field_length+$x"
		let "y+=12" #опускаем клавиатуру
		let "x+=20" #вниз 
		prnt_symbol $y $x "${keyboard[${curr_symbol}]}"
		let "y-=12"
		let "x-=20"	
	done
done
}

function prnt_symbol() { # $1 - x; $2 - y; $3 - symbol
echo -e "\033[1m\E[$1;$2f$3"
}

function check_on_out() {
local res=false
local symb=0
let "symb=($2-12)*$playing_field_length+($1-20)"
	if (( $2 > ${playing_field_width}+12-1 || $2 < 12 || $1 > ${playing_field_length}+20-1 || $1 < 20 )); then
		res=true
	elif [[ "${keyboard[$symb]}" == " " ]]; then
		res=true
	fi
echo $res
}

function check_badorgood_letter() {
local result=0
for letter in ${bad_letters[@]}; do
	if [[ "$1" == "$letter" ]]; then
		let "result=2"
		echo $result
		return
	fi
done

for letter in ${good_letters[@]}; do
	if [[ "$1" == "$letter" ]]; then
		let "result=1"
		echo $result
		return
	fi
done
echo $result
}

function print_word() {
local x=20
local y=10
if [[ ${#good_letters[*]} -eq 0 ]]; then
	for (( i=0; i<${#word}; i++ )); do
	echo -e "\e[1;25;36;40m\e[${y};${x}f_"
	let "x+=2"
	done
echo -e "e[1m\e[25;0;0m\e[${y};${x}f"
elif [[ $1 -eq 7 ]]; then
for (( i=0; i<${#word}; i++ )); do
echo -e "\e[1;5;36;40m\e[${y};${x}f${word:$i:1}" #########
let "x+=2"
done
else
for letter in ${good_letters[@]}; do
	x=20
	for (( i=0; i<${#word}; i++ )); do
	if [ "${word:$i:1}" = "$letter" ]; then
		echo -e "\e[1;25;36;40m\e[${y};${x}f${letter}"
		echo -e "\e[1;25m\e[0;0m\e[${y};${x}f"
	fi
	let "x+=2"
	done
done
fi
}

function goto() {
case $1 in
1) hangman 1 ;;
2) hangman 2 ;;
3) hangman 3 ;;
4) hangman 4 ;;
5) hangman 5 ;;
6) hangman 6 ;;
7) hangman 7 ;;
8) hangman 8 ;;
esac
}

function print_category() {
local x=19
local y=8
echo -e "\e[1;25m\E[$y;${x}f<|___________|>"
let "x+=6"
#let "y-=1"
if [[ $category_str == "Спорт" ]]; then
	let "x-=1"
fi
echo -e "\e[1;25m\E[$y;${x}f$category_str"
}

function hangman() {
local x=11
local y=2
echo -e "\e[1;0;0m\E[$y;${x}f         | /                   "
let "y+=1"
echo -e "\e[1;0;0m\E[$y;${x}f         |/                    "
let "y+=1"
echo -e "\e[1;0;0m\E[$y;${x}f         |                     "
let "y+=1"
echo -e "\e[1;0;0m\E[$y;${x}f         |                     "
let "y+=1"
echo -e "\e[1;0;0m\E[$y;${x}f         |                     "
let "y+=1"
echo -e "\e[1;0;0m\E[$y;${x}f_________|____________________"

case $1 in
1) echo -e "\e[1;25m\E[1;16f____________________" ;;
2) echo -e "\e[0;25m\E[2;29f|" ;;
3) goto 2
   case $die in
	0) echo -e "\e[0m\E[3;27f(^ ^)" ;;
	1) echo -e "\e[0m\E[3;27f(* *)" ;;
   esac
   ;;
4) goto 2
   goto 3 
   echo -e "\e[1;25m\E[4;29f|" 
   echo -e "\e[1;25m\E[5;29f|"
   ;;
5) goto 2
   goto 3
   goto 4
   echo -e "\e[1;25m\E[4;28f/" ;;
6) goto 2
   goto 3
   goto 4
   goto 5
   echo -e "\e[1;25m\E[4;30f\ " ;;
7) goto 2
   goto 3
   goto 4
   goto 5
   goto 6
   echo -e "\e[1;25m\E[6;28f/" ;;
8) let "die=1"
   goto 2
   goto 3
   goto 4
   goto 5
   goto 6
   goto 7
   echo -en "\e[1;25m\E[6;30f\\" ;; 
esac
}

#arr_for_wrdlength+=("${word:$i:1}")
function wrdlength() {
have=false
for (( i=0; i<${#word}; i++ )); do
have=false
	if [[ ${#arr_for_wrdlength[*]} -eq 0 ]]; then
	arr_for_wrdlength+=("${word:$i:1}")
	continue
	fi
	for letter in ${arr_for_wrdlength[@]}; do
	if [ "${word:$i:1}" = "$letter" ]; then
		have=true
		break
	fi
	done
	if ! ${have}; then
		arr_for_wrdlength+=("${word:$i:1}")
	fi
done
word_length=${#arr_for_wrdlength[*]}
}

function garbage_collector() {
local x=0
local y=0
for ((i=${y}; i<21; i++ )); do
echo -en "\e[0;0;0m\e[${i};${x}f             "
done
echo -e "\E[${1};${2}f"
}

# ----------------------------------------- MAIN ----------------------------------------- #

#предисловие
echo -e "\e[2;35fHangman\n"
echo -e "В этой игре вам нужно отгадать слово поочередно выбирая буквы на виртуальной клавиатуре.\nЕсли кол-во неправильных букв будет равно 8, игра окончена.\n
Весь процесс игры сопровождается анимацией.\nУправление: WASD - передвижение по клавиатуре, ENTER - подтвердить букву, q - выйти из игры.\nУдачной игры.\n\nНажмите любую клавишу.."
tput civis
read -sn1
tput cnorm
clear
#предисловие
while ! ${quiet}; do
#тут выбираем категорию
pattern='^[0-3]$'
category=""
tput cnorm
while ! [[ "$category" =~ ${pattern} ]]; do
echo -en "\033[1;25m\033[39m\E[10;4f                       "
echo -e "\033[1;25m\033[39m\E[4;4fВыберите категорию:"
echo -e "\033[1;25m\033[39m\E[6;6fIT --- 1"
echo -e "\033[1;25m\033[39m\E[7;6fЕда --- 2"
echo -e "\033[1;25m\033[39m\E[8;6fСпорт --- 3"
echo -e "\033[1;25m\033[39m\E[9;6fВыйти --- 0"
echo -en "\033[1;25m\033[39m\E[11;4fВаш выбор: "
	read -sn 1 category
done
if [[ $category -eq 0 ]]; then
clear
break
fi
#тут выбираем категорию
#тут выбираем рандомное слово
rand_w=$RANDOM
case $category in
1)
while [[ ${rand_w} -ge ${#it[*]} ]]; do
	let "rand_w=$RANDOM"
done
category_str="IT"
word=${it[${rand_w}]}
;;
2)
while [[ ${rand_w} -ge ${#food[*]} ]]; do
	let "rand_w=$RANDOM"
done
category_str="Еда"
word=${food[${rand_w}]}
;;
3)
while [[ ${rand_w} -ge ${#sport[*]} ]]; do
	let "rand_w=$RANDOM"
done
category_str="Спорт"
word=${sport[${rand_w}]}
;;
esac
#тут выбираем рандомное слово
tput civis
wrdlength
clear
hangman
print_category
print_word
prnt_keyboard
Button=""
flett_x=0
flett_y=0
nlett_x=20
nlett_y=12
next_symbol=0
back_symbol=0
now_symbol=0
echo -e "\033[1;25m\e[5m\033[37m\E[12;20fА"
	while [[ $Button != "q" ]]; do
	garbage_collector $nlett_y $nlett_x
	read -s -n 1 Button
	let "now_symbol=($nlett_y-12)*$playing_field_length+($nlett_x-20)"
	case $Button in
		[wWцЦцЦ]) 
			let "flett_x=${nlett_x}"
			let "flett_y=${nlett_y}-1"
			;;
		[sSыЫіІ])
			let "flett_x=${nlett_x}"
			let "flett_y=${nlett_y}+1"
			;;
		[aAфФфФ])
			let "flett_x=${nlett_x}-2"
			let "flett_y=${nlett_y}"
			;;
		[dDвВвВ])
			let "flett_x=${nlett_x}+2"
			let "flett_y=${nlett_y}"
			;;
		[qQйЙйЙ])
			Button="q"
			clear
			good_letters=()
			bad_letters=()
			die=0
			arr_for_wrdlength=()
			word_length=0
			continue;;
		[[:print:]]|[[:space:]]|[[:punct:]]|[[:digit:]]|[[:blank:]])		
			continue
			;;
		*)
			#Основные действия
			mletter="${keyboard[$now_symbol]}"
			# ------ ++++
			answer2=$(check_badorgood_letter "${mletter}")			
			case $answer2 in
				2) echo -e "\033[1;5m\033[31m\E[${nlett_y};${nlett_x}f${keyboard[$now_symbol]}" ;;
                                1) 		echo -e "\e[1;5;43m\E[${nlett_y};${nlett_x}f${keyboard[$now_symbol]}"
						echo -e "\e[1;5;43m\E[${nlett_y};${nlett_x}f" ;;
				0) 
					if ! $(check_letter ${word} ${mletter}); then
						bad_letters+=("${mletter}")
						echo -e "\033[1;5m\033[31m\E[${nlett_y};${nlett_x}f${keyboard[$now_symbol]}"
						hangman ${#bad_letters[*]}
						if [[ ${#bad_letters[*]} -eq 8 ]]; then
							print_word 7
							#garbage_collector
							echo -e "\e[1;25;36;40m\e[18;20fВы проиграли("
							echo -e "\e[1;25;0;0m\e[18;20f\n"
							read -sn1 -p "Хотите сыграть еще раз(y/n): " choise
							case $choise in
							[yнННнY]) 	Button="q"
								clear
								good_letters=()
								bad_letters=()
								die=0
								arr_for_wrdlength=()
								word_length=0
								continue;;
							[nNтТтТ])      clear; quiet=true; Button="q" ;;
							*)      clear; quiet=true; Button="q" ;;
							esac
						fi
					else
						good_letters+=("${mletter}")
						print_word
						if [[ ${#good_letters[*]} -ge ${word_length} ]]; then
							echo -e "\e[1;25;36;40m\e[18;20fВы выиграли!"
							echo -e "\e[1;25m\e[0;0m\e[18;20f\n"
							read -sn1 -p "Хотите сыграть еще раз(y/n): " choise
							case $choise in
							[yнННнY]) 	Button="q"
								clear
								good_letters=()
								bad_letters=()
								die=0
								arr_for_wrdlength=()
								word_length=0
								continue;;
							[nNтТтТ])      clear; quiet=true; Button="q" ;;
							*)      clear; quiet=true; Button="q" ;;
							esac
						fi
						echo -e "\033[1;5;43m\E[${nlett_y};${nlett_x}f${keyboard[$now_symbol]}"
						echo -e "\033[1;5;43m\E[${nlett_y};${nlett_x}f"
					fi ;;
			esac
			continue ;;
	esac

	if $(check_on_out $flett_x $flett_y); then
		#cursornamesto!
		continue	
	fi

	let "next_symbol=($flett_y-12)*$playing_field_length+($flett_x-20)"
	let "back_symbol=($nlett_y-12)*$playing_field_length+($nlett_x-20)"

	answer=$(check_badorgood_letter "${keyboard[$next_symbol]}")

	if [[ $answer -eq 0 ]]; then
		answer3=$(check_badorgood_letter "${keyboard[$now_symbol]}")
			# ----------------------------------------- #
			case $answer3 in
				2) echo -e "\033[1;25m\033[31m\E[${nlett_y};${nlett_x}f${keyboard[$now_symbol]}" ;;
                                1) 		echo -e "\033[1;25m\033[0;43m\E[${nlett_y};${nlett_x}f${keyboard[$now_symbol]}"
						echo -e "\033[1;25m\033[0;0m\E[${nlett_y};${nlett_x}f" ;;
				0) echo -e "\033[1;25m\033[39m\E[${nlett_y};${nlett_x}f${keyboard[$now_symbol]}"
				;;
			esac
			# ------------------------------------------ #
		echo -e "\033[1;5m\033[37m\E[${flett_y};${flett_x}f${keyboard[$next_symbol]}"
		let "nlett_y=flett_y"
		let "nlett_x=flett_x"
	elif [[ $answer -eq 2 ]]; then
		answer4=$(check_badorgood_letter "${keyboard[$now_symbol]}")
			# ----------------------------------------- #
			case $answer4 in
				2) echo -e "\033[1;25m\033[31m\E[${nlett_y};${nlett_x}f${keyboard[$now_symbol]}" ;;
                                1) 		echo -e "\033[1;25m\033[0;43m\E[${nlett_y};${nlett_x}f${keyboard[$now_symbol]}"
						echo -e "\033[1;25m\033[0;0m\E[${nlett_y};${nlett_x}f" ;;
				0) echo -e "\033[1;25m\033[39m\E[${nlett_y};${nlett_x}f${keyboard[$now_symbol]}"
				;;
			esac
			# ------------------------------------------ #
		echo -e "\033[1;5m\033[31m\E[${flett_y};${flett_x}f${keyboard[$next_symbol]}"
		let "nlett_y=flett_y"
		let "nlett_x=flett_x"
	elif [[ $answer -eq 1 ]]; then
		answer5=$(check_badorgood_letter "${keyboard[$now_symbol]}")
			# ----------------------------------------- #
			case $answer5 in
				2) echo -e "\033[1;25m\033[31m\E[${nlett_y};${nlett_x}f${keyboard[$now_symbol]}" ;;
                                1) 		echo -e "\033[1;25m\033[0;43m\E[${nlett_y};${nlett_x}f${keyboard[$now_symbol]}"
						echo -e "\033[1;25m\033[0;0m\E[${nlett_y};${nlett_x}f" ;;
				0) echo -e "\033[1;25m\033[39m\E[${nlett_y};${nlett_x}f${keyboard[$now_symbol]}"
				;;
			esac
			# ------------------------------------------ #
		echo -e "\033[1;5;43m\E[${flett_y};${flett_x}f${keyboard[$next_symbol]}"
		echo -e "\033[1;5;43m\E[${flett_y};${flett_x}f"
		let "nlett_y=flett_y"
		let "nlett_x=flett_x"
	fi	
	garbage_collector $nlett_y $nlett_x
	done
done
# ----------------------------------------- MAIN ----------------------------------------- #
clear
echo -e "\e[0;0;0m\e[0;0f"
clear
tput cnorm

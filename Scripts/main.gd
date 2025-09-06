extends Node2D

var WordList: Array = [
	"DEUS",
	"MORTE",
	"INFERNO",
	"CACHORRO",
	"VIDA",
	"PURGATORIO",
	"PUNICAO",
	"PECADO",
	"TRABALHO",
	"DEVER",
	"DEMONIO",
	"PENSAR",
	"GULA",
	"RAIVA",
	"INVEJA",
	"LUXURIA",
	"SOBERBA",
	"GANANCIA",
	"AVAREZA",
	"PREGUICA",
	"PODER",
	"PERDICAO",
	"ALUCINACAO",
	"OBEDIENCIA"
]

@onready var AlphabetPlayer: AnimationPlayer = $Alphabet/AnimationPlayer
@onready var SoundFx: AnimationPlayer = $SoundFx/AnimationPlayer

var SecretWord:String
var CurrentWord:String = ""

var Chances: int = 5:
	set(new_value):
		Chances = new_value
		$Hand.frame = 5 - Chances
var Guesses: Array[String] = []
var Score: int = 0:
	set(new_value):
		Score = new_value
		$Score.text = "Pontuação: " + str(Score)
		if Score >= MaxScore:
			MaxScore = Score
var MaxScore: int = 0:
	set(new_value):
		MaxScore = new_value
		$MaxScore.text = "Pontuação máxima: " + str(MaxScore)

enum {
	PLAYING,
	WON,
	LOST,
	AREYOUSURE
}

var GameState: int = 0

func _ready() -> void:
	randomize()
	if Global.LoadGame():
		MaxScore = Global.LoadGame().MaxScore
	GetRandomWord()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if !event.is_pressed() or event.is_echo():
			return
		if !event.keycode in range(KEY_A,KEY_Z + 1) and !event.keycode == KEY_ESCAPE:
			return
		match GameState:
			WON:
				if event.keycode == KEY_S:
					AlphabetPlayer.play("S")
					GetRandomWord()
					return
				elif event.keycode == KEY_N:
					AlphabetPlayer.play("N")
					ReturnToMenu()
					return
			LOST:
				if event.keycode == KEY_S:
					AlphabetPlayer.play("S")
					ResetGame()
					return
				elif event.keycode == KEY_N:
					AlphabetPlayer.play("N")
					ReturnToMenu()
					return
			PLAYING:
				if event.keycode == KEY_ESCAPE:
					ShowMessage("Você tem certeza que quer sair? S/N")
					AlphabetPlayer.play("AreYouSure")
					GameState = AREYOUSURE
					return
				var letter = event.as_text_keycode().to_upper()
				GuessLetter(letter)
			AREYOUSURE:
				if event.keycode == KEY_S:
					AlphabetPlayer.play("S")
					ReturnToMenu()
					return
				elif event.keycode == KEY_N:
					$Message.hide()
					GameState = PLAYING
					return

func ResetGame():
	Chances = 5
	$Hand.Fear = 0
	Score = 000
	SoundFx.stop()
	GetRandomWord()


func GuessLetter(Letter: String):
	if Letter in Guesses:
		ShowMessage("Essa letra ja foi escolhida")
		SoundFx.play("RepeatedLetter")
		return
	Guesses.append(Letter)
	AlphabetPlayer.play(Letter)
	if Letter in SecretWord:
		$Message.hide()
		
		ReplaceLetter(Letter)
	else:
		SoundFx.play("WrongLetter")
		LoseFinger()

func ReplaceLetter(Letter: String):
	for n in SecretWord.length():
		if SecretWord[n] == Letter:
			CurrentWord[n] = Letter
			Score += 10
	$Word.text = CurrentWord
	
	if CurrentWord == SecretWord:
		Win()
	

func LoseFinger():
	Chances -= 1
	if Chances <= 0:
		Lose()
		return
	
	$Hand.Fear += 1

func GetRandomWord():
	SecretWord = WordList.pick_random()
	CurrentWord = ""
	for n in SecretWord.length():
		CurrentWord += "_"
	Guesses = []
	$Word.text = CurrentWord
	$Message.hide()
	GameState = PLAYING

func ShowMessage(Text:String):
	$Message.text = Text
	$Message.show()

func Win():
	GameState = WON
	ShowMessage("Continuar? S/N")

func Lose():
	GameState = LOST
	SoundFx.play("Death")
	ShowMessage("Tentar novamente? S/N")

func ReturnToMenu():
	Global.SaveGame(MaxScore)
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

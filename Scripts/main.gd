extends Node2D

# avareza, luxúria, ira, gula, inveja e preguiça

var Words: Array= [
	{
		"hint":"Pecado capital",
		"words":[
			"SOBERBA",
			"ORGULHO",
			"AVAREZA",
			"LUXURIA",
			"IRA",
			"GULA",
			"INVEJA",
			"PREGUICA"
		]
	},
	{
		"hint":"Natureza humana",
		"words":[
			"PECAR",
			"MATAR",
			"MORRER",
			"SOFRER",
			"SURTAR",
			"MENTIR"
		]
	},
	{
		"hint":"Estado da alma",
		"words":[
			"ANGUSTIA",
			"CULPA",
			"LOUCURA",
			"VAZIO",
			"REMORSO",
			"DESESPERO",
			"SOLIDAO",
			"ARREPENDIMENTO",
			"VICIO"
		]
	}
]

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

var HighScoreName:String = ""

enum {
	PLAYING,
	WON,
	LOST,
	AREYOUSURE,
	HIGHSCORE
}

var GameState: int = 0

func _ready() -> void:
	randomize()
	GetRandomWord()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if !event.is_pressed() or event.is_echo():
			return
		if !event.keycode in range(KEY_A,KEY_Z + 1) and !event.keycode == KEY_ESCAPE and !InputMap.action_has_event("ui_accept",event):
			return
		match GameState:
			WON:
				if event.keycode == KEY_S or InputMap.action_has_event("ui_accept",event):
					AlphabetPlayer.play("S")
					GetRandomWord()
					return
				elif event.keycode == KEY_N:
					AlphabetPlayer.play("N")
					GetPlayerHighScore()
					return
			LOST:
				if event.keycode == KEY_S or InputMap.action_has_event("ui_accept",event):
					AlphabetPlayer.play("S")
					ResetGame()
					return
				elif event.keycode == KEY_N:
					AlphabetPlayer.play("N")
					ReturnToMenu()
					return
			PLAYING:
				if event.keycode == KEY_ESCAPE:
					ShowMessage("Você tem certeza? S/N")
					AlphabetPlayer.play("AreYouSure")
					GameState = AREYOUSURE
					return
				if InputMap.action_has_event("ui_accept",event):
					return
				var letter = event.as_text_keycode().to_upper()
				GuessLetter(letter)
			AREYOUSURE:
				if event.keycode == KEY_S or InputMap.action_has_event("ui_accept",event):
					AlphabetPlayer.play("S")
					GetPlayerHighScore()
					return
				elif event.keycode == KEY_N:
					$Message.hide()
					GameState = PLAYING
					return
			HIGHSCORE:
				if InputMap.action_has_event("ui_accept",event):
					if HighScoreName.length() < 3:
						SoundFx.play("RepeatedLetter")
						return
					Global.HighScoreTable += [{
						"name":HighScoreName,
						"score":Score
					}]
					
					if Chances <= 0:
						ShowMessage("Tentar novamente? S/N")
						GameState = LOST
					else:
						ReturnToMenu()
					return
				
				if HighScoreName.length() >= 3:
					HighScoreName = HighScoreName.erase(0) + event.as_text_keycode() 
				else:
					HighScoreName += event.as_text_keycode()
				ShowMessage("Digite seu nome >> "+ HighScoreName)
				

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
	var Category = Words.pick_random()
	SecretWord = Category.words.pick_random()
	$Hint.text = "Dica: " + Category.hint
	print(Category.hint+" >> "+SecretWord)
	CurrentWord = ""
	for n in SecretWord.length():
		CurrentWord += "_"
	Guesses = []
	HighScoreName = ""
	$Word.text = CurrentWord
	$Message.hide()
	$EscToMainMenu.show()
	GameState = PLAYING

func ShowMessage(Text:String):
	$Message.text = Text
	$Message.show()

func Win():
	ShowMessage("Continuar? S/N")
	$EscToMainMenu.hide()
	GameState = WON

func Lose():
	SoundFx.play("Death")
	$EscToMainMenu.hide()
	$Word.text = SecretWord
	GetPlayerHighScore()

func GetPlayerHighScore():
	ShowMessage("Digite seu nome >> ")
	GameState = HIGHSCORE

func ReturnToMenu():
	Global.SaveGame()
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

extends CanvasLayer

func RetryButton():
	SceneManager.instance.ChangeScene(SceneManager.Scene.GAME)

func MainMenuButton():
	SceneManager.instance.ChangeScene(SceneManager.Scene.MAINMENU)

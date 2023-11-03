extends MarginContainer

class_name PCMenu

const nuke_email: String = "nuke@australia.com"
const nuke_password: String = "for_real"

const passport_email: String = "passport@australia.com"
const passport_password: String = "aus_au1234"

@onready var ending_1: TextureRect = $Ending1
@onready var ending_2: TextureRect = $Ending2

@onready var email_edit: LineEdit = $MarginContainer/MarginContainer/VBoxContainer/Email/EmailEdit
@onready var password_edit: LineEdit = $MarginContainer/MarginContainer/VBoxContainer/Password/PasswordEdit
@onready var error: RichTextLabel = $MarginContainer/MarginContainer/VBoxContainer/Error

func _on_email_edit_text_submitted(new_text: String) -> void:
	if not password_edit.text:
		error.text = "[color=salmon] ! Enter password as well!"
		error.show()
		return
	error.hide()
	if new_text == passport_email and password_edit.text == passport_password:
		ending_2.show()
	if new_text == nuke_email and password_edit.text == nuke_password:
		ending_1.show()


func _on_password_edit_text_submitted(new_text: String) -> void:
	if not email_edit.text:
		error.text = "[color=salmon] ! Enter email as well!"
		error.show()
		return
	error.hide()
	if new_text == passport_password and email_edit.text == passport_email:
		ending_2.show()
	if new_text == nuke_password and email_edit.text == nuke_email:
		ending_1.show()

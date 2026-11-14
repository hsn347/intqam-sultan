local ramadanLetterRead = include("aAReadClass").new()
_UPVALUE2_ = nil
;(nil)[1] = "ramadan_letter"
;(nil)[2] = true
ramadanLetterRead:defineValue("ramadan_letter", nil)
function ramadanLetterRead.getLetters()
	return ramadanLetterRead.ramadan_letter
end
function ramadanLetterRead.getDialogues(chapter)
	local cfg = ramadanLetterRead.getLetterCfg(chapter)
	if not cfg then
		print("chapter ", chapter)
		ramadanLetterRead = print
		return print
	end
	local strs = SoraDStringsSplit(cfg.plot, ";")
	local ramadanLetterRead, dialogues = cfg.plot, cfg.plot
	for index, value in ipairs(strs) do
		ramadanLetterRead = nil
		;(nil).img = "girl"
		dialogue, (nil).str = nil, i18n(value)
		table.insert(dialogues, dialogue)
	end
	return dialogues
end
function ramadanLetterRead.getLetterCfg(chapter)
	return ramadanLetterRead.ramadan_letter[chapter]
end
return ramadanLetterRead
